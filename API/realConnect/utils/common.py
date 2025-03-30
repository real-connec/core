"""
pass
"""
# from datetime import timezone
import random
from django.template.loader import render_to_string
from django.core.mail import EmailMultiAlternatives




def generate_otp():
    """
    pass
    """
    otp = f'{random.randint(100000, 999999):06d}'
    return otp


def send_activation_email(user, code):
    """
    pass
    """
    mail_subject = 'Welcome to Caffae - Happy Networking!'
    try:
        mail_subject = 'Welcome to Caffae - Happy Networking!'
        text_content = render_to_string('accounts/verification_email.html', {
            'user': user,
            'code': code,
        })
        send_email = EmailMultiAlternatives(mail_subject, '', to=[user.email])
        send_email.attach_alternative(text_content, "text/html")
        send_email.send()
    except Exception as e:
        print(f"****{e}"*15)
