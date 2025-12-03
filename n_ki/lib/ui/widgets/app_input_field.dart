import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
    this.fieldKey,
    this.controller,
    this.onChanged,
    this.textInputAction,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final Key? fieldKey;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: palette.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          textAlign: textAlign,
          obscureText: obscure,
          autofillHints: autofillHints,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          textCapitalization: textCapitalization,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            counterText: maxLength != null ? '' : null,
          ),
        ),
      ],
    );
  }
}
