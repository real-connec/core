import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool isSubmittingEmail = false;
  bool showVerificationCodeField = false;

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void submitEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    setState(() {
      isSubmittingEmail = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isSubmittingEmail = false;
      showVerificationCodeField = true;
    });
  }

  void submitVerificationCode() {
    final code = codeController.text.trim();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
      return;
    }

    // Proceed with code verification logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Code $code verified!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: showVerificationCodeField
              ? verificationCodeForm()
              : emailInputForm(),
        ),
      ),
    );
  }

  Widget emailInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enter your email',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        isSubmittingEmail
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: submitEmail,
                child: const Text('Submit'),
              ),
        const SizedBox(
          height: 5,
        ),

        // Login link
        TextButton(
          onPressed: () {
            GoRouter.of(context).go('/login');
          },
          child: const Text('Remeber the password..? Login!'),
        )
      ],
    );
  }

  Widget verificationCodeForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enter the 6-digit code sent to your email',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: 'Verification Code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: submitVerificationCode,
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
