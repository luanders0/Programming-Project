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
Widget fileButton;

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

  PImage file = loadImage("file.png");
  fileButton = new Widget(400, 100, file, FILE_BUTTON);


  table = table2k;

  clickSound = new SoundFile(this, "click.wav");

  println(table.getRowCount() + " total rows in table");


  //ZF


  originChart = new OriginChart(table); // Initialize OriginChart with the loaded table


  //ZF
  userInput = showInputBox(); // Prompt user for input
  pieChart = new PieChart(table);
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
      print(buttonPanel.getInput("Please enter destination airport"));
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
  clouds = loadImage("cloudsBlack.jpg");

  mainScreen = new MainScreen(homeScreen, clouds);
}

void draw() {
  background(255);

  switch(screenState) {
  case HOME_SCREEN:
    image(homeScreen, 0, 0);
    break;
  case CHART_SELECT:
    //fileSelect.popup();
    image(clouds, 0, 0);
    fill(119, 221, 119);
    noStroke();
    rect(30, 30, 550, 550);
    fileButton.draw();
    //mainScreen.flightsScreen();
    //mainScreen.mouseOver();
    //mainScreen.flightsScreen2();
    //mainScreen.mouseOver2();
    mainScreen.backButton();
    break;
  case BAR_CHART_2K: // bar chart 2k
    background(255);
    mainScreen.backButton();
    originChart.drawOriginChart();
    if (!popupDrawn) {
      buttonPanel.popup();
      popupDrawn = true;
    }
    buttonPanel.popup();
    popupDrawn = true;
    buttonPanel.popup();
    if (latenessDraw) {
      latenessScreen.draw();
      mainScreen.backButton();
    }
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
    //background(0);
    lateness();
    pieChart(300, flightStatus);
    mainScreen.backButton();
    key();
    break;
  case PIE_CHART_10K: // pie chart 10k
    background(0);
    mainScreen.backButton();
    break;
  case PIE_CHART_100K: // pie chart 100k
    //ZF
    background(#9DE4F0);
    mainScreen.backButton();
    showInputBox();
    // pieChart.drawPieChart(width / 2, height / 2, 200, userInput); // Draw the pie chart

    //if (!userInput.isEmpty()) {
    //        pieChart.drawPieChart(width / 2, height / 2, 200, userInput); // Draw the pie chart
    //    }
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
  //text("Enter three-letter abbreviation:", width/2, height/2 - 20);
  //return "";

  //if (userInput.isEmpty()) {
  //     text("Enter three-letter abbreviation:", width/2, height/2 - 20);
  // }
  // return "";
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
}
