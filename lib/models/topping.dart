part of models;

@RealmModel()
class _Topping {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late double price;
}
