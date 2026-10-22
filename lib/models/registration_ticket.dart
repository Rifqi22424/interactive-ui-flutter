class RegistrationTicket {
  final String id;
  final String eventId;
  final String eventTitle;
  final String attendeeName;
  final String email;
  final String ticketType;
  final String attendedDate;
  final int seatCount;
  final bool needReminder;
  final DateTime registeredAt;

  const RegistrationTicket({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.attendeeName,
    required this.email,
    required this.ticketType,
    required this.attendedDate,
    required this.seatCount,
    required this.needReminder,
    required this.registeredAt,
  });
}
