PostX
======

A small Django social-feed prototype. This repository contains the web app (PostX) and development files.

Quick structure
- `PostX/` - Django project package and app `post_x`
- `requirements.txt` - minimal runtime requirements for deployment
- `requirements-dev.txt` - optional ML / dev dependencies (install locally only)
- `Procfile` - for Gunicorn on Render/Heroku
- `runtime.txt` - Python runtime for Render
- `.gitignore` - ignores venvs, local DB, media, and IDE files

Cleanup & organization notes
1. Don't commit virtual environments or large local files. If you accidentally added `.venv/` or `media/`, remove them from Git history with:

```pwsh
# remove tracked virtualenv and local files (do this from repo root)
git rm -r --cached .venv
git rm -r --cached media
git rm --cached db.sqlite3
# commit the removal and push
git commit -m "Remove local env and media from repo"
git push
```

2. Use `requirements.txt` for runtime dependencies (what gets installed on Render). Keep heavy ML deps in `requirements-dev.txt` and install them only locally:

```pwsh
pip install -r requirements-dev.txt
```

3. Deploy settings (Render)
- Procfile: `web: gunicorn PostX.wsgi:application --bind 0.0.0.0:$PORT`
- The Gunicorn module path is `PostX.wsgi:application` (module `PostX.wsgi`) because the Django project package is named `PostX`.

4. Static files & Whitenoise
- `whitenoise` is included in `requirements.txt`. In `settings.py`, add `whitenoise.middleware.WhiteNoiseMiddleware` near the top of `MIDDLEWARE` and set `STATIC_ROOT`.
- Run `python manage.py collectstatic --noinput` during deploy (Render can be configured to run it automatically).

5. Database on Render
- Use `dj-database-url` and `python-dotenv` (already in requirements) to parse `DATABASE_URL` environment variable.

If you want, I can:
- Run the Git cleanup commands for you (remove tracked `.venv`, `media`, `db.sqlite3`) and commit the changes.
- Update `settings.py` to enable `whitenoise` and `dj-database-url` parsing and add sensible `STATIC_ROOT` and `ALLOWED_HOSTS` for Render.
- Create a `.github/workflows/deploy.yml` (optional) to automate deployments.

Which of these follow-ups should I do next? (I recommend updating `settings.py` and removing tracked venv/media.)