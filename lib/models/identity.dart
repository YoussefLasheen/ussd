import 'package:flutter/material.dart';

class Identity {
  final String name;
  final Color color;

  const Identity({required this.name, required this.color});

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      name: json['name'] as String,
      color: json['color'] as Color,
    );
  }
}