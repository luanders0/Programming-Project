import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import javax.swing.*;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
final int HOME_SCREEN = 0;
final int CHART_SELECT = 1;
final int BAR_CHART_2K = 2;
final int BAR_CHART_10K = 3;
final int BAR_CHART_100K = 4;
final int PIE_CHART_2K = 5;
final int PIE_CHART_10K = 6;
final int PIE_CHART_100K = 7;

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

Screen barScreen, pieScreen;
ActionListener[] buttonListeners = new ActionListener[4];
Dialog_Pane buttonPanel;

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
  
  buttonListeners[0] = new ActionListener() { // Lukas A added code for Dialog_Pane buttons 26/3/24
   @Override
   public void actionPerformed (ActionEvent e) {
     //this code is executed when the 1st button is pressed
     print("button 1 performed an action");
   }
  };
  
  buttonListeners[1] = new ActionListener() {
   @Override
   public void actionPerformed (ActionEvent e) {
     //this code is executed when the 2nd button is pressed
     print("button 2 performed an action");
   }
  };
  
  buttonListeners[2] = new ActionListener() {
   @Override
   public void actionPerformed (ActionEvent e) {
     //this code is executed when the 3rd button is pressed
     print("button 3 performed an action");
   }
  };
  
  buttonListeners[3] = new ActionListener() {
   @Override
   public void actionPerformed (ActionEvent e) {
     //this code is executed when the 4th button is pressed
     print(buttonPanel.getInput("Please enter destination airport"));
   }
  };
  
  String[] buttonText = {"Button1", "Button2", "Button3", "Sort By Destination Airport"};
  
  buttonPanel = new Dialog_Pane(buttonText, "Choose Your Button", "Buttons", buttonListeners, 300, 200);
  
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
    case HOME_SCREEN:
      image(HomeScreen, 0, 0);
      break;
    case CHART_SELECT:
      image(Clouds, 0, 0);
      mainScreen.flightsScreen();
      mainScreen.mouseOver();
      mainScreen.flightsScreen2();
      mainScreen.mouseOver2();
      mainScreen.backButton();
      buttonPanel.popup();
      break;
    case BAR_CHART_2K: // bar chart 2k
      background(0);
      mainScreen.backButton();
      break;
    case BAR_CHART_10K: // bar chart 10k
      background(0);
      mainScreen.backButton();
      break;
    case BAR_CHART_100K: // bar chart 100k
      background(0);
      mainScreen.backButton();
      break;
    case PIE_CHART_2K: // pie chart 2k
      background(0);
      mainScreen.backButton();
      break;    
    case PIE_CHART_10K: // pie chart 10k
      background(0);
      mainScreen.backButton();
      break;
    case PIE_CHART_100K: // pie chart 100k
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
