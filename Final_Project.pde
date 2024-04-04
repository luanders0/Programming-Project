import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import javax.swing.*;
import java.awt.FlowLayout;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import processing.sound.*;

final int HOME_SCREEN = 0;
final int CHART_SELECT = 1;
final int BAR_CHART_2K = 2;
final int BAR_CHART_10K = 3;
final int BAR_CHART_100K = 4;
final int PIE_CHART_2K = 5;
final int PIE_CHART_10K = 6;
final int PIE_CHART_100K = 7;
final int FILE_BUTTON = 8;
final int EVENT_NULL = -1;
final int BLANK_SCREEN = 9;
final int BAR_CHART_2K_LATENESS = 10;
final int PIE_CHART_TEXT = 12;
final int BAR_CHART_2K_BUSY_ROUTES = 11;
final int BACK_BUTTON = 13;


final String[] FILE_TEXT = {"2k Flights", "10k Flights", "100k Flights", "Month of Flights"};

Table table, table2k, table10k, table100k, tableFull;


//String userInput = "";
boolean pieUserInput = true;


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

PieChart pieChart;
PieChartOrigin pieChartOrigin;
BusyPie BusyRoutesPie;
String userInput = "";

boolean latenessDraw = false;
boolean popupDrawn = false;
boolean originDraw = false;
boolean busyRoutesDraw = false;

Screen latenessScreen, pieScreen;
ActionListener[] buttonListeners = new ActionListener[4];
JRadioButton[] fileButtons = new JRadioButton[4];
Dialog_Pane buttonPanel;
Dialog_Pane fileSelect;
lateness_plot latenessPlot;
OriginChart originChart;
busyRoutes busyRoutes;
Widget fileButton, barChart;

PFont barChartFont;

Button button;
PImage homeScreen;
PImage clouds;
int screenState;
MainScreen mainScreen;
SoundFile clickSound;

void setup() {
  size(600, 600);

  table2k = loadTable("flights2k.csv", "header");
  table10k = loadTable("flights10k.csv", "header");
  table100k = loadTable("flights100k.csv", "header");
  tableFull = loadTable("flights_full.csv", "header");
  barChartFont = loadFont("BellMTBold-48.vlw");

  PImage file = loadImage("fileButton.png");
  fileButton = new Widget(525, 30, file, FILE_BUTTON);
  backButton = new Widget(30, 50, 50, 20, "back", 0, font, BACK_BUTTON);


  table = table2k;

  clickSound = new SoundFile(this, "click.wav");

  println(table.getRowCount() + " total rows in table");


  //ZF
  originChart = new OriginChart(table); // Initialize OriginChart with the loaded table

  latenessPlot = new lateness_plot(table); // Initialize latenessPlot

  busyRoutes = new busyRoutes(table);

  //ZF
  userInput = showInputBox(); // Prompt user for input
  pieChart = new PieChart(table);
  pieChartOrigin = new PieChartOrigin("flights2k.csv", color(0, 0, 255), color(255, 0, 255));
  BusyRoutesPie = new BusyPie(table);

  //zf

  for (int i = 0; i < fileButtons.length; i++) {
    if (i == 0) {
      fileButtons[i] = new JRadioButton(FILE_TEXT[i], true);
    } else {
      fileButtons[i] = new JRadioButton(FILE_TEXT[i]);
    }
  }

  ActionListener fileListener = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      if (fileButtons[0].isSelected()) {
        table = table2k;
        screenState = BLANK_SCREEN;
        print("2K Table Selected");
      }
      if (fileButtons[1].isSelected()) {
        table = table10k;
        screenState = BLANK_SCREEN;
        print("10K Table Selected");
      }
      if (fileButtons[2].isSelected()) {
        table = table100k;
        screenState = BLANK_SCREEN;
        print("100K Table Selected");
      }
      if (fileButtons[3].isSelected()) {
        table = tableFull;
        screenState = BLANK_SCREEN;
        print("Full Table Selected");
      }
    }
  };

  JButton chooseFile = new JButton("Choose File");
  chooseFile.addActionListener(fileListener);

  buttonListeners[0] = new ActionListener() { // Lukas A added code for Dialog_Pane buttons 26/3/24
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 1st button is pressed
      latenessDraw = true;
    }
  };

  buttonListeners[1] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 2nd button is pressed
      print("button 2 performed an action");
      originDraw = true;
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
      userInput = buttonPanel.getInput("Please enter destination airport");
    }
  };

  String[] buttonText = {"Sort by Lateness", "Sort by Origin", "Sort by Busy Routes", "Sort By Destination Airport"};

  buttonPanel = new Dialog_Pane(buttonText, "Choose Your Button", "Buttons", buttonListeners, 200, 100);

  fileSelect = new Dialog_Pane(fileButtons, "Please select file size", 100, 100, chooseFile);

  lateness_plot latenessPlot = new lateness_plot(table);

  latenessScreen = new Screen(color(255), latenessPlot);

  button = new Button(width/2, height/2, 200, 60, "Lateness Chart");

  homeScreen = loadImage("SquareMainScreen.jpg");
  //clouds = loadImage("ChartScreen.jpg");
  clouds = loadImage("clouds.jpg");

  mainScreen = new MainScreen(homeScreen, clouds);
}

void draw() {
  background(255);

  switch(screenState) {
  case HOME_SCREEN:
    image(homeScreen, 0, 0);
    break;
  case CHART_SELECT:
    buttonPanel.popup();
    image(clouds, 0, 0);
    fileButton.draw();
    //mainScreen.flightsScreen();
    //mainScreen.mouseOver();
    //mainScreen.flightsScreen2();
    //mainScreen.mouseOver2();
    break;
  case BLANK_SCREEN:
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Click 1 or 4 to see Flights by State", width/2, height/4);
    text("Click 2 or 5 to see Flights by Lateness", width/2, height/2);
    text("Click 3 or 6 or 7 to see Flights by Most Busy Routes", width/2, 3*height/4);
    break;
  case BAR_CHART_2K: // bar chart 2k
    background(255);
    //mainScreen.backButton();
    originChart.drawOriginChart();
    break;
  case BAR_CHART_2K_LATENESS:
    //mainScreen.backButton();
    latenessPlot.drawChart();
    break;
  case BAR_CHART_2K_BUSY_ROUTES:
    //mainScreen.backButton();
    busyRoutes.drawChart();
    break;
  case BAR_CHART_10K: // bar chart 10k
    background(0);
    //mainScreen.backButton();
    break;
  case BAR_CHART_100K: // bar chart 100k
    background(0);
    //mainScreen.backButton();
    break;
  case PIE_CHART_2K: // pie chart 2k
    background(0);
    //mainScreen.backButton();
    background(#9DE4F0);
    pieChartOrigin.draw(width/2, height/2, 300);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(20);
    text("Number of Flights Flown per State", width/2, 30);
    break;
  case PIE_CHART_10K: // pie chart 10k
    background(#9DE4F0);
    //mainScreen.backButton();

    lateness();
    pieChart(300, flightStatus);
    key();

    //      background(#9DE4F0);
    //    mainScreen.backButton();
    //    showInputBox();
    //    if (!userInput.isEmpty()) {
    //      String label = "Number of flights leaving airport " + userInput + " in January 2022";
    //      textAlign(CENTER);
    //      fill(0);
    //      textSize(16);
    //      text(label, width / 2, 50);
    //      pieChart.drawPieChart(width / 2, height / 2, 200, userInput); // Draw the pie chart
    //  }
    break;
  case PIE_CHART_100K: // pie chart 100k
    //ZF
    //background(#9DE4F0);
    //mainScreen.backButton();
    //showInputBox();
    //if (!userInput.isEmpty()) {
    //  String label = "Number of flights leaving airport " + userInput + " in January 2022";
    //  textAlign(CENTER);
    //  fill(0);
    //  textSize(16);
    //  text(label, width / 2, 50);
    //  pieChart.drawPieChart(width / 2, height / 2, 200, userInput); // Draw the pie chart
    //}
    background(#9DE4F0);
    //mainScreen.backButton();
    //mainScreen.backButton();
    BusyRoutesPie.drawPieChart(width/2, height/2, 300);
    fill(0);
    textSize(20);
    text("Top 15 Busiest Routes", width/2, 30);

    break;
  case PIE_CHART_TEXT:
    background(#9DE4F0);
    //mainScreen.backButton();
    showInputBox();
    if (!userInput.isEmpty()) {
      String label = "Number of flights leaving airport " + userInput + " in January 2022";
      textAlign(CENTER);
      fill(0);
      textSize(16);
      text(label, width / 2, 50);
      pieChart.drawPieChart(width / 2, height / 2, 200, userInput); // Draw the pie chart
    }
    break;
  }
}

//ZF
String showInputBox() {
  textAlign(CENTER);
  fill(0);
  textSize(16);
  if ( pieUserInput == true ) {
    if (userInput.isEmpty()) {
      text("Enter three-letter abbreviation:", width/2, height/2 - 20);
    } else {
      text("Enter three-letter abbreviation: " + userInput, width/2, height/2 - 20);
    }
  }
  return "";
}


void keyPressed() {
  if (key == '\n') { // If Enter key is pressed
    pieChart = new PieChart(table);
    userInput = userInput.toUpperCase(); // Convert to uppercase
    pieUserInput = false;
  } else if (keyCode == BACKSPACE) { // If Backspace key is pressed
    userInput = userInput.substring(0, max(0, userInput.length() - 1)); // Remove the last character
  } else if (keyCode != SHIFT && keyCode != DELETE && keyCode != TAB && keyCode != ESC) { // Ignore special keys
    userInput += key; // Add the typed character to the input
  }
  if (key == '1') {
    screenState = BAR_CHART_2K; // Set screenState to display the Origin chart
  }
  if (key == '2') {
    screenState = BAR_CHART_2K_LATENESS; // Set screenState to display the Latenes chart
  }
  if (key == '3') {
    screenState = BAR_CHART_2K_BUSY_ROUTES; // Set the screenState to display the Busy Routes chart
  }
  if (key == '4') {
    screenState = PIE_CHART_2K; // Set screenState to display the Origin chart
  }
  if (key == '5') {
    screenState = PIE_CHART_10K; // Set screenState to display the Latenes chart
  }
  if (key == '6') {
    screenState = PIE_CHART_100K; // Set the screenState to display the Busy Routes chart
  }
  if (key == '7') {
    screenState = PIE_CHART_TEXT; // Set the screenState to display the Busy Routes chart
  }
}
//ZF

//void mouseClicked() {
//  // Check if the button is clicked and toggle showLatenessPieChart
//  if (button.isMouseOver()) {
//    lateness();
//    pieChart(300, flightStatus);
//    key();
//    button.setLabel("Hide Chart");
//  }
//}
void mousePressed() {
  mainScreen.mousePressed();
  switch(fileButton.getEvent(mouseX, mouseY)) {
    case(FILE_BUTTON):
    fileSelect.popup();
    break;
    case(EVENT_NULL):
    break;
  }
  if (screenState != 0 ) {
  switch(backButton.getEvent(mouseX, mouseY)) {
    case(BACK_BUTTON):
      if (screenState = 1 ) {
          screenState = 0;
      }
      else {
        screenState = 1;
      }
    break;
    case(EVENT_NULL):
    break;
  }
  clickSound.play();
}
