import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/models/category.dart';
import 'package:dio/dio.dart';
import 'package:franko_mobile_app/models/customerModel.dart';
import 'package:franko_mobile_app/models/loginModel.dart';
import 'package:franko_mobile_app/models/login_model.dart';
import 'package:franko_mobile_app/models/momoApi_model.dart';
import 'package:franko_mobile_app/models/order_response.dart';
import 'package:franko_mobile_app/models/payment_model.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/models/reset_password_model.dart';
import 'package:franko_mobile_app/models/variable_product_model.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/util/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:http/http.dart' as http;

class APIService {
  Localstorage local = new Localstorage();

  var dio = Dio();

  Future<bool> createCustomer(Customer model) async {
    bool value = false;
    try {
      print(model.toJson());
      String url = Config.url +
          Config.customersURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().post(url,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 201) {
        print(response.data);
        value = true;
        // SignUpModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return value;
  }

  Future<List<ProductCategory>> getCategories() async {
    List<ProductCategory> data = <ProductCategory>[];
    List<ProductCategory> localData = <ProductCategory>[];
    var isCacheExist =
        await APICacheManager().isAPICacheKeyExist("API_Categories");

    if (!isCacheExist) {
      try {
        print(
            "-------------------------------------------API--------------------------");
        String url = Config.url +
            Config.categoriesURL +
            "?include=${Config.parentCAT}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";
        var response = await Dio().get(url,
            options: new Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }));

        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "API_Categories", syncData: json.encode(response.data));

          await APICacheManager().addCacheData(cacheDBModel);

          print("Hit: API get categories");
          data = (response.data as List)
              .map((i) => ProductCategory.fromJson(i))
              .toList();
        }
      } on DioError catch (e) {
        print(e.response);
      }
      // print("printing data");
      // print(data);

      return data;
    } else {
      var cacheData = await APICacheManager().getCacheData("API_Categories");

      print(
          "-------------------------------------------cache Category-------------------------");

      print("Hit: Cache get Categories");

      var cacheResults = json.decode(cacheData.syncData);

      print("printing cache categories data");
      // debugPrint(cacheData.syncData);

      localData = (cacheResults as List)
          .map((i) => ProductCategory.fromJson(i))
          .toList();

      return localData;
    }
  }

  Future<List<Payment>> getPaymentMethods() async {
    List<Payment> data = <Payment>[];

    try {
      String url = Config.url +
          "payment_gateways?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        print(response.data);
        data = (response.data).map((i) => Payment.fromJson(i)).toList();
        print(data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<Products>> getProducts({
    int pageNumber,
    String productId,
    int pageSize,
    String status,
    String categoryId,
    String strSearch,
    String tagName,
    var sortBy,
    List<int> relatedIds,
    String sortOrder = 'asc',
  }) async {
    List<Products> data = <Products>[];
    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "?&search=$strSearch";
      }

      if (tagName != null) {
        parameter += "?&tag=$tagName";
      }
      if (pageNumber != null) {
        parameter += "?&page=$pageNumber";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }
      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }
      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }
      if (sortOrder != null) {
        parameter += "&order=$sortOrder";
      }

      if (relatedIds != null) {
        parameter += "&include=${relatedIds.join(",").toString()}";
      }

      if (productId != null) {
        parameter += "$productId";
      }
      if (status != null) {
        parameter += "&status=$status";
      }

      String url = Config.url +
          Config.productURL +
          "?$parameter&consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 200) {
        data =
            (response.data as List).map((v) => Products.fromJson(v)).toList();
        //  print(response.headers);
      }
    } on DioError catch (e) {
      print(e.response);
      print('Error Retriving data');
    }

    return data;
  }

  Future loginCustomer(String username, String password) async {
    var model;
    //  DataU dataU;
    try {
      var response = await Dio().post(
        Config.tokenURL,
        data: {
          "username": username,
          "password": password,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          },
        ),
      );
      if (response.statusCode == 200 && response.data['success'] != false) {
        print('--printing from api service file-- response');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserLogin model = UserLogin.fromJson(response.data);
        //getting the json data or getting the data in json
        var info = model.toJson();
        //print(info);
        UserLogin data = UserLogin.fromJson(info);
        print(data);
        print("printing data");

        Map userDetails = {
          'first_name': data.data.firstname,
          'last_name': data.data.lastName,
          'email': data.data.email
        };
        UserProvider userProvider = UserProvider();
        //saving the data to prefs
        userProvider.saveUserDetails(userDetails);
        // print(model.toJson());
        // print('--printing from api service file-- dataU');
        if (model.data != null) {
          var tokenString = model.data;
          // print(jsonEncode(tokenString));
          prefs.setString("token", jsonEncode(tokenString));
        }
        return model;
      } else if (response.statusCode == 403) {
        print("it false");
        model = false;
      }
    } on DioError catch (e) {
      print(e.response);
      ErrorLogin model = ErrorLogin.fromJson(e.response.data);
      return model;
    }
    return model;
  }

  Future<List<ProductCategory>> getbrands(int categoryId) async {
    List<ProductCategory> data = new List<ProductCategory>();
    List<ProductCategory> localData = new List<ProductCategory>();
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("API_Brands");

    try {
      String url = Config.url +
          Config.categoriesURL +
          "?parent=$categoryId&consumer_key=${Config.key}&consumer_secret=${Config.secret}&per_page=21";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        // print(response.headers);

        // APICacheDBModel cacheDBModel = new APICacheDBModel(
        //     key: "API_Brands", syncData: json.encode(response.data));

        // await APICacheManager().addCacheData(cacheDBModel);

        print("Hit: API Brands");
        data = (response.data as List).map((v) {
          // print("cat objects");
          // print(v['name']);
         return ProductCategory.fromJson(v);
        }).toList();

        // print("cat id's");
        // print(response.data['id']);
      }
    } on DioError catch (e) {
      print(e.response);
      print('Error Retriving data');
    }

    return data;
    //   if (!isCacheExist) {

    // } else {
    //   var cacheData = await APICacheManager().getCacheData("API_Brands");

    //   print(
    //       "-------------------------------------------cache-------------------------");

    //   print("Hit: Cache get Brands");

    //   var cacheResults = json.decode(cacheData.syncData);

    //   print("printing cache");
    //   debugPrint(cacheData.syncData);

    //   localData = (cacheResults as List)
    //       .map((i) => ProductCategory.fromJson(i))
    //       .toList();

    //   return localData;
    // }
  }

  Future<OrderModel> createOrder(model) async {
    OrderModel isOrderCreated = new OrderModel();
    try {
      String url = Config.url +
          Config.orders +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().post(url,
          data: model,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      //print(response.data);
      if (response.statusCode == 201) {
        isOrderCreated = OrderModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return isOrderCreated;
  }

  Future<Products> getproduct(String productId) async {
    Products data = new Products();

    try {
      String url = Config.url +
          Config.productURL +
          "$productId?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 200) {
        //print(response.data);
        print("Hit: API product");
        var res = Products.fromJson(response.data);
        return res;
        //print(data);
        //return data;
        // .map((v) => Products.fromJson(v));

      }
    } on DioError catch (e) {
      print(e.response);
      print('Error Retriving data');
    }

    return data;
  }

  Future<List<Products>> getProductsHome(String param, String paramId) async {
    List<Products> data = <Products>[];
    try {
      String url = Config.url +
          Config.productURL +
          "?$param=$paramId&consumer_key=${Config.key}&consumer_secret=${Config.secret}&per_page=6";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 200) {
        //print(response.data);

        print("Hit: API Products Home");
        data =
            (response.data as List).map((v) => Products.fromJson(v)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
      print('Error Retriving data');
    }

    return data;
  }

  Future<List<Products>> getProductBrands({
    int pageNumber,
    String productId,
    int pageSize,
    String categoryId,
    String strSearch,
    String tagName,
    var sortBy,
    String status,
    List<int> relatedIds,
    String sortOrder = 'desc',
  }) async {
    List<Products> data = <Products>[];
    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "?&search=$strSearch";
      }
      if (tagName != null) {
        parameter += "?&tag=$tagName";
      }
      if (pageNumber != null) {
        parameter += "?&page=$pageNumber";
      }
      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }
      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }
      if (status != null) {
        parameter += "&status=$status";
      }
      if (sortOrder != null) {
        parameter += "&order=$sortOrder";
      }

      if (relatedIds != null) {
        parameter += "&include=${relatedIds.join(",").toString()}";
      }
      if (productId != null) {
        parameter += "$productId";
      }

      String url = Config.url +
          Config.productURL +
          "?$parameter&consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        print(response.headers);
        data =
            (response.data as List).map((v) => Products.fromJson(v)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
      print('Error Retriving data');
    }

    return data;
  }

  Future<List<OrderModel>> getOrders(int id) async {
    List<OrderModel> data = <OrderModel>[];
    try {
      String url = Config.url +
          Config.orders +
          "?customer=$id&consumer_key=${Config.key}&consumer_secret=${Config.secret}&order=desc&per_page=15";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        print(response.data);
        data =
            (response.data as List).map((v) => OrderModel.fromJson(v)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<List<Products>> searchproduct(String query) async {
    List<Products> data = <Products>[];
    try {
      String url = Config.url +
          Config.productURL +
          "?search=$query&consumer_key=${Config.key}&consumer_secret=${Config.secret}&per_page=6&status=publish";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        data =
            (response.data as List).map((v) => Products.fromJson(v)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future passwordReset(email) async {
    Reset reset = new Reset();
    try {
      String url = Config.url2 + "reset-password";
      var response = await Dio().post(url,
          data: {
            "email": email,
          },
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        reset = Reset.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return reset;
  }

  Future validateCode(String email, String code) async {
    Reset reset = new Reset();
    try {
      String url = Config.url2 + "validate-code";
      var response = await Dio().post(url,
          data: {
            "email": email,
            "code": code,
          },
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        print(response.data);
        reset = Reset.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return reset;
  }

  Future newPassword(String email, String code, String password) async {
    Reset reset = new Reset();
    try {
      String url = Config.url2 + "set-password";
      var response = await Dio().post(url,
          data: {
            "email": email,
            "password": password,
            "code": code,
          },
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));

      if (response.statusCode == 200) {
        print(response.data);
        reset = Reset.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return reset;
  }

  Future<List<VariableProduct>> getVariableProduct(int productId) async {
    List<VariableProduct> responseModel;

    try {
      String url = Config.url +
          Config.productURL +
          "${productId.toString()}/${Config.variableProductUrl}?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 200) {
        //print(response.data);
        responseModel = (response.data as List)
            .map((i) => VariableProduct.fromJson(i))
            .toList();
        //print(responseModel);
      }
    } on DioError catch (e) {
      print(e.response);
      //print(e.response.request.uri);
    }
    return responseModel;
  }

  // payment sevices implementation

  Future<MomoApi> getMomoApiResponse(requestData) async {
    MomoApi apiResponse = new MomoApi();
    String url = Config.mobileMoneyApiUrl;
    try {
      var response = await Dio().post(url,
          data: requestData,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: Config.merchantID,
          }));
      if (response.statusCode == 200) {
        //print(response.data);
        apiResponse = MomoApi.fromJson(response.data);
      }
    } catch (e) {
      print(e.response);
    }

    return apiResponse;
  }

  Future updateOrderStatus(String orderId, String status, bool setPaid) async {
    var responseModel;

    try {
      String url = Config.url +
          "orders/" +
          orderId +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().put(url,
          data: {'status': status, 'set_paid': setPaid},
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 200) {
        //print(response.data);
        responseModel = response.data;
        print('--api service--');
        print(response);

        //print(responseModel);
      }
    } on DioError catch (e) {
      print(e.response);
      //print(e.response.request.uri);
    }
  }
}

Future cellulantPayment() async {
  try {
    String url = 'https://cellulant-payment.herokuapp.com/payment';

    var body = {
      "merchant_transaction_id": "787867001614",
      "customer_first_name": "Test",
      "customer_last_name": "User",
      "msisdn": "254700000000",
      "customer_email": "joel.lartey@yahoo.com",
      "request_amount": "10.0",
      "currency_code": "KES",
      "account_number": "12345",
      "service_code": "FRANKOTRADINGLIMITED",
      "due_date": "2022-03-21 12:49:36",
      "request_description": "Test payment",
      "country_code": "KEN",
      "language_code": "en",
      "success_redirect_url": "http://abc.com/success",
      "fail_redirect_url": "http://abc.com/fail",
      "pending_redirect_url": "http://abc.com/pending",
      "callback_url": "http://abc.com/callback",
      "charge_beneficiaries": null
    };

    var jsnnBody = json.encode(body.toString());

    print(jsnnBody);
    var response = await Dio().get(url,
        queryParameters: {
          "merchant_transaction_id": "787867001614",
          "customer_first_name": "Test",
          "customer_last_name": "User",
          "msisdn": "254700000000",
          "customer_email": "joel.lartey@yahoo.com",
          "request_amount": "10.0",
          "currency_code": "KES",
          "account_number": "12345",
          "service_code": "FRANKOTRADINGLIMITED",
          "due_date": "2022-03-21 12:49:36",
          "request_description": "Test payment",
          "country_code": "KEN",
          "language_code": "en",
          "success_redirect_url": "http://abc.com/success",
          "fail_redirect_url": "http://abc.com/fail",
          "pending_redirect_url": "http://abc.com/pending",
          "callback_url": "http://abc.com/callback",
          "charge_beneficiaries": "null"
        },
        options: new Options(headers: {
          //HttpHeaders.contentTypeHeader: 'application/json',
          'Content-Type': 'application/json'
        }));
    print(response);

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.data['encryptedResults']);
      // Response responseModel = response.data;
      print('--api service--');
      print(response);
      print(response);

      return response.data['encryptedResults'];

      //print(responseModel);
    }
  } on DioError catch (e) {
    print(e.response);
    //print(e.response.request.uri);
  }
}

Future embeddedWebView(encyptedData) async {
  String url = 'https://online.uat.tingg.africa/testing/express/checkout?';
  try {
    var response = await Dio().get(url,
        queryParameters: {
          'encrypted_payload': encyptedData,
          'access_key':
              'CDDSvSvn24D4dS44sysdCCqSqyvDydvqMZn44qvsZ4ZdVvCy2qVqDsqVSSyy'
        },
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }));
    if (response.statusCode == 200) {
      //print(response.data);
      Response responseModel = response.data;
      print('--api service--');
      print(response);
      print(response.data);

      return responseModel;

      //print(responseModel);
    }
  } on DioError catch (e) {
    print(e.response);
    //print(e.response.request.uri);
  }
}

Future encrypt(id, firstName, lastName, email, number, amount, dueDate) async {
  print('api_service');
  print(email);

  print(dueDate);
  String date = dueDate;

  // "2022-07-21 12:49:36"
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET', Uri.parse('https://cellulant-payment.onrender.com/payment'));
  request.body = json.encode({
    "merchant_transaction_id": id.toString(),
    "customer_first_name": firstName.toString(),
    "customer_last_name": lastName.toString(),
    "msisdn": number,
    "customer_email": email,
    //email.toString()
    "request_amount": amount.toString(),
    "currency_code": "GHS",
    "account_number": "12345",
    "service_code": "FRANKOTRADINGENTERPR",
    "due_date": "$date",
    "request_description": "live payment",
    "country_code": "GHA",
    "language_code": "en",
    "success_redirect_url": Config.baseUrl + "/payment-successful/",
    "fail_redirect_url":
        "https://online.tingg.africa/v2/receipt/?paymentStatus=cancelled", // Config.baseUrl + "/cancel/",
    "pending_redirect_url":
        "https://online.tingg.africa/v2/receipt/?paymentStatus=cancelled",
    "callback_url":
        "https://online.tingg.africa/v2/receipt/?paymentStatus=cancelled",
    "charge_beneficiaries": null
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print('///////////////////////////////////////////');
  print('response code');
  print(response.statusCode);

  if (response.statusCode == 200) {
    var edata = jsonDecode(await response.stream.bytesToString());

    return edata['encryptedResults'];
  } else {
  }
 
}
//write a functio that accepts the encrypted data  and params to generate the webview
