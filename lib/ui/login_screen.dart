import 'package:flutter/material.dart';
import 'package:phone_auth/Provider/login_provider.dart';
import 'package:phone_auth/ui/verification_screen.dart';
import 'package:phone_auth/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 
  String _phoneNumber = '';
 

  @override
  void initState() {
    super.initState();
  }

 
  void _onloginPressed(LoginProvider loginProvider) {
    if (_phoneNumber.length < 10) {
      DialogUtils.showCustomMessageDialog(
          context, 'Please Enter valid phone number');
    } else {
      loginProvider.login(
          phoneNumber: "+91"+ _phoneNumber,
          onCodeSent: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider<LoginProvider>.value(
                  value: loginProvider,
                  child: VerificationPage(
                      phoneNumber:"+91" + _phoneNumber))));
          },
          onFailure: (error) {
            DialogUtils.showCustomMessageDialog(context, error);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
        },
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: ChangeNotifierProvider<LoginProvider>(
              create: (_) => LoginProvider(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: height / 2.5,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("Log In",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                              labelText: 'Enter Phone Number',
                              labelStyle: TextStyle(color:Colors.grey)
                            ),
                            onChanged: (val) {
                              _phoneNumber = val;
                            },
                          ),
                          SizedBox(height: 20.0),
                          Consumer<LoginProvider>(
                            builder: (context, loginProvider, _) =>
                                InkWell(
                                  child:
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                  color: Colors.black),
                                    child: Text("LOG IN",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),)),
                                  onTap: loginProvider.isOtpSending
                                      ? null
                                      : () {
                                    _onloginPressed(loginProvider);
                                  },
                                )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
