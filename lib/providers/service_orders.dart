import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class ServiceOrderItem with ChangeNotifier {
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
  final String bikeNumber;
  final String flat;
  final String address;
  final String landmark;
  final String latitude;
  final String longitude;
  final String deliveryType;
  final String customer;
  final String deId;
  final String deName;
  final String specialRequest;

  ServiceOrderItem({
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
    @required this.make,
    @required this.model,
    @required this.bikeNumber,
    @required this.bikeYear,
    @required this.status,
    @required this.specialRequest,
    this.deId,
    this.deName,
  });
}

class RecommendedJobItem with ChangeNotifier {
  final String name;
  final String cost;

  RecommendedJobItem(this.name, this.cost);
}

class ServiceOrders with ChangeNotifier {
  List<ServiceOrderItem> _items = [];

  List<dynamic> _services;
  List<String> _partNames;
  List<RecommendedJobItem> _jobs;
  List<String> _preImages = [];
  List<String> _postImages = [];
  String _preOdometerReading;
  String _postOdometerReading;
  String _preFuelLevel;
  String _postFuelLevel;
  final String userId;

  ServiceOrders(this.userId, this._items);

  List<ServiceOrderItem> get items {
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

  List<RecommendedJobItem> get jobs {
    return [..._jobs];
  }

  List<dynamic> get services {
    return [..._services];
  }

  List<String> get partNames {
    return [..._partNames];
  }

  Future<void> fetchAndSetOrders() async {
    final url1 =
        'http://stage.protto.in/api/shivangi/fetchbookingsSS.php?ss_id=$userId';
    final response1 = await http.get(url1);
    final extractedData1 = json.decode(response1.body) as Map<String, dynamic>;

    List<ServiceOrderItem> data = [];
    if (extractedData1['count'] != '0') {
      for (int i = 0; i < int.parse(extractedData1['count']); i++) {
        final bikeid = extractedData1['data'][i]['bike_id'];
        final url2 = 'http://stage.protto.in/api/shivangi/getbike.php/$bikeid';
        final response2 = await http.get(url2);
        final extractedData2 =
            json.decode(response2.body) as Map<String, dynamic>;
        data.insert(
          i,
          ServiceOrderItem(
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
            specialRequest: extractedData1['data'][i]['special_request'],
            date: extractedData1['data'][i]['date'],
            time: extractedData1['data'][i]['timestamp'],
            bikeid: extractedData1['data'][i]['bike_id'],
            deId: extractedData1['data'][i]['de_id'],
            deName: extractedData1['data'][i]['de_name'],
            deliveryType: extractedData1['data'][i]['delivery_type'],
            customer: extractedData1['data'][i]['cust_name'],
            bikeNumber: extractedData2['data']['bike_reg'],
            bikeYear: extractedData2['data']['year'],
            make: extractedData2['data']['make'],
            model: extractedData2['data']['model'],
          ),
        );
      }
    }
    _items = data;
    notifyListeners();
  }

  Future<void> assignDeliveryExecutive(
      ServiceOrderItem order, String deName, String id) async {
    final url = 'http://stage.protto.in/api/shivangi/assigndeliveryex.php';
    await http.patch(url,
        body: json.encode({
          'id': order.id,
          'de_id': id,
          'de_name': deName,
        }));
    var item = _items.firstWhere((ord) => ord.id == order.id);
    var index = _items.indexWhere((ord) => ord.id == order.id);
    item = ServiceOrderItem(
      id: item.id,
      bookingId: item.bookingId,
      rideable: item.rideable,
      serviceType: item.serviceType,
      time: item.time,
      date: item.date,
      bikeid: item.bikeid,
      flat: item.flat,
      address: item.address,
      landmark: item.landmark,
      latitude: item.latitude,
      longitude: item.longitude,
      specialRequest: item.specialRequest,
      deliveryType: item.deliveryType,
      customer: item.customer,
      make: item.make,
      model: item.model,
      bikeNumber: item.bikeNumber,
      bikeYear: item.bikeYear,
      status: item.status,
      deId: id,
      deName: deName,
    );
    _items[index] = item;
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

  Future<void> getpartname() async {
    const url = 'http://stage.protto.in/api/hitesh/getpartname.php';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _partNames = List<String>.from(extractedData['parts']);
    notifyListeners();
  }

  Future<void> getjobs(String bookingId) async {
    final url =
        'http://stage.protto.in/api/shivangi/getjobs.php?booking_id=$bookingId';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    var data = [];
    if (extractedData['count'] != '0') {
      for (int i = 0; i < int.parse(extractedData['count']); i++) {
        data.add(
          RecommendedJobItem(
            extractedData['jobs'][i]['part_name'],
            extractedData['jobs'][i]['part_cost'],
          ),
        );
      }
    }
    _jobs = List<RecommendedJobItem>.from(data);
    notifyListeners();
  }

  Future<void> addjob(
      String bookingId, int count, List<dynamic> data, String status) async {
    final url = 'http://stage.protto.in/api/shivangi/bookingstatus.php';
    final response = await http.patch(url,
        body: json.encode({
          'booking_id': bookingId,
          'status': status,
        }));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['message'] == 'status not incremented') {
      throw HttpException('Jobs cannot be added right now');
    }
    const url1 = 'http://stage.protto.in/api/shivangi/addjob.php';
    await http.post(url1,
        body: json.encode({
          'booking_id': bookingId,
          'count': count,
          'data': data,
        }));
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

  void logout() {
    _items.clear();
    _services = null;
    _partNames = null;
    _jobs = null;
    notifyListeners();
  }
}
