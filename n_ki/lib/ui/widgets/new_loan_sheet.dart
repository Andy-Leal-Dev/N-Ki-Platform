import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'app_input_field.dart';

class NewLoanSheet extends StatefulWidget {
  const NewLoanSheet({super.key});

  @override
  State<NewLoanSheet> createState() => _NewLoanSheetState();
}

class _NewLoanSheetState extends State<NewLoanSheet> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final FocusNode _clientFocusNode = FocusNode();

  final List<String> _frequentClients = <String>[
    'Ana González',
    'Carlos Pérez',
    'María Rodríguez',
    'José Martínez',
    'Lucía Fernández',
  ];

  final List<String> _frequencies = <String>[
    'Diario',
    'Semanal',
    'Quincenal',
    'Mensual',
  ];

  String _selectedFrequency = 'Semanal';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clientFocusNode.addListener(_handleClientFocusChange);
    _startDateController.text = _formatDate(_selectedDate);
    _capitalController.text = '1000';
    _interestController.text = '10';
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _clientController.dispose();
    _capitalController.dispose();
    _interestController.dispose();
    _startDateController.dispose();
    _clientFocusNode
      ..removeListener(_handleClientFocusChange)
      ..dispose();
    super.dispose();
  }

  void _handleClientFocusChange() {
    if (_clientFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        try {
          _sheetController.animateTo(
            0.95,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
          );
        } catch (_) {
          // Controller might not be attached yet; ignore and let the user drag manually.
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickStartDate() async {
    final DateTime initialDate = _selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _startDateController.text = _formatDate(picked);
      });
    }
  }

  void _fillClient(String client) {
    _clientController.text = client;
    _clientController.selection = TextSelection.fromPosition(
      TextPosition(offset: _clientController.text.length),
    );
    FocusScope.of(context).requestFocus(_clientFocusNode);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final String client = _clientController.text.trim();
    final String capital = _capitalController.text.trim();
    final String interest = _interestController.text.trim();

    if (client.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona o ingresa un cliente.')),
      );
      return;
    }
    if (capital.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el capital del préstamo.')),
      );
      return;
    }
    if (interest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el interés del préstamo.')),
      );
      return;
    }

    Navigator.of(context).pop(<String, String>{
      'client': client,
      'capital': capital,
      'interest': interest,
      'frequency': _selectedFrequency,
      'startDate': _startDateController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.72,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: palette.cardBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border.all(
                color: palette.dashedBorder.withOpacity(0.6),
                width: 1,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ListView(
                controller: scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: palette.dashedBorder,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Text(
                        'Nuevo Préstamo',
                        style: AppTextStyles.sectionTitle(
                          context,
                        ).copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: palette.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Define los detalles del préstamo y confirma para guardarlo.',
                    style: AppTextStyles.sectionSubtitle(context),
                  ),
                  const SizedBox(height: 24),
                  AppInputField(
                    label: '¿A quién le prestas?',
                    hint: 'Buscar por Nombre o Cédula...',
                    controller: _clientController,
                    suffix: const Icon(Icons.search_rounded),
                    focusNode: _clientFocusNode,
                    textInputAction: TextInputAction.search,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Clientes frecuentes',
                    style: AppTextStyles.sectionSubtitle(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: palette.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final String client = _frequentClients[index];
                        return ActionChip(
                          label: Text(
                            client,
                            style: AppTextStyles.sectionSubtitle(context),
                          ),
                          backgroundColor: palette.cardBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: palette.dashedBorder),
                          ),
                          onPressed: () {
                            _fillClient(client);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: _frequentClients.length,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppInputField(
                          label: 'Capital (\$)',
                          hint: 'Ej. 1000',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: _capitalController,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppInputField(
                          label: 'Interés (%)',
                          hint: 'Ej. 10',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: _interestController,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedFrequency,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          style: AppTextStyles.sectionSubtitle(context),
                          items: _frequencies
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: AppTextStyles.sectionSubtitle(
                                      context,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (String? value) {
                            if (value == null) {
                              return;
                            }
                            setState(() => _selectedFrequency = value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Frecuencia',
                            hintStyle: TextStyle(
                              color: palette.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppInputField(
                          label: 'Fecha inicio',
                          controller: _startDateController,
                          readOnly: true,
                          onTap: _pickStartDate,
                          suffix: const Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Confirmar Préstamo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
