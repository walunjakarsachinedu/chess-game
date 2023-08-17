import 'package:chess_game/backend%20files/model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//this class represent internal state of chess game
class ChessData extends ChangeNotifier {
  late List<Place> chess;
  late int selectedPos;
  late Player currentlyPlaying;
  late List<ChessPiece> killedPieceOfPlayer1;
  late List<ChessPiece> killedPieceOfPlayer2;
  late List<Color> chessBoard;

  ChessData() {
    selectedPos = -1;
    currentlyPlaying = Player.nullPlayer;
    killedPieceOfPlayer1 = [];
    killedPieceOfPlayer2 = [];

    chess = [];
    List<PieceType> chessPieces = [
      PieceType.elephant,
      PieceType.horse,
      PieceType.camel,
      PieceType.queen,
      PieceType.king,
      PieceType.camel,
      PieceType.horse,
      PieceType.elephant,
    ];

    // this all for loop initialize chess with chess character
    for (int i = 0; i <= 7; i++) {
      chess.add(Place(
          position: i,
          chessPiece: ChessPiece(chessPieces[i], Player.player1),
          stateColor: StateColor.normal));
    }
    for (int i = 8; i <= 15; i++) {
      chess.add(Place(
            position: i,
            chessPiece: ChessPiece(PieceType.soldier, Player.player1),
            stateColor: StateColor.normal,
          ));
    }
    for (int i = 16; i <= 47; i++) {
      chess.add(Place(
            position: i,
            chessPiece: ChessPiece(PieceType.none, Player.nullPlayer),
            stateColor: StateColor.normal,
          ));
    }
    for (int i = 48; i <= 55; i++) {
      chess.add(Place(
            position: i,
            chessPiece: ChessPiece(PieceType.soldier, Player.player2),
            stateColor: StateColor.normal,
          ));
    }
    for (int i = 56; i <= 63; i++) {
      chess.add(Place(
          position: i,
          chessPiece: ChessPiece(chessPieces[i - 56], Player.player2),
          stateColor: StateColor.normal));
    }
    chessBoard = [];
    Color greenAccent = Colors.greenAccent;
    Color white = Colors.white;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 == 0) {
          chessBoard.add(greenAccent);
        } else {
          chessBoard.add(white);
        }
      }
    }
  }

  ChessData.copy(ChessData chessData) {
    //passing data by value not by reference
    chess = chessData.chess.map((e) => Place.copy(e)).toList();
    selectedPos = chessData.selectedPos;
    currentlyPlaying = chessData.currentlyPlaying;
    killedPieceOfPlayer1 =
        chessData.killedPieceOfPlayer1.map((e) => ChessPiece.copy(e)).toList();
    killedPieceOfPlayer2 =
        chessData.killedPieceOfPlayer2.map((e) => ChessPiece.copy(e)).toList();
    chessBoard = [...chessData.chessBoard];
  }

  void update(ChessData chessData) {
    for (int i = 0; i < chess.length; i++) {
      chess[i] = Place.copy(chessData.chess[i]);
    }
    selectedPos = chessData.selectedPos;
    currentlyPlaying = chessData.currentlyPlaying;

    killedPieceOfPlayer1 = chessData.killedPieceOfPlayer1
        .map((element) => ChessPiece.copy(element))
        .toList();
    killedPieceOfPlayer2 = chessData.killedPieceOfPlayer2
        .map((element) => ChessPiece.copy(element))
        .toList();
    for (int i = 0; i < chessBoard.length; i++) {
      chessBoard[i] = Color(chessData.chessBoard[i].value);
    }
    // this.chess = chessData.chess;
    // this.chessBoard = chessData.chessBoard;
    // this.selectedPos = chessData.selectedPos;
    // this.currentlyPlaying = chessData.currentlyPlaying;
    // this.killedPieceOfPlayer1 = chessData.killedPieceOfPlayer1;
    // this.killedPieceOfPlayer2 = chessData.killedPieceOfPlayer2;
    notifyListeners();
  }

  //clearing selection and making chess to its normal state;
  void clear() {
    selectedPos = -1;
    for (var place in chess) {
      place.stateColor = StateColor.normal;
    }
  }

//only this function make changes to currentlyPlaying field
  bool togglePlayer() {
    bool canBeToggle = false;
    Map<String, List<int>>? opponentPossiblePosition = {
      "possible": [],
      "sus_kill": []
    };
    for (int i = 0; i < 64; i++) {
      if ((chess[i].chessPiece.player != currentlyPlaying) &&
          (chess[i].chessPiece.pieceType != PieceType.none)) {
        opponentPossiblePosition = getPossibleAndKillPosition(chess[i]);

        if (opponentPossiblePosition["possible"]!.isNotEmpty ||
            opponentPossiblePosition["sus_kill"]!.isNotEmpty) {
          canBeToggle = true;
          break;
        }
      }
    }
    if (canBeToggle) {
      if (currentlyPlaying == Player.player1) {
        currentlyPlaying = Player.player2;
      } else {
        currentlyPlaying = Player.player1;
      }
      return true;
    } else {
      return false;
    }
  }

  Map<String, List<int>> getPossibleAndKillPosition(Place place) {
    switch (place.chessPiece.pieceType) {
      case PieceType.soldier:
        return soldier(place.position);
      case PieceType.elephant:
        return elephant(place.position);
      case PieceType.horse:
        return horse(place.position);
      case PieceType.camel:
        return camel(place.position);
      case PieceType.queen:
        return queen(place.position);
      case PieceType.king:
        return king(place.position);
      default:
    }
    return {"possible": [], "sus_kill": []};
  }

//add notify listeners
//response to different colour state of chess places
  void onTapPlace(Place place) {
    if (place.stateColor == StateColor.normal) {
      if (place.chessPiece.pieceType == PieceType.none) {
        clear();
      } else if (currentlyPlaying == Player.nullPlayer) {
        currentlyPlaying = place.chessPiece.player;
      }
      if (place.chessPiece.player == currentlyPlaying) {
        clear();

//updating the selectingPos to new chessPiece of curringly playing player
        selectedPos = place.position;
        place.stateColor = StateColor.selected;
        //highlighting position base on type of chess piece present
        highlightingPosition(getPossibleAndKillPosition(place));
      }
    } else if (place.stateColor == StateColor.selected) {
      clear();
    } else if (place.stateColor == StateColor.possible) {
      //placing piece to new position
      place.chessPiece = chess[selectedPos].chessPiece;
      chess[selectedPos].chessPiece =
          ChessPiece(PieceType.none, Player.nullPlayer);
      clear();
      togglePlayer();
    } else if (place.stateColor == StateColor.susKill) {
      if (place.chessPiece.player == Player.player1) {
        killedPieceOfPlayer1.add(
            ChessPiece(place.chessPiece.pieceType, place.chessPiece.player));
      } else if (place.chessPiece.player == Player.player2) {
        killedPieceOfPlayer2.add(
            ChessPiece(place.chessPiece.pieceType, place.chessPiece.player));
      }
      //placing piece to new position
      place.chessPiece = chess[selectedPos].chessPiece;
      chess[selectedPos].chessPiece =
          ChessPiece(PieceType.none, Player.nullPlayer);
      clear();
      togglePlayer();
    }
    notifyListeners();
  }

//update state of chess place if it is present in possible and sus_kill
  void highlightingPosition(Map<String, List<int>> range) {
    range["possible"]?.forEach((i) {
      chess[i].stateColor = StateColor.possible;
    });
    range["sus_kill"]?.forEach((i) {
      chess[i].stateColor = StateColor.susKill;
    });
  }

  Map<String, List<int>> soldier(int pos) {
    Map<String, List<int>> separatedList = {"possible": [], "sus_kill": []};
    //player 1 soldier movement
    if (chess[pos].chessPiece.player == Player.player1) {
      //forward movement
      if ((pos ~/ 8 < 7) &&
          chess[pos + 8].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(pos + 8);
        if ((pos ~/ 8 == 1) &&
            //second position, if soldier is at initial possible position
            chess[pos + 16].chessPiece.pieceType == PieceType.none) {
          separatedList["possible"]?.add(pos + 16);
        }
      }

      bool isSoldierAtSide = false;
      //cross movement
      if (pos % 8 == 0 && pos != 56) {
        //soldier at left side
        isSoldierAtSide = true;
        if (chess[pos + 8 + 1].chessPiece.player == Player.player2) {
          separatedList["sus_kill"]?.add(pos + 8 + 1);
        }
      }
      if (pos % 8 == 7 && pos != 63) {
        //soldier at right side
        isSoldierAtSide = true;
        if (chess[pos + 8 - 1].chessPiece.player == Player.player2) {
          separatedList["sus_kill"]?.add(pos + 8 - 1);
        }
      }

      if (!isSoldierAtSide) {
        //movement of soldier not present at side
        if (pos ~/ 8 < 7) {
          if (chess[pos + 8 + 1].chessPiece.player == Player.player2) {
            separatedList["sus_kill"]?.add(pos + 8 + 1);
          }
          if (chess[pos + 8 - 1].chessPiece.player == Player.player2) {
            separatedList["sus_kill"]?.add(pos + 8 - 1);
          }
        }
      }
    }

    //player 2 soldier movement
    //same but reverse logic for player 2 soldier
    else if (chess[pos].chessPiece.player == Player.player2) {
      if ((pos ~/ 8 > 0) &&
          chess[pos - 8].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(pos - 8);
        if ((pos ~/ 8 == 6) &&
            chess[pos - 16].chessPiece.pieceType == PieceType.none) {
          separatedList["possible"]?.add(pos - 16);
        }
      }

      bool isSoldierAtSide = false;
      //cross movement
      if (pos % 8 == 0 && pos > 0) {
        isSoldierAtSide = true;
        if (chess[pos - 8 + 1].chessPiece.player == Player.player1) {
          separatedList["sus_kill"]?.add(pos - 8 + 1);
        }
      }
      if (pos % 8 == 7 && pos > 7) {
        isSoldierAtSide = true;
        if (chess[pos - 8 - 1].chessPiece.player == Player.player1) {
          separatedList["sus_kill"]?.add(pos - 8 - 1);
        }
      }
      if (!isSoldierAtSide) {
        if (pos ~/ 8 > 0) {
          if (chess[pos - 8 + 1].chessPiece.player == Player.player1) {
            separatedList["sus_kill"]?.add(pos - 8 + 1);
          }
          if (chess[pos - 8 - 1].chessPiece.player == Player.player1) {
            separatedList["sus_kill"]?.add(pos - 8 - 1);
          }
        }
      }
    }
    return separatedList;
  }

  Map<String, List<int>> elephant(int pos) {
    Map<String, List<int>> separatedList = {"possible": [], "sus_kill": []};
    int start = pos - pos % 8; //left
    int end = pos + (7 - pos % 8); //right
    int bottom = pos % 8;
    int top = (7 - pos ~/ 8) * 8 + pos;
    for (int i = pos - 1; i >= start; i--) {
      //from current position to left
      if (chess[i].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(i);
      } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(i);
        break;
      } else if (chess[i].chessPiece.player == chess[pos].chessPiece.player) {
        break;
      }
    }
    for (int i = pos + 1; i <= end; i++) {
      //from current position to right
      if (chess[i].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(i);
      } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(i);
        break;
      } else if (chess[i].chessPiece.player == chess[pos].chessPiece.player) {
        break;
      }
    }
    for (int i = pos - 8; i >= bottom; i -= 8) {
      //from current position to bottom
      if (chess[i].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(i);
      } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(i);
        break;
      } else if (chess[i].chessPiece.player == chess[pos].chessPiece.player) {
        break;
      }
    }
    for (int i = pos + 8; i <= top; i += 8) {
      //from current position to top
      if (chess[i].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(i);
      } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(i);
        break;
      } else if (chess[i].chessPiece.player == chess[pos].chessPiece.player) {
        break;
      }
    }
    return separatedList;
  }

  Map<String, List<int>> horse(int pos) {
    Map<String, List<int>> separatedList = {"possible": [], "sus_kill": []};
    List<int> left = [pos + 6, pos - 10, pos + 15, pos - 17];
    List<int> right = [pos - 6, pos + 10, pos - 15, pos + 17];
    left = left.where((i) => (i >= 0 && i <= 63) && (i % 8 < pos % 8)).toList();
    right =
        right.where((i) => (i >= 0 && i <= 63) && (i % 8 > pos % 8)).toList();
    List<int> allPositions = left + right;
    for (var i in allPositions) {
      if ((chess[i].chessPiece.pieceType == PieceType.none)) {
        separatedList["possible"]?.add(i);
      } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(i);
      }
    }
    return separatedList;
  }

  Map<String, List<int>> king(int pos) {
    Map<String, List<int>> separatedList = {"possible": [], "sus_kill": []};
    List<int> left = [pos - 1, pos - 8 - 1, pos + 8 - 1];
    List<int> right = [pos + 1, pos - 8 + 1, pos + 8 + 1];
    List<int> remain = [pos - 8, pos + 8];
    //filtering invalid position for king form left and right list
    left =
        left.where((i) => ((i >= 0 && i <= 63) && (i % 8 < pos % 8))).toList();
    right =
        right.where((i) => ((i >= 0 && i <= 63) && (i % 8 > pos % 8))).toList();
    remain = remain.where((i) => (i >= 0 && i <= 63)).toList();

    List<int> allPositions = left + right + remain;

    for (var i in allPositions) {
      if ((chess[i].chessPiece.pieceType == PieceType.none)) {
        separatedList["possible"]?.add(i);
      } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(i);
      }
    }
    return separatedList;
  }

  Map<String, List<int>> camel(int pos) {
    Map<String, List<int>> separatedList = {"possible": [], "sus_kill": []};
    int x = pos % 8;
    int y = pos ~/ 8;
    int topLeftFactor = (x < y) ? x : y;
    int topRightFactor = ((7 - x) < y) ? (7 - x) : y;
    int bottomLeftFactor = (x < (7 - y)) ? x : (7 - y);
    int bottomRightFactor = ((7 - x) < (7 - y)) ? (7 - x) : (7 - y);
    int currPos = pos;
    for (int i = 1; i <= topLeftFactor; i++) {
      currPos = pos - 9 * i;
      if (chess[currPos].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(currPos);
      } else if (chess[currPos].chessPiece.player !=
          chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(currPos);
        break;
      } else if (chess[currPos].chessPiece.player ==
          chess[pos].chessPiece.player) {
        break;
      }
    }
    for (int i = 1; i <= topRightFactor; i++) {
      currPos = pos - 7 * i;
      if (chess[currPos].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(currPos);
      } else if (chess[currPos].chessPiece.player !=
          chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(currPos);
        break;
      } else if (chess[currPos].chessPiece.player ==
          chess[pos].chessPiece.player) {
        break;
      }
    }
    for (int i = 1; i <= bottomRightFactor; i++) {
      currPos = pos + 9 * i;
      if (chess[currPos].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(currPos);
      } else if (chess[currPos].chessPiece.player !=
          chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(currPos);
        break;
      } else if (chess[currPos].chessPiece.player ==
          chess[pos].chessPiece.player) {
        break;
      }
    }
    for (int i = 1; i <= bottomLeftFactor; i++) {
      currPos = pos + 7 * i;
      if (chess[currPos].chessPiece.pieceType == PieceType.none) {
        separatedList["possible"]?.add(currPos);
      } else if (chess[currPos].chessPiece.player !=
          chess[pos].chessPiece.player) {
        separatedList["sus_kill"]?.add(currPos);
        break;
      } else if (chess[currPos].chessPiece.player ==
          chess[pos].chessPiece.player) {
        break;
      }
    }
    return separatedList;
  }

  Map<String, List<int>> queen(int pos) {
    Map<String, List<int>> separatedList = {"possible": [], "sus_kill": []};
    separatedList.addAll(camel(pos));
    separatedList["possible"]?.addAll(elephant(pos)["possible"]!);
    separatedList["sus_kill"]?.addAll(elephant(pos)["sus_kill"]!);

    print("possible: ${separatedList['possible']}");
    print("sus_kill: ${separatedList['sus_kill']}");
    return separatedList;
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color borderColor(Place place) {
    if (place.stateColor == StateColor.selected) {
      return Colors.green[900]!;
    } else if (place.stateColor == StateColor.susKill) {
      return Colors.red[200]!;
    }
    return chessBoard[place.position];
  }

  Widget placeContent(Place place) {
    if (place.chessPiece.imagePath != "") {
      return SvgPicture.asset(
        place.chessPiece.imagePath,
      );
    } else if ((place.stateColor == StateColor.possible)) {
      return SvgPicture.asset("assets/round_dot.svg");
    }
    return Container();
  }

  @override
  String toString() {
    return " currently selected: $selectedPos\n currently playing: $currentlyPlaying";
  }
}
