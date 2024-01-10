import 'package:chess/blocs/board_bloc.dart';
import 'package:chess/constants.dart';
import 'package:flutter/material.dart';

class ChessTile extends StatefulWidget {
  final int index;
  final bool isLightSquare;
  final Widget? child;
  final BoardBloc boardBloc;

  const ChessTile({
    super.key,
    required this.isLightSquare,
    this.child,
    required this.index,
    required this.boardBloc,
  });

  @override
  State<ChessTile> createState() => _ChessTileState();
}

class _ChessTileState extends State<ChessTile> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.boardBloc.selectedIndexNf,
      builder: (
        _,
        int index,
        __,
      ) {
        Color? boardColor =
            widget.isLightSquare ? Colors.brown[300] : Colors.brown[700];
        if (index == widget.index) {
          boardColor = Colors.blueAccent;
        }
        return GestureDetector(
          onTap: () {
            if (index == widget.index) {
              widget.boardBloc.setSelected(-1);
              return;
            }
            widget.boardBloc.setSelected(widget.index);
          },
          child: Container(
            color: boardColor,
            height: chessSquareWidth,
            width: chessSquareWidth,
            child: widget.child,
          ),
        );
      },
    );
  }
}
