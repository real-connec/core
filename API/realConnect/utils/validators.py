"""
Validator functions 
"""
import re
from django.core.exceptions import ValidationError

def validate_phone_number(value):
    """
    Validates the phone number at account  model level
    """
    pattern = re.compile(r'^[1-9]\d{9}$')
    if not pattern.match(value):
        raise ValidationError('Invalid phone number. It must be exactly 10 digits, \
                              contain only numbers, and not start with zero.')
