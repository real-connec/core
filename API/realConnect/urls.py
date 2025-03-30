"""
    Project Level URLs
"""
from django.contrib import admin
from django.urls import path, include
from debug_toolbar.toolbar import debug_toolbar_urls


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api-auth/', include('accounts.urls')),
    path('api-chat/', include('chat.urls')),
    # path('__debug__/', include('debug_toolbar.urls')),
] + debug_toolbar_urls()
