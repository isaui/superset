import os

# Database connection
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')

# Security
SECRET_KEY = os.environ.get('SECRET_KEY')

# Basic settings
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = None

# Features
FEATURE_FLAGS = {
    'ENABLE_TEMPLATE_PROCESSING': True,
    'ENABLE_PROXY_FIX': True,
    'ENABLE_CORS': True,
    'DYNAMIC_PLUGINS': True,
    'SQL_VALIDATORS_BY_ENGINE': True,
    'SCHEDULED_QUERIES': True,
}

# SQL Lab configuration
SQLLAB_CTAS_NO_LIMIT = True
SQLLAB_TIMEOUT = 300
SQLLAB_ASYNC_TIME_LIMIT_SEC = 600
SQL_MAX_ROW = 100000
DEFAULT_SQLLAB_LIMIT = 1000

# Session configuration
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True  # Set True if using HTTPS
SESSION_COOKIE_SAMESITE = 'Lax'

# CORS
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': ['*']
}

# Timezone
DEFAULT_TIMEZONE = 'Asia/Jakarta'

# Languages
LANGUAGES = {
    'en': {'flag': 'us', 'name': 'English'},
    'id': {'flag': 'id', 'name': 'Indonesian'},
}

BABEL_DEFAULT_LOCALE = 'en'