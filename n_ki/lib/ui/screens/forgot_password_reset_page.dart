import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_input_field.dart';

class ForgotPasswordResetPage extends StatefulWidget {
  const ForgotPasswordResetPage({super.key, required this.email});

  final String email;

  @override
  State<ForgotPasswordResetPage> createState() =>
      _ForgotPasswordResetPageState();
}

class _ForgotPasswordResetPageState extends State<ForgotPasswordResetPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
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
        title: const Text('Nueva contraseña'),
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
                'Crea tu nueva contraseña',
                style: context.sectionTitleStyle,
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  text: 'Ingresa una contraseña segura para la cuenta ',
                  style: context.sectionSubtitleStyle.copyWith(height: 1.4),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: context.sectionSubtitleStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: palette.primaryText,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AppInputField(
                label: 'Nueva contraseña',
                hint: 'Ingresa tu nueva contraseña',
                obscure: _obscurePassword,
                controller: _passwordController,
                fieldKey: const ValueKey('forgot-new-password'),
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: palette.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppInputField(
                label: 'Confirmar contraseña',
                hint: 'Vuelve a escribirla',
                obscure: _obscureConfirm,
                controller: _confirmController,
                fieldKey: const ValueKey('forgot-confirm-password'),
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: palette.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onResetPassword,
                  child: const Text('Guardar contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onResetPassword() {
    final String password = _passwordController.text.trim();
    final String confirm = _confirmController.text.trim();

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres.'),
        ),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Contraseña actualizada'),
        content: const Text(
          'Tu contraseña se ha actualizado correctamente. Inicia sesión nuevamente.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
