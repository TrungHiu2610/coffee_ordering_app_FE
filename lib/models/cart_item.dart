part of models;

@RealmModel()
class _CartItem {
  @PrimaryKey()
  late ObjectId id;

  late int quantity;
  late String description;

  //relationship
  late _Cart? cart;
  late _Product? product;
}
