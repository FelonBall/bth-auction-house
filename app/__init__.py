"""Flask application factory."""
import os

from dotenv import load_dotenv
from flask import Flask, redirect, url_for

load_dotenv()


def create_app() -> Flask:
    app = Flask(__name__)
    app.secret_key = os.getenv("FLASK_SECRET_KEY", "dev-only-not-secure")

    # Register blueprints
    from .auth         import bp as auth_bp
    from .auctions     import bp as auctions_bp
    from .bids         import bp as bids_bp
    from .watchlist    import bp as watchlist_bp
    from .stats        import bp as stats_bp
    from .transactions import bp as transactions_bp

    app.register_blueprint(auth_bp,         url_prefix="/auth")
    app.register_blueprint(auctions_bp,     url_prefix="/auctions")
    app.register_blueprint(bids_bp,         url_prefix="/bids")
    app.register_blueprint(watchlist_bp,    url_prefix="/watchlist")
    app.register_blueprint(stats_bp,        url_prefix="/stats")
    app.register_blueprint(transactions_bp, url_prefix="/transactions")

    @app.route("/")
    def index():
        return redirect(url_for("auctions.browse"))

    # Make `current_user` available in every template
    from .auth import current_user
    app.jinja_env.globals["current_user"] = current_user

    # Register custom Jinja filters (sek, humanize_until, urgency).
    from . import filters
    filters.register(app)

    return app
