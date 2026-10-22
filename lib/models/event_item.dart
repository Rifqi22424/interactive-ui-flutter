import 'package:flutter/material.dart';

class EventItem {
  final String id;
  final String title;
  final String category;
  final String speaker;
  final String date;
  final String location;
  final int price;
  final int seatsAvailable;
  final String description;
  final IconData icon;
  final Color accentColor;

  const EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.speaker,
    required this.date,
    required this.location,
    required this.price,
    required this.seatsAvailable,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}
