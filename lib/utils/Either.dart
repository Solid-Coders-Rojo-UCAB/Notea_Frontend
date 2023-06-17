class Either<L, R> {
  final L? left;
  final R? right;

  Either({this.left, this.right});

  factory Either.left(L value) => Either(left: value);

  factory Either.right(R value) => Either(right: value);

  bool isLeft() => left != null;

  bool isRight() => right != null;

  R getOrElse(R Function() onLeft) {
    return isLeft() ? onLeft() : right!;
  }

  void when(
    void Function(L) onLeft,
    void Function(R) onRight,
  ) {
    if (isLeft()) {
      onLeft(left!);
    } else {
      onRight(right!);
    }
  }
}
