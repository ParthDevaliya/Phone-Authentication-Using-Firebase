import 'package:flutter/material.dart';
import 'package:phone_auth/utils/firebase_auth_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Home Screen"),
      ),
      body: Container(
        child: Center(child: Text(" You Are Login Successfully. Your Phone Number Is ${FirebaseAuthUtil.phoneNumberWithPlusSymbol}",textAlign:TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)),
      ),
    );
  }
}
