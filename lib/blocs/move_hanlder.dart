import 'package:chess/constants.dart';
import 'package:chess/models/chess_piece.dart';

class MoveHandler {
  static List<int> getAllowedMoves<T extends ChessPiece>(
    T piece,
    Map<int, ChessPiece> currentBoardState,
  ) {
    if (piece is Pawn) {
      return _getAllowedMovesPawn(piece, currentBoardState);
    } else if (piece is Knight) {
      return _getAllowedMovesKnight(piece, currentBoardState);
    }
    //todo: Add additional else if blocks for other piece types like Bishop, Rook, Queen, King

    return <int>[]; // Return an empty list if the piece type is not handled
  }

  static List<int> _getAllowedMovesKnight(
    Knight piece,
    Map<int, ChessPiece> currentBoardState,
  ) {
    final List<int> allowedMoves = <int>[];

    // All possible "L" shaped moves for a knight
    List<int> potentialMoves = [
      piece.positionIndex - 17,
      piece.positionIndex - 15,
      piece.positionIndex - 10,
      piece.positionIndex - 6,
      piece.positionIndex + 6,
      piece.positionIndex + 10,
      piece.positionIndex + 15,
      piece.positionIndex + 17,
    ];

    for (int move in potentialMoves) {
      // Check if the move is within the bounds of the board
      if (move >= 0 && move < totalSquares) {
        // Check for wrapping around the board
        int rowDifference = (move ~/ 8) - (piece.positionIndex ~/ 8);
        if (rowDifference.abs() <= 2) {
          // Check if the target square is not occupied by a piece of the same color
          if (!currentBoardState.containsKey(move) ||
              currentBoardState[move]!.color != piece.color) {
            allowedMoves.add(move);
          }
        }
      }
    }

    return allowedMoves;
  }

  static List<int> _getAllowedMovesPawn(
    Pawn piece,
    Map<int, ChessPiece> currentBoardState,
  ) {
    final List<int> allowedMoves = <int>[];

    // Define the forward movement direction based on the color of the pawn
    int forwardStep = piece.color == PieceColor.black ? 8 : -8;
    int startPosition = piece.color == PieceColor.black
        ? 8
        : 48; // Starting rows for black and white pawns

    // Standard Move: Check if the square in front is unoccupied
    int nextPosition = piece.positionIndex + forwardStep;
    if (nextPosition >= 0 && nextPosition < totalSquares) {
      if (!currentBoardState.containsKey(nextPosition)) {
        allowedMoves.add(nextPosition);

        // Initial Two-Square Move: Check if it's the pawn's first move
        int twoStepPosition = piece.positionIndex + 2 * forwardStep;
        if ((piece.positionIndex >= startPosition &&
                piece.positionIndex < startPosition + 8) &&
            !currentBoardState.containsKey(twoStepPosition)) {
          allowedMoves.add(twoStepPosition);
        }
      }
    }

    // Capture: Check if the pawn can capture diagonally
    List<int> diagonalPositions =
        piece.color == PieceColor.black ? [7, 9] : [-7, -9];
    for (int diagonalStep in diagonalPositions) {
      int diagonalPosition = piece.positionIndex + diagonalStep;
      if (diagonalPosition >= 0 &&
          diagonalPosition < totalSquares &&
          currentBoardState.containsKey(diagonalPosition) &&
          currentBoardState[diagonalPosition]!.color != piece.color) {
        allowedMoves.add(diagonalPosition);
      }
    }

    // todo: En Passant logic
    // todo: Re-incarnate pawn

    return allowedMoves;
  }
}
