import 'package:chess/chess.dart' as chess_pkg;
import 'package:chess_flutter/models/chess_piece.dart';

class ChessHelper {
  static String indexToAlgebraic(int index) {
    // The columns on a chessboard are labeled a through h
    const columns = 'abcdefgh';

    // Calculate the row and column for the index
    int row = 8 -
        (index ~/
            8); // Integer division gives the row, 8 at the top (0 index) to 1 at the bottom
    int column =
        index % 8; // Modulo division gives the column, 0 for 'a' to 7 for 'h'

    // Construct the algebraic notation
    return '${columns[column]}$row';
  }

  static int algebraicToIndex(String algebraic) {
    // The columns on a chessboard are labeled a through h
    const columns = 'abcdefgh';

    // Extract the column (letter) and row (number) from the algebraic notation
    String columnLetter = algebraic[0];
    int row = int.parse(algebraic[1]);

    // Calculate the index
    // Column (a=0, b=1, ..., h=7)
    int columnIndex = columns.indexOf(columnLetter);
    // Row (8=0, 7=1, ..., 1=7)
    int rowIndex = 8 - row;

    // Calculate the board index
    return rowIndex * 8 + columnIndex;
  }

  static Map<int, ChessPiece> getBoardState(chess_pkg.Chess game) {
    final Map<int, ChessPiece> boardMap = {};

    for (int i = 0; i < 64; i++) {
      String algebraicPosition = indexToAlgebraic(i);
      chess_pkg.Piece? piece = game.get(algebraicPosition);

      if (piece != null) {
        // Translate the chess.dart piece to your ChessPiece class
        ChessPiece myPiece = _translateChessPiece(piece, i);
        boardMap[i] = myPiece;
      }
    }

    return boardMap;
  }

  static ChessPiece _translateChessPiece(chess_pkg.Piece piece, int index) {
    // Map chess.dart piece type and color to your ChessPiece classes
    PieceColor color = piece.color == chess_pkg.Color.WHITE
        ? PieceColor.white
        : PieceColor.black;
    String name, svgPath;
    final String svgPref = color == PieceColor.black ? 'b' : 'w';

    switch (piece.type) {
      case chess_pkg.PieceType.KING:
        name = 'King';
        svgPath = 'assets/maestro_bw/${svgPref}K.svg';
        return King(
          name: name,
          svgPath: svgPath,
          color: color,
          positionIndex: index,
        );
      case chess_pkg.PieceType.QUEEN:
        name = 'Queen';
        svgPath = 'assets/maestro_bw/${svgPref}Q.svg';
        return Queen(
          name: name,
          svgPath: svgPath,
          color: color,
          positionIndex: index,
        );
      case chess_pkg.PieceType.ROOK:
        name = 'Rook';
        svgPath = 'assets/maestro_bw/${svgPref}R.svg';
        return Rook(
          name: name,
          svgPath: svgPath,
          color: color,
          positionIndex: index,
        );
      case chess_pkg.PieceType.BISHOP:
        name = 'Bishop';
        svgPath = 'assets/maestro_bw/${svgPref}B.svg';
        return Bishop(
          name: name,
          svgPath: svgPath,
          color: color,
          positionIndex: index,
        );
      case chess_pkg.PieceType.KNIGHT:
        name = 'Knight';
        svgPath = 'assets/maestro_bw/${svgPref}N.svg';
        return Knight(
          name: name,
          svgPath: svgPath,
          color: color,
          positionIndex: index,
        );
      case chess_pkg.PieceType.PAWN:
        name = 'Pawn';
        svgPath = 'assets/maestro_bw/${svgPref}P.svg';

        return Pawn(
          name: name,
          svgPath: svgPath,
          color: color,
          positionIndex: index,
        );
      default:
        throw Exception('Unknown piece type');
    }
  }
}
