class MainScreen { // Avery H
  PImage HomeScreen;
  PImage Clouds;
  int areaX0 = 400;
  int areaY0 = 200;
  int areaWidth0 = 100;
  int areaHeight0 = 100;
  PFont font = createFont("AgencyFB-Bold-48.vlw", 18); 
  boolean[] isHovered1 = new boolean[3]; 
  boolean[] isHovered2 = new boolean[3]; 
  //String userInput = "";

  MainScreen(PImage HomeScreen, PImage Clouds) {
    this.HomeScreen = HomeScreen;
    this.Clouds = Clouds;
  }

  void mousePressed() {
    // Check for mouse click on the main screen
    if (mouseX > areaX0 && mouseX < areaX0 + areaWidth0 && mouseY > areaY0 && mouseY < areaY0 + areaHeight0) {
      screenState = 1;
      clickSound.play();
    }
   }

void airportTextDraw() {
  fill(255);
  textFont(font);
  text("Airport: " + userInput, 70, 25);
}

}
