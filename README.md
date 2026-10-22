# NusaEvent Hub — Sesi 5: Membangun UI Interaktif

Aplikasi Flutter (Material 3) untuk praktikum **Pemrograman Perangkat Mobile (IF31033)**, Universitas Nusa Putra.
Katalog seminar & workshop kampus. Setiap layar mendemonstrasikan satu konsep UI interaktif.

<p>
  <img src="screenshots/01_home.png" width="230" alt="Beranda">
  <img src="screenshots/04_form.png" width="230" alt="Formulir pendaftaran">
  <img src="screenshots/05_tickets.png" width="230" alt="Tiket saya">
</p>

---

## Isi Aplikasi

| Layar | Tampilan | Konsep yang dipelajari |
|---|---|---|
| **Beranda** — daftar event, pencarian, badge jumlah tiket | <img src="screenshots/01_home.png" width="180"> | `ListView.separated`, `TextField`, `Badge`, `InkWell` |
| **Filter** — kategori & batas harga | <img src="screenshots/02_filter.png" width="180"> | `showModalBottomSheet`, `ChoiceChip`, `Slider` |
| **Detail event** — tap kartu event | <img src="screenshots/03_detail.png" width="180"> | Bottom sheet dengan `showDragHandle` |
| **Formulir pendaftaran** — validasi input | <img src="screenshots/04_form.png" width="180"> | `Form` + `GlobalKey<FormState>`, `TextFormField` + validator (regex email), `DropdownButtonFormField`, `showDatePicker`, `Slider`, `SwitchListTile`, `CheckboxListTile` |
| **Tiket saya** — hasil pendaftaran | <img src="screenshots/05_tickets.png" width="180"> | Mengirim data balik dengan `Navigator.pop(context, result)`, `SnackBar` |
| **Batalkan tiket** — geser kiri | <img src="screenshots/06_swipe_cancel.png" width="180"> | `Dismissible` + `confirmDismiss` (`AlertDialog`) |
| **Denah venue** — cubit untuk zoom | <img src="screenshots/08_venue_map.png" width="180"> | `InteractiveViewer` (skala 0.6× – 3.5×) |

### Tata letak responsif (tablet / layar lebar)

`LayoutBuilder` mengganti daftar 1 kolom menjadi `GridView.builder` 2 kolom saat lebar layar **≥ 650 dp**.

<img src="screenshots/07_tablet_grid.png" width="620" alt="Tampilan grid di tablet">

### Alur pengguna

```text
Beranda ──tap kartu──▶ Detail ──Daftar──▶ Formulir ──Konfirmasi──▶ Beranda (+1 tiket)
   │                                                                     │
   ├──ikon filter──▶ Filter (bottom sheet)                               │
   ├──ikon peta───▶ Denah venue (pinch-to-zoom)                          │
   └──ikon tiket──▶ Tiket saya ──geser kiri──▶ Konfirmasi batal ◀────────┘
```

---

## Menjalankan dengan FVM

Proyek ini dikunci ke **Flutter 3.41.8** (Dart 3.11.5) lewat [`.fvmrc`](.fvmrc).

```bash
fvm install
```

```bash
fvm flutter pub get
```

```bash
fvm flutter run
```

Cek kualitas kode & jalankan test:

```bash
fvm flutter analyze
```

```bash
fvm flutter test
```

> **VS Code / Android Studio:** arahkan Flutter SDK ke `.fvm/flutter_sdk` di folder proyek.

---

## Struktur Folder

```text
lib/
├── main.dart                          # Entry point + tema (satu warna utama, kartu flat)
├── data/sample_events.dart            # Data dummy 6 event
├── models/
│   ├── event_item.dart                # Model event
│   └── registration_ticket.dart       # Model tiket
├── screens/
│   ├── home_events_screen.dart        # Beranda responsif + detail event
│   ├── event_registration_screen.dart # Formulir dengan validasi
│   └── registered_tickets_screen.dart # Daftar tiket + swipe-to-dismiss
├── utils/formatters.dart              # Format Rupiah & tanggal
└── widgets/
    ├── event_card.dart                # Kartu event
    ├── filter_bottom_sheet.dart       # Bottom sheet filter
    └── venue_map_viewer.dart          # Denah dengan InteractiveViewer
test/widget_test.dart                  # 5 widget test
screenshots/                           # Gambar untuk README ini
```

---

## Latihan Flutter Inspector

1. Jalankan `fvm flutter run`, lalu buka **Flutter DevTools → Flutter Inspector**.
2. Aktifkan **Select Widget Mode**, lalu klik kartu event di layar.
3. Buka **Layout Explorer** pada `Row` di bagian bawah kartu untuk melihat `Expanded` dan constraints.
