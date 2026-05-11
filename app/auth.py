"""Authentication: register, login, logout."""
from functools import wraps

from flask import (Blueprint, flash, g, redirect, render_template, request,
                   session, url_for)
from werkzeug.security import check_password_hash, generate_password_hash

from .db import execute, query_one

bp = Blueprint("auth", __name__)


def current_user():
    """Return the currently logged-in user as a dict, or None."""
    uid = session.get("user_id")
    if not uid:
        return None
    if "current_user" not in g:
        g.current_user = query_one(
            "SELECT user_id, username, email, created_at FROM Users WHERE user_id = %s",
            (uid,),
        )
    return g.current_user


def login_required(view):
    @wraps(view)
    def wrapper(*args, **kwargs):
        if not session.get("user_id"):
            flash("Please log in to continue.", "warning")
            return redirect(url_for("auth.login", next=request.path))
        return view(*args, **kwargs)
    return wrapper


@bp.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form["username"].strip()
        email    = request.form["email"].strip().lower()
        password = request.form["password"]

        if not username or not email or not password:
            flash("All fields are required.", "danger")
            return render_template("register.html")

        if query_one("SELECT 1 FROM Users WHERE username = %s", (username,)):
            flash("Username already taken.", "danger")
            return render_template("register.html")
        if query_one("SELECT 1 FROM Users WHERE email = %s", (email,)):
            flash("Email already registered.", "danger")
            return render_template("register.html")

        execute(
            "INSERT INTO Users (username, email, password_hash) VALUES (%s, %s, %s)",
            (username, email, generate_password_hash(password)),
        )
        flash("Account created — please log in.", "success")
        return redirect(url_for("auth.login"))

    return render_template("register.html")


@bp.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"].strip()
        password = request.form["password"]
        row = query_one(
            "SELECT user_id, password_hash FROM Users WHERE username = %s",
            (username,),
        )
        if row and check_password_hash(row["password_hash"], password):
            session["user_id"]  = row["user_id"]
            session["username"] = username
            flash(f"Welcome back, {username}.", "success")
            next_url = request.args.get("next") or url_for("auctions.browse")
            return redirect(next_url)
        flash("Invalid username or password.", "danger")

    return render_template("login.html")


@bp.route("/logout")
def logout():
    session.clear()
    flash("Logged out.", "info")
    return redirect(url_for("auctions.browse"))
