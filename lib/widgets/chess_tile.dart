import 'package:chess_flutter/blocs/board_bloc.dart';
import 'package:chess_flutter/constants.dart';
import 'package:chess_flutter/models/chess_piece.dart';
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
      valueListenable: boardBloc.allowMovesNf,
      builder: (
        _,
        List<int> allowedMoves,
        __,
      ) {
        return ValueListenableBuilder(
          valueListenable: boardBloc.selectedIndexNf,
          builder: (
            _,
            int curSelectedIndex,
            __,
          ) {
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
              child: _getChild(allowedMoves, curSelectedIndex),
            );
          },
        );
      },
    );
  }

  Widget _getChild(
    List<int> allowedMoves,
    int curSelectedIndex,
  ) {
    Color? boardColor = isLightSquare ? Colors.brown[300] : Colors.brown[700];
    if (curSelectedIndex == index) {
      boardColor = Colors.blueAccent;
    }

    if (allowedMoves.isNotEmpty && allowedMoves.contains(index)) {
      final ChessPiece? piece = boardBloc.getPieceInPosition(index);
      if (piece == null) {
        return Container(
          color: boardColor,
          height: chessSquareWidth,
          width: chessSquareWidth,
          child: Container(
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 2, maxWidth: 2),
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.greenAccent,
          height: chessSquareWidth,
          width: chessSquareWidth,
          child: child,
        );
      }
    }
    return Container(
      color: boardColor,
      height: chessSquareWidth,
      width: chessSquareWidth,
      child: child,
    );
  }
}
