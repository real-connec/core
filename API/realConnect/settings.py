"""
Django settings for real_connect project.
"""
import os
from pathlib import Path
from datetime import timedelta

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: TODO: Intorduce ENV
SECRET_KEY = 'django-insecure-&iu!s+)rq=bsgcicr(fne41bmjxtf1@07!fm((@==c=4vt&*f*'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # 'accounts.apps.AccountsConfig'
    'rest_framework',
    'accounts',
    'debug_toolbar',
    'channels',
    'chat',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'debug_toolbar.middleware.DebugToolbarMiddleware',  
]

ROOT_URLCONF = 'realConnect.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': ['templates',],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'realConnect.wsgi.application'


# REST SETUP
REST_FRAMEWORK = {
    # Use Django's standard `django.contrib.auth` permissions,
    # or allow read-only access for unauthenticated users.
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated'
    ]
}


# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'realconnect_dev',
        'USER': 'postgres',
        'PASSWORD': 'strong_password',
        'HOST': '34.2.53.196',
        'PORT': '5432',
    }
}



# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
        'OPTIONS': {
            'user_attributes': ('fname', 'lname', 'email'),
            'max_similarity': 0.4,
        }
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        "OPTIONS": {
            "min_length": 9,
        },
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# AUTH MODEL CHANGED
AUTH_USER_MODEL = "accounts.Account"

# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Asia/Kolkata'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

STATIC_URL = 'static/'

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'



# FOR Jinja Templates
DATE_FORMAT = 'd-m-Y'   #15-03-2025
DATETIME_FORMAT = 'd F Y, h:i A'  #15 March 2025, 02:30 PM
TIME_FORMAT = 'h:i A'   #02:30 PM
MONTH_DAY_FORMAT = 'd F'    #15 March




# FOR form inputs
DATE_INPUT_FORMATS = [
    '%d-%m-%Y',
]
DATETIME_INPUT_FORMATS = [
    '%d-%m-%Y %I:%M %p',
]
TIME_INPUT_FORMATS = [
    '%I:%M %p',
]


# JWT CONFIGURATIONS
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=5),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),      
    'ROTATE_REFRESH_TOKENS': False,
    'BLACKLIST_AFTER_ROTATION': True,

    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'AUTH_HEADER_TYPES': ('Bearer',),
    'AUTH_HEADER_NAME': 'HTTP_AUTHORIZATION',
}


# REDIS CONFIGURATIONS (localhost)
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': 'redis://127.0.0.1:6379/1',  # Redis server URL with database 1
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        },
        'TIMEOUT': 300,  # Cache expiration time in seconds
    }
}



# Store sessions in Redis cache (optional but recommended for performance)
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
SESSION_CACHE_ALIAS = 'default'



# DJANGO-DEBUG-TOOLBAR
# TODO: MAKE IT DEBUG ENV ONLY AT TIME OF STAGING-PRODUCTION PARTIONING
INTERNAL_IPS = [
    # ...
    "127.0.0.1",
    # ...
]

def show_toolbar(request):
    return True

DEBUG_TOOLBAR_CONFIG = {
    "SHOW_TOOLBAR_CALLBACK" : show_toolbar,
}





# CHANNELS' LAYER
ASGI_APPLICATION = 'realConnect.asgi.application'

CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels_redis.core.RedisChannelLayer',
        'CONFIG': {
            'hosts': [('127.0.0.1', 6379)],
        },
    },
}

REDIS_URL = "redis://127.0.0.1:6379"



# SMTP configuration
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_PORT = 587
EMAIL_HOST_USER = 'h20230187@pilani.bits-pilani.ac.in'
EMAIL_HOST_PASSWORD = 'bhjbmojwrnguinoz'
EMAIL_USE_TLS = True
DEFAULT_FROM_EMAIL = 'From RealConnect'
