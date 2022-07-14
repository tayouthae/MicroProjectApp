import 'package:flutter/material.dart';
import './screen/main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart'; 

import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

///Generate MD5 hash
generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xff6b6b6b), fontFamily: "Ubuntu"),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;
  bool checkBoxValue = false;
  bool loginBool = false;
  final _email = TextEditingController();
  final _passwordController = TextEditingController();
  // var _isLoading = false;
  // final GlobalKey<FormState> _formKey = GlobalKey();

  String textValue = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

   firebaseMessaging.configure(
     onLaunch: (Map<String, dynamic> msg) {
       print(" onLaunch called ${(msg)}");
     },
     onResume: (Map<String, dynamic> msg) {
       print(" onResume called ${(msg)}");
     },
     onMessage: (Map<String, dynamic> msg) {
       showNotification(msg);
       print(" onMessage called ${(msg)}");
     },
   );
   firebaseMessaging.requestNotificationPermissions(
       const IosNotificationSettings(sound: true, alert: true, badge: true));
   firebaseMessaging.onIosSettingsRegistered
       .listen((IosNotificationSettings setting) {
     print('IOS Setting Registed');
   });
   firebaseMessaging.getToken().then((token) {
     update(token);
   });
 }

 showNotification(Map<String, dynamic> msg) async {
   var android = new AndroidNotificationDetails(
     'sdffds dsffds',
     "CHANNLE NAME",
     "channelDescription",
   );
   var iOS = new IOSNotificationDetails();
   var platform = new NotificationDetails(android, iOS);
   await flutterLocalNotificationsPlugin.show(
       0, "New Assignment or Event", "Assignment or Event  Added", platform);
 }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${(token)}').set({"token": "Useless"});
    textValue = token;
    setState(() {});
  }

  Future<void> _submit(
      TextEditingController _email, TextEditingController _password) async {
    String email = _email.text;
    String password = _password.text;
    print(password);
    String hashedPassword = generateMd5(password);
    print(hashedPassword);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('Username/').set({"Email": "${(email)}"});
    databaseReference
        .child('Password/')
        .set({"Password": "${(hashedPassword)}"});
    databaseReference.child('Bool/').set({"BoolValue": "${(loginBool)}"});

    // Future check() async {
    DatabaseReference data = databaseReference.child('Bool/');

    await data.once().then((DataSnapshot snap) {
      var checkData = snap.value;
      var as = checkData['BoolValue'];
      print(as);
      if (as == "false") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(as)),
        );
      }
    });

    // }
    // if (!_formKey.currentState.validate()) {
    //   // Invalid!
    //   return;
    // }
    // _formKey.currentState.save();
    // setState(() {
    //   _isLoading = true;
    // });
  }

  hexColor<Color>(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        // appBar: new AppBar(
        //   title: new Text('Push Notification'),
        // ),
        resizeToAvoidBottomPadding: true,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(hexColor('#1f6ab4')),
                Color(hexColor('#7bc2e8'))
              ])),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(hexColor('#1f6ab4')),
                    Color(hexColor('#7bc2e8'))
                  ])),
              padding: EdgeInsets.only(
                  top: 20.0, right: 20.0, left: 20.0, bottom: 20.0),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // new Text(textValue),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/logo.png',
                          width: 150,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(300.0),
                          border: new Border.all(
                            width: 5.0,
                            color: Color(hexColor('#D2E1F0')),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  buildTextField("Email"),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildTextField("Password"),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Container(
                  //   child: Row(
                  //     children: <Widget>[
                  //       // Checkbox(
                  //       //   value: checkBoxValue,
                  //       //   onChanged: (bool value) {
                  //       //     setState(() {
                  //       //       checkBoxValue = value;
                  //       //     });
                  //       //   },
                  //       // ),
                  //       // Text(
                  //       //   "Remember username",
                  //       //   style: TextStyle(
                  //       //     color: Color(hexColor('#FFFFFF')),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 50.0),
                  buildButtonContainer(),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Container(
                  //   child: Center(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Text("Don't have an account?"),
                  //         SizedBox(
                  //           width: 10.0,
                  //         ),
                  //         Text("SIGN UP",
                  //             style: TextStyle(
                  //               color: Theme.of(context).primaryColor,
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      controller: hintText == "Email" ? _email : _passwordController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(hexColor('#3d3c3c')),
          fontSize: 16.0,
        ),
        fillColor: Color(hexColor('#D2E1F0')),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: hintText == "Email" ? Icon(Icons.email) : Icon(Icons.lock),
        suffixIcon: hintText == "Password"
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }

  Widget buildButtonContainer() {
    var color = hexColor('D2E1F0');
    return GestureDetector(
      onTap: () {
        _submit(_email, _passwordController);
        if (generateMd5(_passwordController.text) != "0e385a520de8f64ddcec5ee4e7d4aa55") {
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text("Invalid UserName or Password"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));

          // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid UserName or Password"),));
          return;
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MainScreen()),
        // );
      },
      child: Container(
        height: 56.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
          border: Border.all(color: Color(hexColor('FFFFFF')), width: 5),
          color: Color(color),
        ),
        child: Container(
          // highlightColor: Color(hexColor('1f6ab4')),
          // // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.45),
          // splashColor: Color(hexColor('1f6ab4')),
          child: Center(
            child: Text(
              "Log In",
              style: TextStyle(
                color: Color(hexColor('6b6b6b')),
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
