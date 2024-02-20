
import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 0)
class Address extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String city;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phoneNumber;

  @HiveField(5)
  bool currentAddress = false;

  @HiveField(6)
  String towns;

  @HiveField(7)
  String region;

  @HiveField(8)
  String price;
}
