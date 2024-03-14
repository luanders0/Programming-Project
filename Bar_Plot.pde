class Bar_Plot {
  ArrayList bars;
  
  Bar_Plot (ArrayList bars) {
    this.bars = bars;
  }
  
  void draw() {  // Lukas A
    for (int i = 0; i < bars.size(); i++) {
      Bar aBar = (Bar)bars.get(i);
      aBar.draw();
    }
  }
}
