part of models;

@RealmModel()
class _Product {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late double price;
  late String description;
  late String img;
  late bool state;

  // relationship
  late _Category? category;

  @Backlink(#product)
  late Iterable<_Review> reviews;

  late List<_Topping> toppings;
}
