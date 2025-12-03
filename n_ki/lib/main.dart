import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/storage/secure_storage.dart';
import 'core/storage/session_storage.dart';
import 'core/network/api_client.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/clientes_repository.dart';
import 'data/repositories/pagos_repository.dart';
import 'data/repositories/prestamos_repository.dart';
import 'data/repositories/resumen_repository.dart';
import 'data/repositories/tasas_repository.dart';
import 'ui/constants/app_colors.dart';
import 'ui/screens/dashboard_page.dart';
import 'ui/screens/forgot_password_email_page.dart';
import 'ui/screens/login_page.dart';
import 'ui/screens/splash_page.dart';
import 'ui/state/app_theme_scope.dart';
import 'ui/state/auth_provider.dart';
import 'ui/state/clientes_provider.dart';
import 'ui/state/prestamos_provider.dart';
import 'ui/state/resumen_provider.dart';
import 'ui/state/tasas_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppSecureStorage secureStorage = AppSecureStorage();
  final SessionStorage sessionStorage = SessionStorage(secureStorage);
  final AuthRepository authRepository = AuthRepository();
  final AuthProvider authProvider = AuthProvider(
    authRepository: authRepository,
    sessionStorage: sessionStorage,
  );
  await authProvider.initialize();

  late final ApiClient apiClient;
  apiClient = ApiClient(
    sessionStorage: sessionStorage,
    authRepository: authRepository,
    onUnauthorized: authProvider.handleUnauthorized,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SessionStorage>.value(value: sessionStorage),
        Provider<AuthRepository>.value(value: authRepository),
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ClientesProvider>(
          create: (_) => ClientesProvider(ClientesRepository(apiClient)),
        ),
        ChangeNotifierProvider<PrestamosProvider>(
          create: (_) => PrestamosProvider(
            prestamosRepository: PrestamosRepository(apiClient),
            pagosRepository: PagosRepository(apiClient),
          ),
        ),
        ChangeNotifierProvider<ResumenProvider>(
          create: (_) => ResumenProvider(ResumenRepository(apiClient)),
        ),
        ChangeNotifierProvider<TasasProvider>(
          create: (_) => TasasProvider(TasasRepository(apiClient)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _handleThemeModeChange(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      mode: _themeMode,
      onModeChanged: _handleThemeModeChange,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'N-Ki',
        themeMode: _themeMode,
        theme: _buildTheme(AppColors.light, Brightness.light),
        darkTheme: _buildTheme(AppColors.dark, Brightness.dark),
        home: const AuthGate(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/dashboard': (_) => const DashboardPage(),
          '/forgot-password': (_) => const ForgotPasswordEmailPage(),
        },
      ),
    );
  }

  ThemeData _buildTheme(AppPalette palette, Brightness brightness) {
    final ColorScheme colors =
        ColorScheme.fromSeed(
          seedColor: palette.accent,
          brightness: brightness,
        ).copyWith(
          primary: palette.primaryStart,
          secondary: palette.accent,
          tertiary: palette.accentDark,
          surface: palette.cardBackground,
          background: palette.pageBackground,
          onPrimary: Colors.white,
          outline: palette.dashedBorder,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: palette.pageBackground,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primaryText,
          side: BorderSide(color: palette.dashedBorder),
          backgroundColor: palette.cardBackground,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.subtleBlueBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.accent, width: 1.5),
        ),
        hintStyle: TextStyle(color: palette.mutedText),
      ),
      fontFamily: 'Roboto',
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider auth, Widget? child) {
        if (!auth.initialized) {
          return const SplashPage();
        }

        if (!auth.isAuthenticated) {
          return const LoginPage();
        }

        return const DashboardPage();
      },
    );
  }
}
