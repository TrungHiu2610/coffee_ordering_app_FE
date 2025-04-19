part of models;

@RealmModel()
class _Order {
  @PrimaryKey()
  late ObjectId id;

  late DateTime createdAt;
  late String status; // chờ thanh toán, chờ xác nhận, chờ lấy nước, hoàn tất...
  late String paymenMethod;

  late _User? customer;
  late List<_OrderItem> items;
}
