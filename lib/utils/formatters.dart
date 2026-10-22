/// Helper format teks agar tampilan angka & tanggal konsisten di semua layar.
String formatRupiah(num value) {
  final digits = value.toInt().toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
  return 'Rp $digits';
}

String formatPrice(int price) => price == 0 ? 'Gratis' : formatRupiah(price);

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

String formatDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';
