import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:realconnect_ui/controllers/api_service_controller.dart';
import 'package:realconnect_ui/providers/user_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _obtainToken() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final controller = ref.read(apiControllerProvider.notifier);

    setState(() {
      _isLoading = true;
    });

    final errorMessage =
        await controller.login({'email': email, 'password': password});

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null) {
      // ✅ Success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        GoRouter.of(context).go('/dashboard');
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Login button
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _obtainToken,
                    child: const Text('Login'),
                  ),

            // Signup link
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/signup');
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),

            // Forgot Password link
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/forgot-password');
              },
              child: const Text('Forgot Password ??'),
            )
          ],
        ),
      ),
    );
  }
}
