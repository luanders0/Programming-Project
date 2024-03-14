class Bar_Plot {
  ArrayList bars;
  
  Bar_Plot (ArrayList bars) {
    this.bars = bars;
  }
  
  void draw() {
    for (int i = 0; i < bars.size(); i++) {
      Bar aBar = (Bar)bars.get(i);
      aBar.draw();
    }
  }
}
