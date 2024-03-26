import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
String userInput = "";

Table table;
int difference = 0;
int schDepHour = 0;
int schDepMinute = 0;
int depHour = 0;
int depMinute = 0;
int[] flightStatus = {0, 0, 0, 0}; // Index 0: early, Index 1: on time, Index 2: late, Index 3: Cancelled
int earlyFlightCount = 0;
int onTimeFlightCount = 0;
int lateFlightCount = 0;
int cancelledFlightCount = 0;
int totalFlightCount = -1;

Button button;
PImage HomeScreen;
PImage Clouds;
int screenState;
MainScreen mainScreen;

void setup() {
  size(600, 600);
  
    //zf
  //dateList = new ArrayList<String>();
  //dayList = new ArrayList<Integer>();
  //monthList = new ArrayList<Integer>();
  //yearList = new ArrayList<Integer>();
  //dayCounts = new int[7];
  //date = new Dates(dateList, dayList, monthList, yearList, lines, dayCounts);
  //zf
  
  table = loadTable("flights2k.csv", "header");
  println(table.getRowCount() + " total rows in table");
  
  button = new Button(width/2, height/2, 200, 60, "Lateness Chart");
  
  HomeScreen = loadImage("SquareMainScreen.jpg");
  Clouds = loadImage("ChartScreen.jpg");

  mainScreen = new MainScreen(HomeScreen, Clouds);
}

void draw() {
  background(255);

  switch(screenState) {
    case 0:
      image(HomeScreen, 0, 0);
      break;
    case 1:
      image(Clouds, 0, 0);
      mainScreen.flightsScreen();
      mainScreen.mouseOver();
      mainScreen.flightsScreen2();
      mainScreen.mouseOver2();
      mainScreen.backButton();
      break;
    case 2: // bar chart 2k
      background(0);
      mainScreen.backButton();
      //mainScreen.airportTextDraw();
      break;
    case 3: // bar chart 10k
      background(0);
      mainScreen.backButton();
      break;
    case 4: // bar chart 100k
      background(0);
      mainScreen.backButton();
      break;
    case 5: // pie chart 2k
      background(0);
      mainScreen.backButton();
      break;    
    case 6: // pie chart 10k
      background(0);
      mainScreen.backButton();
      break;
    case 7: // pie chart 100k
      background(0);
      mainScreen.backButton();
      break;
  }
}

void mouseClicked() {
  // Check if the button is clicked and toggle showLatenessPieChart
  if (button.isMouseOver()) {
    lateness();
    pieChart(300, flightStatus);
    key();
    button.setLabel("Hide Chart");
  }
}
void mousePressed() {
  mainScreen.mousePressed();
}

//void keyPressed() {
//  if (key == BACKSPACE) {
//    if (userInput.length() > 0) {
//      userInput = userInput.substring(0, userInput.length() - 1);
//    }
//  } else if (key != CODED) {
//      userInput += key;
//   }
//}
