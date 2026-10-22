import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;
  final Function(String ticketId) onTicketDeleted;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onTicketDeleted,
  });

  @override
  State<RegisteredTicketsScreen> createState() =>
      _RegisteredTicketsScreenState();
}

class _RegisteredTicketsScreenState extends State<RegisteredTicketsScreen> {
  // Salinan lokal agar item yang di-dismiss langsung hilang dari tree layar ini.
  late final List<RegistrationTicket> _tickets = List.of(widget.tickets);

  Future<bool?> _confirmCancel(RegistrationTicket ticket) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan tiket?'),
        content: Text(
          'Pendaftaran "${ticket.eventTitle}" atas nama ${ticket.attendeeName} akan dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              minimumSize: const Size(0, 40),
            ),
            child: const Text('Ya, batalkan'),
          ),
        ],
      ),
    );
  }

  void _removeTicket(RegistrationTicket ticket) {
    setState(() => _tickets.removeWhere((t) => t.id == ticket.id));
    widget.onTicketDeleted(ticket.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tiket ${ticket.id} dibatalkan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: const Text('Tiket Pendaftaran Saya')),
      body: _tickets.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 56,
                      color: muted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada tiket',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Daftar ke salah satu event di beranda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Lihat Katalog Event'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: _tickets.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    children: [
                      Icon(Icons.swipe_left_outlined, size: 18, color: muted),
                      const SizedBox(width: 8),
                      Text(
                        'Geser tiket ke kiri untuk membatalkan',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                    ],
                  );
                }

                final ticket = _tickets[index - 1];
                return Dismissible(
                  key: Key(ticket.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (_) => _confirmCancel(ticket),
                  onDismissed: (_) => _removeTicket(ticket),
                  child: _TicketCard(ticket: ticket),
                );
              },
            ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final RegistrationTicket ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    const green = Color(0xFF16A34A);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ticket.id,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: muted,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.check_circle, size: 14, color: green),
                const SizedBox(width: 4),
                Text(
                  'Terkonfirmasi',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.eventTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Peserta',
                    value: ticket.attendeeName,
                  ),
                ),
                Expanded(
                  child: _InfoItem(label: 'Tipe', value: ticket.ticketType),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Tanggal',
                    value: ticket.attendedDate,
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Jumlah',
                    value: '${ticket.seatCount} kursi',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
