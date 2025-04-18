part of models;

@RealmModel()
class _Size {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late double price;
}
