import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_input_field.dart';
import 'forgot_password_code_page.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() =>
      _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: palette.primaryText),
        title: const Text('Recuperar contraseña'),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: palette.primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Olvidaste tu contraseña?',
                style: context.sectionTitleStyle,
              ),
              const SizedBox(height: 6),
              Text(
                'Ingresa el correo asociado a tu cuenta y te enviaremos un código de verificación.',
                style: context.sectionSubtitleStyle.copyWith(height: 1.4),
              ),
              const SizedBox(height: 28),
              AppInputField(
                label: 'Correo electrónico',
                hint: 'tuemail@empresa.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                controller: _emailController,
                autofillHints: const [AutofillHints.email],
                fieldKey: const ValueKey('forgot-email-field'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onSendCode,
                  child: const Text('Enviar código'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSendCode() {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa tu correo electrónico.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ForgotPasswordCodePage(email: email),
      ),
    );
  }
}
