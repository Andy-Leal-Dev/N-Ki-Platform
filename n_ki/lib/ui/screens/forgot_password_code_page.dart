import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_input_field.dart';
import 'forgot_password_reset_page.dart';

class ForgotPasswordCodePage extends StatefulWidget {
  const ForgotPasswordCodePage({super.key, required this.email});

  final String email;

  @override
  State<ForgotPasswordCodePage> createState() => _ForgotPasswordCodePageState();
}

class _ForgotPasswordCodePageState extends State<ForgotPasswordCodePage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
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
        title: const Text('Verificar código'),
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
              Text('Verifica tu código', style: context.sectionTitleStyle),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  text: 'Enviamos un código de 6 dígitos al correo ',
                  style: context.sectionSubtitleStyle.copyWith(height: 1.4),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: context.sectionSubtitleStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: palette.primaryText,
                      ),
                    ),
                    const TextSpan(text: '. Ingrésalo para continuar.'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AppInputField(
                label: 'Código de verificación',
                hint: 'Ingresa el código de 6 dígitos',
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                controller: _codeController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                fieldKey: const ValueKey('forgot-code-field'),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hemos reenviado el código a tu correo.'),
                      ),
                    );
                  },
                  child: const Text('Reenviar código'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onVerifyCode,
                  child: const Text('Verificar código'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onVerifyCode() {
    final String code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El código debe tener 6 dígitos.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ForgotPasswordResetPage(email: widget.email),
      ),
    );
  }
}
