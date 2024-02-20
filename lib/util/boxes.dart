import 'package:franko_mobile_app/models/address_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Address> getAddressTransactions() => Hive.box('address');
}
