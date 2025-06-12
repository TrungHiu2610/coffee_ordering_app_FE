import 'package:json_annotation/json_annotation.dart';

part 'review_dto.g.dart';

@JsonSerializable()
class ReviewCreateDto {
  /// The ID of the product being reviewed
  final int productId;

  /// The ID of the user submitting the review
  final int userId;

  /// The rating value (1-5) as an integer
  final int rating;

  /// The review comment text
  @JsonKey(name: 'comment')
  final String review;

  ReviewCreateDto({
    required this.productId,
    required this.userId,
    required this.rating,
    required this.review,
  });

  factory ReviewCreateDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewCreateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewCreateDtoToJson(this);
}
