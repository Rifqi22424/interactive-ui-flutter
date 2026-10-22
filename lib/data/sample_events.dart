import 'package:flutter/material.dart';
import '../models/event_item.dart';

final List<EventItem> sampleEvents = [
  const EventItem(
    id: 'EVT-001',
    title: 'Flutter Forward Sukabumi 2026',
    category: 'Seminar',
    speaker: 'Nugraha, M.Kom & Google Developer Expert',
    date: '28 Oktober 2026',
    location: 'Auditorium Utama Universitas Nusa Putra',
    price: 0,
    seatsAvailable: 150,
    description:
        'Seminar akbar membahas arsitektur mobile computing mutakhir, Flutter 3.40+, integrasi AI generatif pada edge device, dan peluang karier engineer mobile global.',
    icon: Icons.flutter_dash,
    accentColor: Color(0xFF0288D1),
  ),
  const EventItem(
    id: 'EVT-002',
    title: 'Hands-on Workshop: Clean Architecture di Flutter',
    category: 'Workshop',
    speaker: 'Yulhan Wahyudin, M.Kom',
    date: '05 November 2026',
    location: 'Lab Komputer Rekayasa Perangkat Lunak Lt. 3',
    price: 35000,
    seatsAvailable: 40,
    description:
        'Praktik intensif membedah Domain-Driven Design, pemisahan layer Data-Domain-Presentation, State Management BLoC/Provider, dan implementasi automated testing unit & widget.',
    icon: Icons.code,
    accentColor: Color(0xFF00897B),
  ),
  const EventItem(
    id: 'EVT-003',
    title: 'Nusa Putra Informatics Tech Expo & Hackathon',
    category: 'Festival',
    speaker: 'Dewan Juri Industri & Alumni Sukses',
    date: '18 November 2026',
    location: 'Hall Expo Nusa Putra Kampus Cisaat',
    price: 25000,
    seatsAvailable: 300,
    description:
        'Pameran inovasi proyek capstone mahasiswa TI, kompetisi hackathon 24 jam membangun solusi smart campus, serta sesi networking dengan perusahaan software house terkemuka.',
    icon: Icons.celebration,
    accentColor: Color(0xFFE65100),
  ),
  const EventItem(
    id: 'EVT-004',
    title: 'Masterclass: Desain Sistem Design System Material 3',
    category: 'Workshop',
    speaker: 'Lead UI/UX Designer Unicorn Tech',
    date: '25 November 2026',
    location: 'Multimedia Smart Classroom Lt. 2',
    price: 40000,
    seatsAvailable: 50,
    description:
        'Pelajari rahasia perancangan Micro-Interactions, tokenisasi warna dinamis Material You, tipografi adaptif, serta pembuatan widget library reusable lintas platform.',
    icon: Icons.palette,
    accentColor: Color(0xFF7B1FA2),
  ),
  const EventItem(
    id: 'EVT-005',
    title: 'National Cyber Security & Mobile Hardening Forum',
    category: 'Seminar',
    speaker: 'Pakar Keamanan Siber Nasional',
    date: '02 Desember 2026',
    location: 'Convention Hall Nusa Putra Lt. 4',
    price: 0,
    seatsAvailable: 200,
    description:
        'Membahas teknik pengamanan APK seluler dari reverse engineering, SSL pinning, enkripsi data at rest menggunakan Flutter Secure Storage, dan standar OWASP Mobile.',
    icon: Icons.security,
    accentColor: Color(0xFFC2185B),
  ),
  const EventItem(
    id: 'EVT-006',
    title: 'Generative AI on Mobile: Gemini Nano & On-Device ML',
    category: 'Seminar',
    speaker: 'AI Research Scientist',
    date: '10 Desember 2026',
    location: 'Auditorium Utama Universitas Nusa Putra',
    price: 50000,
    seatsAvailable: 120,
    description:
        'Eksplorasi eksekusi model bahasa besar (LLM) langsung di perangkat mobile menggunakan Flutter, MediaPipe, dan Google AICore tanpa latensi jaringan internet.',
    icon: Icons.psychology,
    accentColor: Color(0xFF1565C0),
  ),
];
