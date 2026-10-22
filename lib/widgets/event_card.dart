import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../utils/formatters.dart';

class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  final VoidCallback onRegister;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final isFree = event.price == 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon kategori + judul
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventIconTile(event: event),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.category,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: event.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              IconText(icon: Icons.calendar_today_outlined, text: event.date),
              const SizedBox(height: 6),
              IconText(icon: Icons.place_outlined, text: event.location),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 12),

              // Harga, sisa kursi, tombol daftar
              Row(
                children: [
                  Text(
                    formatPrice(event.price),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isFree
                          ? const Color(0xFF16A34A)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '· ${event.seatsAvailable} kursi',
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: onRegister,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Daftar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kotak ikon berwarna lembut sesuai warna aksen event.
class EventIconTile extends StatelessWidget {
  final EventItem event;
  final double size;

  const EventIconTile({super.key, required this.event, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: event.accentColor.withAlpha(24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(event.icon, color: event.accentColor, size: size * 0.5),
    );
  }
}

/// Baris ikon kecil + teks abu-abu untuk info sekunder.
class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, size: 16, color: muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
