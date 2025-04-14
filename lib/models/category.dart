part of models;

@RealmModel()
class _Category {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  // relationship
  @Backlink(#category)
  late Iterable<_Product> products;
}
