"""
    Accounts' Model
"""
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

from realConnect.utils.common import generate_otp
from realConnect.utils.validators import validate_phone_number

# Create your models here.



class MyAccountManager(BaseUserManager):
    """
        Account Model Manager
    """
    def create_user(self, *, fname, lname, email, phone, dob, password):
        """
            Creates Users
        """
        if not email or not dob or not phone:
            raise ValueError('Must Provide Email, Phone and DOB!')

        user = self.model(
            fname=fname,lname=lname, email=self.normalize_email(email),phone=phone, dob=dob
        )
        user.set_password(password)
        user.save(using=self.db)
        return user

    def create_superuser(self, *, fname, lname, email, phone, dob, password):
        """
            Create SuperUser Account
        """
        user = self.create_user(
            fname=fname, lname=lname, email=email, phone=phone, dob=dob, password=password
        )
        user.is_active = True
        user.is_staff = True
        user.is_admin = True
        user.is_superadmin = True
        user.save(using=self.db)
        return user

    def create_staff(self, *, fname, lname, email, phone, dob, password):
        """
            Create Staff Account
        """
        user = self.create_user(
            fname=fname, lname=lname, email=email, phone=phone, dob=dob, password=password
        )
        user.is_staff = True
        user.is_active = True
        user.save(using=self.db)
        return user

class Account(AbstractBaseUser):
    """
        User Entity Model
    """

    # # Personal Details
    fname = models.CharField(max_length=50)
    lname = models.CharField(max_length=50)
    email = models.EmailField(null=False, unique=True, blank=False)
    dob = models.DateField(null=False, blank=False)
    phone = models.CharField(
        max_length=10, blank=False, null=False, unique=True, validators=[validate_phone_number]
    )
    # TODO: Make occupation a list option
    occupation = models.CharField(max_length=100, null=True, blank=True)

    # Mode Of Onboarding Details
    referred = models.BooleanField(blank=False, null=False, default=False)
    referred_by = models.ForeignKey("self", on_delete=models.DO_NOTHING, null=True),

    # State Information
    is_active = models.BooleanField(default=False)
    phone_verified = models.BooleanField(default=False)
    online = models.BooleanField(default=False)
    # OK: True when all UserProfile Details are filled up
    is_profile_ok = models.BooleanField(default=False)

    # Management Related Details
    date_joined = models.DateTimeField(auto_now_add=True)
    last_login = models.DateTimeField(auto_now_add=True)
    is_admin = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)
    is_superadmin = models.BooleanField(default=False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['fname', 'lname', 'dob', 'phone',]

    objects = MyAccountManager()

    # def to_json(self):
    #     """Convert Account instance to JSON format."""

    @property
    def full_name(self):
        """FullName"""
        return f"{self.fname} {self.lname}"

    def __str__(self):
        return f"{self.fname} {self.lname}: {self.email}"

    def has_perm (self, perm, obj=None):
        """
            Has Perm
        """
        return self.is_admin

    def has_module_perms (self, add_label):
        """
            Has module perms
        """
        return True

class UserProfile(models.Model):
    """
        User Profile Table
    """
    user = models.OneToOneField(Account, on_delete=models.CASCADE, related_name='profile')
    address_1 = models.CharField(max_length=100, blank=True, null=True)
    address_2 = models.CharField(max_length=100, blank=True, null=True)
    photo = models.ImageField(blank=True, upload_to='userprofile/', null=True)
    # TODO: Address Matching using Google
    city = models.CharField(blank=True, null=True)
    state = models.CharField(blank=False, null=True)
    pincode = models.CharField(blank=True, null=True, max_length=6)
    activation_code = models.CharField(blank=False, max_length=6, default="000000", null=False)

    @property
    def full_address(self):
        """
            Full Address
        """
        return f'{self.address_1} {self.address_2}'
    