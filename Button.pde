class Button {
  float x, y;
  float w, h;
  String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  boolean isMouseOver() {
    return mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2;
  }

  void setLabel(String label) {
    this.label = label;
  }

  void display() {
    stroke(50);
    fill(200);
    rectMode(CENTER);
    rect(x, y, w, h, 10); // Rounded corners with a radius of 10
    textAlign(CENTER, CENTER);
    fill(50);
    textSize(20);
    text(label, x, y + 3); // Slightly offset the text vertically for better centering
  }
    
  void mousePressed() {
    if (isMouseOver()) {
       //Play click sound
       if (clickSound != null) {
      clickSound.play();
    
  }
}
}
}
