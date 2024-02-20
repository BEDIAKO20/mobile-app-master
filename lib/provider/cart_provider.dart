import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/address_model.dart';
import 'package:franko_mobile_app/models/product_cart.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager with ChangeNotifier {
  final String localCartStorageKey = 'franko_cart_data';
  final String localShippingAddressFee = 'franko_shipping_fee';
  final String localShipppingAddressPrice = 'franko_shipping_price';

  double _itemPrice;

  List<Products> cartItems;
  List<Cart> _items;
  List<Cart> _incartItems;
  int data;
  List<dynamic> _carts;
  double _sum;
  String _shippingAddressFees;
  String _shippingAddressLocation;
  String _shippingRegionAddress;
  Map<String, dynamic> _addressDetails;

  Future<SharedPreferences> _prefs;
  double get itemPrice => _itemPrice;
  List<dynamic> get carts => _carts;
  List<Cart> get incartItems => _incartItems;
  List<Cart> get items => _items;
  String get shippingAddressFees => _shippingAddressFees;
  String get shippingAddressLocation => _shippingAddressLocation;
  String get shippingAddressRegions => _shippingRegionAddress;

  String _persistedFee;
  String get persistedFee => _persistedFee;
  String _persistedLocation;
  String get persistedLocation => _persistedLocation;
  Address _currentAddress;
  Address get currentAddress => _currentAddress;

  Map<String, dynamic> get addressDetails => _addressDetails;

  int totalCartValue = 0;
  int itemQuantity;

  retrievePersistedDetails(Address addressTransaction) {
    print("Provided towns");
    print(addressTransaction.towns);
    print(addressTransaction.price);
    _persistedFee = addressTransaction.price;
    _persistedLocation = addressTransaction.towns;
    _currentAddress = addressTransaction;
  }

  getShippingFee(Map<String, dynamic> map) async {
    final SharedPreferences prefs = await _prefs;

    String charge = map['Charge'];
    // prefs.remove(localShippingAddressFee);
    prefs.setString(localShipppingAddressPrice, charge);
    _shippingAddressFees = prefs.getString(localShippingAddressFee);

    _shippingAddressLocation = map['Location'];
    _shippingRegionAddress = map['Region'];
    _shippingAddressFees = map['Charge'];

    notifyListeners();
  }

   getCurrentPrice(int productId) async {
    APIService apiService = APIService();
    Products product = await apiService.getproduct(productId.toString());
    print('priniting product price');
    print(product.price);

    return product;
  }

  savedAddress() async {
    final SharedPreferences prefs = await _prefs;
    _shippingAddressFees = prefs.getString(localShipppingAddressPrice);
    var addressData = prefs.getString(localShippingAddressFee);
    _shippingAddressLocation = jsonDecode(addressData)['Location'];
    _shippingRegionAddress = jsonDecode(addressData)['Region'];
    _shippingAddressFees = jsonDecode(addressData)['Charge'];

    notifyListeners();
  }

  saveRegionalvalue(value) {
    _shippingRegionAddress = value;
    _shippingAddressLocation = null;
    notifyListeners();
  }

  saveCityvalue(value) {
    // _shippingAddressLocation = null;
    _shippingAddressLocation = value;
  }

  calculateTotalPrice(List<Cart> product) {
    _sum = product.fold(
        0, (previousValue, element) => previousValue + element.total);

    //save total value into shared preferences
    return _sum;
  }

  saveAddressDetails(value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(localShippingAddressFee, json.encode(value));
    notifyListeners();
  }

  getAddressdetails() async {
    final SharedPreferences prefs = await _prefs;
    var details = json.decode(prefs.getString(localShippingAddressFee));
    _addressDetails = details;
    notifyListeners();
  }

  deleteFromCart(item) async {
    carts.removeWhere((element) => element['id'] == item.id);
    final SharedPreferences prefs = await _prefs;
    prefs.setString(localCartStorageKey, json.encode(carts));
    getData();
  }

  CartManager() {
    cartItems = [];
    _carts = List<dynamic>();
    _incartItems = List<Cart>();
    _items = List<Cart>();

    _prefs = SharedPreferences.getInstance();
  }

  getProductQuantity(item) {
    for (final cart in carts) {
      if (cart['id'] == item.id) {
        notifyListeners();
        return cart['quantity'];
      }
    }
  }

  addCartItem(item) async {
    //if (isPresentInCart(item) == true) return;
    try {
      // print(cartItems);
      //print(carts);
    } catch (err) {
      print(err);
      print("it not saving");
      return;
    }
    this.cartItems.add(item);
    notifyListeners();
    _getCartDataAsString(item);
    getData();
    //clearCart();
    //print(carts);
  }

  removeCartItem(item) {
    this.cartItems.remove(item);

    notifyListeners();
    //_storeCartLocally();
    getData();
    // getCartLocally();
  }

  clearCart() async {
    print(incartItems.toString() + 'incart provider');
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(localCartStorageKey);
    // await prefs.remove(localShippingAddressFee);
    // await prefs.remove(localShipppingAddressPrice);

    this._incartItems.clear();
    // var items = prefs.getString(localCartStorageKey);
    // print(items.toString() + 'items items');
    carts.clear();

    notifyListeners();

    //_storeCartLocally();
  }

  isPresentInCart(item) {
    for (final cart in carts) {
      if (cart['id'] == item.id) {
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  isSameInCart(Products item) {
    if (carts[0]['id'] == item.id) {
      notifyListeners();
      print("true");
      return true;
    } else {
      return false;
    }
  }

  Future<double> generateCartPrice(id) async {
    var productData = await APIService().getproduct(id);
    var currentPrice = productData.price;
    var specificPrice = double.parse(currentPrice);
    notifyListeners();
    return specificPrice;
  }

  generatePrice(id) async {
    var productData = await APIService().getproduct(id);
    var currentPrice = productData.price;
    //var specificPrice = double.parse(currentPrice);
    notifyListeners();
    return currentPrice;
  }

  incrementQuantityOfProduct(item) async {
    if (isPresentInCart(item) == true) {
      for (final cart in carts) {
        if (cart['id'] == item.id) {
          cart['quantity'] += 1;
          var cartPrice =
              double.parse(await generatePrice(cart['id'].toString()));
          //cart['price'];
          cart['total'] = cart['quantity'] * cartPrice;
          final SharedPreferences prefs = await _prefs;
          prefs.setString(localCartStorageKey, json.encode(carts));
          getData();
          //print(carts);
        }
        //cart['quantity']++;
        // print(cart);
        notifyListeners();
      }
    }
  }

  decrementQuantityOfProduct(item) async {
    if (isPresentInCart(item) == true) {
      for (final cart in carts) {
        if (cart['id'] == item.id) {
          if (cart['quantity'] > 1) {
            cart['quantity'] -= 1;
            var cartPrice =
                double.parse(await generatePrice(cart['id'].toString()));
            cart['total'] = cart['quantity'] * cartPrice;
            final SharedPreferences prefs = await _prefs;
            prefs.setString(localCartStorageKey, json.encode(carts));
            getData();
            notifyListeners();
          } else {
            return;
          }
          //print(carts);
        }
      }
    }
  }

  getData() async {
    await getCartLocally().then((value) {
      if (value != null) {
        _incartItems = (value as List).map((e) => Cart.fromJson(e)).toList();
        data = _incartItems.length;
        // print(_incartItems);
        //print(data);

      }
    });
  }

  Future getCartLocally() async {
    try {
      final SharedPreferences prefs = await _prefs;
      var items = prefs.getString(localCartStorageKey);
      if (items != null) {
        _carts = json.decode(items);
      }
      //print(_carts);
    } catch (err) {
      print(err);
      print("error data not retrive");
    }
    notifyListeners();
    return _carts;
  }

  _getCartDataAsString(item) async {
    List image = item.images;
    if (carts == null) {
      try {
        List<dynamic> productsInCart = [];
        this.cartItems.forEach(
              (item) => productsInCart.add({
                'id': item.id,
                'quantity': item.quantity,
                'price': double.parse(item.price),
                'total': double.parse(item.price),
                'name': item.name,
                'image': image[0].src,
              }),
            );
        final SharedPreferences prefs = await _prefs;
        prefs.setString(localCartStorageKey, json.encode(productsInCart));
        print('added 1');
      } catch (err) {
        print(err);
      }
    } else if (isPresentInCart(item) != true) {
      try {
        carts.add({
          'id': item.id,
          'quantity': item.quantity,
          'price': double.parse(item.price),
          'total': double.parse(item.price),
          'name': item.name,
          'image': image[0].src,
        });
        final SharedPreferences prefs = await _prefs;
        prefs.setString(localCartStorageKey, json.encode(carts));
      } catch (err) {
        print(err);
      }
    } else if (isPresentInCart(item) == true) {
      for (final cart in carts) {
        if (cart['id'] == item.id) {
          cart['quantity'] += 1;
          cart['total'] = cart['quantity'] * cart['price'];
          final SharedPreferences prefs = await _prefs;
          prefs.setString(localCartStorageKey, json.encode(carts));

          //print(carts);
        }
        //cart['quantity']++;
        // print(cart);
        notifyListeners();
      }
    }
  }
}
