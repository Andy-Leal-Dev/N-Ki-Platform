import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/agenda_registro.dart';
import '../state/prestamos_provider.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrestamosProvider>().loadAgenda();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de préstamos')),
      body: Consumer<PrestamosProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<AgendaRegistro> items = provider.agenda;
          if (items.isEmpty) {
            return const Center(child: Text('No hay registros en la agenda.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final AgendaRegistro r = items[index];
              return ListTile(
                title: Text('${r.clienteNombre} — Cuota #${r.numeroCuota}'),
                subtitle: Text(
                  'Vence: ${r.fechaVencimiento.toLocal().toString().split(" ").first}',
                ),
                trailing: Text('\$${r.montoTotalCuota.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
