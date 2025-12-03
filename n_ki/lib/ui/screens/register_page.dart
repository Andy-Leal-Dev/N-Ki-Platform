import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_input_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Scaffold(
      backgroundColor: palette.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: palette.primaryText,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crear una cuenta', style: context.sectionTitleStyle),
              const SizedBox(height: 6),
              Text(
                'Regístrate en N-Ki y mantén tu cobranza organizada sin sorpresas.',
                style: context.sectionSubtitleStyle,
              ),
              const SizedBox(height: 28),
              _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
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
            label: 'Nombre',
            hint: 'Ingresa tu nombre',
            keyboardType: TextInputType.name,
            fieldKey: const ValueKey('register-firstname'),
          ),
          const SizedBox(height: 20),
          AppInputField(
            label: 'Apellido',
            hint: 'Ingresa tu apellido',
            keyboardType: TextInputType.name,
            fieldKey: const ValueKey('register-lastname'),
          ),
          const SizedBox(height: 20),
          AppInputField(
            label: 'Correo electrónico',
            hint: 'tuemail@empresa.com',
            keyboardType: TextInputType.emailAddress,
            fieldKey: const ValueKey('register-email'),
          ),
          const SizedBox(height: 20),
          AppInputField(
            label: 'Contraseña',
            hint: 'Crea una contraseña segura',
            obscure: true,
            suffix: const Icon(Icons.visibility_off_outlined),
            fieldKey: const ValueKey('register-password'),
          ),
          const SizedBox(height: 20),
          AppInputField(
            label: 'Fecha de nacimiento',
            hint: 'DD/MM/AAAA',
            keyboardType: TextInputType.datetime,
            suffix: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today_outlined),
              color: palette.secondaryText,
            ),
            fieldKey: const ValueKey('register-birthday'),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Crear cuenta'),
            ),
          ),
        ],
      ),
    );
  }
}
