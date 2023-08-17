// import 'package:chess_game/model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class ChessData extends ChangeNotifier {
//   late List<Place> chess;
//   late int selectedPos;
//   late Player currentlyPlaying;
//   late List<ChessPiece> killedPieceOfPlayer1;
//   late List<ChessPiece> killedPieceOfPlayer2;
//   late List<Color> chessBoard;

//   ChessData() {
//     this.selectedPos = -1;
//     this.currentlyPlaying = Player.NullPlayer;
//     this.killedPieceOfPlayer1 = [];
//     this.killedPieceOfPlayer2 = [];

//     chess = [];
//     List<PieceType> chessPieces = [
//       PieceType.elephant,
//       PieceType.horse,
//       PieceType.camel,
//       PieceType.queen,
//       PieceType.king,
//       PieceType.camel,
//       PieceType.horse,
//       PieceType.elephant,
//     ];
//     for (int i = 0; i <= 7; i++) {
//       this.chess.add(Place(
//           position: i,
//           chessPiece: ChessPiece(chessPieces[i], Player.Player1),
//           stateColor: StateColor.normal));
//     }
//     for (int i = 8; i <= 15; i++) {
//       this.chess.add(Place(
//             position: i,
//             chessPiece: ChessPiece(PieceType.soldier, Player.Player1),
//             stateColor: StateColor.normal,
//           ));
//     }
//     for (int i = 16; i <= 47; i++) {
//       this.chess.add(Place(
//             position: i,
//             chessPiece: ChessPiece(PieceType.none, Player.NullPlayer),
//             stateColor: StateColor.normal,
//           ));
//     }
//     for (int i = 48; i <= 55; i++) {
//       this.chess.add(Place(
//             position: i,
//             chessPiece: ChessPiece(PieceType.soldier, Player.Player2),
//             stateColor: StateColor.normal,
//           ));
//     }
//     for (int i = 56; i <= 63; i++) {
//       this.chess.add(Place(
//           position: i,
//           chessPiece: ChessPiece(chessPieces[i - 56], Player.Player2),
//           stateColor: StateColor.normal));
//     }
//     chessBoard = [];
//     Color greenAccent = Colors.greenAccent;
//     Color white = Colors.white;
//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         if ((i + j) % 2 == 0) {
//           chessBoard.add(greenAccent);
//         } else {
//           chessBoard.add(white);
//         }
//       }
//     }
//   }

//   ChessData.copy(ChessData chessData) {
//     this.chess = chessData.chess.map((e) => Place.copy(e)).toList();
//     this.selectedPos = chessData.selectedPos;
//     this.currentlyPlaying = chessData.currentlyPlaying;
//     this.killedPieceOfPlayer1 =
//         chessData.killedPieceOfPlayer1.map((e) => ChessPiece.copy(e)).toList();
//     this.killedPieceOfPlayer2 =
//         chessData.killedPieceOfPlayer2.map((e) => ChessPiece.copy(e)).toList();
//     this.chessBoard = [...chessData.chessBoard];
//   }

//   void update(ChessData chessData) {
//     for (int i = 0; i < chess.length; i++) {
//       chess[i] = Place.copy(chessData.chess[i]);
//     }
//     selectedPos = chessData.selectedPos;
//     currentlyPlaying = chessData.currentlyPlaying;

//     killedPieceOfPlayer1 = chessData.killedPieceOfPlayer1
//         .map((element) => ChessPiece.copy(element))
//         .toList();
//     killedPieceOfPlayer2 = chessData.killedPieceOfPlayer2
//         .map((element) => ChessPiece.copy(element))
//         .toList();
//     for (int i = 0; i < chessBoard.length; i++) {
//       chessBoard[i] = Color(chessData.chessBoard[i].value);
//     }
//     // this.chess = chessData.chess;
//     // this.chessBoard = chessData.chessBoard;
//     // this.selectedPos = chessData.selectedPos;
//     // this.currentlyPlaying = chessData.currentlyPlaying;
//     // this.killedPieceOfPlayer1 = chessData.killedPieceOfPlayer1;
//     // this.killedPieceOfPlayer2 = chessData.killedPieceOfPlayer2;
//     notifyListeners();
//   }

//   //clearing selection and making chess to its normal state;
//   void clear() {
//     selectedPos = -1;
//     chess.forEach((place) {
//       place.stateColor = StateColor.normal;
//     });
//   }

// //only this function make changes to currentlyPlaying field
//   void togglePlayer() {
//     if (currentlyPlaying == Player.Player1) {
//       currentlyPlaying = Player.Player2;
//     } else {
//       currentlyPlaying = Player.Player1;
//     }
//   }

// //add notify listeners
// //response to different colour state of chess places
//   void onTapPlace(Place place) {
//     print("onTapPlace function is called.");
//     if (place.stateColor == StateColor.normal) {
//       print("place is in normal state.");
//     }
//     if (place.stateColor == StateColor.possible) {
//       print("place is in possible state.");
//     }
//     if (place.stateColor == StateColor.selected) {
//       print("place is in selected state.");
//     }
//     if (place.stateColor == StateColor.susKill) {
//       print("place is in susKill state.");
//     }
//     if (place.stateColor == StateColor.normal) {
//       print("place is normal");
//       if (place.chessPiece.pieceType == PieceType.none) {
//         clear();
//       } else if (currentlyPlaying == Player.NullPlayer) {
//         currentlyPlaying = place.chessPiece.player;
//       }
//       if (place.chessPiece.player == currentlyPlaying) {
//         clear();

// //updating the selectingPos to new chessPiece of curringly playing player
//         selectedPos = place.position;
//         place.stateColor = StateColor.selected;
//         //highlighting position base on type of chess piece present
        // switch (place.chessPiece.pieceType) {
        //   case PieceType.soldier:
        //     soldier(place.position);
        //     break;
        //   case PieceType.elephant:
        //     elephant(place.position);
        //     break;
        //   case PieceType.horse:
        //     horse(place.position);
        //     break;
        //   case PieceType.camel:
        //     camel(place.position);
        //     break;
        //   case PieceType.queen:
        //     queen(place.position);
        //     break;
        //   case PieceType.king:
        //     king(place.position);
        //     break;
        //   default:
        // }
//       }
//     } else if (place.stateColor == StateColor.selected) {
//       clear();
//     } else if (place.stateColor == StateColor.possible) {
//       //placing piece to new position
//       place.chessPiece = chess[selectedPos].chessPiece;
//       chess[selectedPos].chessPiece =
//           ChessPiece(PieceType.none, Player.NullPlayer);
//       clear();
//       togglePlayer();
//     } else if (place.stateColor == StateColor.susKill) {
//       if (place.chessPiece.player == Player.Player1) {
//         killedPieceOfPlayer1.add(
//             ChessPiece(place.chessPiece.pieceType, place.chessPiece.player));
//       } else if (place.chessPiece.player == Player.Player2) {
//         killedPieceOfPlayer2.add(
//             ChessPiece(place.chessPiece.pieceType, place.chessPiece.player));
//       }
//       //placing piece to new position
//       place.chessPiece = chess[selectedPos].chessPiece;
//       chess[selectedPos].chessPiece =
//           ChessPiece(PieceType.none, Player.NullPlayer);
//       clear();
//       togglePlayer();
//     }
//     notifyListeners();
//   }

// //boolean return by this function state whether further possible position are highlightable or not
//   bool highlightingPosition(int pos, int i) {
//     if (chess[i].chessPiece.pieceType == PieceType.none) {
//       chess[i].stateColor = StateColor.possible;
//       return true;
//     } else if (chess[i].chessPiece.player != chess[pos].chessPiece.player) {
//       chess[i].stateColor = StateColor.susKill;
//       return false;
//     } else if (chess[i].chessPiece.player == chess[pos].chessPiece.player) {
//       return false;
//     }
//     return true;
//   }

//   void soldier(int pos) {
//     //player 1 soldier movement
//     if (chess[pos].chessPiece.player == Player.Player1) {
//       //forward movement
//       if ((pos ~/ 8 < 7) &&
//           chess[pos + 8].chessPiece.pieceType == PieceType.none) {
//         chess[pos + 8].stateColor = StateColor.possible;
//         if ((pos ~/ 8 == 1) &&
//             //second position if soldier is at initial possible position
//             chess[pos + 16].chessPiece.pieceType == PieceType.none) {
//           chess[pos + 16].stateColor = StateColor.possible;
//         }
//       }

//       bool isSoldierAtSide = false;
//       //cross movement
//       if (pos % 8 == 0 && pos != 56) {
//         //soldier at left side
//         if (chess[pos + 8 + 1].chessPiece.player == Player.Player2) {
//           chess[pos + 8 + 1].stateColor = StateColor.susKill;
//         }
//         isSoldierAtSide = true;
//       }
//       if (pos % 8 == 7 && pos != 63) {
//         //soldier at right side
//         if (chess[pos + 8 - 1].chessPiece.player == Player.Player2) {
//           chess[pos + 8 - 1].stateColor = StateColor.susKill;
//         }
//         isSoldierAtSide = true;
//       }

//       if (!isSoldierAtSide) {
//         if (pos ~/ 8 < 7) {
//           //movement of soldier not present at side
//           if (chess[pos + 8 + 1].chessPiece.player == Player.Player2) {
//             chess[pos + 8 + 1].stateColor = StateColor.susKill;
//           }
//           if (chess[pos + 8 - 1].chessPiece.player == Player.Player2) {
//             chess[pos + 8 - 1].stateColor = StateColor.susKill;
//           }
//         }
//       }
//     }
//     //player 2 soldier movement
//     //same but reverse logic for player 2 soldier

//     else if (chess[pos].chessPiece.player == Player.Player2) {
//       if ((pos ~/ 8 > 0) &&
//           chess[pos - 8].chessPiece.pieceType == PieceType.none) {
//         chess[pos - 8].stateColor = StateColor.possible;
//         if ((pos ~/ 8 == 6) &&
//             chess[pos - 16].chessPiece.pieceType == PieceType.none) {
//           chess[pos - 16].stateColor = StateColor.possible;
//         }
//       }

//       bool isSoldierAtSide = false;
//       if (pos % 8 == 0 && pos > 0) {
//         if (chess[pos - 8 + 1].chessPiece.player == Player.Player1) {
//           chess[pos - 8 + 1].stateColor = StateColor.susKill;
//           isSoldierAtSide = true;
//         }
//       }
//       if (pos % 8 == 7 && pos > 7) {
//         if (chess[pos - 8 - 1].chessPiece.player == Player.Player1) {
//           chess[pos - 8 - 1].stateColor = StateColor.susKill;
//           isSoldierAtSide = true;
//         }
//       }
//       if (!isSoldierAtSide) {
//         if (pos ~/ 8 > 0) {
//           if (chess[pos - 8 + 1].chessPiece.player == Player.Player1) {
//             chess[pos - 8 + 1].stateColor = StateColor.susKill;
//           }
//           if (chess[pos - 8 - 1].chessPiece.player == Player.Player1) {
//             chess[pos - 8 - 1].stateColor = StateColor.susKill;
//           }
//         }
//       }
//     }
//   }

//   void elephant(int pos) {
//     int start = pos - pos % 8;
//     int end = pos + (7 - pos % 8);
//     int bottom = pos % 8;
//     int top = (7 - pos ~/ 8) * 8 + pos;
//     for (int i = pos - 1; i >= start; i--) {
//       //from current position to left
//       if (!highlightingPosition(pos, i)) {
//         break;
//       }
//     }
//     for (int i = pos + 1; i <= end; i++) {
//       //from current position to right
//       if (!highlightingPosition(pos, i)) {
//         break;
//       }
//     }
//     for (int i = pos - 8; i >= bottom; i -= 8) {
//       //from current position to bottom
//       if (!highlightingPosition(pos, i)) {
//         break;
//       }
//     }
//     for (int i = pos + 8; i <= top; i += 8) {
//       //from current position to top
//       if (!highlightingPosition(pos, i)) {
//         break;
//       }
//     }
//   }

//   void horse(int pos) {
//     List<int> left = [pos + 6, pos - 10, pos + 15, pos - 17];
//     List<int> right = [pos - 6, pos + 10, pos - 15, pos + 17];
//     left = left.where((i) => (i >= 0 && i <= 63) && (i % 8 < pos % 8)).toList();
//     right =
//         right.where((i) => (i >= 0 && i <= 63) && (i % 8 > pos % 8)).toList();
//     left.forEach((i) {
//       highlightingPosition(pos, i);
//     });
//     right.forEach((i) {
//       highlightingPosition(pos, i);
//     });
//   }

//   void camel(int pos) {
//     int x = pos % 8;
//     int y = pos ~/ 8;
//     int topLeftFactor = (x < y) ? x : y;
//     int topRightFactor = ((7 - x) < y) ? (7 - x) : y;
//     int bottomLeftFactor = (x < (7 - y)) ? x : (7 - y);
//     int bottomRightFactor = ((7 - x) < (7 - y)) ? (7 - x) : (7 - y);
//     int currPos = pos;
//     // int topleft = pos - topLeftFactor * 9;
//     // int topright = pos - topRightFactor * 7;
//     // int bottomright = pos + bottomRightFactor * 9;
//     // int bottomleft = pos + bottomLeftFactor * 7;
//     // print("topright: $topright   topleft: $topleft   bottomright: $bottomright   bottomleft: $bottomleft");
//     for (int i = 1; i <= topLeftFactor; i++) {
//       //topleft
//       currPos = pos - 9 * i;
//       if (!highlightingPosition(pos, currPos)) {
//         break;
//       }
//     }
//     for (int i = 1; i <= topRightFactor; i++) {
//       currPos = pos - 7 * i;
//       if (!highlightingPosition(pos, currPos)) {
//         break;
//       }
//     }
//     for (int i = 1; i <= bottomRightFactor; i++) {
//       currPos = pos + 9 * i;
//       if (!highlightingPosition(pos, currPos)) {
//         break;
//       }
//     }
//     for (int i = 1; i <= bottomLeftFactor; i++) {
//       currPos = pos + 7 * i;
//       if (!highlightingPosition(pos, currPos)) {
//         break;
//       }
//     }
//   }

//   void queen(int pos) {
//     elephant(pos);
//     camel(pos);
//   }

//   void king(int pos) {
//     List<int> left = [pos - 1, pos - 8 - 1, pos + 8 - 1];
//     List<int> right = [pos + 1, pos - 8 + 1, pos + 8 + 1];
//     List<int> remain = [pos - 8, pos + 8];
//     left =
//         left.where((i) => ((i >= 0 && i <= 63) && (i % 8 < pos % 8))).toList();
//     right =
//         right.where((i) => ((i >= 0 && i <= 63) && (i % 8 > pos % 8))).toList();
//     remain = remain.where((i) => (i >= 0 && i <= 63)).toList();
//     left.forEach((i) {
//       highlightingPosition(pos, i);
//     });
//     right.forEach((i) {
//       highlightingPosition(pos, i);
//     });
//     remain.forEach((i) {
//       highlightingPosition(pos, i);
//     });
//   }

//   Color darken(Color color, [double amount = .1]) {
//     assert(amount >= 0 && amount <= 1);
//     final hsl = HSLColor.fromColor(color);
//     final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
//     return hslDark.toColor();
//   }

//   Color borderColor(Place place) {
//     if (place.stateColor == StateColor.selected) {
//       return Colors.green[900]!;
//     } else if (place.stateColor == StateColor.susKill) {
//       return Colors.red[200]!;
//     }
//     return chessBoard[place.position];
//   }

//   Widget placeContent(Place place) {
//     if (place.chessPiece.imagePath != "") {
//       return SvgPicture.asset(
//         place.chessPiece.imagePath,
//       );
//     } else if ((place.stateColor == StateColor.possible)) {
//       return SvgPicture.asset("assets/round_dot.svg");
//     }
//     return Container();
//   }

//   @override
//   String toString() {
//     return " currently selected: $selectedPos\n currently playing: $currentlyPlaying";
//   }
// }