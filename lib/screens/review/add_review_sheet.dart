import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/models/review_model.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';
import 'package:flutter_coffee_shop_app/services/review_service.dart';

class AddReviewSheet extends StatefulWidget {
  final OrderItem orderItem;
  final VoidCallback onReviewSubmitted;

  const AddReviewSheet({
    Key? key,
    required this.orderItem,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ReviewService _reviewService = ReviewService();
  final AuthService _authService = AuthService();
  double _rating = 5;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.orderItem.product?.imageUrl ??
                        'assets/images/img_unavailable.jpg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Image.asset(
                          'assets/images/img_unavailable.jpg',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.orderItem.product?.name ?? 'Unknown Product',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Size: ${widget.orderItem.size?.name ?? 'Unknown'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Đánh giá của bạn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Nhận xét của bạn',
                hintText: 'Chia sẻ trải nghiệm của bạn về sản phẩm này...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.brown,
              ),
              child:
                  _isSubmitting
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text('Gửi đánh giá'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    // Validate
    if (_commentController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập nhận xét của bạn';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Get current user
      final currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Vui lòng đăng nhập để gửi đánh giá';
        });
        return;
      }

      final request = CreateReviewRequest(
        productId: widget.orderItem.productId,
        userId: currentUser.id,
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      await _reviewService.createReview(request);

      // if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')));

      // Close bottom sheet
      Navigator.pop(context);

      // Notify parent
      widget.onReviewSubmitted();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
