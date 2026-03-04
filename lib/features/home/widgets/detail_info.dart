import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';

class DetailInfo extends StatefulWidget {
  final Restaurant restaurant;

  const DetailInfo({super.key, required this.restaurant});

  @override
  State<DetailInfo> createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.restaurant.name.toUpperCase(),
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
            Text(widget.restaurant.city, style: const TextStyle(fontSize: 12)),
            if (widget.restaurant.address != null &&
                widget.restaurant.address!.isNotEmpty) ...[
              const Text(', ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  widget.restaurant.address!,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(width: 12),
            Icon(Icons.star_rounded, size: 14, color: AppColor.selected),
            const SizedBox(width: 2),
            Text(
              widget.restaurant.rating.toString(),
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
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.restaurant.description,
                maxLines: _isExpanded ? null : 4,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _isExpanded ? 'Tampilkan Lebih Sedikit' : 'Baca Selengkapnya',
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
