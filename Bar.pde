class Bar { // Lukas A added rough outline for bar object 3/14/2024
  int category;
  int height;
  color barColor;
  int x; int y;
  
  Bar (int category, int height, color barColor, int plotBottomY, int x) {
    this.category = category;
    this.height = height;
    this.barColor = barColor;
    this.y = plotBottomY + height * 2;
    this.x = x;
  }
  
  void draw() {
    fill(barColor);
    rect(x, y, BAR_WIDTH, height);
  }
}
