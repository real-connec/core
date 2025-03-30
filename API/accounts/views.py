"""
pass
"""
from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView

from accounts.models import Account, UserProfile
from .serializers import OTPVerificationSerializer, RegisterSerializer

# Create your views here.
class RegisterView(generics.CreateAPIView):
    """
    pass
    """
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]


class OTPVerificationAPIView(APIView):
    """
    Verify OTP and activate user account.
    """
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = OTPVerificationSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({
                "status": "error",
                "message": "Invalid data",
                "errors": serializer.errors
            }, status=status.HTTP_400_BAD_REQUEST)

        email = serializer.validated_data.get("email")
        otp = serializer.validated_data.get("code")

        try:
            # Find the account using email
            account = Account.objects.get(email=email)
        except Exception as e:
            return Response({
                "status": "error",
                "message": f"Account with this email was not found. {e}"
            }, status=status.HTTP_404_NOT_FOUND)

        try:
            # Assuming there's a OneToOne relationship with UserProfile
            profile = UserProfile.objects.get(user=account)
        except Exception as e:
            return Response({
                "status": "error",
                "message": f"User profile for this account was not found. {e}"
            }, status=status.HTTP_404_NOT_FOUND)

        if profile.activation_code != otp:
            return Response({
                "status": "error",
                "message": "Invalid OTP provided."
            }, status=status.HTTP_400_BAD_REQUEST)

        # OTP matches: activate the account
        account.is_active = True
        account.save()

        return Response({
            "status": "success",
            "message": "Account successfully activated."
        }, status=status.HTTP_200_OK)
