from django.contrib import admin 
from .models import Message, Room

class RoomAdmin(admin.ModelAdmin):
    list_display = ('name', 'created_at')
    readonly_fields = ('name', 'created_at')
    ordering = ('-created_at',)
    list_display_links = ('name',)


class MessageAdmin(admin.ModelAdmin):
    list_display = ('room', 'user',  'content_preview', 'timestamp')
    list_display_links = ('room', 'user', 'timestamp')
    readonly_fields = ('user', 'room', 'timestamp')
    
    def content_preview(self, obj):
        return '**** Hidden ****'

    def has_add_permission(self, request):
        return False  # Prevent adding new messages

    def has_change_permission(self, request, obj=None):
        return False  # Prevent editing messages

    content_preview.short_description = 'Message'

# Register your models here.
admin.site.register(Room, RoomAdmin)
admin.site.register(Message, MessageAdmin)