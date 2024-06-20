// ignore_for_file: file_names

import 'package:chess/chess_pieces.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Map<String, TileDetails> children;
  final Widget child;
  final String str;
  final VoidCallback onPressed;
  const Tile(this.children, {super.key, required this.child, required this.onPressed, required this.str});
  @override
  Widget build(BuildContext context) {
    final keyval = str;
    final int row = keyval.codeUnitAt(0);
    const Color black = Colors.black;
    const Color white = Color.fromARGB(255, 255, 255, 255);
    children[str]!.context = context;
    if (row % 2 == 1) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: (keyval.codeUnitAt(1) % 2 != 0) ? black : white),
        child: child,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: (keyval.codeUnitAt(1) % 2 == 0) ? black : white),
        child: child,
      );
    }
  }
}

class TileDetails {
  OverlayEntry? overlayEntry;
  late BuildContext context;
  String key;
  late Moves piece;
  Widget childWidget = const Text('');
  String child = '';
  Color color = Colors.transparent;
  BoxDecoration capture = const BoxDecoration();
  TileDetails({required this.key});

  void initState() {
    if (child == 'Pawn') {
      piece = Pawn(color: color, position: key);
    } else if (child == 'Rook') {
      piece = Rook(color: color, position: key);
    } else if (child == 'Night') {
      piece = Knight(color: color, position: key);
    } else if (child == 'Bishop') {
      piece = Bishop(color: color, position: key);
    } else if (child == 'Queen') {
      piece = Queen(color: color, position: key);
    } else if (child == 'King') {
      piece = King(color: color, position: key);
    }
  }

  Widget build() {
    if (child == 'available') {
      return const CircleAvatar(backgroundColor: Color.fromARGB(220, 190, 190, 190));
    } else if (child == '') {
      return const Text('');
    } else {
      childWidget = piece.build();
      return FractionallySizedBox(
        widthFactor: 1.5,
        heightFactor: 1.4,
        child: Container(
          height: 50.0,
          width: 50.0,
          alignment: Alignment.center,
          decoration: capture,
          child: Center(
            child: childWidget,
          ),
        ),
      );
    }
  }
}

/* class PawnPromotion extends StatefulWidget {
  const PawnPromotion({super.key});
  @override
  PawnPromotionState createState() => PawnPromotionState();
}

class PawnPromotionState extends State<PawnPromotion> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Queen',
          child: Icon(
            ChessIcons.chessQueen,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Rook',
          child: Icon(
            ChessIcons.chessRook,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Bishop',
          child: Icon(
            ChessIcons.chessBishop,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Night',
          child: Icon(
            ChessIcons.chessKnight,
          ),
        ),
      ],
    );
  }
} */
