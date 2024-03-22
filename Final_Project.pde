import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
final int BAR_WIDTH = 20;

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

  // Draw MainScreen or Clouds based on screenState
  if (screenState == 0) {
    image(HomeScreen, 0, 0);
  } else if (screenState == 1) {
    image(Clouds, 0, 0);
    button.display();
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
  // Call mousePressed() of MainScreen to handle screen state change
  mainScreen.mousePressed();
}
