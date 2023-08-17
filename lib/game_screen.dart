import 'package:chess_game/backend%20files/chess_data.dart';
import 'package:chess_game/backend%20files/model.dart';
import 'package:chess_game/mygrid.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import './chess_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<ChessData> history;
  late ChessData chessData;

  @override
  void initState() {
    super.initState();
    history = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chessData = Provider.of<ChessData>(context);
    if (history.isEmpty ||
        (history.last.currentlyPlaying != chessData.currentlyPlaying)) {
      history.add(ChessData.copy(chessData));
    }
  }

  @override
  void dispose() {
    print("dispose: game screen is disposed");
    super.dispose();
  }

  void reset(BuildContext context) {
    if (history.length > 1) {
      Provider.of<ChessData>(context, listen: false).update(history.first);
      ChessData first = history.first;
      history.clear();
      history.add(first);
    }
    print("reset: ${history.length}");
  }

  void undo(BuildContext context) {
    if (history.length == 2) {
      reset(context);
      return;
    }
    if (history.length > 2) {
      Provider.of<ChessData>(context, listen: false)
          .update(history[history.length - 1 - 1]);
      history.removeLast();
      history.removeLast();
    }

    print("undo: ${history.length}");
  }

  @override
  Widget build(BuildContext context) {
    chessData = Provider.of<ChessData>(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 0, 51, 1),
      body: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {
                undo(context);
              },
              child: SafeArea(
                child: Container(
                  height: size.width / 4,
                  color: const Color.fromRGBO(159, 75, 225, 1),
                  child: MyGridView(chessData.killedPieceOfPlayer1
                      .map((e) => SizedBox(
                          width: size.width / 8,
                          child: SvgPicture.asset(e.imagePath)))
                      .toList()),
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 60,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      reset(context);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                            width: 4.0,
                            color: chessData.currentlyPlaying == Player.player1
                                ? Colors.white
                                : Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //adding chess to game screen
            Center(
              child: SizedBox(
                height: size.width,
                width: size.width,
                child: const Chess(),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      reset(context);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                            width: 4.0,
                            color: chessData.currentlyPlaying == Player.player2
                                ? Colors.white
                                : Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onDoubleTap: () {
                undo(context);
              },
              child: SafeArea(
                child: Container(
                  height: size.width / 4, //(159, 75, 225, 1)
                  color: const Color.fromRGBO(159, 75, 225, 1),
                  child: GridView.extent(
                    maxCrossAxisExtent: size.width / 8,
                    dragStartBehavior: DragStartBehavior.down,
                    physics: const NeverScrollableScrollPhysics(),
                    children: chessData.killedPieceOfPlayer2
                        .map((e) => SvgPicture.asset(e.imagePath))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
