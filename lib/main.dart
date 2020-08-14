import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/welcome_screen.dart';
import './screens/delivery_executive/login_screen.dart';
import './screens/service_station/bookings_screen.dart' as Bookings;
import './screens/delivery_executive/bookings_screen.dart';
import './screens/delivery_executive/menu_screen.dart';
import './screens/delivery_executive/payments_screen.dart';
import './screens/delivery_executive/delivery_info_screen.dart';
import './screens/delivery_executive/inspection_images_screen.dart';
import './screens/delivery_executive/display_inspection_images_screen.dart';
import './screens/service_station/login_screen.dart' as Login;
import './screens/service_station/menu_screen.dart' as Menu;
import './screens/service_station/order_menu_screen.dart';
import './screens/service_station/delivery_info_screen.dart' as DeliveryInfo;
import './screens/service_station/jobs_screen.dart';
import './screens/service_station/partner_details_screen.dart';
import './screens/service_station/inspection_images_screen.dart' as Inspection;
import './screens/service_station/coming_soon.dart';
import './providers/service_station.dart';
import './providers/delivery_executive.dart';
import './providers/service_orders.dart';
import './providers/delivery_orders.dart';
import './screens/service_station/delivery_executives_screen.dart';
import './screens/service_station/edit_deliveryex_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isInit = true;
  var _isLoading = false;
  var _type;
  var _routes = {
    WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
    LoginScreen.routeName: (ctx) => LoginScreen(),
    Bookings.BookingsScreen.routeName: (ctx) => Bookings.BookingsScreen(),
    BookingsScreen.routeName: (ctx) => BookingsScreen(),
    MenuScreen.routeName: (ctx) => MenuScreen(),
    DeliveryInfoScreen.routeName: (ctx) => DeliveryInfoScreen(),
    PaymentsScreen.routeName: (ctx) => PaymentsScreen(),
    InspectionImagesScreen.routeName: (ctx) => InspectionImagesScreen(),
    DisplayInspectionImagesScreen.routeName: (ctx) =>
        DisplayInspectionImagesScreen(),
    Login.LoginScreen.routeName: (ctx) => Login.LoginScreen(),
    Menu.MenuScreen.routeName: (ctx) => Menu.MenuScreen(),
    OrderMenuScreen.routeName: (ctx) => OrderMenuScreen(),
    DeliveryInfo.DeliveryInfoScreen.routeName: (ctx) =>
        DeliveryInfo.DeliveryInfoScreen(),
    JobsScreen.routeName: (ctx) => JobsScreen(),
    PartnerDetailsScreen.routeName: (ctx) => PartnerDetailsScreen(),
    Inspection.InspectionImagesScreen.routeName: (ctx) =>
        Inspection.InspectionImagesScreen(),
    DeliveryExecutivesScreen.routeName: (ctx) => DeliveryExecutivesScreen(),
    EditDeliveryexScreen.routeName: (ctx) => EditDeliveryexScreen(),
    SplashScreen.routeName: (ctx) => SplashScreen(),
    ComingSoonScreen.routeName: (ctx) => ComingSoonScreen()
  };
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('serviceData')) {
        _type = null;
      } else {
        final extractedUserData =
            json.decode(prefs.getString('serviceData')) as Map<String, Object>;
        if (extractedUserData['user'] == 'servicestation') {
          _type = 'servicestation';
        } else {
          _type = 'deliveryexecutive';
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ServiceStation(),
        ),
        ChangeNotifierProvider.value(
          value: DeliveryExecutive(),
        ),
        ChangeNotifierProxyProvider<DeliveryExecutive, DeliveryOrders>(
          update: (ctx, deliveryprofile, previousOrders) => DeliveryOrders(
            deliveryprofile.item == null ? null : deliveryprofile.item.id,
            previousOrders == null ? [] : previousOrders.items,
          ),
        ),
        ChangeNotifierProxyProvider<ServiceStation, ServiceOrders>(
          update: (ctx, serviceprofile, previousOrders) => ServiceOrders(
            serviceprofile.item1 == null ? null : serviceprofile.item1.id,
            previousOrders == null ? [] : previousOrders.items,
          ),
        ),
      ],
      child: _isLoading
          ? MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: SplashScreen(),
              routes: _routes,
            )
          : _type == null
              ? MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.deepOrange,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: WelcomeScreen(),
                  routes: _routes,
                )
              : _type == 'servicestation'
                  ? Consumer<ServiceStation>(
                      builder: (ctx, profile, _) => MaterialApp(
                        title: 'Flutter Demo',
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          primarySwatch: Colors.deepOrange,
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                        ),
                        home: profile.isAuthSS
                            ? Menu.MenuScreen()
                            : FutureBuilder(
                                future: profile.tryAutoLoginSS(),
                                builder: (ctx, snapshot) =>
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? SplashScreen()
                                        : WelcomeScreen(),
                              ),
                        routes: _routes,
                      ),
                    )
                  : Consumer<DeliveryExecutive>(
                      builder: (ctx, profile, _) => MaterialApp(
                        title: 'Flutter Demo',
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          primarySwatch: Colors.deepOrange,
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                        ),
                        home: profile.isAuthDE
                            ? BookingsScreen()
                            : FutureBuilder(
                                future: profile.tryAutoLoginDE(),
                                builder: (ctx, snapshot) =>
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? SplashScreen()
                                        : WelcomeScreen(),
                              ),
                        routes: _routes,
                      ),
                    ),
    );
  }
}
