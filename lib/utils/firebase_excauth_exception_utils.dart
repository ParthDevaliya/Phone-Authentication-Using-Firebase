import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHandlExceptionsUtils {
  String handleException(FirebaseAuthException firebaseAuthException) {
    String message = '';
    print(firebaseAuthException.code);
    switch (firebaseAuthException.code) {
      case 'network-request-failed':
        message = 'Please check your internet connection !';
        break;
      case 'invalid-verification-code':
        message = 'Please enter a valid code';
        break;
      case 'too-many-requests':
        message =
            'Please try again after some time. You have used multiple verification requests!';
        break;
      default:
        message = firebaseAuthException.message;
    }
    return message;
  }
}
