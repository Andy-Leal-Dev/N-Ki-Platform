import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/dashboard_tab.dart';
import '../widgets/dashboard_segmented_control.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/new_loan_sheet.dart';
import '../widgets/new_client_dialog.dart';
import '../state/app_theme_scope.dart';

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
                                ScaffoldMessenger.of(rootContext).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Historial disponible próximamente.',
                                    ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryStatCard(
                title: 'CAPITAL PRESTADO',
                value: '\$0',
                subtitle: 'Dinero activo en la calle',
                icon: Icons.account_balance_outlined,
                background: palette.subtleBlueBackground,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: SummaryStatCard(
                title: 'GANANCIAS',
                value: '\$0',
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
          value: '\$0',
          subtitle: 'Intereses por periodo',
          icon: Icons.calendar_today_outlined,
          background: palette.cardBackground,
        ),
        const SizedBox(height: 32),
        Text('Préstamos Activos', style: context.sectionTitleStyle),
        const SizedBox(height: 12),
        EmptyStateCard(
          message: 'No tienes préstamos activos.',
          actionLabel: 'Crear Nuevo',
          onAction: onCreateLoan,
        ),
      ],
    );
  }
}

class _ClientsView extends StatelessWidget {
  const _ClientsView({super.key, required this.onCreateClient});

  final VoidCallback onCreateClient;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
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
        EmptyStateCard(
          message: 'No tienes clientes registrados',
          actionLabel: 'Agregar cliente',
          onAction: onCreateClient,
        ),
      ],
    );
  }
}
