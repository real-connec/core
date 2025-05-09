# Generated by Django 5.1.7 on 2025-03-15 12:13

import realConnect.utils.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Account',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('fname', models.CharField(max_length=50)),
                ('lname', models.CharField(max_length=50)),
                ('email', models.EmailField(max_length=254, unique=True)),
                ('dob', models.DateField()),
                ('phone', models.CharField(max_length=10, unique=True, validators=[realConnect.utils.validators.validate_phone_number])),
                ('occupation', models.CharField(max_length=100)),
                ('referred', models.BooleanField(default=False)),
                ('phone_verified', models.BooleanField(default=False)),
                ('online', models.BooleanField(default=False)),
                ('is_profile_ok', models.BooleanField(default=False)),
                ('date_joined', models.DateTimeField(auto_now_add=True)),
                ('last_login', models.DateTimeField(auto_now_add=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('is_staff', models.BooleanField(default=False)),
                ('is_active', models.BooleanField(default=False)),
                ('is_superadmin', models.BooleanField(default=False)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
