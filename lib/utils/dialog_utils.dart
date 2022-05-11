import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showCustomMessageDialog(
      BuildContext context, String message,
      {double fontSize, Color textColor}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
              )
            ],
          );
        });
  }

  static Future<void> showLoadingDialogWithMessage(
      BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            content: Container(height: 50, child: LoadingWidget()),
          );
        });
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
