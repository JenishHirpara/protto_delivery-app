import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

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
  final String bikeNumber;
  final String flat;
  final String address;
  final String landmark;
  final String latitude;
  final String longitude;
  final String deliveryType;
  final String otp;
  final String deliveryOtp;

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
    @required this.otp,
    @required this.deliveryOtp,
    @required this.make,
    @required this.model,
    @required this.bikeNumber,
    @required this.bikeYear,
    @required this.status,
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
  final String userId;

  DeliveryOrders(this.userId, this._items);

  List<DeliveryOrderItem> get items {
    return [..._items];
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
    final url1 =
        'http://stage.protto.in/api/hitesh/fetchbookingsDE.php?de_id=$userId';
    final response1 = await http.get(url1);
    final extractedData1 = json.decode(response1.body) as Map<String, dynamic>;

    List<DeliveryOrderItem> data = [];
    if (extractedData1['count'] == '0') {
      return;
    }
    for (int i = 0; i < int.parse(extractedData1['count']); i++) {
      final bikeid = extractedData1['data'][i]['bike_id'];
      final url2 = 'http://stage.protto.in/api/shivangi/getbike.php/$bikeid';
      final response2 = await http.get(url2);
      final extractedData2 =
          json.decode(response2.body) as Map<String, dynamic>;
      data.insert(
        i,
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
    final url =
        'http://stage.protto.in/api/shivangi/getservicetype.php/$bookingId';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _services = extractedData['data'];
    notifyListeners();
  }

  Future<void> approveotp(String bookingId) async {
    final url =
        'http://stage.protto.in/api/hitesh/getotpapprove.php?booking_id=$bookingId';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['otp_approve'] == '0') {
      throw HttpException('Customer has not verified otp yet');
    }
  }

  Future<void> incrementstatus(
      String bookingId, String status, String message) async {
    final url = 'http://stage.protto.in/api/shivangi/bookingstatus.php';
    final response = await http.patch(url,
        body: json.encode({
          'booking_id': bookingId,
          'status': status,
        }));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['message'] == 'status not incremented') {
      throw HttpException(message);
    }
  }

  Future<String> fetchBooking(String bookingId) async {
    final url =
        'http://stage.protto.in/api/shivangi/fetchbooking.php?booking_id=$bookingId';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    return extractedData['data']['status'];
  }

  Future<void> getpreimages(String bookingId) async {
    final url =
        'http://stage.protto.in/api/shivangi/getpreserviceinspection.php?booking_id=$bookingId';
    final response = await http.get(url);
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
        'http://stage.protto.in/api/hitesh/getdeliveryinspection.php?booking_id=$bookingId';
    final response = await http.get(url);
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
    notifyListeners();
  }

  Future<void> addpreimages(
    String bookingId,
    List<String> preImgUrl,
    String preOdometer,
    double prerating,
  ) async {
    final url =
        'http://stage.protto.in/api/shivangi/addpreserviceinspection.php';
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
        }));
  }

  Future<void> addpostimages(
    String bookingId,
    List<String> postImgUrl,
    String postOdometer,
    double postrating,
  ) async {
    final url = 'http://stage.protto.in/api/prina/adddeliveryinspection.php';
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
        }));
  }

  void logout() {
    _items.clear();
    _services = null;
    notifyListeners();
  }
}
