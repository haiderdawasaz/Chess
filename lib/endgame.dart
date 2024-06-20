import 'package:flutter/material.dart';

class Endgame extends StatelessWidget {
  final String reason;
  final String title;
  final buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.green,
      shadowColor: const Color.fromARGB(255, 255, 255, 255));
  Endgame({super.key, required this.title, required this.reason});
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = (title == 'Stalemate') ? Colors.grey : Colors.green;
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      contentTextStyle: const TextStyle(fontSize: 23, color: Colors.black),
      content: SizedBox(
        height: 150,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text(
            reason,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          style: buttonStyle,
          child: const Text('Home', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
