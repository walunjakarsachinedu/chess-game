import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  final List<Widget> list;
  const MyGridView(this.list, {Key? key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (list.length < 8) {
      return Column(
        children: [
          SizedBox(
            height: size.width / 8,
          ),
          SizedBox(
            height: size.width / 8,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: list.reversed.toList()),
          ),
        ],
      );
    }
    return Column(
      children: [
        SizedBox(
          height: size.width / 8,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: list.sublist(8).reversed.toList()),
        ),
        SizedBox(
          height: size.width / 8,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: list.sublist(0, 8).reversed.toList()),
        ),
      ],
    );
  }
}
