"""Custom Jinja filters: SEK price formatting + human time-deltas."""
from datetime import datetime


def sek(value):
    """Format an integer (or numeric) value as Swedish kronor.

    Examples:
        1234   -> '1 234 kr'
        50     -> '50 kr'
        None   -> ''
    """
    if value is None:
        return ""
    try:
        n = int(round(float(value)))
    except (TypeError, ValueError):
        return str(value)
    # Swedish convention: space as thousands separator.
    return f"{n:,} kr".replace(",", " ")  # non-breaking space


def humanize_until(dt):
    """Render a datetime as a human-readable distance from now.

    Examples (relative to NOW):
        in 2d 5h         (more than 24h away)
        in 3h 12m        (less than 24h)
        in 18m           (less than 1h)
        ending now       (less than 60s away)
        ended 2h ago
        ended 3d ago
    """
    if dt is None:
        return ""
    delta = dt - datetime.now()
    secs  = int(delta.total_seconds())

    if secs < 0:
        ago = -secs
        if ago < 60:
            return "just ended"
        if ago < 3600:
            return f"ended {ago // 60}m ago"
        if ago < 86400:
            return f"ended {ago // 3600}h ago"
        return f"ended {ago // 86400}d ago"

    if secs < 60:
        return "ending now"
    if secs < 3600:
        return f"in {secs // 60}m"
    if secs < 86400:
        h = secs // 3600
        m = (secs % 3600) // 60
        return f"in {h}h {m}m" if m else f"in {h}h"
    days  = secs // 86400
    hours = (secs % 86400) // 3600
    return f"in {days}d {hours}h" if hours else f"in {days}d"


def urgency(dt):
    """Return a Bootstrap text-color class based on time until `dt`.

    < 6 hours  -> 'text-danger fw-semibold'
    < 24 hours -> 'text-warning fw-semibold'
    past       -> 'text-muted'
    otherwise  -> '' (default text colour)
    """
    if dt is None:
        return ""
    secs = (dt - datetime.now()).total_seconds()
    if secs < 0:
        return "text-muted"
    if secs < 6 * 3600:
        return "text-danger fw-semibold"
    if secs < 24 * 3600:
        return "text-warning fw-semibold"
    return ""


def register(app):
    app.jinja_env.filters["sek"]            = sek
    app.jinja_env.filters["humanize_until"] = humanize_until
    app.jinja_env.filters["urgency"]        = urgency
