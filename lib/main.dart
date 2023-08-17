import 'package:chess_game/backend%20files/chess_data.dart';
import 'package:chess_game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ChessData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameScreen(),
      ),
    );
  }
}

