import 'package:chess/constants.dart';
import 'package:chess/models/chess_piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final Map<int, ChessPiece> _initialPosition = <int, ChessPiece>{};

  @override
  void initState() {
    super.initState();
    _initBoardMap();
  }

  void _initPawns(PieceColor pawnColor) {
    final int startIndex = pawnColor == PieceColor.black ? 8 : 48;
    final int endIndex = startIndex + 8;
    for (int i = startIndex; i < endIndex; i++) {
      _initialPosition.putIfAbsent(
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
        _initialPosition.putIfAbsent(
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
        _initialPosition.putIfAbsent(
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
        _initialPosition.putIfAbsent(
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
        _initialPosition.putIfAbsent(
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
        _initialPosition.putIfAbsent(
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
    _initialPosition.clear();
    _initPawns(PieceColor.black);
    _initPawns(PieceColor.white);
    _initHeroes(PieceColor.black);
    _initHeroes(PieceColor.white);
  }

  @override
  Widget build(BuildContext context) {
    final GridView chessGrid = GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, index) {
        // Determine color of the square
        bool isLightSquare = (index ~/ 8 + index) % 2 == 0;
        return Container(
          color: isLightSquare ? Colors.brown[300] : Colors.brown[700],
          height: chessSquareWidth,
          width: chessSquareWidth,
          child: _getChessPiece(index),
        );
      },
      itemCount: 64,
    );
    return Container(
      padding: const EdgeInsets.all(50.0),
      child: chessGrid,
    );
  }

  Widget _getChessPiece(int index) {
    if (!_initialPosition.containsKey(index)) {
      return Container();
    }

    return SvgPicture.asset(_initialPosition[index]!.svgPath);
  }
}
