import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_input_field.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildLoginCard(context),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text('Crear una cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final AppPalette palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: palette.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white.withOpacity(0.16),
                ),
                child: Image.asset("assets/logogb.png", width: 60, height: 60),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('N-Ki', style: context.headerTitleStyle),
                  const SizedBox(height: 6),
                  Text(
                    "Pa' que no te jueguen kikiriwiki",
                    style: context.headerSubtitleStyle,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Bienvenido de vuelta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Inicia sesión para seguir llevando tus finanzas al día.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final AppPalette palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputField(
            label: 'Correo electrónico',
            hint: 'tuemail@empresa.com',
            keyboardType: TextInputType.emailAddress,
            fieldKey: const ValueKey('login-email-field'),
          ),
          const SizedBox(height: 20),
          AppInputField(
            label: 'Contraseña',
            obscure: true,
            hint: 'Ingresa tu contraseña',
            suffix: const Icon(Icons.visibility_off_outlined),
            fieldKey: const ValueKey('login-password-field'),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/forgot-password');
              },
              child: const Text('¿Olvidaste la contraseña?'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/dashboard');
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Iniciar Sesión'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: palette.divider, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'o',
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: palette.divider, thickness: 1)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide(color: palette.dashedBorder),
              ),
              icon: Icon(
                Icons.g_mobiledata_rounded,
                size: 32,
                color: palette.accent,
              ),
              label: Text(
                'Continuar con Google',
                style: TextStyle(
                  color: palette.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
