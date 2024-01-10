import 'package:chess/blocs/board_bloc.dart';
import 'package:chess/constants.dart';
import 'package:flutter/material.dart';

class ChessTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: boardBloc.selectedIndexNf,
      builder: (
        _,
        int curSelectedIndex,
        __,
      ) {
        Color? boardColor =
            isLightSquare ? Colors.brown[300] : Colors.brown[700];
        if (curSelectedIndex == index) {
          boardColor = Colors.blueAccent;
        }
        return GestureDetector(
          onTap: () {
            if (curSelectedIndex == index) {
              boardBloc.setSelected(-1);
              return;
            }
            boardBloc.setSelected(index);

            if (curSelectedIndex != -1) {
              boardBloc.movePiece(curSelectedIndex, index);
              boardBloc.setSelected(-1);
              return;
            }
          },
          child: Container(
            color: boardColor,
            height: chessSquareWidth,
            width: chessSquareWidth,
            child: child,
          ),
        );
      },
    );
  }
}
