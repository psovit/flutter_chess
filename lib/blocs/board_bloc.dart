import 'package:chess_flutter/helpers/chess_helper.dart';
import 'package:chess_flutter/models/chess_piece.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess_pkg;

class BoardBloc {
  final chess_pkg.Chess _chessGame;

  BoardBloc({required chess_pkg.Chess chessGame}) : _chessGame = chessGame;
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

  ChessPiece? getPieceInPosition(int index) {
    if (_boardMapPiecesNf.value.containsKey(index)) {
      return _boardMapPiecesNf.value[index];
    }
    return null;
  }

  void setAllowedMoves(int selectedItemIndex) {
    final Map<int, ChessPiece> updatedBoard = Map.from(_boardMapPiecesNf.value);

    if (!updatedBoard.containsKey(selectedItemIndex)) {
      return;
    }

    var possibleMoves = getPossibleMovesForPiece(selectedItemIndex);

    final List<int> allowedMoves =
        possibleMoves.map((e) => ChessHelper.algebraicToIndex(e)).toList();

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

  void setBoardState() {
    final Map<int, ChessPiece> boardState =
        ChessHelper.getBoardState(_chessGame);
    _boardMapPiecesNf.value = boardState;
  }

  bool _boardMovePiece(int fromIndex, int toIndex) {
    // Convert board indices to algebraic positions
    String fromPosition = ChessHelper.indexToAlgebraic(fromIndex);
    String toPosition = ChessHelper.indexToAlgebraic(toIndex);

    return _chessGame.move({'from': fromPosition, 'to': toPosition});
  }

  List<String> getPossibleMovesForPiece(int pieceIndex) {
    // Convert the index to algebraic notation
    String piecePosition = ChessHelper.indexToAlgebraic(pieceIndex);

    // Generate all legal moves
    List<chess_pkg.Move> moves = _chessGame.generate_moves();

    // Filter moves for the selected piece
    List<String> possibleMoves = [];
    for (var move in moves) {
      if (move.fromAlgebraic == piecePosition) {
        possibleMoves.add(move.toAlgebraic);
      }
    }

    return possibleMoves;
  }

  void movePiece(int curIndex, int newIndex) {
    final bool moved = _boardMovePiece(curIndex, newIndex);
    if (!moved) {
      return;
    }

    setBoardState();
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
