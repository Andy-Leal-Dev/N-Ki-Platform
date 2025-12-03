import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/data_sources/static_data_source.dart';
import 'data/repositories/clientes_repository.dart';
import 'data/repositories/pagos_repository.dart';
import 'data/repositories/prestamos_repository.dart';
import 'data/repositories/resumen_repository.dart';
import 'data/repositories/tasas_repository.dart';
import 'data/repositories/historial_repository.dart';
import 'ui/constants/app_colors.dart';
import 'ui/screens/dashboard_page.dart';
import 'ui/screens/agenda_page.dart';
import 'ui/screens/forgot_password_email_page.dart';
import 'ui/screens/login_page.dart';
import 'ui/screens/loan_history_page.dart';
import 'ui/state/app_theme_scope.dart';
import 'ui/state/clientes_provider.dart';
import 'ui/state/prestamos_provider.dart';
import 'ui/state/resumen_provider.dart';
import 'ui/state/tasas_provider.dart';
import 'ui/state/historial_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initializeDateFormatting('es'),
    initializeDateFormatting('es_VE'),
  ]);

  final StaticDataSource dataSource = StaticDataSource();

  runApp(
    MultiProvider(
      providers: [
        Provider<StaticDataSource>.value(value: dataSource),
        ChangeNotifierProvider<ClientesProvider>(
          create: (_) => ClientesProvider(ClientesRepository(dataSource)),
        ),
        ChangeNotifierProvider<PrestamosProvider>(
          create: (_) => PrestamosProvider(
            prestamosRepository: PrestamosRepository(dataSource),
            pagosRepository: PagosRepository(dataSource),
          ),
        ),
        ChangeNotifierProvider<ResumenProvider>(
          create: (_) => ResumenProvider(ResumenRepository(dataSource)),
        ),
        ChangeNotifierProvider<TasasProvider>(
          create: (_) => TasasProvider(TasasRepository(dataSource)),
        ),
        ChangeNotifierProvider<HistorialProvider>(
          create: (_) => HistorialProvider(HistorialRepository(dataSource)),
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
        home: const DashboardPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/dashboard': (_) => const DashboardPage(),
          '/agenda': (_) => const AgendaPage(),
          '/forgot-password': (_) => const ForgotPasswordEmailPage(),
          '/loan-history': (_) => const LoanHistoryPage(),
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
