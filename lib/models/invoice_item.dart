part of models;

@RealmModel()
class _InvoiceItem {
  @PrimaryKey()
  late ObjectId id;

  late int quantity;
  late double price;
  late String description;

  // relationship
  late _Invoice? invoice;
  late _Product? product;
}
