import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart' show Product;
import 'package:flutter_coffee_shop_app/models/review_model.dart';
import 'package:flutter_coffee_shop_app/providers/auth_provider.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';
import 'package:flutter_coffee_shop_app/services/review_service.dart';
import 'package:flutter_coffee_shop_app/services/product_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final Product? product;
  final int? userId;

  const ReviewScreen({Key? key, this.product,this.userId}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Review> _userReviews = [];
  Map<int, String> _productNames = {};

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _loadProductReviews();
    } else {
      _loadUserReviews();
    }
  }
  Future<void> _loadUserReviews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _reviewService.getUserReviews(
        Provider.of<AuthProvider>(context,listen:false).currentUser!.id,
      );
      
      // Load product names for each review
      final Map<int, String> productNames = {};
      for (final review in response) {
        if (!productNames.containsKey(review.productId)) {
          try {
            final product = await _productService.getProduct(review.productId);
            if (product != null) {
              productNames[review.productId] = product.name;
            } else {
              productNames[review.productId] = 'Unknown Product';
            }
          } catch (e) {
            productNames[review.productId] = 'Unknown Product';
          }
        }
      }
      
      setState(() {
        _userReviews = response;
        _productNames = productNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reviews: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProductReviews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reviews = await _reviewService.getProductReviews(widget.product!.id);

      // Load product names for each review
      final Map<int, String> productNames = {};
      for (final review in reviews) {
        if (!productNames.containsKey(review.productId)) {
          try {
            final product = await _productService.getProduct(review.productId);
            if (product != null) {
              productNames[review.productId] = product.name;
            } else {
              productNames[review.productId] = 'Unknown Product';
            }
          } catch (e) {
            productNames[review.productId] = 'Unknown Product';
          }
        }
      }

      setState(() {
        _userReviews = reviews;
        _productNames = productNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load your reviews: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đánh giá của tôi')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorView()
              : _buildReviewsContent(),
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
          ElevatedButton(onPressed: _loadUserReviews, child: Text('Thử lại')),
        ],
      ),
    );
  }

  Widget _buildReviewsContent() {
    if (_userReviews.isEmpty) {
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
              'Bạn chưa đánh giá sản phẩm nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Các đánh giá của bạn sẽ hiển thị ở đây',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _userReviews.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final review = _userReviews[index];
        return _buildReviewItem(review);
      },
    );
  }
  Widget _buildReviewItem(Review review) {
    // Use a fallback product name if it's not in the map
    final productName = _productNames[review.productId] ?? 'Unknown Product';
    final formattedDate = DateFormat('dd/MM/yyyy').format(review.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),            const SizedBox(height: 8),
            _buildStarRating(review.rating.toDouble()),
            const SizedBox(height: 12),
            Text(review.comment, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditReviewDialog(context, review),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showDeleteConfirmation(context, review),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
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
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
        }
      }),
    );
  }

  void _showEditReviewDialog(BuildContext context, Review review) {
    double newRating = review.rating as double;
    final commentController = TextEditingController(text: review.comment);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Chỉnh sửa đánh giá'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Đánh giá mới:'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < newRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              newRating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        labelText: 'Nhận xét',
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

                    // Update review
                    await _updateReview(
                      review.id,
                      newRating,
                      commentController.text,
                      review.productId,
                    );
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc muốn xóa đánh giá này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteReview(review.id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateReview(
    int reviewId,
    double rating,
    String comment,
    int productId,
  ) async {
    try {
      // Get current user
      final currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng đăng nhập để cập nhật đánh giá'),
            ),
          );
        }
        return;
      }

      final request = CreateReviewRequest(
        productId: productId,
        userId: currentUser.id,
        rating: rating,
        comment: comment,
      );

      await _reviewService.updateReview(reviewId, request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đánh giá đã được cập nhật')),
        );
      }

      // Reload reviews
      _loadUserReviews();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật đánh giá: $e')),
        );
      }
    }
  }

  Future<void> _deleteReview(int reviewId) async {
    try {
      await _reviewService.deleteReview(reviewId);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đánh giá đã được xóa')));
      }

      // Reload reviews
      _loadUserReviews();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi xóa đánh giá: $e')));
      }
    }
  }
}
