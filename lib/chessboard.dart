import 'package:chess/chess_pieces.dart';
import 'package:chess/endgame.dart';
import 'package:flutter/material.dart';
import 'package:chess/tile.dart';

class Chessboard extends StatefulWidget {
  final String player1, player2;
  final ValueNotifier player1notifier, player2notifier;
  const Chessboard({super.key, required this.player1, required this.player2, required this.player1notifier, required this.player2notifier});
  @override
  ChessboardState createState() => ChessboardState();
}

class ChessboardState extends State<Chessboard> {
  late ValueNotifier player1notifier, player2notifier;
  OverlayEntry? _overlayEntry;
  static String enpassant = '';
  List<String> pinnedPieces = List.empty(growable: true);
  List<String> pinningPieces = List.empty(growable: true);
  List<String> attackPreventionList = List.empty(growable: true);
  final BoxDecoration captureStyle = BoxDecoration(
    border: Border.all(
      color: const Color.fromARGB(220, 190, 190, 190),
      width: 3.0,
    ),
    borderRadius: BorderRadius.circular(23.0),
  );
  List<String> history = List.empty(growable: true);
  String firstSelection = '', secondSelection = '';
  int count = 0;
  Map<String, TileDetails> children = {};
  @override
  void initState() {
    super.initState();
    player1notifier = widget.player1notifier;
    player2notifier = widget.player2notifier;
    for (int i = 8; i >= 1; i--) {
      String ch = i.toString();
      for (int j = 0; j < 8; j++) {
        String key = String.fromCharCode(65 + j) + ch;
        children.putIfAbsent(key, () => TileDetails(key: key));
      }
    }
    setPieces();
    for (final key in children.keys) {
      children[key]!.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = List.empty(growable: true);
    for (int i = 8; i >= 1; i--) {
      String ch = i.toString();
      for (int j = 0; j < 8; j++) {
        String key = String.fromCharCode(65 + j) + ch;
        tiles.add(
          Tile(
            children,
            onPressed: () => setState(() {
              selectTile(key);
            }),
            str: key,
            child: children.putIfAbsent(key, () => TileDetails(key: key)).build(),
          ),
        );
      }
    }
    return GridView.count(
      crossAxisCount: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: tiles,
    );
  }

  void setPieces() {
    for (final key in children.keys) {
      Color color = (key[1] == '1' || key[1] == '2') ? Colors.white : Colors.black;
      if (key[1] == '2' || key[1] == '7') {
        children.putIfAbsent(key, () => TileDetails(key: key)).child = 'Pawn';
        children.putIfAbsent(key, () => TileDetails(key: key)).color = color;
      } else if (key[1] == '1' || key[1] == '8') {
        if (key[0] == 'A' || key[0] == 'H') {
          children.putIfAbsent(key, () => TileDetails(key: key)).child = 'Rook';
        } else if (key[0] == 'B' || key[0] == 'G') {
          children.putIfAbsent(key, () => TileDetails(key: key)).child = 'Night';
        } else if (key[0] == 'C' || key[0] == 'F') {
          children.putIfAbsent(key, () => TileDetails(key: key)).child = 'Bishop';
        } else if (key[0] == 'D') {
          children.putIfAbsent(key, () => TileDetails(key: key)).child = 'Queen';
        } else if (key[0] == 'E') {
          children.putIfAbsent(key, () => TileDetails(key: key)).child = 'King';
        }
        children.putIfAbsent(key, () => TileDetails(key: key)).color = color;
      }
    }
  }

  _showPopupMenu(BuildContext context, String key) {
    if (_overlayEntry == null) {
      final RenderBox button = context.findRenderObject() as RenderBox;
      final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
      final position = button.localToGlobal(Offset.zero, ancestor: overlay);
      int row = int.parse(key[1]);
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: position.dx,
          top: (row > 4) ? position.dy : position.dy + button.size.height,
          width: button.size.width,
          child: Transform(
            transform: (row > 4) ? Matrix4.rotationX(0) : Matrix4.rotationX(3.14159),
            child: Material(
              elevation: 8.0,
              child: Column(
                children: [
                  ListTile(
                    title: Queen(position: key, color: children[key]!.color).build(),
                    onTap: () => _selectOption(Queen(position: key, color: children[key]!.color), key),
                  ),
                  ListTile(
                    title: Rook(position: key, color: children[key]!.color).build(),
                    onTap: () => _selectOption(Rook(position: key, color: children[key]!.color), key),
                  ),
                  ListTile(
                    title: Bishop(position: key, color: children[key]!.color).build(),
                    onTap: () => _selectOption(Bishop(position: key, color: children[key]!.color), key),
                  ),
                  ListTile(
                    title: Knight(position: key, color: children[key]!.color).build(),
                    onTap: () => _selectOption(Knight(position: key, color: children[key]!.color), key),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _selectOption(Moves option, String key) {
    setState(() {
      children[key]!.piece = option;
      if (option.runtimeType.toString() == 'Knight') {
        children[key]!.child = 'Night';
      } else {
        children[key]!.child = option.runtimeType.toString();
      }
      children[key]!.color = option.color;
      postMoveProcessing(children[key]!);
    });
    _overlayEntry!.remove();
    _overlayEntry = null;
  }

  void selectTile(String key) {
    setState(() {
      TileDetails selectedTile = children[key]!;
      if ((history.length % 2 == 0 && selectedTile.color == Colors.white) || (history.length % 2 == 1 && selectedTile.color == Colors.black)) {
        showAvailableMoves(key, selectedTile);
      } else {
        if (selectedTile.child == 'available' || selectedTile.capture != const BoxDecoration()) {
          secondSelection = key;
          movePiece(firstSelection, secondSelection);
        } else {
          clearAvailableMoves();
        }
      }
    });
  }

  void clearAvailableMoves() {
    children.forEach((key, tile) {
      if (tile.child == 'available') {
        tile.child = '';
      }
      tile.capture = const BoxDecoration();
      firstSelection = secondSelection = '';
    });
  }

  List<String> getAvailableMoves(String key, TileDetails selectedTile) {
    List<String> availablemoves = List.empty(growable: true);
    if (attackPreventionList.isEmpty || selectedTile.child == 'King') {
      availablemoves = selectedTile.piece.availableMoves(children);
    } else {
      availablemoves = (attackPreventionList.toSet().intersection(selectedTile.piece.availableMoves(children).toSet())).toList();
    }
    if (pinnedPieces.contains(key)) {
      String kingPosition = children.keys.firstWhere((key) => children[key]!.child == 'King' && children[key]!.color == selectedTile.color);
      int columnShifter = (kingPosition.codeUnitAt(0) > key.codeUnitAt(0)) ? 1 : ((kingPosition.codeUnitAt(0) == key.codeUnitAt(0)) ? 0 : -1);
      int rowShifter = (kingPosition.codeUnitAt(1) > key.codeUnitAt(1)) ? 1 : ((kingPosition.codeUnitAt(1) == key.codeUnitAt(1)) ? 0 : -1);
      availablemoves.retainWhere((pos) {
        int cShifter = (kingPosition.codeUnitAt(0) > pos.codeUnitAt(0)) ? 1 : ((kingPosition.codeUnitAt(0) == pos.codeUnitAt(0)) ? 0 : -1);
        int rShifter = (kingPosition.codeUnitAt(1) > pos.codeUnitAt(1)) ? 1 : ((kingPosition.codeUnitAt(1) == pos.codeUnitAt(1)) ? 0 : -1);
        int rowDiff = (kingPosition.codeUnitAt(1) - pos.codeUnitAt(1)).abs();
        int columnDiff = (kingPosition.codeUnitAt(0) - pos.codeUnitAt(0)).abs();
        return cShifter == columnShifter && rShifter == rowShifter && (rowDiff == columnDiff || rowDiff == 0 || columnDiff == 0);
      });
    }
    return availablemoves;
  }

  void showAvailableMoves(String key, TileDetails selectedTile) {
    clearAvailableMoves();
    firstSelection = key;
    List<String> availablemoves = getAvailableMoves(key, selectedTile);
    for (int i = 0; i < availablemoves.length; i++) {
      String temp = availablemoves[i];
      TileDetails tile = children.putIfAbsent(temp, () => TileDetails(key: temp));
      if (tile.child != '') {
        tile.capture = captureStyle;
      } else {
        tile.child = 'available';
      }
    }
  }

  void movePiece(String firstSelection, String secondSelection) {
    TileDetails firstTile = children.putIfAbsent(firstSelection, () => TileDetails(key: firstSelection));
    TileDetails secondTile = children.putIfAbsent(secondSelection, () => TileDetails(key: secondSelection));
    secondTile.child = firstTile.child;
    secondTile.piece = firstTile.piece;
    secondTile.piece.position = secondSelection;
    secondTile.color = firstTile.color;
    firstTile.child = '';
    firstTile.color = Colors.transparent;
    if (secondTile.child == 'Pawn') {
      int checkRow = (secondTile.color == Colors.white) ? '8'.codeUnitAt(0) : '1'.codeUnitAt(0);
      if (secondSelection.codeUnitAt(1) == checkRow) _showPopupMenu(secondTile.context, secondTile.key);
    }
    playEnpassant(secondTile);
    playCastle(secondTile);
    history.add(secondTile.child.toString()[0] + secondSelection.toLowerCase());
    postMoveProcessing(secondTile);
  }

  void postMoveProcessing(TileDetails tile) {
    player1notifier.value = (tile.color == Colors.white) ? false : true;
    player2notifier.value = (tile.color == Colors.white) ? true : false;
    clearAvailableMoves();
    tile.piece.postMoveProcessing();
    Moves opponentKing = (children.values.firstWhere((e) => e.child == 'King' && e.color != tile.color)).piece;
    if (opponentKing is King) {
      attackPreventionList = opponentKing.getCommonMoves(children);
    }
    pinnedPieces = getPinnedPieces(opponentKing.color);
    bool stalemate = isStalemate(opponentKing.color);
    if (stalemate) {
      if (attackPreventionList.isNotEmpty) {
        String name = (tile.color == Colors.white) ? widget.player1 : widget.player2;
        endGame('Checkmate', 'Check Mate\n$name Wins!');
      } else {
        endGame('Stalemate', 'Draw by Stalemate');
      }
    }
  }

  void promotePawn(String key) {
    int checkRow = (children[key]!.color == Colors.white) ? '8'.codeUnitAt(0) : '1'.codeUnitAt(0);
    if (key.codeUnitAt(1) == checkRow) _showPopupMenu(children[key]!.context, children[key]!.key);
  }

  void playEnpassant(TileDetails secondTile) {
    if (enpassant != '') {
      if (firstSelection[1] == enpassant[1] && secondSelection[0] == enpassant[0] && ((secondSelection.codeUnitAt(1) - enpassant.codeUnitAt(1)).abs() == 1) && secondTile.child == 'Pawn') {
        children[enpassant]!.child = '';
        children[enpassant]!.color = Colors.transparent;
      }
      enpassant = '';
    }
  }

  void playCastle(TileDetails secondTile) {
    if (secondTile.child == 'King' && (secondSelection.codeUnitAt(0) - firstSelection.codeUnitAt(0)).abs() == 2) {
      if ((secondSelection.codeUnitAt(0) - firstSelection.codeUnitAt(0)) < 0) {
        children[('D') + secondSelection[1]]!.child = children[('A') + secondSelection[1]]!.child;
        children[('D') + secondSelection[1]]!.piece = children[('A') + secondSelection[1]]!.piece;
        children[('D') + secondSelection[1]]!.color = children[('A') + secondSelection[1]]!.color;
        children[('D') + secondSelection[1]]!.piece.position = ('D') + secondSelection[1];
        children[('A') + secondSelection[1]]!.child = '';
        children[('A') + secondSelection[1]]!.color = Colors.transparent;
      } else {
        children[('F') + secondSelection[1]]!.child = children[('H') + secondSelection[1]]!.child;
        children[('F') + secondSelection[1]]!.piece = children[('H') + secondSelection[1]]!.piece;
        children[('F') + secondSelection[1]]!.color = children[('H') + secondSelection[1]]!.color;
        children[('F') + secondSelection[1]]!.piece.position = ('F') + secondSelection[1];
        children[('H') + secondSelection[1]]!.child = '';
        children[('H') + secondSelection[1]]!.color = Colors.transparent;
      }
    }
  }

  List<String> getPinnedPieces(Color color) {
    List<String> pinnedPieces = List.empty(growable: true);
    String kingPosition = children.keys.firstWhere((key) => children[key]!.child == 'King' && children[key]!.color == color);
    List<String> pinningPieces = List.from(children.keys.where((k) =>
        [
          'Queen',
          'Bishop',
          'Rook'
        ].contains(children[k]!.child) &&
        children[k]!.color != color));
    pinningPieces.retainWhere((key) {
      int rowDiff = (kingPosition.codeUnitAt(1) - key.codeUnitAt(1)).abs();
      int columnDiff = (kingPosition.codeUnitAt(0) - key.codeUnitAt(0)).abs();
      if (rowDiff == columnDiff && (children[key]!.child == 'Queen' || children[key]!.child == 'Bishop')) {
        return true;
      } else if ((rowDiff == 0 || columnDiff == 0) && (children[key]!.child == 'Queen' || children[key]!.child == 'Rook')) {
        return true;
      } else {
        return false;
      }
    });
    for (String key in pinningPieces) {
      int columnShifter = (kingPosition.codeUnitAt(0) > key.codeUnitAt(0)) ? 1 : ((kingPosition.codeUnitAt(0) == key.codeUnitAt(0)) ? 0 : -1);
      int rowShifter = (kingPosition.codeUnitAt(1) > key.codeUnitAt(1)) ? 1 : ((kingPosition.codeUnitAt(1) == key.codeUnitAt(1)) ? 0 : -1);
      int i = 0;
      int columnCode = key.codeUnitAt(0) + columnShifter;
      int rowCode = key.codeUnitAt(1) + rowShifter;
      String pos = (String.fromCharCode(columnCode) + String.fromCharCode(rowCode));
      while (pos != kingPosition) {
        if (children[pos]!.child != '') {
          if (i == 1 || children[pos]!.color != color) break;
          pinnedPieces.add(pos);
          i++;
        }
        columnCode += columnShifter;
        rowCode += rowShifter;
        pos = (String.fromCharCode(columnCode) + String.fromCharCode(rowCode));
      }
    }
    return pinnedPieces;
  }

  bool isStalemate(Color color) {
    List<TileDetails> allPlayerPieces = children.values.where((el) => el.color == color).toList();
    for (TileDetails tile in allPlayerPieces) {
      if (getAvailableMoves(tile.key, tile).isNotEmpty) return false;
    }
    return true;
  }

  void endGame(String title, String reason) {
    player1notifier.value = false;
    player2notifier.value = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Endgame(title: title, reason: reason);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
