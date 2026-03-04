import 'package:flutter/material.dart';

class FavoriteErrorView extends StatelessWidget {
  final String message;

  const FavoriteErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
