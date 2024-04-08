import hivis.common.*;
import hivis.data.*;
import hivis.data.reader.*;
import hivis.data.view.*;
import hivis.example.*;
import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import javax.swing.*;
import java.awt.FlowLayout;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import processing.sound.*;
import gifAnimation.*;

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
final int LABELX = 500;
final int LABELY = 500;
final String[] FILE_TEXT = {"2k Flights", "10k Flights", "100k Flights", "Month of Flights"};
final int HERE_BUTTON = 9;

boolean pieUserInput = true;
boolean latenessDraw = false;
boolean popupDrawn = false;
boolean originDraw = false;
boolean busyDraw = false;
boolean busyRoutesDraw = false;
boolean destDraw = false;

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
int screenState;

PImage homeScreen;
PImage clouds;
PImage[] allFramesClouds;
PImage[] allFramesPlanes;
PFont barChartFont;
String userInput = "";

PieChart pieChart;
PieChartOrigin pieChartOrigin;
BusyPie busyRoutesPie;
lateness_plot latenessPlot;
OriginChart originChart;
busyRoutes busyRoutes;
LatenessPieChart latenessChart;
Widget fileButton, barChart, pieChartButton, backButton, pressHere;
Button button;
Screen latenessScreen, pieScreen;
ActionListener[] buttonListeners = new ActionListener[4];
JRadioButton[] fileButtons = new JRadioButton[4];
Dialog_Pane buttonPanel;
Dialog_Pane fileSelect;
SoundFile clickSound;
DataTable table, table2k, table10k, table100k, tableFull;

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  
  table2k = HV.loadSpreadSheet(HV.loadSSConfig().sourceFile(sketchPath("data/flights2k.csv")));
  table10k = HV.loadSpreadSheet(HV.loadSSConfig().sourceFile(sketchPath("data/flights10k.csv")));
  table100k = HV.loadSpreadSheet(HV.loadSSConfig().sourceFile(sketchPath("data/flights100k.csv")));
  tableFull = HV.loadSpreadSheet(HV.loadSSConfig().sourceFile(sketchPath("data/flights_full.csv")));
  
  barChartFont = loadFont("BellMTBold-48.vlw");
  PImage file = loadImage("fileButton.png");
  
  fileButton = new Widget(485, 60, file, FILE_BUTTON);
  barChart = new Widget(230, 200, 150, 80, "Bar Chart", color(255, 255, 255), barChartFont, BAR_CHART_BUTTON);
  pieChartButton = new Widget(230, 300, 150, 80, "Pie Chart", color(255, 255, 255), barChartFont, PIE_CHART_BUTTON);
  backButton = new Widget(30, 50, 100, 40, "Back", color(255), barChartFont, BACK_BUTTON);
  pressHere = new Widget(300, 350, 100, "CLICK HERE FOR \nFLIGHT INFO", (0), (255), barChartFont, HERE_BUTTON);

  table = table2k;
  userInput = showInputBox();
  clickSound = new SoundFile(this, "click.wav");
  originChart = new OriginChart(table); 
  latenessPlot = new lateness_plot(table);
  busyRoutes = new busyRoutes(table);
  pieChart = new PieChart(table);
  pieChartOrigin = new PieChartOrigin("flights2k.csv", color(0, 0, 255), color(255, 0, 255));
  busyRoutesPie = new BusyPie(table);
  latenessChart = new LatenessPieChart(table);

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
        busyRoutesPie.processData(table);
        busyRoutesPie.sortRoutes();
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
      destDraw = false;
    }
  };

  buttonListeners[1] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 2nd button is pressed
      originDraw = true;
      latenessDraw = false;
      busyDraw = false;   
      destDraw = false;
    }
  };

  buttonListeners[2] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 3rd button is pressed
      busyDraw = true;
      originDraw = false;
      latenessDraw = false;
      destDraw = false;
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
      busyDraw = false;
      originDraw = false;
      latenessDraw = false;
    }
  };

  String[] buttonText = {"Sort by Lateness", "Sort by Origin", "Sort by Busy Routes", "Sort By Destination Airport"};
  buttonPanel = new Dialog_Pane(buttonText, "Choose Your Button", "Buttons", buttonListeners, 200, 100);
  fileSelect = new Dialog_Pane(fileButtons, "Please select file size", 100, 100, chooseFile);
  lateness_plot latenessPlot = new lateness_plot(table);
  latenessScreen = new Screen(color(255), latenessPlot);
  button = new Button(width/2, height/2, 200, 60, "Lateness Chart");

  homeScreen = loadImage("SquareMainScreen.jpg"); // Avery H
  clouds = loadImage("clouds.jpg");
  frameRate(30);
  allFramesClouds = Gif.getPImages(this, "cloudScreen.gif");
  //mainScreen = new MainScreen(homeScreen, clouds);
  frameRate(15);
  allFramesPlanes = Gif.getPImages(this, "PlanesGIF.gif");
}

void draw() {
  background(255);

  switch(screenState) { // Avery H set up switch statement for screens 
  case HOME_SCREEN:
    int currentFramePlanes = frameCount % allFramesPlanes.length;
    image(allFramesPlanes[currentFramePlanes], 0, 0, 600, 600);
    pressHere.draw();
    break;
  case CHART_SELECT:
    int currentFrameClouds = frameCount % allFramesClouds.length;
    image(allFramesClouds[currentFrameClouds], 0, 0, 600, 600);
    fileButton.draw();
    barChart.draw();
    backButton.draw();
    pieChartButton.draw();
    break;
  case BAR_SCREEN:
    background(#248cdc);
    backButton.draw();
    if (busyDraw) {
      busyRoutes.drawChart();
      fill(0);
      textSize(20);
      text("Top 10 Busiest Routes", width/2, 30);
    }
    else if (latenessDraw) {
      latenessPlot.drawChart();
      fill(0);
      textSize(20);
      text("Delayed Flights", width/2, 30);
    }
    else if (originDraw) {
      originChart.drawOriginChart();
      fill(0);
      textSize(20);
      text("Flights by State", width/2, 30);
    }
    break;
  case PIE_SCREEN:
    background(#248cdc);
    backButton.draw();
    if (originDraw) {
      pieChartOrigin.draw(width/2, height/2, width/2, height/2, 300);
      fill(0);
      textSize(20);
      text("Flights by State", width/2, 30);

    }
    if (latenessDraw) {
      latenessChart.draw(width/2, height/2, width/2, height/2, 300);
      fill(0);
      textSize(20);
      text("Flights by Lateness", width/2, 30);
    }
    if (busyDraw) {
      busyRoutesPie.drawPieChart(width/2, height/2, 300);
      fill(0);
      textSize(20);
      text("Top 15 Busiest Routes", width/2, 30);
    }
    if (destDraw) {
      pieChart.drawPieChart(width/2, height/2, 300, userInput);
      fill(0);
      textSize(20);
      String label = "Number of flights leaving airport " + userInput + " in January 2022";
      text(label, width/2, 30);
    }
    break;
  }
}

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

void mousePressed() { // Avery H & Lukas A worked on mousePressed & widgets 
  switch(pressHere.getEvent(mouseX, mouseY)) {
    case(HERE_BUTTON):
      screenState = CHART_SELECT;
      break;
    case(EVENT_NULL):
      break;
  }
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
        if (screenState == PIE_SCREEN || screenState == BAR_SCREEN) { // Adjusted condition to check for PIE_SCREEN
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
