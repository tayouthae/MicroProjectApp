// import 'package:provider/provider.dart';

import 'package:firebase_database/firebase_database.dart';

import '../main.dart';
import 'package:flutter/material.dart';

// import 'DBmain_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen(String as); //Widget.as ='false'
  static const Routename = 'mainscreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List testing = [];
  bool _loading = true;
  Future<void> _submit() async {
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    DatabaseReference data = databaseReference.child('-Lzg0XaCmdsVtsgXSewe/');

    data.once().then((DataSnapshot snap) {
      Map<dynamic, dynamic> checkData = snap.value;
      // var as = checkData['$i'];
      print(checkData);
      checkData.forEach((id, value) {
        // print("value is");
        // Map <dynamic,dynamic> test=value;
        try {
          var test = value as Map<dynamic, dynamic>;
          test.forEach((idtest, valuetest) {
            print(valuetest);
            testing.add(valuetest);
          });
        } catch (e) {}
        // print(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _submit().then((__) {
      setState(() {
        // print("object");
        _loading = false;
      });
    });
  }

  hexColor<Color>(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }

  @override
  Widget build(BuildContext context) {
    // final test=Provider.of<FetchingData>(context,listen:false);
    // test.fetchpaper();
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Color(hexColor('1982fa')),
          automaticallyImplyLeading: false,
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Welcome Tayouth,',
              )),
          centerTitle: true,
        ),
        body: (_loading)
            ? Center(child: CircularProgressIndicator())
            :Column(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      color: Color(hexColor('f2f2f2')),
                      margin: EdgeInsets.all(20),
                      child: Center(
                          child: ListView.builder(
                        itemBuilder: (context, i) => Text("${testing[i]}"),
                        itemCount: testing.length,
                      )),
                    ),
                  ),
                  Container(
                    color: Color(hexColor('2e2f30')),
                    width: double.infinity,
                    child: Card(
                      color: Color(hexColor('2e2f30')),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Image.asset('assets/collz.png'),
                            width: 120,
                            padding: EdgeInsets.only(
                                top: 5.0, right: 5.0, left: 8.0, bottom: 5.0),
                          ),
                          Spacer(),
                          FlatButton(
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  ))
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
