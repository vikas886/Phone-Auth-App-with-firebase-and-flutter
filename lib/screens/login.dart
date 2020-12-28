import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/screens/otp.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //contoller to take phne number
  TextEditingController _controller = TextEditingController();

  //This will show Alert Dialog ,when user does not enter number and press sent btn
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Invalid Phone Number!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please Enter Valid Phone Number.'),
              Text('Thank You!.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              //pop the alert dialog box
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
        centerTitle: true,
        backgroundColor: Colors.orange[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 11,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(33),
              ),
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  labelText: 'Phone Number',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  labelStyle: TextStyle(color: Colors.orange[800]),
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+91'),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.orange[800]),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.orange[800]),
                    gapPadding: 10,
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.orange[800],
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              color: Colors.orange[800],
              onPressed: () {
                _controller.text != null && _controller.text.length == 10
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OTPScreen(_controller.text)))
                    : _showMyDialog();
              },
              child: Text(
                'Send Code',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          )
        ],
      ),
    );
  }
}
