part of models;

@RealmModel()
class _Review {
  @PrimaryKey()
  late ObjectId id;

  late String content;
  late int starRate;
  late DateTime postTime;

  // relationship
  late _User? user;
  late _Product? product;
}
