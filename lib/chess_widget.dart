import 'package:chess_game/backend%20files/chess_data.dart';
import 'package:chess_game/backend%20files/model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chess extends StatefulWidget {
  const Chess({Key? key}) : super(key: key);

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  @override
  Widget build(BuildContext context) {
    ChessData chessData = Provider.of<ChessData>(context);
    Size size = MediaQuery.of(context).size;
    double widthOfPlace = size.width / 8;
    List<Widget> places = chessData.chess
        .map(
          (place) => GestureDetector(
            onTap: () => chessData.onTapPlace(place),
            child: Container(
              width: widthOfPlace,
              height: widthOfPlace,
              decoration: BoxDecoration(
                border:
                    Border.all(color: chessData.borderColor(place), width: 3.0),
                color: place.stateColor == StateColor.susKill
                    ? Colors.red[200]
                    : chessData.chessBoard[place.position],
              ),
              child: chessData.placeContent(place),
            ),
          ),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          height: size.width + 20,
          width: size.width,
          child: GridView.count(
            padding: const EdgeInsets.only(bottom: 10),
            crossAxisCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            // scrollDirection: Axis.horizontal,
            children: places,
          ),
        ),
      ),
    );
  }
}
