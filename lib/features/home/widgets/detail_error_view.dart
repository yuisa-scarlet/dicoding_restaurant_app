import 'package:flutter/material.dart';

class DetailErrorView extends StatelessWidget {
  final String message;

  const DetailErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}
