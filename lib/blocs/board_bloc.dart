import 'package:chess/models/chess_piece.dart';
import 'package:flutter/material.dart';

class BoardBloc {
  void setSelected(int index) {
    _selectedIndexNf.value = index;
  }

  final ValueNotifier<int> _selectedIndexNf = ValueNotifier<int>(-1);
  final ValueNotifier<PieceColor> _nextMoveNf = ValueNotifier<PieceColor>(
    PieceColor.white,
  );
  final ValueNotifier<Map<int, ChessPiece>> _boardMapPiecesNf =
      ValueNotifier<Map<int, ChessPiece>>({});

  ValueNotifier<Map<int, ChessPiece>> get boardMapPiecesNf => _boardMapPiecesNf;
  ValueNotifier<int> get selectedIndexNf => _selectedIndexNf;
  ValueNotifier<PieceColor> get nextMoveNf => _nextMoveNf;

  void setBoardState(Map<int, ChessPiece> boardMap) {
    _boardMapPiecesNf.value = boardMap;
  }

  movePiece(int curIndex, int newIndex) {
    final Map<int, ChessPiece> updatedBoard = Map.from(_boardMapPiecesNf.value);
    if (!updatedBoard.containsKey(curIndex)) {
      return;
    }
    final ChessPiece piece = updatedBoard[curIndex]!;
    if (piece.color != _nextMoveNf.value) {
      return;
    }
    updatedBoard.removeWhere((key, value) => key == curIndex);
    updatedBoard.putIfAbsent(newIndex, () => piece);
    setBoardState(updatedBoard);
    toggleNextMoveColor();
  }

  toggleNextMoveColor() {
    if (_nextMoveNf.value == PieceColor.black) {
      _nextMoveNf.value = PieceColor.white;
      return;
    }
    _nextMoveNf.value = PieceColor.black;
  }
}
