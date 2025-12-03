import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/dashboard_tab.dart';
import '../widgets/dashboard_segmented_control.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/new_loan_sheet.dart';
import '../widgets/new_client_dialog.dart';
import 'loan_history_page.dart';
import '../state/app_theme_scope.dart';
import '../state/clientes_provider.dart';
import '../state/prestamos_provider.dart';
import '../state/resumen_provider.dart';
import '../../data/models/agenda_registro.dart';
import '../../data/models/prestamo.dart';
import '../../data/models/cliente.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardTab _activeTab = DashboardTab.loans;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _DashboardHeader(
              activeTab: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
              onMenuTap: _openProfileSheet,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _activeTab == DashboardTab.loans
                      ? _LoansView(
                          key: const ValueKey('loans-view'),
                          onCreateLoan: _openNewLoanSheet,
                        )
                      : _ClientsView(
                          key: const ValueKey('clients-view'),
                          onCreateClient: _openNewClientDialog,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNewLoanSheet() async {
    final Map<String, String>? result =
        await showModalBottomSheet<Map<String, String>>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext modalContext) {
            return const NewLoanSheet();
          },
        );

    if (!mounted || result == null) {
      return;
    }

    final String client = result['client'] ?? 'cliente';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Préstamo creado para $client.')));
  }

  Future<void> _openNewClientDialog() async {
    final Map<String, String>? client = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const NewClientDialog(),
    );

    if (!mounted || client == null) {
      return;
    }

    final String firstName = client['firstName'] ?? '';
    final String lastName = client['lastName'] ?? '';
    final String displayName = [
      firstName,
      lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();

    final String message = displayName.isEmpty
        ? 'Cliente registrado correctamente.'
        : 'Cliente $displayName registrado.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openProfileSheet() {
    final BuildContext rootContext = context;
    final AppPalette palette = rootContext.palette;
    final TextStyle? menuTitleStyle = Theme.of(rootContext)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w600, color: palette.primaryText);

    showModalBottomSheet<void>(
      context: rootContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.45,
              maxChildSize: 0.9,
              expand: false,
              builder: (sheetBodyContext, scrollController) {
                final AppPalette sheetPalette = sheetBodyContext.palette;
                final AppThemeScope? themeScope = AppThemeScope.maybeOf(
                  sheetBodyContext,
                );
                final bool darkModeEnabled =
                    themeScope?.isDark(sheetBodyContext) ??
                    (Theme.of(sheetBodyContext).brightness == Brightness.dark);
                final TextStyle? sheetMenuTitleStyle =
                    Theme.of(sheetBodyContext).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: sheetPalette.primaryText,
                    ) ??
                    menuTitleStyle;
                return Container(
                  decoration: BoxDecoration(
                    color: sheetPalette.cardBackground,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: sheetPalette.dashedBorder,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: sheetPalette.accentSoft,
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 40,
                                    color: sheetPalette.accent,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ana González',
                                        style: sheetMenuTitleStyle?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ana.gonzalez@n-ki.com',
                                        style: sheetBodyContext
                                            .sectionSubtitleStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(modalContext).pop();
                                    ScaffoldMessenger.of(
                                      rootContext,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Editar perfil disponible próximamente.',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Editar'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Divider(height: 1, color: sheetPalette.divider),
                            const SizedBox(height: 12),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.history_rounded,
                                color: sheetPalette.primaryStart,
                              ),
                              title: Text(
                                'Historial de préstamos',
                                style: sheetMenuTitleStyle,
                              ),
                              subtitle: Text(
                                'Consulta tus operaciones anteriores.',
                                style: sheetBodyContext.sectionSubtitleStyle,
                              ),
                              onTap: () {
                                Navigator.of(modalContext).pop();
                                Navigator.of(rootContext).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const LoanHistoryPage(),
                                  ),
                                );
                              },
                            ),
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              value: darkModeEnabled,
                              activeColor: sheetPalette.accent,
                              title: Text(
                                'Modo oscuro',
                                style: sheetMenuTitleStyle,
                              ),
                              subtitle: Text(
                                'Activa o desactiva el modo oscuro manualmente.',
                                style: sheetBodyContext.sectionSubtitleStyle,
                              ),
                              secondary: Icon(
                                Icons.dark_mode_rounded,
                                color: sheetPalette.primaryStart,
                              ),
                              onChanged: (value) {
                                themeScope?.onModeChanged(
                                  value ? ThemeMode.dark : ThemeMode.light,
                                );
                                setSheetState(() {});
                                ScaffoldMessenger.of(rootContext).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      value
                                          ? 'Modo oscuro activado.'
                                          : 'Modo claro activado.',
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.help_outline_rounded,
                                color: sheetPalette.primaryStart,
                              ),
                              title: Text('Ayuda', style: sheetMenuTitleStyle),
                              subtitle: Text(
                                'Resuelve dudas sobre N-Ki.',
                                style: sheetBodyContext.sectionSubtitleStyle,
                              ),
                              onTap: () {
                                Navigator.of(modalContext).pop();
                                ScaffoldMessenger.of(rootContext).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Centro de ayuda próximamente.',
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.logout_rounded,
                                color: sheetPalette.accent,
                              ),
                              title: Text(
                                'Cerrar sesión',
                                style: sheetMenuTitleStyle?.copyWith(
                                  color: sheetPalette.accent,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(modalContext).pop();
                                ScaffoldMessenger.of(rootContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sesión cerrada.'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.activeTab,
    required this.onTabChanged,
    required this.onMenuTap,
  });

  final DashboardTab activeTab;
  final ValueChanged<DashboardTab> onTabChanged;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: palette.primaryGradient.last,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white.withOpacity(0.16),
                    ),
                    child: Image.asset(
                      "assets/logogb.png",
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('N-Ki', style: context.headerTitleStyle),
                      const SizedBox(height: 4),
                      Text(
                        "Pa' que no te jueguen kikiriwiki",
                        style: context.headerSubtitleStyle,
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: onMenuTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: const Icon(Icons.menu_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          DashboardSegmentedControl(
            activeTab: activeTab,
            onChanged: onTabChanged,
          ),
        ],
      ),
    );
  }
}

class _LoansView extends StatelessWidget {
  const _LoansView({super.key, required this.onCreateLoan});

  final VoidCallback onCreateLoan;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final prestamosProvider = context.watch<PrestamosProvider>();
    final resumenProvider = context.watch<ResumenProvider>();
    final clientesProvider = context.watch<ClientesProvider>();

    if (prestamosProvider.isLoading && prestamosProvider.prestamos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final double capitalPrestado =
        resumenProvider.latest?.capitalPrestado ??
        prestamosProvider.prestamos.fold<double>(
          0.0,
          (acc, p) => acc + (p.montoCapital),
        );
    final double ganancias = resumenProvider.latest?.gananciasTotales ?? 0.0;
    final double cobroProyectado = prestamosProvider.prestamos.fold<double>(
      0.0,
      (acc, p) => acc + (p.montoCapital * (p.tasaInteres / 100) / 12),
    );

    final prestamoActivos = prestamosProvider.prestamos
        .where((p) => p.estado.toLowerCase() == 'activo')
        .toList();
    final List<AgendaRegistro> agenda = prestamosProvider.agenda;

    final int totalClientes =
        resumenProvider.latest?.totalClientes ??
        clientesProvider.clientes.length;
    final int totalPrestamos =
        resumenProvider.latest?.totalPrestamosActivos ?? prestamoActivos.length;
    final int agendaPendiente = agenda.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _InfoBadge(
              label: 'Préstamos activos',
              value: totalPrestamos.toString(),
            ),
            _InfoBadge(label: 'Clientes', value: totalClientes.toString()),
            _InfoBadge(
              label: 'Cuotas en agenda',
              value: agendaPendiente.toString(),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SummaryStatCard(
                title: 'CAPITAL PRESTADO',
                value: '\$${capitalPrestado.toStringAsFixed(2)}',
                subtitle: 'Dinero activo en la calle',
                icon: Icons.account_balance_outlined,
                background: palette.subtleBlueBackground,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: SummaryStatCard(
                title: 'GANANCIAS',
                value: '\$${ganancias.toStringAsFixed(2)}',
                subtitle: 'Total intereses cobrados',
                icon: Icons.trending_up_rounded,
                background: palette.subtleGreenBackground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SummaryStatCard(
          title: 'Cobro Proyectado',
          value: '\$${cobroProyectado.toStringAsFixed(2)}',
          subtitle: 'Intereses por periodo',
          icon: Icons.calendar_today_outlined,
          background: palette.cardBackground,
        ),
        const SizedBox(height: 32),
        Text('Préstamos Activos', style: context.sectionTitleStyle),
        const SizedBox(height: 12),
        if (prestamoActivos.isEmpty)
          EmptyStateCard(
            message: 'No tienes préstamos activos.',
            actionLabel: 'Crear Nuevo',
            onAction: onCreateLoan,
          )
        else
          Column(
            children: prestamoActivos.map<Widget>((p) {
              final List<AgendaRegistro> cuotas =
                  agenda.where((item) => item.prestamoId == p.id).toList()
                    ..sort(
                      (a, b) =>
                          a.fechaVencimiento.compareTo(b.fechaVencimiento),
                    );
              final AgendaRegistro? nextCuota = cuotas.isNotEmpty
                  ? cuotas.first
                  : null;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _LoanCard(
                  prestamo: p,
                  nextCuota: nextCuota,
                  cuotaCount: cuotas.length,
                  onTap: () => _showLoanDetail(context, p, cuotas),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 24),
        const _EntityRelationshipCard(),
      ],
    );
  }

  Future<void> _showLoanDetail(
    BuildContext context,
    Prestamo prestamo,
    List<AgendaRegistro> cuotas,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LoanDetailSheet(prestamo: prestamo, cuotas: cuotas),
    );
  }
}

class _ClientsView extends StatelessWidget {
  const _ClientsView({super.key, required this.onCreateClient});

  final VoidCallback onCreateClient;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final clientesProvider = context.watch<ClientesProvider>();
    final prestamosProvider = context.watch<PrestamosProvider>();
    final clients = clientesProvider.clientes;
    final loans = prestamosProvider.prestamos;
    final int activos = loans
        .where((p) => p.estado.toLowerCase() == 'activo')
        .length;
    final double capitalClientes = loans.fold<double>(
      0,
      (acc, item) => acc + item.montoCapital,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Cartera de Clientes', style: context.sectionTitleStyle),
            FilledButton.icon(
              onPressed: onCreateClient,
              style: FilledButton.styleFrom(
                backgroundColor: palette.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: Text('Nuevo', style: context.buttonLabelStyle),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _InfoBadge(
              label: 'Clientes activos',
              value: clients.length.toString(),
            ),
            _InfoBadge(label: 'Préstamos asociados', value: activos.toString()),
            _InfoBadge(
              label: 'Capital cartera',
              value: _formatCurrency(capitalClientes),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (clientesProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (clients.isEmpty)
          EmptyStateCard(
            message: 'No tienes clientes registrados',
            actionLabel: 'Agregar cliente',
            onAction: onCreateClient,
          )
        else
          Column(
            children: clients.map((c) {
              final related = loans.where((p) => p.clienteId == c.id).toList();
              final double deudaActiva = related
                  .where((p) => p.estado.toLowerCase() == 'activo')
                  .fold<double>(0, (acc, p) => acc + p.saldoPendiente);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ClientCard(
                  cliente: c,
                  prestamos: related,
                  deudaPendiente: deudaActiva,
                  onTap: () => _showClientDetail(context, c, related),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Future<void> _showClientDetail(
    BuildContext context,
    Cliente cliente,
    List<Prestamo> prestamos,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          _ClientDetailSheet(cliente: cliente, prestamos: prestamos),
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({
    required this.prestamo,
    required this.nextCuota,
    required this.cuotaCount,
    required this.onTap,
  });

  final Prestamo prestamo;
  final AgendaRegistro? nextCuota;
  final int cuotaCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final bool isDelayed =
        nextCuota != null &&
        nextCuota!.fechaVencimiento.isBefore(DateTime.now());
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
                    prestamo.cliente.nombre,
                    style: context.sectionTitleStyle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: prestamo.estado.toLowerCase() == 'activo'
                        ? palette.subtleGreenBackground
                        : palette.subtleBlueBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prestamo.estado.toUpperCase(),
                    style: TextStyle(
                      color: palette.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Capital: ${_formatCurrency(prestamo.montoCapital)}',
              style: AppTextStyles.statValue(context).copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              'Saldo pendiente: ${_formatCurrency(prestamo.saldoPendiente)}',
              style: context.sectionSubtitleStyle,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cuotas programadas: $cuotaCount',
                    style: context.sectionSubtitleStyle,
                  ),
                ),
                if (nextCuota != null)
                  Row(
                    children: [
                      Icon(
                        isDelayed
                            ? Icons.error_outline
                            : Icons.schedule_rounded,
                        size: 16,
                        color: isDelayed ? palette.accent : palette.primaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(nextCuota!.fechaVencimiento),
                        style: context.sectionSubtitleStyle,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanDetailSheet extends StatelessWidget {
  const _LoanDetailSheet({required this.prestamo, required this.cuotas});

  final Prestamo prestamo;
  final List<AgendaRegistro> cuotas;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (buildContext, controller) {
        return Container(
          decoration: BoxDecoration(
            color: palette.cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.dashedBorder,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Detalle del préstamo',
                style: buildContext.sectionTitleStyle,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _InfoBadge(
                    label: 'Capital',
                    value: _formatCurrency(prestamo.montoCapital),
                  ),
                  _InfoBadge(
                    label: 'Saldo',
                    value: _formatCurrency(prestamo.saldoPendiente),
                  ),
                  _InfoBadge(
                    label: 'Tasa %',
                    value: prestamo.tasaInteres.toStringAsFixed(2),
                  ),
                  _InfoBadge(
                    label: 'Frecuencia',
                    value: prestamo.frecuenciaPago,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Cliente'),
                subtitle: Text(prestamo.cliente.nombre),
                trailing: Text(prestamo.cliente.cedula),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Periodo'),
                subtitle: Text(
                  '${_formatDate(prestamo.fechaInicio)} - ${_formatDate(prestamo.fechaVencimiento)}',
                ),
              ),
              const SizedBox(height: 8),
              Text('Agenda de cuotas', style: buildContext.sectionTitleStyle),
              const SizedBox(height: 8),
              if (cuotas.isEmpty)
                Text(
                  'Aún no hay cuotas registradas para este préstamo.',
                  style: buildContext.sectionSubtitleStyle,
                )
              else
                ...cuotas.map(
                  (cuota) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        'Cuota #${cuota.numeroCuota}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(_formatDate(cuota.fechaVencimiento)),
                      trailing: Text(
                        _formatCurrency(cuota.montoTotalCuota),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    required this.cliente,
    required this.prestamos,
    required this.deudaPendiente,
    required this.onTap,
  });

  final Cliente cliente;
  final List<Prestamo> prestamos;
  final double deudaPendiente;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final int activos = prestamos
        .where((p) => p.estado.toLowerCase() == 'activo')
        .length;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(cliente.nombre, style: context.sectionTitleStyle),
                ),
                Text(cliente.cedula, style: context.sectionSubtitleStyle),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              cliente.telefono ?? 'Sin teléfono',
              style: context.sectionSubtitleStyle,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Préstamos activos: $activos',
                    style: context.sectionSubtitleStyle,
                  ),
                ),
                Text(
                  'Deuda: ${_formatCurrency(deudaPendiente)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientDetailSheet extends StatelessWidget {
  const _ClientDetailSheet({required this.cliente, required this.prestamos});

  final Cliente cliente;
  final List<Prestamo> prestamos;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final double totalCapital = prestamos.fold<double>(
      0,
      (acc, item) => acc + item.montoCapital,
    );
    final double saldoPendiente = prestamos.fold<double>(
      0,
      (acc, item) => acc + item.saldoPendiente,
    );
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (buildContext, controller) {
        return Container(
          decoration: BoxDecoration(
            color: palette.cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.dashedBorder,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(cliente.nombre, style: buildContext.sectionTitleStyle),
              const SizedBox(height: 8),
              Text(cliente.cedula, style: buildContext.sectionSubtitleStyle),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _InfoBadge(
                    label: 'Préstamos totales',
                    value: prestamos.length.toString(),
                  ),
                  _InfoBadge(
                    label: 'Capital entregado',
                    value: _formatCurrency(totalCapital),
                  ),
                  _InfoBadge(
                    label: 'Saldo vigente',
                    value: _formatCurrency(saldoPendiente),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Teléfono'),
                subtitle: Text(cliente.telefono ?? 'Sin registro'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dirección'),
                subtitle: Text(cliente.direccion ?? 'Sin registro'),
              ),
              const SizedBox(height: 12),
              Text(
                'Préstamos asociados',
                style: buildContext.sectionTitleStyle,
              ),
              const SizedBox(height: 8),
              if (prestamos.isEmpty)
                Text(
                  'Este cliente aún no tiene préstamos registrados.',
                  style: buildContext.sectionSubtitleStyle,
                )
              else
                ...prestamos.map(
                  (p) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text('Préstamo #${p.id}'),
                      subtitle: Text(
                        'Estado: ${p.estado} · ${_formatDate(p.fechaVencimiento)}',
                      ),
                      trailing: Text(
                        _formatCurrency(p.saldoPendiente),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EntityRelationshipCard extends StatelessWidget {
  const _EntityRelationshipCard();

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final List<Map<String, String>> relations = [
      {'from': 'Clientes', 'to': 'Préstamos', 'type': '1:N'},
      {'from': 'Préstamos', 'to': 'Cuotas', 'type': '1:N'},
      {'from': 'Cuotas', 'to': 'Pagos', 'type': '1:N'},
      {'from': 'Préstamos', 'to': 'Tasas', 'type': 'N:1'},
      {'from': 'Préstamos', 'to': 'Resumen', 'type': 'N:1'},
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.subtleBlueBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Diagrama entidad-relación', style: context.sectionTitleStyle),
          const SizedBox(height: 8),
          Text(
            'Resumen rápido de cómo se conectan las tablas principales en N-Ki.',
            style: context.sectionSubtitleStyle,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Clientes')),
              Chip(label: Text('Préstamos')),
              Chip(label: Text('Cuotas')),
              Chip(label: Text('Pagos')),
              Chip(label: Text('Tasas')),
              Chip(label: Text('Resumen')),
            ],
          ),
          const SizedBox(height: 12),
          ...relations.map(
            (relation) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_tree_outlined),
              title: Text('${relation['from']} → ${relation['to']}'),
              subtitle: Text('Relación ${relation['type']}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.dashedBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: context.sectionSubtitleStyle),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

final NumberFormat _currencyFormatter = NumberFormat.currency(
  locale: 'es_VE',
  symbol: r'$',
);
final DateFormat _dateFormatter = DateFormat('dd MMM yyyy', 'es');

String _formatCurrency(double value) => _currencyFormatter.format(value);
String _formatDate(DateTime date) => _dateFormatter.format(date);
