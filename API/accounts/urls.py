"""
    Accounts APP Level URLs
"""
# from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,   # Login (get token)
    TokenRefreshView,      # Refresh token
)
from .views import OTPVerificationAPIView, RegisterView

urlpatterns = [
    path('token', TokenObtainPairView.as_view(), name='obtainToken'),
    path('token/refresh', TokenRefreshView.as_view(), name='refreshToken'),
    path('register/', RegisterView.as_view(), name='register'),
    path('activate/', OTPVerificationAPIView.as_view(), name='verifyEmail'),

]
