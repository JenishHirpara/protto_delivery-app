import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './menu_screen.dart';
import '../../providers/service_station.dart';
import '../../models/http_exception.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/service-station-login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _name;
  var _code;
  var _password;
  var _isLoading = false;
  var _focus1 = FocusNode();
  var _focus2 = FocusNode();
  var _focus3 = FocusNode();

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
      await Provider.of<ServiceStation>(context, listen: false)
          .loginServiceStation(_name, _code, _password);

      Navigator.of(context).pushReplacementNamed(MenuScreen.routeName);
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              width: double.infinity,
              child: Image.asset(
                'assets/images/protto-logo.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.04),
            Text(
              'Service Station',
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 22,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.15),
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
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_focus2),
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    TextFormField(
                      focusNode: _focus2,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_focus3),
                      decoration:
                          InputDecoration(labelText: 'Service Station Code'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a ss_code';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _code = value;
                      },
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    TextFormField(
                      focusNode: _focus3,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _saveForm(),
                      decoration: InputDecoration(labelText: 'Passcode'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a passcode';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.1),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: RaisedButton(
                        onPressed: _saveForm,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : Text(
                                'SIGN IN',
                                style: TextStyle(color: Colors.white),
                              ),
                        elevation: 0,
                        color: Colors.deepOrange,
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
