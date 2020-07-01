import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceStationUser with ChangeNotifier {
  final String id;
  final String ssCode;
  final String ssName;
  final String owner;
  final String ssAddress;
  final String panNo;
  final String panCard;
  final String password;
  final String cancelledChq;

  ServiceStationUser({
    @required this.id,
    @required this.ssCode,
    @required this.ssName,
    @required this.owner,
    @required this.ssAddress,
    @required this.panNo,
    @required this.panCard,
    @required this.password,
    @required this.cancelledChq,
  });
}

class DeliveryExecutiveUser with ChangeNotifier {
  final String id;
  final String name;
  final String userName;
  final String mobile;
  final String aadhar;
  final String password;
  final bool assigned;
  final String make;
  final String model;
  final String customer;
  final String status;

  DeliveryExecutiveUser({
    @required this.id,
    @required this.name,
    @required this.userName,
    @required this.mobile,
    @required this.aadhar,
    @required this.password,
    @required this.assigned,
    @required this.status,
    this.make,
    this.model,
    this.customer,
  });
}

class ServiceStation with ChangeNotifier {
  ServiceStationUser _item1;
  List<DeliveryExecutiveUser> _item2 = [];
  String _token;

  ServiceStationUser get item1 {
    return _item1;
  }

  List<DeliveryExecutiveUser> get item2 {
    return [..._item2];
  }

  bool get isAuthSS {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  DeliveryExecutiveUser findById(String id) {
    return _item2.firstWhere((prod) => prod.id == id);
  }

  Future<void> addExecutive(DeliveryExecutiveUser executive) async {
    final url = 'http://stage.protto.in/api/hitesh/adddeliveryex.php';
    await http.post(url,
        body: json.encode({
          'ss_code': item1.ssCode,
          'ss_id': item1.id,
          'name': executive.name,
          'de_name': executive.userName,
          'de_phone': executive.mobile,
          'de_id_proof': executive.aadhar,
          'de_passcode': executive.password,
        }));
    _item2.add(executive);
    notifyListeners();
  }

  Future<void> updateExecutive(
      String id, DeliveryExecutiveUser executive) async {
    final url = 'http://stage.protto.in/api/prina/editdeliveryex.php';
    await http.patch(url,
        body: json.encode({
          'de_id': id,
          'name': executive.name,
          'de_name': executive.userName,
          'de_phone': executive.mobile,
          'de_id_proof': executive.aadhar,
          'de_passcode': executive.password,
        }));
    final exIndex = _item2.indexWhere((ex) => ex.id == id);
    if (exIndex >= 0) {
      _item2[exIndex] = executive;
      notifyListeners();
    }
  }

  Future<void> getDeliveryExecutives() async {
    final url =
        'http://stage.protto.in/api/hitesh/getdeliveryexSS.php?ss_code=${item1.ssCode}';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['count'] != '0') {
      List<DeliveryExecutiveUser> data = [];
      for (int i = 0; i < int.parse(extractedData['count']); i++) {
        if (extractedData['data'][i]['message'] == 'assigned') {
          print(extractedData['data'][i]['make']);
          data.insert(
            i,
            DeliveryExecutiveUser(
              id: extractedData['data'][i]['de_id'],
              aadhar: extractedData['data'][i]['de_id_proof'],
              mobile: extractedData['data'][i]['de_phone'],
              userName: extractedData['data'][i]['de_name'],
              name: extractedData['data'][i]['name'],
              password: extractedData['data'][i]['de_passcode'],
              assigned: true,
              status: extractedData['data'][i]['status'],
              customer: extractedData['data'][i]['cust_name'],
              make: extractedData['data'][i]['make'],
              model: extractedData['data'][i]['model'],
            ),
          );
        } else {
          data.insert(
            i,
            DeliveryExecutiveUser(
              id: extractedData['data'][i]['de_id'],
              aadhar: extractedData['data'][i]['de_id_proof'],
              mobile: extractedData['data'][i]['de_phone'],
              userName: extractedData['data'][i]['de_name'],
              name: extractedData['data'][i]['name'],
              password: extractedData['data'][i]['de_passcode'],
              assigned: false,
              status: '9',
            ),
          );
        }
      }
      _item2 = data;
      notifyListeners();
    }
  }

  Future<void> loginServiceStation(
      String name, String code, String password) async {
    final url =
        'http://stage.protto.in/api/prina/servicestation.php?name=$name&code=$code&password=$password';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['message'] == 'User does not exist') {
      throw HttpException('Invalid service station code');
    }
    if (extractedData['message'] == 'Invalid Credentials') {
      throw HttpException('Invalid credentials');
    }
    _item1 = ServiceStationUser(
      id: extractedData['Data']['ss_id'],
      ssCode: extractedData['Data']['ss_code'],
      ssName: extractedData['Data']['ss_name'],
      owner: extractedData['Data']['ss_owner'],
      panNo: extractedData['Data']['ss_pan_num'],
      panCard: extractedData['Data']['ss_pan_card'],
      cancelledChq: extractedData['Data']['ss_canceled_chq'],
      password: extractedData['Data']['ss_passcode'],
      ssAddress: extractedData['Data']['ss_address'],
    );
    var rng = new Random();
    _token = '${rng.nextInt(90000000) + 10000000}';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final user = json.encode({
      'token': _token,
      'name': name,
      'code': code,
      'password': password,
      'user': 'servicestation',
    });
    prefs.setString('serviceData', user);
  }

  Future<bool> tryAutoLoginSS() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('serviceData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('serviceData')) as Map<String, Object>;
    var url =
        'http://stage.protto.in/api/prina/servicestation.php?name=${extractedUserData['name']}&code=${extractedUserData['code']}&password=${extractedUserData['password']}';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _item1 = ServiceStationUser(
      id: extractedData['Data']['ss_id'],
      ssCode: extractedData['Data']['ss_code'],
      ssName: extractedData['Data']['ss_name'],
      owner: extractedData['Data']['ss_owner'],
      panNo: extractedData['Data']['ss_pan_num'],
      panCard: extractedData['Data']['ss_pan_card'],
      cancelledChq: extractedData['Data']['ss_canceled_chq'],
      password: extractedData['Data']['ss_passcode'],
      ssAddress: extractedData['Data']['ss_address'],
    );
    _token = extractedUserData['token'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _item1 = null;
    _item2 = null;
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
