part of models;

@RealmModel()
class _User{
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late String email;
  late String password;
  late double totalPoint;
  late String role;
  
  // relationship
  @Backlink(#user)
  late Iterable<_Invoice> invoices;
  
  @Backlink(#user)
  late Iterable<_Review> reviews;

  @Backlink(#customer)
  late Iterable<_Order> orders;
}