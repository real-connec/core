import 'package:go_router/go_router.dart';
import 'package:realconnect_ui/auth/screens/dashboard.dart';
import 'package:realconnect_ui/auth/screens/forgot_password.dart';
import 'package:realconnect_ui/auth/screens/login.dart';
import 'package:realconnect_ui/auth/screens/signup.dart';
import 'package:realconnect_ui/auth/screens/verify_email.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/signup',
      name: 'signupPage',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'loginPage',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const HomeDashboardScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      name: 'verifyEmail',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
  ],
);
