class MainScreen {
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
    if (mouseX > areaX0 && mouseX < areaX0 + areaWidth0 && mouseY > areaY0 && mouseY < areaY0 + areaHeight0 && screenState == 0) {
      screenState = 1; 
    }
    else if (mouseX > 350 && mouseX < 550 && mouseY > 110 && mouseY < 140 && screenState == 1) {
      screenState = 2; 
    }
    else if (mouseX > 350 && mouseX < 550 && mouseY > 160 && mouseY < 190 && screenState == 1) {
      screenState = 3; 
    }
    else if (mouseX > 350 && mouseX < 550 && mouseY > 210 && mouseY < 240 && screenState == 1) {
      screenState = 4; 
    }

    else if (mouseX > 350 && mouseX < 550 && mouseY > 410 && mouseY < 440 && screenState == 1) {
      screenState = 5; 
    }
    else if (mouseX > 350 && mouseX < 550 && mouseY > 460 && mouseY < 490 && screenState == 1) {
      screenState = 6; 
    }
    else if (mouseX > 350 && mouseX < 550 && mouseY > 510 && mouseY < 540 && screenState == 1) {
      screenState = 7; 
    }
    else if (mouseX > 10 && mouseX < 60 && mouseY > 10 && mouseY < 30 && screenState != 1) {
      screenState = 1; 
    }
    else if (mouseX > 10 && mouseX < 60 && mouseY > 10 && mouseY < 30 && screenState == 1) {
      screenState = 0; 
    }
  }
  
  void flightsScreen() {
  for (int i = 0; i < 3; i++) {
    fill(#F01B1B);
    int y = 110 + i * 50; 

    if (isHovered1[i]) {
      noStroke(); 
    } else {
      stroke(20); 
    }
    
    rect(350, y, 200, 30); 

    fill(0);
    textFont(font);
    if (i == 0 ) {
      text("2k flights", 400, y + 15); 
    }
    else if (i == 1) {
      text("10k flights", 400, y + 15); 
    }
    else {
      text("100k flights", 400, y + 15); 
    }
  }

  for (int i = 0; i < 3; i++) {
    isHovered1[i] = false;
  }
  
}
void mouseOver() {
  for (int i = 0; i < 3; i++) {
    int y = 110 + i * 50; 
    if (mouseX > 350 && mouseX < 350 + 200 && mouseY > y && mouseY < y + 30) {
      isHovered1[i] = true;
      break; 
    }
  }
}

  void flightsScreen2() {
  for (int i = 0; i < 3; i++) {
    fill(#F01B1B);
    int y = 410 + i * 50; 

    if (isHovered2[i]) {
      noStroke(); 
    } else {
      stroke(20); 
    }
    
    rect(350, y, 200, 30); 

    fill(0);
    textFont(font);
    if (i == 3 ) {
      text("2k flights", 400, y + 15); 
    }
    else if (i == 4 ) {
      text("10k flights", 400, y + 15); 
    }
    else {
      text("100k flights", 400, y + 15); 
    }
  }

  for (int i = 0; i < 3; i++) {
    isHovered2[i] = false;
  }
  
}
void mouseOver2() {
  for (int i = 0; i < 3; i++) {
    int y = 410 + i * 50; 
    if (mouseX > 350 && mouseX < 350 + 200 && mouseY > y && mouseY < y + 30) {
      isHovered2[i] = true;
      break; 
    }
  }
}

void backButton() {
   fill(0);
   rect(2, 10, 50, 20);
   textFont(font);
   fill(255);
   text("back", 30, 20);
}

void airportTextDraw() {
  fill(255);
  textFont(font);
  text("Airport: " + userInput, 70, 25);
}

}
