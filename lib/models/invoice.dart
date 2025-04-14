part of models;

@RealmModel()
class _Invoice {
  @PrimaryKey()
  late ObjectId id;

  late DateTime createTime;
  late DateTime completeTime;
  late String state;
  late String paymentMethod;
  late double total;
  late double rewardPoint;

  // relationship
  late _User? user;

  @Backlink(#invoice)
  late Iterable<_InvoiceItem> invoiceItems;
}
