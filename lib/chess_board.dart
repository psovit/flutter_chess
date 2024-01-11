import 'package:chess_flutter/blocs/board_bloc.dart';
import 'package:chess_flutter/models/chess_piece.dart';
import 'package:chess_flutter/widgets/chess_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chess/chess.dart' as chess_pkg;

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late BoardBloc _boardBloc;

  @override
  void initState() {
    super.initState();
    _boardBloc = BoardBloc(chessGame: chess_pkg.Chess());
    _boardBloc.setBoardState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess Board')),
      body: Column(
        children: [
          Row(
            children: [
              _chessBoard(),
              _gameInfo(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gameInfo() {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _boardBloc.nextMoveNf,
          builder: (
            _,
            PieceColor nextMove,
            __,
          ) {
            final String text = nextMove == PieceColor.white
                ? "Next Move: White"
                : "Next Move: Black";
            return Text(text);
          },
        ),
      ],
    );
  }

  Widget _chessBoard() {
    return ValueListenableBuilder(
      valueListenable: _boardBloc.boardMapPiecesNf,
      builder: (
        _,
        Map<int, ChessPiece> boardMapPieces,
        __,
      ) {
        final GridView chessGrid = GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (context, index) {
            // Determine color of the square
            late Widget child;
            if (!boardMapPieces.containsKey(index)) {
              child = Container();
            } else {
              child = SvgPicture.asset(boardMapPieces[index]!.svgPath);
            }

            bool isLightSquare = (index ~/ 8 + index) % 2 == 0;

            return ChessTile(
              boardBloc: _boardBloc,
              index: index,
              isLightSquare: isLightSquare,
              child: child,
            );
          },
          itemCount: 64,
        );
        return Container(
          height: 600,
          width: 600,
          padding: const EdgeInsets.all(24.0),
          child: chessGrid,
        );
      },
    );
  }
}
