"""
    Blah
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.html import format_html
from .models import Account, UserProfile



class AccountAdmin(UserAdmin):
    """
        Account Admin
    """
    list_display = ("pk", "fname", "lname", "email", "is_admin", "is_staff", "dob", "is_profile_ok")
    list_display_links = ("email", "fname", "pk")

    ordering = ('-date_joined',)

    # TODO: Implement Followings
    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()


class ProfileAdmin(admin.ModelAdmin):
    """
        Profile Admin
    """
    def thumbnail(self, object):
        """
            Thumbnail Rendering Function on Admin Panel
        """
        return format_html(
            f'<img src="{object.profile_picture.url}" width="30" style="border-radius:50%;">'
        )
    thumbnail.short_description = 'Profile Picture'
    list_display = ("pk", "user", "photo", "full_address")
    list_display_links = ("photo", "user")
    

# Register your models here.
admin.site.register(Account, AccountAdmin)
admin.site.register(UserProfile, ProfileAdmin)
