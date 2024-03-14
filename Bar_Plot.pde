class Bar_Plot {
  ArrayList bars;
  
  Bar_Plot (ArrayList bars) {
    this.bars = bars;
  }
  
  void draw() {  // Lukas A added draw functionality for barplot 3/14/2024
    for (int i = 0; i < bars.size(); i++) {
      Bar aBar = (Bar)bars.get(i);
      aBar.draw();
    }
  }
}
