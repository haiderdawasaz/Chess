import 'package:flutter/material.dart';
import 'package:chess/player_info.dart';
import 'package:chess/chessboard.dart';

class Game extends StatefulWidget {
  final String player1, player2;
  final int time;
  const Game({super.key, required this.player1, required this.player2, required this.time});
  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  ValueNotifier<bool> player1notifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> player2notifier = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    player1notifier.value = true;
    player1notifier.value = false;
    player1notifier.value = false;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chess'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 36, 35, 39),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: PlayerInfo(name: widget.player2, time: widget.time, listenable: player2notifier, opponent: widget.player1)),
                Chessboard(
                  player1: widget.player1,
                  player2: widget.player2,
                  player1notifier: player1notifier,
                  player2notifier: player2notifier,
                ),
                Expanded(child: PlayerInfo(name: widget.player1, time: widget.time, listenable: player1notifier, opponent: widget.player2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }
}
