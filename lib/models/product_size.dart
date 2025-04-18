part of models;

@RealmModel()
class _ProductSize {
  @PrimaryKey()
  late ObjectId id;

  late _Product? product;
  late _Size? size;

  late double additionalPrice;
}
