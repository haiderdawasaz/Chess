import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chess/endgame.dart';

class PlayerInfo extends StatefulWidget {
  final ValueNotifier listenable;
  final int time;
  final String name, opponent;
  const PlayerInfo({super.key, required this.name, required this.time, required this.listenable, required this.opponent});
  @override
  State<PlayerInfo> createState() => PlayerInfoState();
}

class PlayerInfoState extends State<PlayerInfo> {
  Color timerColor = const Color.fromARGB(78, 73, 73, 73);
  Color timeColor = Colors.black;
  late Timer timer;
  late int timeRemaining;
  late ValueNotifier listener;
  @override
  void initState() {
    super.initState();
    listener = widget.listenable;
    timeRemaining = widget.time;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (listener.value) {
        setState(() {
          timerColor = const Color.fromARGB(255, 255, 255, 255);
          timeColor = Colors.black;
          timeRemaining--;
        });
      } else {
        setState(() {
          timerColor = const Color.fromARGB(78, 73, 73, 73);
          timeColor = Colors.white;
        });
      }
      if (timeRemaining <= 0) {
        endGame('Timeout', '${widget.opponent} wins by Time Out');
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String time = (timeRemaining / 60).floor().toString().padLeft(2, '0') + (':') + (timeRemaining % 60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 23.0),
        child: ValueListenableBuilder(
          valueListenable: listener,
          builder: (context, value, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name, style: const TextStyle(color: Colors.white)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  color: timerColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                  child: Text(time, style: TextStyle(color: timeColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel;
    listener.dispose();
    super.dispose();
  }

  void endGame(String title, String reason) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Endgame(title: title, reason: reason);
      },
    );
  }
}
