import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeliveryOrderItem with ChangeNotifier {
  final String id;
  final String bookingId;
  final String make;
  final String model;
  final String rideable;
  final String bikeid;
  final String serviceType;
  final String bikeYear;
  final String status;
  final String date;
  final String time;
  final String customer;
  final String mobile;
  final String email;
  final String bikeNumber;
  final String flat;
  final String address;
  final String landmark;
  final String latitude;
  final String longitude;
  final String deliveryType;
  final String otp;
  final String deliveryOtp;
  final String total;
  final String paid;

  DeliveryOrderItem({
    @required this.id,
    @required this.bookingId,
    @required this.rideable,
    @required this.serviceType,
    @required this.time,
    @required this.date,
    @required this.bikeid,
    @required this.flat,
    @required this.address,
    @required this.landmark,
    @required this.latitude,
    @required this.longitude,
    @required this.deliveryType,
    @required this.customer,
    @required this.mobile,
    @required this.email,
    @required this.otp,
    @required this.deliveryOtp,
    @required this.make,
    @required this.model,
    @required this.bikeNumber,
    @required this.bikeYear,
    @required this.status,
    @required this.total,
    @required this.paid,
  });
}

class DeliveryOrders with ChangeNotifier {
  List<DeliveryOrderItem> _items = [];

  List<dynamic> _services;
  List<String> _preImages = [];
  List<String> _postImages = [];
  String _preOdometerReading;
  String _postOdometerReading;
  String _preFuelLevel;
  String _postFuelLevel;
  String _currentTotal;
  String _currentPaid;
  final String userId;

  DeliveryOrders(this.userId, this._items);

  List<DeliveryOrderItem> get items {
    return [..._items];
  }

  String get currentTotal {
    return _currentTotal;
  }

  String get currentPaid {
    return _currentPaid;
  }

  String get preOdometerReading {
    return _preOdometerReading;
  }

  String get postOdometerReading {
    return _postOdometerReading;
  }

  String get preFuelLevel {
    return _preFuelLevel;
  }

  String get postFuelLevel {
    return _postFuelLevel;
  }

  List<String> get preImages {
    return [..._preImages];
  }

  List<String> get postImages {
    return [..._postImages];
  }

  List<dynamic> get services {
    return [..._services];
  }

  Future<void> fetchAndSetOrders() async {
    final url1 = 'http://api.protto.in/fetchbookingsDE.php?de_id=$userId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response1 = await http
        .get(url1, headers: <String, String>{'Authorization': basicAuth});
    final extractedData1 = json.decode(response1.body) as Map<String, dynamic>;

    List<DeliveryOrderItem> data = [];
    if (extractedData1['count'] == '0') {
      return;
    }
    for (int i = 0; i < int.parse(extractedData1['count']); i++) {
      final bikeid = extractedData1['data'][i]['bike_id'];
      final url2 = 'http://api.protto.in/getbike.php/$bikeid';
      final response2 = await http
          .get(url2, headers: <String, String>{'Authorization': basicAuth});
      final extractedData2 =
          json.decode(response2.body) as Map<String, dynamic>;
      data.insert(
        0,
        DeliveryOrderItem(
          id: extractedData1['data'][i]['id'],
          bookingId: extractedData1['data'][i]['booking_id'],
          rideable: extractedData1['data'][i]['rideable'],
          serviceType: extractedData1['data'][i]['service_type'],
          status: extractedData1['data'][i]['status'],
          address: extractedData1['data'][i]['address'],
          flat: extractedData1['data'][i]['flat'],
          landmark: extractedData1['data'][i]['landmark'],
          latitude: extractedData1['data'][i]['lat'],
          longitude: extractedData1['data'][i]['lon'],
          otp: extractedData1['data'][i]['otp'],
          deliveryOtp: extractedData1['data'][i]['delivery_otp'],
          date: extractedData1['data'][i]['date'],
          time: extractedData1['data'][i]['timestamp'],
          bikeid: extractedData1['data'][i]['bike_id'],
          deliveryType: extractedData1['data'][i]['delivery_type'],
          customer: extractedData1['data'][i]['cust_name'],
          mobile: extractedData1['data'][i]['mobile'],
          email: extractedData1['data'][i]['email'],
          total: extractedData1['data'][i]['total'],
          paid: extractedData1['data'][i]['paid'],
          bikeNumber: extractedData2['data']['bike_reg'],
          bikeYear: extractedData2['data']['year'],
          make: extractedData2['data']['make'],
          model: extractedData2['data']['model'],
        ),
      );
    }

    _items = data;
    notifyListeners();
  }

  Future<void> getservices(String bookingId) async {
    final url = 'http://api.protto.in/getservicetype.php/$bookingId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http
        .get(url, headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _services = extractedData['data'];
    notifyListeners();
  }

  Future<void> approveotp(String bookingId) async {
    final url = 'http://api.protto.in/getotpapprove.php?booking_id=$bookingId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http
        .get(url, headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['otp_approve'] == '0') {
      throw HttpException('Customer has not verified otp yet');
    }
  }

  Future<void> incrementstatus(
      String bookingId, String status, String message) async {
    final url = 'http://api.protto.in/bookingstatus.php';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http.patch(url,
        body: json.encode({
          'booking_id': bookingId,
          'status': status,
        }),
        headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['message'] == 'status not incremented') {
      throw HttpException(message);
    }
  }

  Future<String> fetchBooking(String bookingId) async {
    final url = 'http://api.protto.in/fetchbooking.php?booking_id=$bookingId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http
        .get(url, headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _currentTotal = extractedData['data']['total'];
    _currentPaid = extractedData['data']['paid'];
    notifyListeners();
    return extractedData['data']['status'];
  }

  Future<String> paymentLink(
    String name,
    String email,
    String mobile,
    String amount,
    String make,
    String model,
    String bookingId,
  ) async {
    final storage = new FlutterSecureStorage();
    String username = await storage.read(key: 'username');
    String password = await storage.read(key: 'password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final url = 'https://api.razorpay.com/v1/invoices/';
    final response = await http.post(url,
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "customer": {"name": name, "email": email, "contact": mobile},
          "type": "link",
          "view_less": 1,
          "amount": double.parse(amount) * 100,
          "currency": "INR",
          "description": "Payment Link for the service of $make $model",
          "receipt": bookingId,
          "reminder_enable": true,
          "sms_notify": 1,
          "email_notify": 1,
          "expire_by": 1793630556
        }));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    return extractedData['id'];
  }

  Future<bool> verifyPayment(String paymentId, String bookingId) async {
    final storage = new FlutterSecureStorage();
    String username = await storage.read(key: 'username');
    String password = await storage.read(key: 'password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final url = 'https://api.razorpay.com/v1/invoices/$paymentId';
    final response = await http.get(
      url,
      headers: <String, String>{
        'authorization': basicAuth,
        'Content-Type': 'application/json'
      },
    );
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['status'] == 'paid') {
      final url1 = 'http://api.protto.in/pidafter.php';
      final storage = new FlutterSecureStorage();
      String key = await storage.read(key: 'key');
      String value = await storage.read(key: 'value');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
      await http.patch(url1,
          body: json.encode({
            'booking_id': bookingId,
            'pid_after': extractedData['payment_id'],
          }),
          headers: <String, String>{'Authorization': basicAuth});
      return true;
    } else {
      return false;
    }
  }

  Future<DeliveryOrderItem> fetchabooking(
      String bookingId, DeliveryOrderItem order) async {
    final url = 'http://api.protto.in/fetchabooking.php?booking_id=$bookingId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http
        .get(url, headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    return DeliveryOrderItem(
      id: extractedData['data']['id'],
      bookingId: extractedData['data']['booking_id'],
      address: extractedData['data']['address'],
      bikeid: extractedData['data']['bike_id'],
      date: extractedData['data']['date'],
      deliveryType: extractedData['data']['delivery_type'],
      customer: extractedData['data']['cust_name'],
      deliveryOtp: extractedData['data']['delivery_otp'],
      flat: extractedData['data']['flat'],
      email: extractedData['data']['email'],
      latitude: extractedData['data']['lat'],
      longitude: extractedData['data']['lon'],
      mobile: extractedData['data']['mobile'],
      otp: extractedData['data']['otp'],
      landmark: extractedData['data']['landmark'],
      paid: extractedData['data']['paid'],
      rideable: extractedData['data']['rideable'],
      serviceType: extractedData['data']['service_type'],
      time: extractedData['data']['timestamp'],
      total: extractedData['data']['total'],
      bikeNumber: order.bikeNumber,
      bikeYear: order.bikeYear,
      make: order.make,
      model: order.model,
      status: extractedData['data']['status'],
    );
  }

  void changeorderstatus(String id, DeliveryOrderItem order) {
    var index = _items.indexWhere((order) => order.id == id);
    _items[index] = order;
    notifyListeners();
  }

  Future<void> editrgno(String bikeId, String bikeReg, String id) async {
    final url = 'http://api.protto.in/editrgno.php';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http.patch(url,
        body: json.encode({
          'bike_id': bikeId,
          'bike_reg': bikeReg,
        }),
        headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    print(extractedData['message']);
    var index = _items.indexWhere((ex) => ex.id == id);
    var item = _items[index];
    _items[index] = DeliveryOrderItem(
      id: id,
      bookingId: item.bookingId,
      address: item.address,
      bikeNumber: bikeReg,
      bikeYear: item.bikeYear,
      bikeid: bikeId,
      customer: item.customer,
      date: item.date,
      deliveryOtp: item.deliveryOtp,
      deliveryType: item.deliveryType,
      email: item.email,
      flat: item.flat,
      landmark: item.landmark,
      latitude: item.latitude,
      longitude: item.longitude,
      make: item.make,
      mobile: item.mobile,
      model: item.model,
      otp: item.otp,
      paid: item.paid,
      rideable: item.rideable,
      serviceType: item.serviceType,
      status: item.status,
      time: item.time,
      total: item.total,
    );
    notifyListeners();
  }

  Future<void> getpreimages(String bookingId) async {
    final url =
        'http://api.protto.in/getpreserviceinspection.php?booking_id=$bookingId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http
        .get(url, headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['data'] == null) {
      _preImages.clear();
      _preOdometerReading = null;
      _preFuelLevel = null;
      notifyListeners();
      return;
    }
    _preImages.clear();
    _preImages.add(extractedData['data']['front_pic']);
    _preImages.add(extractedData['data']['left_pic']);
    _preImages.add(extractedData['data']['rear_pic']);
    _preImages.add(extractedData['data']['right_pic']);
    _preImages.add(extractedData['data']['dashboard_pic']);
    _preImages.add(extractedData['data']['number_pic']);
    _preOdometerReading = extractedData['data']['odometer_reading'];
    _preFuelLevel = extractedData['data']['fuel_level'];
    notifyListeners();
  }

  Future<void> getpostimages(String bookingId) async {
    final url =
        'http://api.protto.in/getdeliveryinspection.php?booking_id=$bookingId';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http
        .get(url, headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['data'] == null) {
      _postImages.clear();
      _postOdometerReading = null;
      _postFuelLevel = null;
      notifyListeners();
      return;
    }
    _postImages.clear();
    _postImages.add(extractedData['data']['front_pic']);
    _postImages.add(extractedData['data']['left_pic']);
    _postImages.add(extractedData['data']['rear_pic']);
    _postImages.add(extractedData['data']['right_pic']);
    _postImages.add(extractedData['data']['dashboard_pic']);
    _postImages.add(extractedData['data']['number_pic']);
    _postOdometerReading = extractedData['data']['odometer_reading'];
    _postFuelLevel = extractedData['data']['fuel_level'];
    print(_postFuelLevel);
    notifyListeners();
  }

  Future<void> addpreimages(
    String bookingId,
    List<String> preImgUrl,
    String preOdometer,
    double prerating,
  ) async {
    final url = 'http://api.protto.in/addpreserviceinspection.php';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    await http.post(url,
        body: json.encode({
          'booking_id': bookingId,
          'front_pic': preImgUrl[0],
          'left_pic': preImgUrl[1],
          'rear_pic': preImgUrl[2],
          'right_pic': preImgUrl[3],
          'dashboard_pic': preImgUrl[4],
          'number_pic': preImgUrl[5],
          'odometer_reading': preOdometer,
          'fuel_level': prerating,
        }),
        headers: <String, String>{'Authorization': basicAuth});
  }

  Future<void> addpostimages(
    String bookingId,
    List<String> postImgUrl,
    String postOdometer,
    double postrating,
  ) async {
    final url = 'http://api.protto.in/adddeliveryinspection.php';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    await http.post(url,
        body: json.encode({
          'booking_id': bookingId,
          'front_pic': postImgUrl[0],
          'left_pic': postImgUrl[1],
          'rear_pic': postImgUrl[2],
          'right_pic': postImgUrl[3],
          'dashboard_pic': postImgUrl[4],
          'number_pic': postImgUrl[5],
          'odometer_reading': postOdometer,
          'fuel_level': postrating,
        }),
        headers: <String, String>{'Authorization': basicAuth});
  }

  Future<String> paymentreceived(String bookingId) async {
    const url = 'http://api.protto.in/paymentreceived.php';
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'key');
    String value = await storage.read(key: 'value');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$value'));
    final response = await http.patch(url,
        body: json.encode({
          'booking_id': bookingId,
          'status': '8',
        }),
        headers: <String, String>{'Authorization': basicAuth});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['message'] == 'payment approved') {
      _currentPaid = _currentTotal;
      notifyListeners();
      return extractedData['message'];
    } else {
      return extractedData['message'];
    }
  }

  void logout() {
    _items.clear();
    _services = null;
    notifyListeners();
  }
}
