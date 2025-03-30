/*
  TODO:
  - Add error messages inline (optional)
  - DOB and Email inputs proper types and validations (done)
  - Phone validation (done)
*/

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:realconnect_ui/auth/widgets/dob_picker.dart';
import 'package:realconnect_ui/common/validators.dart'; // assuming you have isValidEmail here
import 'package:realconnect_ui/controllers/api_service_controller.dart';
import 'package:realconnect_ui/providers/user_providers.dart'; // ApiController

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // ✅ Validator for phone number
  bool isValidPhone(String phone) {
    // Simple validation - adjust as needed!
    return RegExp(r'^[0-9]{10,15}$').hasMatch(phone);
  }

  Future<void> registerUser() async {
    final controller = ref.read(apiControllerProvider.notifier);

    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final fname = fnameController.text.trim();
    final lname = lnameController.text.trim();
    final dob = dobController.text;
    final phone = phoneController.text.trim();

    // ✅ Client-side validations
    if (fname.isEmpty || lname.isEmpty) {
      showError('Please enter your first and last name');
      return;
    }

    if (!isValidEmail(email)) {
      showError('Please enter a valid email address');
      return;
    }

    if (!isValidPhone(phone)) {
      showError('Please enter a valid phone number');
      return;
    }

    if (dob.isEmpty) {
      showError('Please select your date of birth');
      return;
    }

    if (password.length < 9) {
      showError('Password must be at least 9 characters');
      return;
    }

    if (password != confirmPassword) {
      showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    final errorMessage = await controller.registerUser({
      "email": email,
      "password": password,
      "fname": fname,
      "lname": lname,
      "dob": dob,
      "phone": phone,
    });

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      // ✅ Success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        GoRouter.of(context).go('/verify-email');
        ref.read(userEmailProvider.notifier).update(
              (state) => email,
            );
      }
    } else {
      // ✅ Show error message
      showError(errorMessage);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // First Name
                  TextField(
                    controller: fnameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),

                  const SizedBox(height: 12),

                  // Last Name
                  TextField(
                    controller: lnameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),

                  const SizedBox(height: 12),

                  // Phone Number
                  TextField(
                    controller: phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 12),

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 12),

                  // DOB Picker Widget (custom widget)
                  DOBPicker(dobController: dobController),

                  const SizedBox(height: 12),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Confirm Password
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: registerUser,
                    child: const Text('Sign Up'),
                  ),

                  const SizedBox(height: 16),

                  // Login link
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).go('/login');
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
    );
  }
}
