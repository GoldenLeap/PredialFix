import 'package:mobile/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'view/login_view.dart';
import 'view_models/login_view_model.dart';
import 'view/home_view.dart';
import 'view/profile_view.dart';
import 'view/dashboard_view.dart';
import 'view/materiais_view.dart';
import 'view/orcamento_view.dart';
import 'view/relatorios_view.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/dashboard_view_model.dart';
import 'view_models/materiais_view_model.dart';
import 'view_models/orcamento_view_model.dart';
import 'view_models/relatorios_view_model.dart';
import 'services/sound_navigation_observer.dart';
import 'services/auth_service.dart';
import 'view/register_view.dart';
import 'view_models/register_view_model.dart';
import 'view/forgot_password_view.dart';
import 'view_models/forgot_password_view_model.dart';
import 'view/verify_email_view.dart';
import 'view_models/verify_email_view_model.dart';
import 'view/two_factor_challenge_view.dart';
import 'view_models/two_factor_challenge_view_model.dart';
import 'view_models/settings_view_model.dart';
import 'view/password_settings_view.dart';
import 'view/two_factor_settings_view.dart';
import 'view/appearance_settings_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final token = await authService.getToken();
  final initialRoute = (token != null && token.isNotEmpty) ? '/home' : '/';

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
      ChangeNotifierProvider(create: (_) => VerifyEmailViewModel()),
      ChangeNotifierProvider(create: (_) => TwoFactorChallengeViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ChangeNotifierProvider(create: (_) => MateriaisViewModel()),
      ChangeNotifierProvider(create: (_) => OrcamentoViewModel()),
      ChangeNotifierProvider(create: (_) => RelatoriosViewModel()),
    ], child: PredialFix(initialRoute: initialRoute)),
  );
}

class PredialFix extends StatelessWidget {
  final String initialRoute;
  const PredialFix({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PredialFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/forgot-password': (context) => const ForgotPasswordView(),
        '/verify-email': (context) => const VerifyEmailView(email: ''),
        '/two-factor-challenge': (context) => const TwoFactorChallengeView(),
        '/home': (context) => const HomeView(),
        '/profile': (context) => const ProfileView(),
        '/dashboard': (context) => const DashboardView(),
        '/materiais': (context) => const MateriaisView(),
        '/orcamento': (context) => const OrcamentoView(),
        '/relatorios': (context) => const RelatoriosView(),
      },
      navigatorObservers: [
        SoundNavigationObserver(),
      ],
    );
  }
}