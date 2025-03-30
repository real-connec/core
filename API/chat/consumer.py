import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from django.contrib.auth import get_user_model
from .models import Room, Message
import aioredis
from django.conf import settings

User = get_user_model()

class ChatConsumer(AsyncWebsocketConsumer):

    def __init__(self, client_socket=None, statusMessage=""):
        self.super()
        self.client_socket = client_socket
        self.statusMessage = statusMessage



    async def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = f'chat_{self.room_name}'

        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

        # Load cached messages from Redis on connect
        cached_messages = await self.get_cached_messages(self.room_group_name)
        if cached_messages:
            for msg in cached_messages:
                await self.send(text_data=json.dumps(msg))

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data.get('message')
        username = data.get('username')

        # Save message to DB
        user = await database_sync_to_async(User.objects.get)(username=username)
        room = await database_sync_to_async(Room.objects.get)(name=self.room_name)
        msg_obj = await database_sync_to_async(Message.objects.create)(
            room=room,
            user=user,
            content=message
        )

        message_data = {
            'username': username,
            'message': message,
            'timestamp': str(msg_obj.timestamp)
        }

        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message_data
            }
        )

        # Cache message in Redis
        await self.cache_message(self.room_group_name, message_data)

    # Receive message from room group
    async def chat_message(self, event):
        message = event['message']

        # Send message to WebSocket
        await self.send(text_data=json.dumps(message))

    # Redis caching
    async def cache_message(self, room_group_name, message_data):
        redis = await aioredis.create_redis_pool(settings.REDIS_URL)
        await redis.rpush(room_group_name, json.dumps(message_data))
        # Limit history to 50 messages
        await redis.ltrim(room_group_name, -50, -1)
        redis.close()
        await redis.wait_closed()

    async def get_cached_messages(self, room_group_name):
        redis = await aioredis.create_redis_pool(settings.REDIS_URL)
        messages = await redis.lrange(room_group_name, 0, -1)
        redis.close()
        await redis.wait_closed()
        return [json.loads(m.decode('utf-8')) for m in messages]
