# accounts/serializers.py

from rest_framework import serializers
from .models import Account

class RegisterSerializer(serializers.ModelSerializer):
    """
    pass
    """
    # password2 = serializers.CharField(write_only=True, required=True)

    class Meta:
        """ 
        pass
        """
        model = Account
        fields = ('fname', 'lname', 'email', 'phone', 'dob', 'password')
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        # validated_data.pop('password2')
        password = validated_data.pop('password')
        user = Account(**validated_data)
        user.set_password(password)
        user.save()
        return user

class OTPVerificationSerializer(serializers.Serializer):
    """
    pass
    """
    email = serializers.EmailField()
    code = serializers.CharField(max_length=6, min_length=6)