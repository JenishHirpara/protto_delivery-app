import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/http_exception.dart';

import '../delivery_executive/bookings_screen.dart';
import '../../providers/delivery_executive.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/delivery-executive-login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _name;
  var _password;
  var _isLoading = false;
  var _focus1 = FocusNode();
  var _focus2 = FocusNode();

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<DeliveryExecutive>(context, listen: false)
          .loginDeliveryExecutive(_name, _password);

      Navigator.of(context).pushReplacementNamed(BookingsScreen.routeName);
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Something went wrong!'),
            content: Text(error.message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: mediaQuery.size.height * 0.02),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Image.asset(
                'assets/images/protto-logo.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.04),
            Text(
              'Delivery Executive',
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 26,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.1),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _form,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    TextFormField(
                      focusNode: _focus1,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focus2);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Name'),
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    TextFormField(
                      focusNode: _focus2,
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a passcode';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                      decoration: InputDecoration(labelText: 'Passcode'),
                      obscureText: true,
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.15),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.deepOrange,
                        elevation: 0,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : const Text(
                                'SIGN IN',
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed: _saveForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
