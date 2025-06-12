import 'package:json_annotation/json_annotation.dart';
import 'api_models.dart';

// Re-export Review class from api_models.dart
export 'api_models.dart' show Review;

part 'review_model.g.dart';

@JsonSerializable()
class CreateReviewRequest {
  /// The ID of the product being reviewed
  final int productId;

  /// The ID of the user submitting the review
  final int userId;

  /// The rating value (1-5)
  final double rating;

  /// The review comment text
  final String comment;

  CreateReviewRequest({
    required this.productId,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateReviewRequestToJson(this);
}

@JsonSerializable()
class ReviewResponse {
  /// List of reviews for the product
  final List<Review> reviews;

  /// Average rating calculated from all reviews
  final double averageRating;

  /// Total number of reviews
  final int totalReviews;

  ReviewResponse({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewResponseToJson(this);
}
