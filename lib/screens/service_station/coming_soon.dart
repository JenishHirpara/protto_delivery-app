import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  static const routeName = '/coming-screen';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            ' ',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 24,
            ),
          ),
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          elevation: 0,
          leading: InkWell(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.15,
            ),
            Container(
              child: Image(
                image: AssetImage('assets/images/coming_soon.png'),
              ),
            ),
          ],
        ));
  }
}
