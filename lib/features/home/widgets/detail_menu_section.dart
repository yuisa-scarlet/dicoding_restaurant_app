import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/app_color.dart';

class DetailMenuSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const DetailMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 0,
          children: items
              .map(
                (item) => Chip(
                  label: Text(
                    item,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: AppColor.selected,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  side: const BorderSide(color: Colors.transparent),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
