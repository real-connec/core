from threading import Thread
from django.db.models.signals import post_save
from django.dispatch import receiver

from realConnect.utils.common import generate_otp, send_activation_email
from .models import Account, UserProfile

@receiver(post_save, sender=Account)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        otp = generate_otp()
        UserProfile.objects.create(
            user=instance,
            activation_code=otp
        )
         # SEND: User activation email containing this activation code
        Thread(
            target=send_activation_email,
            args=(instance, otp),
        ).start()
