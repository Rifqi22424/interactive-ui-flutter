import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi5_ui_interaktif/main.dart';
import 'package:sesi5_ui_interaktif/models/event_item.dart';
import 'package:sesi5_ui_interaktif/screens/event_registration_screen.dart';
import 'package:sesi5_ui_interaktif/screens/registered_tickets_screen.dart';
import 'package:sesi5_ui_interaktif/models/registration_ticket.dart';
import 'package:sesi5_ui_interaktif/widgets/filter_bottom_sheet.dart';
import 'package:sesi5_ui_interaktif/widgets/venue_map_viewer.dart';

void main() {
  testWidgets('Smoke test: NusaEvent Hub home loads catalog & title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NusaEventApp());

    // Verify title and search bar
    expect(find.text('NusaEvent Hub'), findsOneWidget);
    expect(find.text('Cari event atau pembicara'), findsOneWidget);

    // Verify first event
    expect(find.text('Flutter Forward Sukabumi 2026'), findsOneWidget);
  });

  testWidgets(
    'Interactive test: Open Filter Bottom Sheet and verify controls',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NusaEventApp());

      // Tap filter tune button
      final filterButton = find.byTooltip('Filter Kegiatan');
      expect(filterButton, findsOneWidget);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Verify bottom sheet title and options
      expect(find.text('Filter Katalog Event'), findsOneWidget);
      expect(find.text('Kategori Kegiatan'), findsOneWidget);
      final sheet = find.byType(FilterBottomSheet);
      expect(
        find.descendant(of: sheet, matching: find.text('Workshop')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: sheet, matching: find.text('Festival')),
        findsOneWidget,
      );
      expect(find.text('Terapkan Filter'), findsOneWidget);
    },
  );

  testWidgets('Form validation test: Registration Form rejects empty inputs', (
    WidgetTester tester,
  ) async {
    const testEvent = EventItem(
      id: 'EVT-TEST',
      title: 'Workshop Test UI',
      category: 'Workshop',
      speaker: 'Test Speaker',
      date: '01 Nov 2026',
      location: 'Lab A',
      price: 0,
      seatsAvailable: 30,
      description: 'Deskripsi tes',
      icon: Icons.code,
      accentColor: Colors.blue,
    );

    await tester.pumpWidget(
      const MaterialApp(home: EventRegistrationScreen(event: testEvent)),
    );

    // Find submit button and scroll to it
    final submitBtn = find.text('Konfirmasi & Daftar');
    expect(submitBtn, findsOneWidget);
    await tester.ensureVisible(submitBtn);
    await tester.pumpAndSettle();

    // Tap without filling and without agreement
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Verify SnackBar requirement for agreement
    expect(
      find.text(
        'Silakan centang persetujuan syarat & ketentuan terlebih dahulu.',
      ),
      findsOneWidget,
    );

    // Hide the floating SnackBar so it doesn't cover the checkbox
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();

    // Agree to terms
    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Tap submit again to trigger validator
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Expect validation errors
    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
  });

  testWidgets(
    'InteractiveViewer test: Venue Map Viewer displays stage and zoom canvas',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VenueMapViewer(venueName: 'Auditorium Nusa Putra'),
        ),
      );

      expect(find.text('Denah Auditorium Nusa Putra'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.text('PANGGUNG'), findsOneWidget);
    },
  );

  testWidgets('Dismissible test: Registered tickets screen renders tickets', (
    WidgetTester tester,
  ) async {
    final tickets = [
      RegistrationTicket(
        id: 'TCK-001',
        eventId: 'EVT-001',
        eventTitle: 'Seminar AI Nasional',
        attendeeName: 'Ahmad Faiz',
        email: 'faiz@example.com',
        ticketType: 'Mahasiswa Reguler',
        attendedDate: '28/10/2026',
        seatCount: 1,
        needReminder: true,
        registeredAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: RegisteredTicketsScreen(
          tickets: tickets,
          onTicketDeleted: (_) {},
        ),
      ),
    );

    expect(find.text('Tiket Pendaftaran Saya'), findsOneWidget);
    expect(find.text('Seminar AI Nasional'), findsOneWidget);
    expect(find.text('Ahmad Faiz'), findsOneWidget);
    expect(find.byType(Dismissible), findsOneWidget);
  });
}
