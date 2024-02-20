import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  setFiamTrigger(String triggerName) {
    fiam.triggerEvent(triggerName);
  }

  AnalyticsService();

  Future<void> setCurrentScreen(
      String screenName, String screenClassOverride) async {
    await analytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenClassOverride);
  }

  Future<void> logEvent(String name) async {
    await analytics.logEvent(
        name: name, parameters: <String, dynamic>{'init_state': 'started'});
  }

  Future<void> setUserProperty(String name, String value) async {
    await analytics.setUserProperty(name: name, value: 'customer');
  }

  Future<void> logAddToCart(
      String currency, List items, double value) async {
    await analytics.logAddToCart(
        items: items,
        value: value,
        currency: 'cedis',
       );
  }

  Future<void> logEcommercePurchase(
      String currency, double value, String location) async {
    await analytics.logEcommercePurchase(
        currency: currency, value: value, location: location);
  }
}
