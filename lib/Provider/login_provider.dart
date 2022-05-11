import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/utils/firebase_auth_util.dart';
import 'package:phone_auth/utils/firebase_excauth_exception_utils.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider();

  final _firebaseAuthUtil = FirebaseAuthUtil();

  String _verificationId = '';

  bool _isOtpSending = false;
  bool get isOtpSending => _isOtpSending;
  set _setIsOtpSending(bool value) {
    if (value != _isOtpSending) {
      _isOtpSending = value;
      notifyListeners();
    }
  }

  bool _isOtpVerifying = false;
  bool get isOtpVerifying => _isOtpVerifying;
  set _setIsOtpVerifying(bool value) {
    if (value != _isOtpVerifying) {
      _isOtpVerifying = value;
      notifyListeners();
    }
  }

  void login(
      {@required String phoneNumber,
      @required GestureTapCallback onCodeSent,
      @required ValueChanged<String> onFailure}) async {
    try {
      _setIsOtpSending = true;
      await sendFirebaseOTP(
          phoneNumber: phoneNumber,
          onCodeSent: onCodeSent,
          onFailure: onFailure);
    } catch (error) {
      _setIsOtpSending = false;
      onFailure(error.toString());
    }
  }

  Future<void> sendFirebaseOTP(
      {@required String phoneNumber,
      @required GestureTapCallback onCodeSent,
      @required ValueChanged<String> onFailure}) async {
    _setIsOtpSending = true;
    _firebaseAuthUtil.login(
        mobileNumber: phoneNumber,
        onCodeSent: (value) {
          _verificationId = value;
          _setIsOtpSending = false;
          onCodeSent();
        },
        onVerificationFailed: (value) {
          _setIsOtpSending = false;
          onFailure(FirebaseAuthHandlExceptionsUtils().handleException(value));
        });
  }

  Future<void> verifyFirebaseOTP(
      {@required String verificationCode,
      @required ValueChanged<User> onOtpVerified,
      @required ValueChanged<String> onFailure}) async {
    _setIsOtpVerifying = true;
    try {
      await _firebaseAuthUtil.verifyOTPCode(
          verificationId: _verificationId,
          verificationCode: verificationCode,
          onVerificationSuccess: (value) {
            _verificationDone(
                phoneNumber: value.phoneNumber,
                onFailure: onFailure,
                onDeviceTokenUpdated: () {
                  onOtpVerified(value);
                });
          },
          onCodeVerificationFailed: (value) {
            _setIsOtpVerifying = false;
            onFailure(value);
          });
    } catch (error) {
      _setIsOtpVerifying = false;
      onFailure(error.toString());
    }
  }

  Future<void> _verificationDone(
      {@required String phoneNumber,
      @required ValueChanged<String> onFailure,
      @required GestureTapCallback onDeviceTokenUpdated}) async {
    try {
      _setIsOtpVerifying = false;
      onDeviceTokenUpdated();
    } catch (error) {
      await FirebaseAuth.instance.signOut();
      _setIsOtpVerifying = false;
      onFailure(error.toString());
    }
  }
}
