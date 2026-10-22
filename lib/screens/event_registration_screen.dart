import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../utils/formatters.dart';
import '../widgets/event_card.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedTicketType = 'Mahasiswa Reguler';
  DateTime? _selectedDate;
  double _seatCount = 1;
  bool _needReminder = true;
  bool _agreeTerms = false;

  final List<String> _ticketTypes = [
    'Mahasiswa Reguler',
    'VIP Delegasi Kampus',
    'Peserta Umum / Eksternal',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 3));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      helpText: 'Pilih tanggal kehadiran',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _seatCount = 1;
      _agreeTerms = false;
    });
  }

  void _submitForm() {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan centang persetujuan syarat & ketentuan terlebih dahulu.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final newTicket = RegistrationTicket(
        id: 'TCK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        eventId: widget.event.id,
        eventTitle: widget.event.title,
        attendeeName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        ticketType: _selectedTicketType,
        attendedDate: _selectedDate != null
            ? formatDate(_selectedDate!)
            : widget.event.date,
        seatCount: _seatCount.toInt(),
        needReminder: _needReminder,
        registeredAt: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pendaftaran berhasil! E-Ticket: ${newTicket.id}'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, newTicket);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran'),
        actions: [
          TextButton(onPressed: _resetForm, child: const Text('Reset')),
          const SizedBox(width: 8),
        ],
      ),
      // SingleChildScrollView (bukan ListView) agar semua field tetap terdaftar di Form.
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ringkasan event yang dipilih
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      EventIconTile(event: event),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${event.date} · ${formatPrice(event.price)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const _SectionLabel('Data Peserta'),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi';
                  }
                  if (val.trim().length < 3) {
                    return 'Nama minimal terdiri dari 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'nama@nusaputra.ac.id',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),

              const _SectionLabel('Tiket & Jadwal'),
              DropdownButtonFormField<String>(
                initialValue: _selectedTicketType,
                decoration: const InputDecoration(
                  labelText: 'Tipe tiket',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: _ticketTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTicketType = val);
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal kehadiran',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    suffixIcon: Icon(Icons.expand_more),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? formatDate(_selectedDate!)
                        : 'Belum dipilih',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Jumlah kursi'),
                          const Spacer(),
                          Text(
                            '${_seatCount.toInt()} kursi',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _seatCount,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: '${_seatCount.toInt()}',
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        onChanged: (val) => setState(() => _seatCount = val),
                      ),
                    ],
                  ),
                ),
              ),

              const _SectionLabel('Lainnya'),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Kirim pengingat'),
                      subtitle: const Text(
                        'Email & WhatsApp H-1 sebelum acara',
                      ),
                      value: _needReminder,
                      onChanged: (val) => setState(() => _needReminder = val),
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    CheckboxListTile(
                      title: const Text('Saya menyetujui tata tertib kegiatan'),
                      value: _agreeTerms,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) =>
                          setState(() => _agreeTerms = val ?? false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Tombol utama selalu terlihat di bawah layar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _submitForm,
            child: const Text('Konfirmasi & Daftar'),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
