import 'package:flutter/material.dart';

class VenueMapViewer extends StatelessWidget {
  final String venueName;

  const VenueMapViewer({super.key, required this.venueName});

  static const _vip = Color(0xFFF59E0B);
  static const _regular = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: Text('Denah $venueName')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(Icons.pinch_outlined, size: 18, color: muted),
                const SizedBox(width: 8),
                Text(
                  'Cubit untuk zoom, geser untuk menjelajah',
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(40),
              minScale: 0.6,
              maxScale: 3.5,
              child: Center(
                child: Container(
                  width: 360,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Panggung
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'PANGGUNG',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSeatBlock(_vip, rows: 2),
                      const SizedBox(height: 14),
                      _buildSeatBlock(_regular, rows: 4),
                      const SizedBox(height: 20),

                      // Legenda
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildLegend(_vip, 'VIP'),
                          _buildLegend(_regular, 'Reguler'),
                          _buildFacility(Icons.how_to_reg_outlined, 'Check-in'),
                          _buildFacility(Icons.coffee_outlined, 'Snack'),
                          _buildFacility(Icons.exit_to_app, 'Darurat'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatBlock(Color color, {required int rows}) {
    return Column(
      children: [
        for (int r = 0; r < rows; r++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                8,
                (index) => Container(
                  width: 24,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color.withAlpha(40),
                    border: Border.all(color: color.withAlpha(140)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 9,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
        ),
      ],
    );
  }

  Widget _buildFacility(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF4B5563)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
        ),
      ],
    );
  }
}
