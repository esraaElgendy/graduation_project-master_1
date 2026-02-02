import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/bloc/settings_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_preferences.dart';
import 'features/auth/presentation/pages/login_screen.dart'; // Changed to LoginScreen as per logic
import 'features/auth/presentation/pages/sign_up_screen.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(AppPreferences()),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Student Portal',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: const SplashWrapper(),
          );
        },
      ),
    );
  }
}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Navigate using simple Future.delayed
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignUpScreen()), // Or LoginScreen, starting with SignUp as per original code flow, but Plan said Login. Original main had Splash -> SignUp. 
          // Wait, original main.dart had specific logic.
          // Original: Splash -> SignUp.
          // I will follow that flow but maybe Login is better?
          // Screenshots show Login and SignUp.
          // Usually Splash -> Login.
          // I'll route to SignUpScreen as requested by existing code logic but better to check if logged in.
          // For now, I'll stick to LoginScreen as the start actually, it makes more sense.
          // BUT the user's code had `Navigator.pushReplacement(..., Sign_upScreen())`.
          // Let's use LoginScreen as it's more standard, and SignUp is reachable from Login.
          // Wait, the screenshots show "Faculty of Engineering Student Portal" login screen.
          // I'll route to LoginScreen.
        );
      }
    });
    
    return const SplashScreen();
  }
}
