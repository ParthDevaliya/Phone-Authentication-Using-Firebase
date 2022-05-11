import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phone_auth/Provider/login_provider.dart';
import 'package:phone_auth/utils/dialog_utils.dart';
import 'package:provider/provider.dart';
import 'home_scren.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;

  VerificationPage({@required this.phoneNumber});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String _verificationCode = '';
  Timer _codeResendTimer;
  int _codeResendTime = 0;
  set _setCodeResendTime(int time) {
    if (mounted) {
      setState(() {
        _codeResendTime = time;
      });
    }
  }

  @override
  void initState() {
    _initializeCodeResendTimer;
    super.initState();
  }



  void get _initializeCodeResendTimer {
    _codeResendTimer?.cancel();
    _codeResendTime = 60;
    _codeResendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_codeResendTime > 0) {
        _setCodeResendTime = --_codeResendTime;
      } else {
        timer?.cancel();
      }
    });
  }

  void _onVerifyPressed() {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (!loginProvider.isOtpSending && !loginProvider.isOtpVerifying) {
      if (_verificationCode.length < 6) {
        DialogUtils.showCustomMessageDialog(
            context, 'Please enter complete verification code');
      } else {
        DialogUtils.showLoadingDialogWithMessage(context, 'Verifying code');
        loginProvider.verifyFirebaseOTP(
            verificationCode: _verificationCode,
            onOtpVerified: (value) async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()));
            },
            onFailure: (value) {
              Navigator.pop(context);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding:  EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text("Enter Verifiaction Code",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              "Please Enter Your Verification Code below, the code sent to your phone number ${widget.phoneNumber}",
                              style: TextStyle(fontSize: 16))),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Consumer<LoginProvider>(
                          builder: (context, loginProvider, _) => TextField(
                              enabled: !(loginProvider.isOtpSending ||
                                  loginProvider.isOtpVerifying),
                              style: TextStyle(
                                fontSize: 32.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 17),
                                hintText: 'Enter Verification Code',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left:10, bottom: 10.0),
                              ),
                              onChanged: (verificationCode) {
                                if (verificationCode.length == 6) {
                                  _verificationCode = verificationCode;
                                  _onVerifyPressed();
                                }
                              }),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    height: 40,
                    highlightColor: Colors.transparent,
                    child: Consumer<LoginProvider>(
                      builder: (context, loginProvider, _) => InkWell(
                        child: Text(
                          _codeResendTime == 0
                              ? "Resend Code".toUpperCase()
                              : 'Resend Code In $_codeResendTime',
                          style: _codeResendTime == 0
                              ? TextStyle(
                              color: Colors.grey,
                                  fontWeight: FontWeight.w600)
                              : TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                        ),
                        onTap: loginProvider.isOtpSending ||
                                loginProvider.isOtpVerifying ||
                                _codeResendTime > 0
                            ? null
                            : () {
                                // DialogUtils.showLoadingDialogWithMessage(
                                //     context, 'Resending code');
                                loginProvider.sendFirebaseOTP(
                                    phoneNumber: widget.phoneNumber,
                                    onCodeSent: () {
                                      Navigator.pop(context);
                                      _initializeCodeResendTimer;
                                    },
                                    onFailure: (value) {
                                      Navigator.pop(context);
                                      // DialogUtils.showCustomMessageDialog(
                                      //     context, value);
                                    });
                              },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Consumer<LoginProvider>(
            builder: (context, loginProvider, _) => Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MaterialButton(
                height: kBottomNavigationBarHeight +
                    MediaQuery.of(context).padding.bottom,
                color: Colors.black,
                // disabledColor: kMainColor,
                minWidth: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Verify Code'.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                onPressed:
                    loginProvider.isOtpVerifying || loginProvider.isOtpSending
                        ? null
                        : _onVerifyPressed,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeResendTimer?.cancel();
    super.dispose();
  }
}
