import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:franko_mobile_app/provider/auth_provider.dart';

import 'package:franko_mobile_app/provider/categories_provider.dart';

import 'package:franko_mobile_app/provider/category_provider.dart';
import 'package:franko_mobile_app/provider/connectvity_provider.dart';
import 'package:franko_mobile_app/provider/dashboard_provider.dart';

import 'package:franko_mobile_app/provider/loader_provider.dart';
import 'package:franko_mobile_app/provider/order_provider.dart';
import 'package:franko_mobile_app/provider/payment_provider.dart';
import 'package:franko_mobile_app/provider/products_provider.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/services/dynamic_link_service.dart';
import 'package:franko_mobile_app/services/local_notification_service.dart';
import 'package:franko_mobile_app/view/pages/brands_page.dart';
import 'package:franko_mobile_app/view/pages/category/categories_page.dart';
import 'package:franko_mobile_app/view/pages/dashboard/dashboard.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:franko_mobile_app/view/pages/home.dart';
import 'package:franko_mobile_app/view/pages/notification/notificaction_details.dart';
import 'package:franko_mobile_app/view/pages/order/address_form.dart';
import 'package:franko_mobile_app/view/pages/order/address_management.dart';
import 'package:franko_mobile_app/view/pages/order/order_pay.dart';
import 'package:franko_mobile_app/view/pages/order/order_summary.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_cancel.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_successful.dart';
import 'package:franko_mobile_app/view/pages/product/product_page.dart';

import 'package:franko_mobile_app/view/pages/profile/account_pages/orders_page.dart';
import 'package:franko_mobile_app/view/pages/order/verify_address.dart';
import 'package:franko_mobile_app/view/view_auth/login_ui.dart';
import 'package:franko_mobile_app/view/view_auth/register_otp_number.dart';
import 'package:franko_mobile_app/view/view_auth/signup_ui.dart';
import 'package:franko_mobile_app/view/widget/base_page.dart';

import 'package:franko_mobile_app/view/widget/widget_new_password.dart';
import 'package:franko_mobile_app/view/widget/widget_validate_code.dart';

import 'package:franko_mobile_app/view/widget/parent_categories_home.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_config/flutter_config.dart';


import 'models/address_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  //await Firebase.initializeApp();
  print('A bg message just showed up :${remoteMessage.messageId}');
}

Future<void> main() async {
  // var path = Directory
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Hive.initFlutter();

  await Firebase.initializeApp();
  // await Hive.initFlutter()

  Hive.registerAdapter(AddressAdapter());
  await Hive.openBox<Address>('address');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;

  //Facebook Sdk
   String _deepLinkUrl = 'Unknown';
  //  FlutterFacebookPro facebookDeepLinks;
  bool isAdvertisingTrackingEnabled = false;

  @override
  void initState() {
    super.initState();
    FirebaseDynamicLinkService.initDynamicLink(context);

    FirebaseInAppMessaging.instance.triggerEvent("");

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        String noteTitle = message.notification.title;
        // String noteImageforApple = message.notification.apple.imageUrl;

        String noteImage = message.notification.android.imageUrl ??
            message.notification.apple.imageUrl;
        String noteBody = message.notification.body;
        print(noteBody);
        print(noteImage);
        print(noteTitle);
        Navigator.of(context).pushNamed(routeFromMessage, arguments: {
          "noteTitle": noteTitle,
          "noteImage": noteImage,
          "noteBody": noteBody
        });
      }
    });
    //foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final routeFromMessage = message.data["route"];
      String noteTitle = message.notification.title;
      // String noteImageforApple = message.notification.apple.imageUrl;

      String noteImage = message.notification.android.imageUrl ??
          message.notification.apple.imageUrl;
      String noteBody = message.notification.body;
      print(noteBody);
      print(noteImage);
      print(noteTitle);
      Navigator.of(context).pushNamed(routeFromMessage, arguments: {
        "noteTitle": noteTitle,
        "noteImage": noteImage,
        "noteBody": noteBody
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      final routeFromMessage = message.data["route"];
      String noteTitle = message.notification.title;
      // String noteImageforApple = message.notification.apple.imageUrl;

      String noteImage = message.notification.android.imageUrl ??
          message.notification.apple.imageUrl;
      String noteBody = message.notification.body;
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => NotificationDetailPage(title: noteTitle,body: noteBody,image: noteImage,)));
      Navigator.of(context).pushNamed(routeFromMessage, arguments: {
        'noteTitle': noteTitle,
        'noteImage': noteImage,
        'noteBody': noteBody
      });

      //  final routeFromMessage = message.data["route"];

      // Navigator.of(context).pushNamed(routeFromMessage);
      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      // if (notification != null && android != null) {
      //   showDialog(
      //       context: context,
      //       builder: (_) {
      //         return AlertDialog(
      //           title: Text(notification.title),
      //           content: SingleChildScrollView(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(notification.body)
      //                 ],
      //             ),
      //           ),
      //         );
      //       });
      // }
    });
    FirebaseMessaging.instance.sendMessage();
    // var token =  FirebaseMessaging.instance.getToken();
    // print("Print Instance Token ID: " + token!.);
    //listenNotifications();

    getToken();

    // initPlatformState();

    
  }

  //  Future<void> initPlatformState() async {
  //   String deepLinkUrl;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     facebookDeepLinks = FlutterFacebookPro();
  //     facebookDeepLinks.onDeepLinkReceived.listen((event) {
  //       setState(() {
  //         _deepLinkUrl = event;
  //       });
  //     });
  //     deepLinkUrl = await facebookDeepLinks.getDeepLinkUrl;
  //     setState(() {
  //       _deepLinkUrl = deepLinkUrl;
  //     });
  //   } on PlatformException {}
  //   if (!mounted) return;
  // }

  @override
  void dispose() {
    // onNotifications.close();
     Hive.close();
    super.dispose();
  }

  getToken() async {
    print('get token called');
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print("Print Instance Token ID: " + token.toString());
  }

  AnalyticsService analyticsService = AnalyticsService();

  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    // fiam.triggerEvent('app_launch');
    print(FlutterConfig.get('url').toString());
    // flutterLocalNotificationsPlugin.show(
    //     0,
    //     "Testing 2",
    //     "How you doin ?",
    //     NotificationDetails(
    //         android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
    //             importance: Importance.high,
    //             color: Colors.blue,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher')));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {"notes": (_) => NotificationDetailPage()},
      home: NewHome(analyticsService: analyticsService),
    );
  }
}

class NewHome extends StatefulWidget {
  const NewHome({
    Key key,
    @required this.analyticsService,
  }) : super(key: key);

  final AnalyticsService analyticsService;

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        print(routeFromMessage);
        String noteTitle = message.notification.title;
        // String noteImageforApple = message.notification.apple.imageUrl;

        String noteImage = message.notification.android.imageUrl ??
            message.notification.apple.imageUrl;
        String noteBody = message.notification.body;
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationDetailPage(title: noteTitle,body: noteBody,image: noteImage,)));
        Navigator.of(context).pushNamed(routeFromMessage, arguments: {
          'noteTitle': noteTitle,
          'noteImage': noteImage,
          'noteBody': noteBody
        });
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        final routeFromMessage = message.data["route"];
        print(message.notification.body);
        print(message.notification.title);

        String noteTitle = message.notification.title;
        // String noteImageforApple = message.notification.apple.imageUrl;

        String noteImage = message.notification.android.imageUrl ??
            message.notification.apple.imageUrl;
        String noteBody = message.notification.body;
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationDetailPage(title: noteTitle,body: noteBody,image: noteImage,)));
        Navigator.of(context).pushNamed(routeFromMessage, arguments: {
          'noteTitle': noteTitle,
          'noteImage': noteImage,
          'noteBody': noteBody
        });
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      print(message.notification.body);
      print(message.notification.title);

      String noteTitle = message.notification.title;
      // String noteImageforApple = message.notification.apple.imageUrl;

      String noteImage = message.notification.android.imageUrl ??
          message.notification.apple.imageUrl;
      String noteBody = message.notification.body;
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => NotificationDetailPage(title: noteTitle,body: noteBody,image: noteImage,)));
      Navigator.of(context).pushNamed(routeFromMessage, arguments: {
        'noteTitle': noteTitle,
        'noteImage': noteImage,
        'noteBody': noteBody
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // routes:{
      //   "notes":(_)=>NotificationDetailPage()
      // },
      home: MultiProvider(
        providers: [
          // ChangeNotifierProvider(
          //   create: (context) => CartStateProvider(),
          //   child: ProductDetails(),
          // ),
          ChangeNotifierProvider(
            create: (context) => PaymentProvider(),
            child: VerifyAddress(),
          ),
          ChangeNotifierProvider(
            create: (context) => PaymentProvider(),
            child: OrderSummaryPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartManager(),
            child: BasePage(),
          ),
           ChangeNotifierProvider(
            create: (context) => CartManager(),
            child: AddressManagementPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => ConnectivityProvider(),
            child: Home(),
          ),
          ChangeNotifierProvider(
            create: (context) => DashboardProvider(),
            child: ParentCategories(),
          ),
          ChangeNotifierProvider(
            create: (context) => DashboardProvider(),
            child: NotificationDetailPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(),
            child: CategoriesPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => DashboardProvider(),
            child: Dashboard(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
            child: SignUpScreen(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
            child: LoginScreen(),
          ),

          ChangeNotifierProvider(
            create: (context) => UserProvider(),
            child: AddressFormPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartManager(),
            child: PaymentSuccessful(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
            child: VerifyAddress(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartManager(),
            child: Home(),
          ),
          ChangeNotifierProvider(
            create: (context) => PaymentProvider(),
            child: Register(),
          ),
          ChangeNotifierProvider(
            create: (context) => PaymentProvider(),
            child: OrderPayPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartManager(),
            child: OrderSummaryPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartManager(),
            child: AddressFormPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => LoaderProvider(),
            child: BasePage(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => CartStateProvider(),
          //   child: BasePage(),
          // ),
          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: ProductPage(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => SearchProvider(),
          //   child: Home(),
          // ),
          ChangeNotifierProvider(
            create: (context) => Authentication(),
            child: Home(),
          ),
          ChangeNotifierProvider(
            create: (context) => OrderProvider(),
            child: OrdersPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoriesProvider(),
            child: BrandsPage(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [widget.analyticsService.observer],
          theme: new ThemeData(
            scaffoldBackgroundColor: const Color(0xFFEFEFEF),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          home: Scaffold(
            //for displaying update dialog box for new updates
            body: Home(
              analytics: AnalyticsService.analytics,
              observer: widget.analyticsService.observer,
            ),
          ),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => new Home(
                  index: 0,
                  logValue: "logout",
                ),
            '/homeScreen': (BuildContext context) => new Home(
                  index: 0,
                ),
            '/cart': (BuildContext context) => new Home(
                  index: 2,
                ),
            '/loginScreen': (BuildContext context) => new LoginScreen(),
            '/account': (BuildContext context) => new Home(
                  index: 3,
                ),
            '/validate': (BuildContext context) => new ValidateCode(
                  title: "Validate Code",
                ),
            '/setNewPassword': (BuildContext context) => new NewPassword(
                  title: "Set New Password",
                ),
            '/cancel': (BuildContext context) => new PaymentCancel(),
            '/success': (BuildContext context) => new PaymentSuccessful(),
            // '/screen4' : (BuildContext context) => new Screen4()
          },
        ),
      ),
    );
  }
}
