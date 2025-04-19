part of models;

@RealmModel()
class _OrderItem {
  @PrimaryKey()
  late ObjectId id;

  late _Product? product;
  late _ProductSize? productSize;
  late List<_Topping> toppings;

  late int quantity;
  late String note;
  late String status; // trạng thái riêng từng món: chờ xác nhận, đã xác nhận...

  late _Order? order;
}
