import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import 'app_input_field.dart';

class NewClientDialog extends StatefulWidget {
  const NewClientDialog({super.key});

  @override
  State<NewClientDialog> createState() => _NewClientDialogState();
}

class _NewClientDialogState extends State<NewClientDialog> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _lastNameFocus = FocusNode();
  final _idFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _lastNameFocus.dispose();
    _idFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop({
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'idNumber': _idController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
    });
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: theme.colorScheme.surface,
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nuevo cliente', style: context.sectionTitleStyle),
                const SizedBox(height: 24),
                AppInputField(
                  controller: _firstNameController,
                  label: 'Nombre(s)',
                  hint: 'Introduce el nombre',
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _lastNameFocus.requestFocus(),
                  validator: _requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: _lastNameController,
                  label: 'Apellido(s)',
                  hint: 'Introduce el apellido',
                  focusNode: _lastNameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _idFocus.requestFocus(),
                  validator: _requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: _idController,
                  label: 'Cédula',
                  hint: 'Introduce el número de cédula',
                  focusNode: _idFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                  keyboardType: TextInputType.number,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  hint: 'Introduce el teléfono',
                  focusNode: _phoneFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _addressFocus.requestFocus(),
                  keyboardType: TextInputType.phone,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: _addressController,
                  label: 'Dirección completa',
                  hint: 'Introduce la dirección',
                  focusNode: _addressFocus,
                  keyboardType: TextInputType.streetAddress,
                  validator: _requiredValidator,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _submit,
                      child: const Text('Guardar cliente'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
