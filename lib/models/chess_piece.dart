enum PieceColor {
  black,
  white,
}

abstract class ChessPiece {
  int positionIndex;
  final String name;
  final String svgPath;
  final PieceColor color;

  ChessPiece({
    required this.positionIndex,
    required this.name,
    required this.svgPath,
    required this.color,
  });

  void setPosition(int newIndex) {
    positionIndex = newIndex;
  }
}

class Rook extends ChessPiece {
  Rook({
    required super.name,
    required super.svgPath,
    required super.color,
    required super.positionIndex,
  });
}

class Pawn extends ChessPiece {
  Pawn({
    required super.name,
    required super.svgPath,
    required super.color,
    required super.positionIndex,
  });
}

class Bishop extends ChessPiece {
  Bishop({
    required super.name,
    required super.svgPath,
    required super.color,
    required super.positionIndex,
  });
}

class King extends ChessPiece {
  King({
    required super.name,
    required super.svgPath,
    required super.color,
    required super.positionIndex,
  });
}

class Queen extends ChessPiece {
  Queen({
    required super.name,
    required super.svgPath,
    required super.color,
    required super.positionIndex,
  });
}

class Knight extends ChessPiece {
  Knight({
    required super.name,
    required super.svgPath,
    required super.color,
    required super.positionIndex,
  });
}
