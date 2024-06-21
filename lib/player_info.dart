import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chess/endgame.dart';

class PlayerInfo extends StatefulWidget {
  final ValueListenable<bool> listenable;
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
    // listener = widget.listenable;
    timeRemaining = widget.time;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.listenable.value) {
        setState(() {
          timeRemaining--;
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
    return ValueListenableBuilder<bool>(
      valueListenable: widget.listenable,
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(10),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 23.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name, style: const TextStyle(color: Colors.white)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  color: (widget.listenable.value) ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(78, 73, 73, 73),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                  child: Text(time, style: TextStyle(color: (widget.listenable.value) ? Colors.black: Colors.white)),
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
