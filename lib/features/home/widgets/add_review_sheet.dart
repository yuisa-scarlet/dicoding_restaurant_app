import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/features/home/providers/add_review_provider.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_detail/restaurant_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class AddReviewSheet extends StatelessWidget {
  const AddReviewSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddReviewProvider(),
      child: const _AddReviewSheetContent(),
    );
  }
}

class _AddReviewSheetContent extends StatefulWidget {
  const _AddReviewSheetContent();

  @override
  State<_AddReviewSheetContent> createState() => _AddReviewSheetContentState();
}

class _AddReviewSheetContentState extends State<_AddReviewSheetContent> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(BuildContext context) async {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();

    if (name.isEmpty || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Review cannot be empty')),
      );
      return;
    }

    final reviewProvider = context.read<AddReviewProvider>();
    reviewProvider.setLoading(true);

    try {
      await context.read<RestaurantDetailProvider>().addReview(name, review);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review added successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        reviewProvider.setLoading(false);
      }
    }
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String label,
    bool alignTop = false,
  }) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: alignTop,
      filled: true,
      fillColor: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.selected, width: 1.5),
      ),
      labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Add your review for this restaurant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'InstrumentSerif',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Share your experience with others',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(context, label: 'Your Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDecoration(
                context,
                label: 'Write your review...',
                alignTop: true,
              ),
            ),
            const SizedBox(height: 20),
            Consumer<AddReviewProvider>(
              builder: (context, reviewState, _) {
                return ElevatedButton(
                  onPressed: reviewState.isLoading
                      ? null
                      : () => _submitReview(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.selected,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: reviewState.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.send, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Submit Review',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
