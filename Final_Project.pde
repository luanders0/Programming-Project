import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import javax.swing.*;
import java.awt.FlowLayout;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import processing.sound.*;

final int EVENT_NULL = -1;
final int HOME_SCREEN = 0;
final int CHART_SELECT = 1;
final int PIE_CHART_BUTTON = 2;
final int BAR_CHART_BUTTON = 3;
final int PIE_SCREEN = 4;
final int FILE_BUTTON = 5;
final int BAR_SCREEN = 5;
final int BACK_BUTTON = 7;
final int PIE_CHART_TEXT = 8;

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
boolean busyDraw = false;
boolean busyRoutesDraw = false;
boolean destDraw = false;

Screen latenessScreen, pieScreen;
ActionListener[] buttonListeners = new ActionListener[4];
JRadioButton[] fileButtons = new JRadioButton[4];
Dialog_Pane buttonPanel;
Dialog_Pane fileSelect;
lateness_plot latenessPlot;
OriginChart originChart;
busyRoutes busyRoutes;
Widget fileButton, barChart, pieChartButton, backButton;

PFont barChartFont;

Button button;
PImage homeScreen;
PImage clouds;
int screenState;
MainScreen mainScreen;
SoundFile clickSound;

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);

  table2k = loadTable("flights2k.csv", "header");
  table10k = loadTable("flights10k.csv", "header");
  table100k = loadTable("flights100k.csv", "header");
  tableFull = loadTable("flights_full.csv", "header");
  barChartFont = loadFont("BellMTBold-48.vlw");

  PImage file = loadImage("fileButton.png");
  fileButton = new Widget(525, 30, file, FILE_BUTTON);
  barChart = new Widget(200, 200, 80, 30, "Bar Chart", color(255, 0, 0), null, BAR_CHART_BUTTON);
  backButton = new Widget(30, 50, 50, 20, "back", color(255), barChartFont, BACK_BUTTON);
  pieChartButton = new Widget(300, 300, 80, 30, "Pie Chart", color(255,0,0), null, PIE_CHART_BUTTON);


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
        print("2K Table Selected");
      }
      if (fileButtons[1].isSelected()) {
        table = table10k;
        print("10K Table Selected");
      }
      if (fileButtons[2].isSelected()) {
        table = table100k;
        print("100K Table Selected");
      }
      if (fileButtons[3].isSelected()) {
        table = tableFull;
        print("Full Table Selected");
      }
        fileSelect.parent.setVisible(false); // Close the window after file selection
    }
  };


  JButton chooseFile = new JButton("Choose File");
  chooseFile.addActionListener(fileListener);

  buttonListeners[0] = new ActionListener() { // Lukas A added code for Dialog_Pane buttons 26/3/24
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 1st button is pressed
      latenessDraw = true;
      originDraw = false;
      busyDraw = false;
    }
  };

  buttonListeners[1] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 2nd button is pressed
      originDraw = true;
      latenessDraw = false;
      busyDraw = false;      
    }
  };

  buttonListeners[2] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 3rd button is pressed
      busyDraw = true;
      originDraw = false;
      latenessDraw = false;
    }
  };

  buttonListeners[3] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 4th button is pressed
      userInput = buttonPanel.getInput("Please enter destination airport");
      pieChart = new PieChart(table);
      userInput = userInput.toUpperCase(); // Convert to uppercase
      destDraw = true;
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
    image(homeScreen, 0, 0, 600, 600);
    break;
  case CHART_SELECT:
    image(clouds, 0, 0);
    fileButton.draw();
    barChart.draw();
    backButton.draw();
    pieChartButton.draw();
    //mainScreen.flightsScreen();
    //mainScreen.mouseOver();
    //mainScreen.flightsScreen2();
    //mainScreen.mouseOver2();
    break;
  case BAR_SCREEN:
    background(255);
    backButton.draw();
    if (busyDraw) {
      busyRoutes.drawChart();
    }
    else if (latenessDraw) {
      latenessPlot.drawChart();      
    }
    else if (originDraw) {
      originChart.drawOriginChart();
    }
    //text("Click 1 or 4 to see Flights by State", width/2, height/4);
    //text("Click 2 or 5 to see Flights by Lateness", width/2, height/2);
    //text("Click 3 or 6 or 7 to see Flights by Most Busy Routes", width/2, 3*height/4);
    break;
  case PIE_SCREEN:
    background(#9DE4F0);
    backButton.draw();
    if (originDraw) {
      pieChartOrigin.draw(width/2, height/2, 300);
    }
    if (latenessDraw) {
      lateness();
      pieChart(300, flightStatus);
      key();
      //backButton.draw();
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
    }
    if (busyDraw) {
       BusyRoutesPie.drawPieChart(width/2, height/2, 300);
       fill(0);
      textSize(20);
      text("Top 15 Busiest Routes", width/2, 30);
      textSize(16);
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
    }
    if (destDraw) {
      String label = "Number of flights leaving airport " + userInput + " in January 2022";
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
  //if (key == '\n') { // If Enter key is pressed
  //  pieChart = new PieChart(table);
  //  userInput = userInput.toUpperCase(); // Convert to uppercase
  //  pieUserInput = false;
  //} else if (keyCode == BACKSPACE) { // If Backspace key is pressed
  //  userInput = userInput.substring(0, max(0, userInput.length() - 1)); // Remove the last character
  //} else if (keyCode != SHIFT && keyCode != DELETE && keyCode != TAB && keyCode != ESC) { // Ignore special keys
  //  userInput += key; // Add the typed character to the input
  //}
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
  switch(barChart.getEvent(mouseX, mouseY)) {
    case(BAR_CHART_BUTTON):
      screenState = BAR_SCREEN;
      buttonPanel.popup();
      break;
    case(EVENT_NULL):
      break;
  }
  switch(pieChartButton.getEvent(mouseX, mouseY)) {
    case(PIE_CHART_BUTTON):
      buttonPanel.popup();
      screenState = PIE_SCREEN;
      break;
    case(EVENT_NULL):
      break;
  }
   if (screenState != HOME_SCREEN ) { // Adjusted condition to check for PIE_SCREEN
    switch(backButton.getEvent(mouseX, mouseY)) {
      case(BACK_BUTTON):
        if (screenState == PIE_SCREEN ) { // Adjusted condition to check for PIE_SCREEN
          screenState = CHART_SELECT; // Set back to CHART_SELECT when pressing back on PIE_SCREEN
        } else {
          screenState = HOME_SCREEN; // Set back to HOME_SCREEN for other screens
        }
        break;
      case(EVENT_NULL):
        break;
    }  
    clickSound.play();
  }
}
