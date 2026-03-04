import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';

class DetailInfo extends StatelessWidget {
  final Restaurant restaurant;

  const DetailInfo({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'InstrumentSerif',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),

        Row(
          children: [
            Icon(Icons.location_on, size: 14, color: AppColor.selected),
            const SizedBox(width: 2),
            Text(restaurant.city, style: const TextStyle(fontSize: 12)),
            if (restaurant.address != null &&
                restaurant.address!.isNotEmpty) ...[
              const Text(', ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  restaurant.address!,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(width: 12),
            Icon(Icons.star_rounded, size: 14, color: AppColor.selected),
            const SizedBox(width: 2),
            Text(
              restaurant.rating.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          'Deskripsi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ChangeNotifierProvider(
          create: (_) => ValueNotifier<bool>(false),
          child: Consumer<ValueNotifier<bool>>(
            builder: (context, isExpandedNotifier, _) {
              final isExpanded = isExpandedNotifier.value;
              return InkWell(
                onTap: () {
                  isExpandedNotifier.value = !isExpanded;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.description,
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isExpanded
                          ? 'Tampilkan Lebih Sedikit'
                          : 'Baca Selengkapnya',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
