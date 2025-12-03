import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/empty_state_card.dart';
import '../state/historial_provider.dart';
import '../../data/models/historial_entry.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  State<LoanHistoryPage> createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage> {
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'es_VE',
    symbol: r'$',
  );
  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'es');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistorialProvider>().loadHistorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de préstamos'),
        backgroundColor: palette.cardBackground,
        foregroundColor: palette.primaryText,
        elevation: 0,
      ),
      backgroundColor: palette.pageBackground,
      body: Consumer<HistorialProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && !provider.hasEntries) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                'No pudimos cargar el historial.\n${provider.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!provider.hasEntries) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyStateCard(
                message: 'Todavía no hay movimientos registrados.',
                actionLabel: 'Actualizar',
                onAction: provider.loadHistorial,
              ),
            );
          }

          final List<HistorialEntry> entries = provider.entries;
          return Column(
            children: [
              _FiltersBar(
                activeFilter: provider.filter ?? 'todos',
                onFilterSelected: provider.setFilter,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final HistorialEntry entry = entries[index];
                    return _HistoryTile(
                      entry: entry,
                      currencyFormatter: _currencyFormatter,
                      dateFormatter: _dateFormatter,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.activeFilter,
    required this.onFilterSelected,
  });

  final String activeFilter;
  final ValueChanged<String?> onFilterSelected;

  static const List<Map<String, String>> _filters = [
    {'value': 'todos', 'label': 'Todos'},
    {'value': 'cuota', 'label': 'Cuotas'},
    {'value': 'abono', 'label': 'Abonos'},
    {'value': 'desembolso', 'label': 'Desembolsos'},
    {'value': 'refinanciación', 'label': 'Refinanciaciones'},
  ];

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final Map<String, String> filter = _filters[index];
          final bool selected = activeFilter == filter['value'];
          return ChoiceChip(
            label: Text(filter['label'] ?? ''),
            selected: selected,
            selectedColor: palette.accentSoft,
            onSelected: (_) => onFilterSelected(filter['value']),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.currencyFormatter,
    required this.dateFormatter,
  });

  final HistorialEntry entry;
  final NumberFormat currencyFormatter;
  final DateFormat dateFormatter;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final bool isPending = entry.estado == 'pendiente';
    final Color statusColor = isPending ? palette.accent : palette.primaryText;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.clienteNombre,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: palette.subtleBlueBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(entry.prestamoCodigo),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${entry.tipoMovimiento.toUpperCase()} · ${entry.canal}',
            style: context.sectionSubtitleStyle,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  currencyFormatter.format(entry.monto),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dateFormatter.format(entry.fechaMovimiento.toLocal()),
                    style: context.sectionSubtitleStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Saldo: ${currencyFormatter.format(entry.saldoRestante)}',
                    style: context.sectionSubtitleStyle,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.brightness_1, size: 10, color: statusColor),
              const SizedBox(width: 6),
              Text(
                entry.estado.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (entry.nota != null && entry.nota!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(entry.nota!),
          ],
        ],
      ),
    );
  }
}
