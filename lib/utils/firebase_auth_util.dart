import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthUtil {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static User get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<void> login(
      {@required
          String mobileNumber,
      @required
          ValueChanged<String> onCodeSent,
      @required
          ValueChanged<FirebaseAuthException> onVerificationFailed}) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {};

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      onVerificationFailed(authException);
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      onCodeSent(verificationId);
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+$mobileNumber',
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> verifyOTPCode(
      {@required String verificationId,
      @required String verificationCode,
      @required ValueChanged<User> onVerificationSuccess,
      @required ValueChanged<String> onCodeVerificationFailed}) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: verificationCode);
    await _firebaseAuth.signInWithCredential(credential).then((value) {
      if (value.user != null) {
        onVerificationSuccess(value.user);
      } else {
        onCodeVerificationFailed('Code VerificationFailed');
      }
    }).catchError((error) {
      onCodeVerificationFailed(error.toString());
    });
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static String get phoneNumberWithPlusSymbol {
    return FirebaseAuth.instance.currentUser.phoneNumber;
  }
}
