import 'package:chess/chess_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:chess/tile.dart';
import 'package:chess/chessboard.dart';

abstract class Moves {
  String position;
  final Color color;
  Moves({required this.color, required this.position});
  Widget build();
  List<String> possibleMoves(Map<String, TileDetails> children);
  List<String> availableMoves(Map<String, TileDetails> children);
  void postMoveProcessing() {}
}

class Rook extends Moves {
  Rook({required super.color, required super.position});

  @override
  Widget build() {
    return Icon(
      ChessIcons.chessRook,
      color: color,
      size: 27,
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 255, 255, 255), blurRadius: 5.5),
        Shadow(color: Color.fromARGB(255, 0, 0, 0), blurRadius: 3),
      ],
    );
  }

  @override
  List<String> possibleMoves(Map<String, TileDetails> children) {
    List<String> possiblemoves = List.empty(growable: true);
    for (int i = 1; i <= 8; i++) {
      possiblemoves.add(position[0] + i.toString());
    }
    for (int i = 0; i < 8; i++) {
      possiblemoves.add(String.fromCharCode(65 + i) + position[1]);
    }
    possiblemoves.removeWhere((element) => element == position);
    return possiblemoves;
  }

  @override
  List<String> availableMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    for (int i = -1; i <= 1; i += 2) {
      int codeUnit = position[0].codeUnitAt(0);
      while (codeUnit + i >= 65 && codeUnit + i <= 72) {
        String key = String.fromCharCode(codeUnit + i) + position[1];
        TileDetails tile = children.putIfAbsent(key, () => TileDetails(key: key));
        if (tile.child != '') {
          if (tile.color != color) availablemoves.add(key);
          break;
        }
        availablemoves.add(key);
        codeUnit += i;
      }
    }
    for (int i = -1; i <= 1; i += 2) {
      int row = int.tryParse(position[1]) ?? 1;
      while (row + i >= 1 && row + i <= 8) {
        String key = position[0] + (row + i).toString();
        TileDetails tile = children.putIfAbsent(key, () => TileDetails(key: key));
        if (tile.child != '') {
          if (tile.color != color) availablemoves.add(key);
          break;
        }
        availablemoves.add(key);
        row += i;
      }
    }
    return availablemoves;
  }
}

class Knight extends Moves {
  Knight({required super.color, required super.position});

  @override
  Widget build() {
    return Icon(
      ChessIcons.chessKnight,
      color: color,
      size: 27,
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 255, 255, 255), blurRadius: 5.5),
        Shadow(color: Color.fromARGB(255, 0, 0, 0), blurRadius: 3),
      ],
    );
  }

  @override
  List<String> possibleMoves(Map<String, TileDetails> children) {
    List<String> possiblemoves = List.empty(growable: true);
    for (int i = -2; i <= 2; i += 4) {
      for (int j = -1; j <= 1; j += 2) {
        if ((position.codeUnitAt(0) + i) >= 65 && (position.codeUnitAt(0) + i) <= 72) {
          if ((int.parse(position[1]) + j) >= 1 && (int.parse(position[1]) + j) <= 8) {
            possiblemoves.add(String.fromCharCode(position.codeUnitAt(0) + i) + (int.parse(position[1]) + j).toString());
          }
        }
        if ((position.codeUnitAt(0) + j) >= 65 && (position.codeUnitAt(0) + j) <= 72) {
          if ((int.parse(position[1]) + i) >= 1 && (int.parse(position[1]) + i) <= 8) {
            possiblemoves.add(String.fromCharCode(position.codeUnitAt(0) + j) + (int.parse(position[1]) + i).toString());
          }
        }
      }
    }
    return possiblemoves;
  }

  @override
  List<String> availableMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    for (int i = -2; i <= 2; i += 4) {
      for (int j = -1; j <= 1; j += 2) {
        if ((position.codeUnitAt(0) + i) >= 65 && (position.codeUnitAt(0) + i) <= 72) {
          if ((int.parse(position[1]) + j) >= 1 && (int.parse(position[1]) + j) <= 8) {
            String key = String.fromCharCode(position.codeUnitAt(0) + i) + (int.parse(position[1]) + j).toString();
            TileDetails tile = children.putIfAbsent(key, () => TileDetails(key: key));
            if (tile.child == '' || (tile.child != '' && tile.color != color)) {
              availablemoves.add(key);
            }
          }
        }
        if ((position.codeUnitAt(0) + j) >= 65 && (position.codeUnitAt(0) + j) <= 72) {
          if ((int.parse(position[1]) + i) >= 1 && (int.parse(position[1]) + i) <= 8) {
            String key = String.fromCharCode(position.codeUnitAt(0) + j) + (int.parse(position[1]) + i).toString();
            TileDetails tile = children.putIfAbsent(key, () => TileDetails(key: key));
            if (tile.child == '' || (tile.child != '' && tile.color != color)) {
              availablemoves.add(key);
            }
          }
        }
      }
    }
    return availablemoves;
  }
}

class Bishop extends Moves {
  Bishop({required super.color, required super.position});

  @override
  Widget build() {
    return Icon(
      ChessIcons.chessBishop,
      color: color,
      size: 27,
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 255, 255, 255), blurRadius: 5.5),
        Shadow(color: Color.fromARGB(255, 0, 0, 0), blurRadius: 3),
      ],
    );
  }

  @override
  List<String> possibleMoves(Map<String, TileDetails> children) {
    List<String> possiblemoves = List.empty(growable: true);
    for (int i = -1; i <= 1; i += 2) {
      for (int j = -1; j <= 1; j += 2) {
        int row = int.tryParse(position[1]) ?? 1;
        String column = position[0];
        while (column.codeUnitAt(0) + i >= 65 && column.codeUnitAt(0) + i <= 72 && row + j >= 1 && row + j <= 8) {
          column = String.fromCharCode(column.codeUnitAt(0) + i);
          row = row + j;
          possiblemoves.add(column + row.toString());
        }
      }
    }
    return possiblemoves;
  }

  @override
  List<String> availableMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    for (int i = -1; i <= 1; i += 2) {
      for (int j = -1; j <= 1; j += 2) {
        int row = int.tryParse(position[1]) ?? 1;
        String column = position[0];
        while (column.codeUnitAt(0) + i >= 65 && column.codeUnitAt(0) + i <= 72 && row + j >= 1 && row + j <= 8) {
          column = String.fromCharCode(column.codeUnitAt(0) + i);
          row = row + j;
          String key = column + row.toString();
          TileDetails tile = children.putIfAbsent(key, () => TileDetails(key: key));
          if (tile.child != '') {
            if (tile.color != color) availablemoves.add(key);
            break;
          }
          availablemoves.add(key);
        }
      }
    }
    return availablemoves;
  }
}

class Queen extends Moves {
  Queen({required super.color, required super.position});

  @override
  Widget build() {
    return Icon(
      ChessIcons.chessQueen,
      color: color,
      size: 27,
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 255, 255, 255), blurRadius: 5.5),
        Shadow(color: Color.fromARGB(255, 0, 0, 0), blurRadius: 3),
      ],
    );
  }

  @override
  List<String> possibleMoves(Map<String, TileDetails> children) {
    List<String> possiblemoves = List.empty(growable: true);
    for (int i = 1; i <= 8; i++) {
      possiblemoves.add(position[0] + i.toString());
    }
    for (int i = 0; i < 8; i++) {
      possiblemoves.add(String.fromCharCode(65 + i) + position[1]);
    }
    possiblemoves.removeWhere((element) => element == position);
    for (int i = -1; i <= 1; i += 2) {
      for (int j = -1; j <= 1; j += 2) {
        int row = int.tryParse(position[1]) ?? 1;
        String column = position[0];
        while (column.codeUnitAt(0) + i >= 65 && column.codeUnitAt(0) + i <= 72 && row + j >= 1 && row + j <= 8) {
          column = String.fromCharCode(column.codeUnitAt(0) + i);
          row = row + j;
          possiblemoves.add(column + row.toString());
        }
      }
    }
    return possiblemoves;
  }

  @override
  List<String> availableMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    availablemoves.addAll(Rook(position: position, color: color).availableMoves(children));
    availablemoves.addAll(Bishop(position: position, color: color).availableMoves(children));
    return availablemoves;
  }
}

class King extends Moves {
  bool castleAvailable = true;
  King({required super.color, required super.position});

  @override
  Widget build() {
    return Icon(
      ChessIcons.chessKing,
      color: color,
      size: 27,
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 255, 255, 255), blurRadius: 5.5),
        Shadow(color: Color.fromARGB(255, 0, 0, 0), blurRadius: 3),
      ],
    );
  }

  @override
  List<String> possibleMoves(Map<String, TileDetails> children) {
    List<String> possiblemoves = List.empty(growable: true);
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (position.codeUnitAt(0) + i >= 65 && position.codeUnitAt(0) + i <= 72 && int.parse(position[1]) + j >= 1 && int.parse(position[1]) + j <= 8) {
          String key = String.fromCharCode(position.codeUnitAt(0) + i) + (int.parse(position[1]) + j).toString();
          possiblemoves.add(key);
        }
      }
    }
    possiblemoves.removeWhere((element) => element == position);
    return possiblemoves;
  }

  @override
  List<String> availableMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    List<String> possiblemoves = List.empty(growable: true);
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (position.codeUnitAt(0) + i >= 65 && position.codeUnitAt(0) + i <= 72 && int.parse(position[1]) + j >= 1 && int.parse(position[1]) + j <= 8) {
          String key = String.fromCharCode(position.codeUnitAt(0) + i) + (int.parse(position[1]) + j).toString();
          TileDetails tile = children.putIfAbsent(key, () => TileDetails(key: key));
          if (tile.child == '' || (tile.child != '' && tile.color != color)) {
            possiblemoves.add(key);
          }
        }
      }
    }
    TileDetails opponentKing = children.values.firstWhere((e) => e.child == 'King' && e.color != color);
    List<String> opponentKingMoves = opponentKing.piece.possibleMoves(children);
    possiblemoves.removeWhere((element) => element == position);
    for (int i = 0; i < possiblemoves.length; i++) {
      bool valid = true;
      valid = checkIfValid(children, possiblemoves[i]).isEmpty;
      if (opponentKingMoves.contains(possiblemoves[i])) valid = false;
      if (valid) availablemoves.add(possiblemoves[i]);
    }
    if (castleAvailable && checkIfValid(children, position).isEmpty) {
      if (children[('A') + position[1]]!.child == 'Rook') {
        bool valid = true;
        int column = position.codeUnitAt(0) - 1;
        while (column != 65) {
          if (children[String.fromCharCode(column) + position[1]]!.child != '' || checkIfValid(children, String.fromCharCode(column) + position[1]).isNotEmpty) {
            valid = false;
            break;
          }
          column--;
        }
        if (valid) availablemoves.add(('C') + position[1]);
      }
      if (children[('H') + position[1]]!.child == 'Rook') {
        bool valid = true;
        int column = position.codeUnitAt(0) + 1;
        while (column != 72) {
          if (children[String.fromCharCode(column) + position[1]]!.child != '' || checkIfValid(children, String.fromCharCode(column) + position[1]).isNotEmpty) {
            valid = false;
            break;
          }
          column++;
        }
        if (valid) availablemoves.add(('G') + position[1]);
      }
    }
    return availablemoves;
  }

  List<List<String>> checkIfValid(Map<String, TileDetails> children, String possiblemove) {
    List<List<String>> attackPreventionList = List.empty(growable: true);
    children.update(position, (value) {
      value.child = '';
      return value;
    });
    List<String> rookAttacks = Rook(position: possiblemove, color: color).availableMoves(children);
    for (int j = 0; j < rookAttacks.length; j++) {
      String tempPos = rookAttacks[j];
      if (children.putIfAbsent(tempPos, () => TileDetails(key: tempPos)).child == 'Rook' || children.putIfAbsent(tempPos, () => TileDetails(key: tempPos)).child == 'Queen') {
        attackPreventionList.add(getPossibleMoves(tempPos, possiblemove));
      }
    }
    List<String> bishopAttacks = Bishop(position: possiblemove, color: color).availableMoves(children);
    for (int j = 0; j < bishopAttacks.length; j++) {
      String tempPos = bishopAttacks[j];
      if (children.putIfAbsent(tempPos, () => TileDetails(key: tempPos)).child == 'Bishop' || children.putIfAbsent(tempPos, () => TileDetails(key: tempPos)).child == 'Queen') {
        attackPreventionList.add(getPossibleMoves(tempPos, possiblemove));
      }
    }
    children.update(position, (value) {
      value.child = 'King';
      return value;
    });
    List<String> knightAttacks = Knight(position: possiblemove, color: color).availableMoves(children);
    for (int j = 0; j < knightAttacks.length; j++) {
      String tempPos = knightAttacks[j];
      if (children.putIfAbsent(tempPos, () => TileDetails(key: tempPos)).child == 'Night') {
        attackPreventionList.add([
          tempPos
        ]);
      }
    }
    int temp = (color == Colors.white) ? 1 : -1;
    String leftkey = String.fromCharCode(possiblemove.codeUnitAt(0) - 1) + (int.parse(possiblemove[1]) + temp).toString();
    TileDetails leftChild = children.putIfAbsent(leftkey, () => TileDetails(key: leftkey));
    if (leftChild.child == 'Pawn' && leftChild.color != color) {
      attackPreventionList.add([
        leftkey
      ]);
    }
    String rightkey = String.fromCharCode(possiblemove.codeUnitAt(0) + 1) + (int.parse(possiblemove[1]) + temp).toString();
    TileDetails rightChild = children.putIfAbsent(rightkey, () => TileDetails(key: rightkey));
    if (rightChild.child == 'Pawn' && rightChild.color != color) {
      attackPreventionList.add([
        rightkey
      ]);
    }
    return attackPreventionList;
  }

  List<String> getCommonMoves(Map<String, TileDetails> children) {
    List<List<String>> attackPreventionList = checkIfValid(children, position);
    if (attackPreventionList.isEmpty) return List.empty();
    Set<String> commonMovesSet = attackPreventionList.first.toSet();
    for (int i = 0; i < attackPreventionList.length; i++) {
      commonMovesSet = commonMovesSet.intersection(attackPreventionList[i].toSet());
    }
    List<String> commonMovesList = commonMovesSet.toList();
    return commonMovesList;
  }

  List<String> getPossibleMoves(String attackerLocation, String possiblemove) {
    int columnShifter = (possiblemove.codeUnitAt(0) > attackerLocation.codeUnitAt(0)) ? 1 : ((possiblemove.codeUnitAt(0) == attackerLocation.codeUnitAt(0)) ? 0 : -1);
    int rowShifter = (possiblemove.codeUnitAt(1) > attackerLocation.codeUnitAt(1)) ? 1 : ((possiblemove.codeUnitAt(1) == attackerLocation.codeUnitAt(1)) ? 0 : -1);
    List<String> availablemoves = List.empty(growable: true);
    int columnCode = attackerLocation.codeUnitAt(0);
    int rowCode = attackerLocation.codeUnitAt(1);
    while ((String.fromCharCode(columnCode) + String.fromCharCode(rowCode)) != possiblemove) {
      availablemoves.add(String.fromCharCode(columnCode) + String.fromCharCode(rowCode));
      columnCode += columnShifter;
      rowCode += rowShifter;
    }
    return availablemoves;
  }

  @override
  void postMoveProcessing() {
    castleAvailable = false;
  }
}

class Pawn extends Moves {
  bool isFirstMove = true;
  Pawn({required super.color, required super.position});

  @override
  Widget build() {
    return Icon(
      ChessIcons.chessPawn,
      color: color,
      size: 27,
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 255, 255, 255), blurRadius: 5.5),
        Shadow(color: Color.fromARGB(255, 0, 0, 0), blurRadius: 3),
      ],
    );
  }

  @override
  List<String> possibleMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    int step = (color == Colors.white) ? 1 : -1;
    if ((position[1] == '2' && step == 1) || (position[1] == '7' && step == -1)) {
      for (int i = 1; i <= 2; i++) {
        availablemoves.add(position[0] + (int.parse(position[1]) + (i * step)).toString());
      }
    } else {
      availablemoves.add(position[0] + (int.parse(position[1]) + step).toString());
    }
    return availablemoves;
  }

  @override
  List<String> availableMoves(Map<String, TileDetails> children) {
    List<String> availablemoves = List.empty(growable: true);
    int step = (color == Colors.white) ? 1 : -1;
    if (isFirstMove) {
      for (int i = 1; i <= 2; i++) {
        String key = position[0] + (int.parse(position[1]) + (i * step)).toString();
        if (children.putIfAbsent(key, () => TileDetails(key: key)).child == '') {
          availablemoves.add(key);
        } else {
          break;
        }
      }
    } else {
      String key = position[0] + (int.parse(position[1]) + step).toString();
      if (children.putIfAbsent(key, () => TileDetails(key: key)).child == '') {
        availablemoves.add(key);
      }
    }
    int i = (color == Colors.white) ? 1 : -1;
    String leftkey = String.fromCharCode(position.codeUnitAt(0) - 1) + String.fromCharCode(position.codeUnitAt(1) + i);
    String rightkey = String.fromCharCode(position.codeUnitAt(0) + 1) + String.fromCharCode(position.codeUnitAt(1) + i);
    TileDetails leftChild = children.putIfAbsent(leftkey, () => TileDetails(key: leftkey));
    TileDetails rightChild = children.putIfAbsent(rightkey, () => TileDetails(key: rightkey));
    if (leftChild.child != '' && leftChild.color != color) availablemoves.add(leftkey);
    if (rightChild.child != '' && rightChild.color != color) availablemoves.add(rightkey);
    if (ChessboardState.enpassant != '') {
      int enpassantColumnDiff = ChessboardState.enpassant.codeUnitAt(0) - position.codeUnitAt(0);
      int enpassantRowDiff = ChessboardState.enpassant.codeUnitAt(1) - position.codeUnitAt(1);
      if (enpassantColumnDiff.abs() == 1 && enpassantRowDiff == 0) {
        availablemoves.add(ChessboardState.enpassant[0] + String.fromCharCode(position.codeUnitAt(1) + i));
      }
    }
    return availablemoves;
  }

  @override
  void postMoveProcessing() {
    if (isFirstMove) {
      if (position[1] == '4' || position[1] == '5') ChessboardState.enpassant = position;
    }
    isFirstMove = false;
  }
}
