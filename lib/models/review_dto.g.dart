// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewCreateDto _$ReviewCreateDtoFromJson(Map<String, dynamic> json) =>
    ReviewCreateDto(
      productId: (json['productId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      review: json['comment'] as String,
    );

Map<String, dynamic> _$ReviewCreateDtoToJson(ReviewCreateDto instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'userId': instance.userId,
      'rating': instance.rating,
      'comment': instance.review,
    };
