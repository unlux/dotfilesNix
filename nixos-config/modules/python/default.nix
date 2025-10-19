{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Python interpreter
    python312
    python312Packages.pip
    python312Packages.virtualenv

    # # Django and related packages
    # python312Packages.django
    # python312Packages.django-extensions
    # python312Packages.django-environ
    # python312Packages.django-cors-headers
    # python312Packages.djangorestframework
    # python312Packages.django-debug-toolbar
    # python312Packages.django-filter

    # # Database drivers
    # python312Packages.psycopg2
    # python312Packages.mysqlclient
    # python312Packages.pymongo

    # # Web server and ASGI/WSGI
    # python312Packages.gunicorn
    # python312Packages.uvicorn
    # python312Packages.daphne
    # python312Packages.whitenoise

    # # Common Python development tools
    # python312Packages.pytest
    # python312Packages.pytest-django
    # python312Packages.pytest-cov
    # python312Packages.black
    # python312Packages.flake8
    # python312Packages.pylint
    # python312Packages.mypy
    # python312Packages.ipython
    # python312Packages.ipdb

    # # Useful libraries
    # python312Packages.requests
    # python312Packages.pillow
    # python312Packages.celery
    # python312Packages.redis
    # python312Packages.python-dotenv
    # python312Packages.pyyaml
    # python312Packages.python-dateutil
    # python312Packages.pytz

    # Additional tools
    poetry
    uv # Fast Python package installer
    ruff # Fast Python linter
  ];

  # Optional: Set up environment variables
  environment.variables = {
    PYTHONPATH = "$HOME/.local/lib/python3.12/site-packages:$PYTHONPATH";
  };
}
