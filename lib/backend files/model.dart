import 'package:flutter/material.dart';

enum PieceType { none, king, queen, camel, horse, elephant, soldier }

enum Player { player1, player2, nullPlayer }

class ChessPiece {
  PieceType pieceType;
  Player player;
  ChessPiece(
    this.pieceType,
    this.player,
  );
  ChessPiece.copy(ChessPiece chessPiece)
      : this(chessPiece.pieceType, chessPiece.player);

  String get imagePath {
    if (player == Player.player1) {
      switch (pieceType) {
        case PieceType.none:
          return "";
        case PieceType.camel:
          return "assets/black_camel.svg";
        case PieceType.elephant:
          return "assets/black_elephant.svg";
        case PieceType.horse:
          return "assets/black_horse.svg";
        case PieceType.king:
          return "assets/black_king.svg";
        case PieceType.soldier:
          return "assets/black_pawn.svg";
        case PieceType.queen:
          return "assets/black_queen.svg";
        default:
      }
    } else if (player == Player.player2) {
      switch (pieceType) {
        case PieceType.none:
          return "";
        case PieceType.camel:
          return "assets/white_camel.svg";
        case PieceType.elephant:
          return "assets/white_elephant.svg";
        case PieceType.horse:
          return "assets/white_horse.svg";
        case PieceType.king:
          return "assets/white_king.svg";
        case PieceType.soldier:
          return "assets/white_pawn.svg";
        case PieceType.queen:
          return "assets/white_queen.svg";
        default:
      }
    }
    return "";
  }
  //
}

class StateColor {
  static const Color normal = Colors.green;
  static const Color possible = Colors.yellow;
  static const Color selected = Colors.blueAccent;
  static const Color susKill = Colors.redAccent;
}

//actual place in chess grid
class Place {
  final int position;
  ChessPiece chessPiece;
  Color stateColor;
  Place({
    required this.position,
    required this.chessPiece,
    required this.stateColor,
  });

  //return value instead reference
  Place.copy(Place place)
      : this(
          position: place.position,
          chessPiece: ChessPiece.copy(place.chessPiece),
          stateColor: place.stateColor,
        );
}

// class ChessGame {
//   List<Place> chess = [];
//   int selectedPos = -1;
//   Player currentlyPlaying = Player.Player1;
//   List<ChessPiece> killPieceOfPlayer1 = [];
//   List<ChessPiece> killPieceOfPlayer2 = [];
// }


// @override
//   String toString() {
//     String state;
//     switch (this.chessPiece.pieceType) {
//       case PieceType.elephant:
//         state = "elephant";
//         break;
//       case PieceType.horse:
//         state = "horse";
//         break;
//       case PieceType.camel:
//         state = "camel";
//         break;
//       case PieceType.king:
//         state = "king";
//         break;
//       case PieceType.queen:
//         state = "queen";
//         break;
//       case PieceType.soldier:
//         state = "soldier";
//         break;
//       default:
//         state = "empty";
//     }
//     if (this.position % 8 == 0) {
//       return "\n" + state;
//     }
//     return state;
//   }