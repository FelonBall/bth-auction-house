"""MySQL connection helper.

We deliberately do NOT use an ORM. Every query is written explicitly so the
SQL is the source of truth (course requirement).
"""
import os
from contextlib import contextmanager

import mysql.connector
from flask import g


def _connect():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        autocommit=False,
    )


def get_db():
    """Per-request connection. Reused across queries within the same request."""
    if "db" not in g:
        g.db = _connect()
    return g.db


def close_db(exc=None):
    db = g.pop("db", None)
    if db is not None:
        try:
            db.close()
        except mysql.connector.Error:
            pass


@contextmanager
def cursor(dictionary: bool = True):
    """Context manager that yields a cursor and commits/rolls back automatically."""
    conn = get_db()
    cur = conn.cursor(dictionary=dictionary)
    try:
        yield cur
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        cur.close()


def query_all(sql: str, params=None):
    """Run a SELECT and return all rows as a list of dicts."""
    conn = get_db()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(sql, params or ())
        return cur.fetchall()
    finally:
        cur.close()


def query_one(sql: str, params=None):
    """Run a SELECT and return the first row as a dict (or None)."""
    conn = get_db()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(sql, params or ())
        return cur.fetchone()
    finally:
        cur.close()


def execute(sql: str, params=None):
    """Run an INSERT/UPDATE/DELETE and return cursor.lastrowid."""
    conn = get_db()
    cur = conn.cursor()
    try:
        cur.execute(sql, params or ())
        conn.commit()
        return cur.lastrowid
    except Exception:
        conn.rollback()
        raise
    finally:
        cur.close()


def callproc(name: str, args=()):
    """Call a stored procedure. Commits on success, rolls back on error."""
    conn = get_db()
    cur = conn.cursor()
    try:
        cur.callproc(name, args)
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        cur.close()
