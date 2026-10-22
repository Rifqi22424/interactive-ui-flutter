import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../utils/formatters.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  final List<EventItem> _allEvents = sampleEvents;
  final List<RegistrationTicket> _registeredTickets = [];

  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  double _maxPrice = maxPriceFilter;

  @override
  void initState() {
    super.initState();
    // Contoh tiket awal untuk demonstrasi
    _registeredTickets.add(
      RegistrationTicket(
        id: 'TCK-98124',
        eventId: 'EVT-001',
        eventTitle: 'Flutter Forward Sukabumi 2026',
        attendeeName: 'Rifqi Pratama',
        email: 'rifqi@nusaputra.ac.id',
        ticketType: 'Mahasiswa Reguler',
        attendedDate: '28 Okt 2026',
        seatCount: 1,
        needReminder: true,
        registeredAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
  }

  bool get _hasActiveFilter =>
      _selectedCategory != 'Semua' || _maxPrice < maxPriceFilter;

  List<EventItem> get _filteredEvents {
    final query = _searchQuery.toLowerCase();
    return _allEvents.where((event) {
      final matchesQuery =
          event.title.toLowerCase().contains(query) ||
          event.speaker.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'Semua' || event.category == _selectedCategory;
      final matchesPrice = event.price <= _maxPrice;

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        maxPrice: _maxPrice,
        onApply: (cat, price) {
          setState(() {
            _selectedCategory = cat;
            _maxPrice = price;
          });
        },
      ),
    );
  }

  Future<void> _navigateToRegistration(EventItem event) async {
    final result = await Navigator.push<RegistrationTicket>(
      context,
      MaterialPageRoute(
        builder: (ctx) => EventRegistrationScreen(event: event),
      ),
    );

    if (result != null) {
      setState(() => _registeredTickets.add(result));
    }
  }

  void _openTickets() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => RegisteredTicketsScreen(
          tickets: _registeredTickets,
          onTicketDeleted: (id) {
            setState(() => _registeredTickets.removeWhere((t) => t.id == id));
          },
        ),
      ),
    );
  }

  void _openVenueMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) =>
            const VenueMapViewer(venueName: 'Auditorium Nusa Putra'),
      ),
    );
  }

  void _showEventDetail(EventItem event) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => _EventDetailSheet(
        event: event,
        onRegister: () {
          Navigator.pop(ctx);
          _navigateToRegistration(event);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedEvents = _filteredEvents;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaEvent Hub'),
        actions: [
          IconButton(
            tooltip: 'Denah Venue Interaktif',
            icon: const Icon(Icons.map_outlined),
            onPressed: _openVenueMap,
          ),
          IconButton(
            tooltip: 'Tiket Terdaftar',
            onPressed: _openTickets,
            icon: Badge.count(
              count: _registeredTickets.length,
              isLabelVisible: _registeredTickets.isNotEmpty,
              child: const Icon(Icons.confirmation_number_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pencarian + tombol filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: 'Cari event atau pembicara',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _openFilterBottomSheet,
                  tooltip: 'Filter Kegiatan',
                  style: IconButton.styleFrom(
                    fixedSize: const Size(48, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Badge(
                    isLabelVisible: _hasActiveFilter,
                    smallSize: 8,
                    child: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
          ),

          // Ringkasan hasil + filter aktif
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${displayedEvents.length} kegiatan',
                  style: TextStyle(color: muted),
                ),
                if (_selectedCategory != 'Semua')
                  InputChip(
                    label: Text(_selectedCategory),
                    visualDensity: VisualDensity.compact,
                    onDeleted: () =>
                        setState(() => _selectedCategory = 'Semua'),
                  ),
                if (_maxPrice < maxPriceFilter)
                  InputChip(
                    label: Text(
                      _maxPrice == 0
                          ? 'Gratis'
                          : '≤ ${formatRupiah(_maxPrice)}',
                    ),
                    visualDensity: VisualDensity.compact,
                    onDeleted: () => setState(() => _maxPrice = maxPriceFilter),
                  ),
              ],
            ),
          ),

          // Konten responsif: List (HP) atau Grid (tablet/desktop)
          Expanded(
            child: displayedEvents.isEmpty
                ? const _EmptyState()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Breakpoint: layar lebar >= 650dp → 2 kolom grid
                      final isWideScreen = constraints.maxWidth >= 650;

                      Widget buildCard(BuildContext context, int index) {
                        final event = displayedEvents[index];
                        return EventCard(
                          event: event,
                          onTap: () => _showEventDetail(event),
                          onRegister: () => _navigateToRegistration(event),
                        );
                      }

                      if (isWideScreen) {
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 226,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: displayedEvents.length,
                          itemBuilder: buildCard,
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: displayedEvents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: buildCard,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: muted),
          const SizedBox(height: 12),
          Text(
            'Tidak ada kegiatan yang cocok.',
            style: TextStyle(color: muted),
          ),
        ],
      ),
    );
  }
}

class _EventDetailSheet extends StatelessWidget {
  final EventItem event;
  final VoidCallback onRegister;

  const _EventDetailSheet({required this.event, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                EventIconTile(event: event, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    event.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IconText(icon: Icons.person_outline, text: event.speaker),
            const SizedBox(height: 8),
            IconText(icon: Icons.calendar_today_outlined, text: event.date),
            const SizedBox(height: 8),
            IconText(icon: Icons.place_outlined, text: event.location),
            const SizedBox(height: 8),
            IconText(icon: Icons.sell_outlined, text: formatPrice(event.price)),
            const SizedBox(height: 20),
            Text(
              event.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onRegister,
                child: const Text('Daftar Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
