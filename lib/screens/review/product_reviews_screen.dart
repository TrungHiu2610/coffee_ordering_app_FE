import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/models/review_model.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';
import 'package:flutter_coffee_shop_app/services/review_service.dart';
import 'package:flutter_coffee_shop_app/services/reviewable_products_service.dart';
import 'package:intl/intl.dart';

class ProductReviewsScreen extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductReviewsScreen({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final ReviewService _reviewService = ReviewService();
  final ReviewableProductsService _reviewableProductsService =
      ReviewableProductsService();
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _canReviewProduct = false;
  String? _errorMessage;
  List<Review> _reviewResponse = [];
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if user can review this product
      final canReview = await _reviewableProductsService.canReviewProduct(
        widget.productId,
      );      // Load the reviews
      final response = await _reviewService.getProductReviews(widget.productId);
      
      // Calculate average rating
      double avgRating = 0.0;
      if (response.isNotEmpty) {
        avgRating = response.fold(0.0, (sum, review) => sum + review.rating) / response.length;
      }

      setState(() {
        _reviewResponse = response;
        _canReviewProduct = canReview;
        averageRating = avgRating;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reviews: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.productName} - Đánh giá')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorView()
              : _buildReviewsContent(),
      floatingActionButton:
          _canReviewProduct
              ? FloatingActionButton(
                onPressed: () {
                  _showAddReviewDialog(context);
                },
                backgroundColor: Colors.brown,
                child: const Icon(Icons.add_comment),
              )
              : null,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(_errorMessage!),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadReviews, child: Text('Thử lại')),
        ],
      ),
    );
  }

  Widget _buildReviewsContent() {
    return Column(
      children: [
        _buildRatingSummary(),
        Expanded(
          child:
              _reviewResponse.isEmpty
                  ? _buildEmptyReviews()
                  : _buildReviewsList(),
        ),
      ],
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                _buildStarRating(averageRating),
                const SizedBox(height: 4),
                Text(
                  '${_reviewResponse.length} đánh giá',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: _buildRatingBars()),
        ],
      ),
    );
  }

  Widget _buildRatingBars() {
    // This would typically show a breakdown of ratings (5-star, 4-star, etc.)
    // For simplicity, we'll just show a placeholder
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingBar(5, 0.7),
          _buildRatingBar(4, 0.2),
          _buildRatingBar(3, 0.05),
          _buildRatingBar(2, 0.03),
          _buildRatingBar(1, 0.02),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int rating, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$rating',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có đánh giá nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy là người đầu tiên đánh giá sản phẩm này',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          if (_canReviewProduct) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showAddReviewDialog(context);
              },
              icon: const Icon(Icons.star),
              label: const Text('Đánh giá ngay'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              'Bạn cần mua sản phẩm này trước khi đánh giá',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemCount: _reviewResponse.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final review = _reviewResponse[index];
        return _buildReviewItem(review);
      },
    );
  }

  Widget _buildReviewItem(Review review) {
    final userName = review.user?.name ?? 'Anonymous';
    final formattedDate = DateFormat('dd/MM/yyyy').format(review.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.brown.shade200,
                  radius: 20,
                  child: Text(
                    userName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),                ),
                _buildStarRating(review.rating.toDouble()),
              ],
            ),
            const SizedBox(height: 12),
            Text(review.comment, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 18);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 18);
        }
      }),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Đánh giá sản phẩm'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Chọn đánh giá của bạn:'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        labelText: 'Nhận xét của bạn',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate
                    if (commentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập nhận xét')),
                      );
                      return;
                    }

                    Navigator.pop(context);

                    // Show loading
                    _submitReview(rating, commentController.text);
                  },
                  child: const Text('Gửi đánh giá'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitReview(double rating, String comment) async {
    try {
      // Get current user
      final currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng đăng nhập để gửi đánh giá')),
          );
        }
        return;
      }

      final request = CreateReviewRequest(
        productId: widget.productId,
        userId: currentUser.id,
        rating: rating,
        comment: comment,
      );

      await _reviewService.createReview(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đánh giá của bạn đã được gửi thành công'),
          ),
        );
      }

      // Reload reviews
      _loadReviews();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi gửi đánh giá: $e')));
      }
    }
  }
}
