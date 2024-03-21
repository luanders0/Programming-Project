class MainScreen {
  PImage HomeScreen;
  PImage Clouds;
  int areaX0 = 400;
  int areaY0 = 130;
  int areaWidth0 = 100;
  int areaHeight0 = 100;

  MainScreen(PImage HomeScreen, PImage Clouds) {
    this.HomeScreen = HomeScreen;
    this.Clouds = Clouds;
  }


  void mousePressed() {
    // Check if the mouse is pressed in the specific area to change screenState
    if (mouseX > areaX0 && mouseX < areaX0 + areaWidth0 && mouseY > areaY0 && mouseY < areaY0 + areaHeight0) {
      screenState = 1; // Change to clouds screen
    }
  }
}
