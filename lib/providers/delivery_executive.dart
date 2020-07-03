import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class DeliveryExecutiveUser with ChangeNotifier {
  final String id;
  final String name;
  final String mobile;
  final String aadhar;
  final String username;
  final String password;
  final String ssCode;
  final String ssId;
  final String ssName;
  final String assignedBooking;
  final String status;

  DeliveryExecutiveUser({
    @required this.id,
    @required this.name,
    @required this.mobile,
    @required this.aadhar,
    @required this.username,
    @required this.password,
    @required this.ssCode,
    @required this.ssId,
    @required this.ssName,
    this.assignedBooking,
    this.status,
  });
}

class DeliveryExecutive with ChangeNotifier {
  DeliveryExecutiveUser _item;
  String _token;

  DeliveryExecutiveUser get item {
    return _item;
  }

  bool get isAuthDE {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> loginDeliveryExecutive(String name, String password) async {
    final url =
        'http://stage.protto.in/api/hitesh/deliveryex.php?de_name=$name&de_passcode=$password';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['message'] == 'User does not exists') {
      throw HttpException('Invalid Credentials');
    }
    _item = DeliveryExecutiveUser(
      id: extractedData['data']['de_id'],
      ssCode: extractedData['data']['ss_code'],
      name: extractedData['data']['de_name'],
      mobile: extractedData['data']['de_phone'],
      aadhar: extractedData['data']['de_id_proof'],
      username: extractedData['data']['de_name'],
      ssId: extractedData['data']['ss_id'],
      ssName: extractedData['data']['ss_name'],
      password: extractedData['data']['de_passcode'],
    );
    var rng = new Random();
    _token = '${rng.nextInt(90000000) + 10000000}';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final user = json.encode({
      'token': _token,
      'name': name,
      'password': password,
      'user': 'deliveryexecutive',
    });
    prefs.setString('serviceData', user);
  }

  Future<bool> tryAutoLoginDE() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('serviceData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('serviceData')) as Map<String, Object>;
    var url =
        'http://stage.protto.in/api/hitesh/deliveryex.php?de_name=${extractedUserData['name']}&de_passcode=${extractedUserData['password']}';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _item = DeliveryExecutiveUser(
      id: extractedData['data']['de_id'],
      ssCode: extractedData['data']['ss_code'],
      name: extractedData['data']['de_name'],
      mobile: extractedData['data']['de_phone'],
      aadhar: extractedData['data']['de_id_proof'],
      username: extractedData['data']['de_name'],
      ssId: extractedData['data']['ss_id'],
      ssName: extractedData['data']['ss_name'],
      password: extractedData['data']['de_passcode'],
    );
    _token = extractedUserData['token'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _item = null;
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
