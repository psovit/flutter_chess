import 'package:chess/blocs/move_hanlder.dart';
import 'package:chess/models/chess_piece.dart';
import 'package:flutter/material.dart';

class BoardBloc {
  void setSelected(int index) {
    _selectedIndexNf.value = index;
    if (index != -1) {
      setAllowedMoves(index);
    } else {
      final List<int> allowedMoves = List.from(_allowMovesNf.value);
      allowedMoves.clear();
      _allowMovesNf.value = allowedMoves;
    }
  }

  void setAllowedMoves(int selectedItemIndex) {
    final Map<int, ChessPiece> updatedBoard = Map.from(_boardMapPiecesNf.value);

    if (!updatedBoard.containsKey(selectedItemIndex)) {
      return;
    }
    final ChessPiece piece = updatedBoard[selectedItemIndex]!;
    if (piece.color != _nextMoveNf.value) {
      return;
    }
    final List<int> allowedMoves = MoveHandler.getAllowedMoves(
      piece,
      updatedBoard,
    );
    _allowMovesNf.value = allowedMoves;
  }

  final ValueNotifier<List<int>> _allowMovesNf = ValueNotifier<List<int>>(
    <int>[],
  );

  final ValueNotifier<int> _selectedIndexNf = ValueNotifier<int>(-1);
  final ValueNotifier<PieceColor> _nextMoveNf = ValueNotifier<PieceColor>(
    PieceColor.white,
  );
  final ValueNotifier<Map<int, ChessPiece>> _boardMapPiecesNf =
      ValueNotifier<Map<int, ChessPiece>>({});

  ValueNotifier<Map<int, ChessPiece>> get boardMapPiecesNf => _boardMapPiecesNf;
  ValueNotifier<int> get selectedIndexNf => _selectedIndexNf;
  ValueNotifier<PieceColor> get nextMoveNf => _nextMoveNf;
  ValueNotifier<List<int>> get allowMovesNf => _allowMovesNf;

  void setBoardState(Map<int, ChessPiece> boardMap) {
    _boardMapPiecesNf.value = boardMap;
  }

  movePiece(int curIndex, int newIndex) {
    final Map<int, ChessPiece> updatedBoard = Map.from(_boardMapPiecesNf.value);
    if (!updatedBoard.containsKey(curIndex) ||
        !_allowMovesNf.value.contains(newIndex)) {
      return;
    }
    final ChessPiece piece = updatedBoard[curIndex]!;
    if (piece.color != _nextMoveNf.value) {
      return;
    }
    updatedBoard.removeWhere((key, value) => key == curIndex);
    updatedBoard.removeWhere((key, value) => key == newIndex);
    piece.setPosition(newIndex);
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
