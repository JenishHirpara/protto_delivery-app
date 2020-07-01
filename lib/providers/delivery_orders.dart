import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final String deliveryType;

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
    @required this.deliveryType,
    @required this.customer,
    this.make,
    this.model,
    this.bikeNumber,
    this.bikeYear,
    this.status,
  });
}

class DeliveryOrders with ChangeNotifier {
  List<DeliveryOrderItem> _items = [];

  List<dynamic> _services;
  final String userId;

  DeliveryOrders(this.userId, this._items);

  List<DeliveryOrderItem> get items {
    return [..._items];
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
}
