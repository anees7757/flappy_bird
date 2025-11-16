class Pipe {
  double x;
  double gapY;
  double gapHeight;
  double width;
  bool passed;

  Pipe(
      this.x,
      this.gapY, {
        this.gapHeight = 150,
        this.width = 60,
        this.passed = false,
      });
}
