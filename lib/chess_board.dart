import 'package:chess/blocs/board_bloc.dart';
import 'package:chess/models/chess_piece.dart';
import 'package:chess/widgets/chess_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({
    super.key,
    required this.boardBloc,
  });
  final BoardBloc boardBloc;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final Map<int, ChessPiece> _initialBoard = <int, ChessPiece>{};

  @override
  void initState() {
    super.initState();
    _initBoardMap();
    widget.boardBloc.setBoardState(_initialBoard);
  }

  void _initPawns(PieceColor pawnColor) {
    final int startIndex = pawnColor == PieceColor.black ? 8 : 48;
    final int endIndex = startIndex + 8;
    for (int i = startIndex; i < endIndex; i++) {
      _initialBoard.putIfAbsent(
        i,
        () => Pawn(
          positionIndex: i,
          name: 'Pawn',
          color: pawnColor,
          svgPath: pawnColor == PieceColor.black
              ? 'assets/maestro_bw/bP.svg'
              : 'assets/maestro_bw/wP.svg',
        ),
      );
    }
  }

  void _initHeroes(PieceColor color) {
    final int startIndex = color == PieceColor.black ? 0 : 56;
    final int endIndex = startIndex + 8;
    final String svgPref = color == PieceColor.black ? 'b' : 'w';

    for (int i = startIndex; i < endIndex; i++) {
      if (i == 0 || i == 7 || i == 56 || i == 63) {
        _initialBoard.putIfAbsent(
          i,
          () => Rook(
            positionIndex: i,
            name: 'Rook',
            color: color,
            svgPath: 'assets/maestro_bw/${svgPref}R.svg',
          ),
        );
      }

      if (i == 1 || i == 6 || i == 57 || i == 62) {
        _initialBoard.putIfAbsent(
          i,
          () => Knight(
            positionIndex: i,
            name: 'Knight',
            color: color,
            svgPath: 'assets/maestro_bw/${svgPref}N.svg',
          ),
        );
      }

      if (i == 2 || i == 5 || i == 58 || i == 61) {
        _initialBoard.putIfAbsent(
          i,
          () => Bishop(
            positionIndex: i,
            name: 'Bishop',
            color: color,
            svgPath: 'assets/maestro_bw/${svgPref}B.svg',
          ),
        );
      }

      if (i == 3 || i == 59) {
        _initialBoard.putIfAbsent(
          i,
          () => Queen(
            positionIndex: i,
            name: 'Queen',
            color: color,
            svgPath: 'assets/maestro_bw/${svgPref}Q.svg',
          ),
        );
      }

      if (i == 4 || i == 60) {
        _initialBoard.putIfAbsent(
          i,
          () => King(
            positionIndex: i,
            name: 'King',
            color: color,
            svgPath: 'assets/maestro_bw/${svgPref}K.svg',
          ),
        );
      }
    }
  }

  void _initBoardMap() {
    _initPawns(PieceColor.black);
    _initPawns(PieceColor.white);
    _initHeroes(PieceColor.black);
    _initHeroes(PieceColor.white);
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
          valueListenable: widget.boardBloc.nextMoveNf,
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
      valueListenable: widget.boardBloc.boardMapPiecesNf,
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
              boardBloc: widget.boardBloc,
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
