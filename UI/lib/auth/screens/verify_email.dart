/*
  TODO: Numbers only keyboard for input
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:realconnect_ui/controllers/api_service_controller.dart';
import 'package:realconnect_ui/providers/user_providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _verifyOtp(final email) async {
    final otp = _otpController.text.trim();
    final controller = ref.read(apiControllerProvider.notifier);

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final errorMessage =
        await controller.activateUser({'email': '$email', 'code': otp});

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null) {
      // ✅ Success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activation successful')),
        );
        GoRouter.of(context).go('/login');
        ref.read(userEmailProvider.notifier).update(
              (state) => email,
            );
      }
    } else {
      // ✅ Show error message
      showError(errorMessage);
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(userEmailProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the 6-digit code sent to your email: $email',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // OTP TextField
              TextField(
                controller: _otpController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                textInputAction: TextInputAction
                    .done, // Optional: changes the keyboard "action" button
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Ensures only digits are allowed
                  LengthLimitingTextInputFormatter(6), // Limits the length to 6
                ],
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                  counterText: '', // Hides the counter under the TextField
                ),
              ),
              const SizedBox(height: 24),

              // Verify Button
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _verifyOtp(email),
                        child: const Text('Verify'),
                      ),
                    ),

              const SizedBox(height: 16),

              // Resend OTP Option
              TextButton(
                onPressed: () {
                  // Trigger resend OTP function
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resend OTP clicked')),
                  );
                },
                child: const Text('Didn\'t receive the code? Resend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
