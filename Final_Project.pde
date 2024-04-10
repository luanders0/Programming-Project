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
final int BAR_10K = 1;
final int BAR_CHART_100K = 2;
final int BAR_FULK = 1;

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
int barScreen;

PImage homeScreen;
PImage clouds;
PImage cursor;
PImage[] allFramesClouds;
PImage[] allFramesPlanes;
PFont barChartFont;
String userInput = "";
float floatDelay;
String roundedDelay;

DataSeries delays, tempDelays;
DataValue avDelay, maxDelay;

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
ActionListener[] pieListeners = new ActionListener[4];
JRadioButton[] fileButtons = new JRadioButton[4];
Dialog_Pane piePanel, fileSelect, barPanel;
SoundFile clickSound;
DataTable table, table2k, table10k, table100k, tableFull;

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  cursor = loadImage("planeMouse.png");

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
  pressHere = new Widget(250, 350, 100, 40, 100, "click here for \nflight info", (0), barChartFont, HERE_BUTTON);

  table = table2k;
  userInput = showInputBox();
  clickSound = new SoundFile(this, "click.wav");
  originChart = new OriginChart(table);
  latenessPlot = new lateness_plot(table);
  busyRoutes = new busyRoutes(table);
  pieChart = new PieChart(table);
  pieChartOrigin = new PieChartOrigin(table);
  busyRoutesPie = new BusyPie(table);
  latenessChart = new LatenessPieChart(table);
  
  
  
  calculateDelay(table);
  

  
  
  
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
        calculateDelay(table);
        print("2K Table Selected");
        busyRoutesPie.processData(table);
        busyRoutesPie.sortRoutes();
        latenessPlot.processData(table);
        originChart.setTable(table);
        busyRoutes.processData(table);
        busyRoutes.sortRoutes();
        pieChart.setTable(table);
        latenessChart.calculateLateness(table);
        pieChartOrigin.updateTable(table);
      }
      if (fileButtons[1].isSelected()) {
        table = table10k;
        calculateDelay(table);
        print("10K Table Selected");
        busyRoutesPie.processData(table);
        busyRoutesPie.sortRoutes();
        latenessPlot.processData(table);
        originChart.setTable(table);
        busyRoutes.processData(table);
        busyRoutes.sortRoutes();
        pieChart.setTable(table);
        latenessChart.calculateLateness(table);
        pieChartOrigin.updateTable(table);
      }
      if (fileButtons[2].isSelected()) {
        table = table100k;
        calculateDelay(table);
        print("100K Table Selected");
        busyRoutesPie.processData(table);
        busyRoutesPie.sortRoutes();
        latenessPlot.processData(table);
        originChart.setTable(table);
        busyRoutes.processData(table);
        busyRoutes.sortRoutes();
        pieChart.setTable(table);
        latenessChart.calculateLateness(table);
        pieChartOrigin.updateTable(table); 
      }
      if (fileButtons[3].isSelected()) {
        table = tableFull;
        calculateDelay(table);
        print("Full Table Selected");
        busyRoutesPie.processData(table);
        busyRoutesPie.sortRoutes();
        latenessPlot.processData(table);
        originChart.setTable(table);
        busyRoutes.processData(table);
        busyRoutes.sortRoutes();
        pieChart.setTable(table);
        latenessChart.calculateLateness(table);
        pieChartOrigin.updateTable(table);
      }
      fileSelect.parent.setVisible(false); // Close the window after file selection
    }
  };

  JButton chooseFile = new JButton("Choose File");
  chooseFile.addActionListener(fileListener);

  pieListeners[0] = new ActionListener() { // Lukas A added code for Dialog_Pane buttons 26/3/24
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 1st button is pressed
      latenessDraw = true;
      originDraw = false;
      busyDraw = false;
      destDraw = false;
    }
  };

  pieListeners[1] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 2nd button is pressed
      originDraw = true;
      latenessDraw = false;
      busyDraw = false;
      destDraw = false;
    }
  };

  pieListeners[2] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 3rd button is pressed
      busyDraw = true;
      originDraw = false;
      latenessDraw = false;
      destDraw = false;
    }
  };

  pieListeners[3] = new ActionListener() {
    @Override
      public void actionPerformed (ActionEvent e) {
      //this code is executed when the 4th button is pressed
      userInput = piePanel.getInput("Please enter destination airport");
      pieChart = new PieChart(table);
      userInput = userInput.toUpperCase(); // Convert to uppercase
      destDraw = true;
      busyDraw = false;
      originDraw = false;
      latenessDraw = false;
    }
  };

  String[] buttonText = {"Sort by Lateness", "Sort by Origin", "Sort by Busy Routes", "Sort By Destination Airport"};
  piePanel = new Dialog_Pane(buttonText, "Choose Your Button", "Buttons", pieListeners, 200, 100);
  String[] barButtonText = new String[buttonText.length - 1];
  arrayCopy(buttonText, 0, barButtonText, 0, 3);
  ActionListener[] barListeners = new ActionListener[pieListeners.length - 1];
  arrayCopy(pieListeners, 0, barListeners, 0, 3);
  barPanel = new Dialog_Pane(barButtonText, "Choose Your Button", "Buttons", barListeners, 200, 100);
  
  fileSelect = new Dialog_Pane(fileButtons, "Please select file size", 100, 100, chooseFile);
  lateness_plot latenessPlot = new lateness_plot(table);
  latenessScreen = new Screen(color(255), latenessPlot);
  button = new Button(width/2, height/2, 200, 60, "Lateness Chart");

  homeScreen = loadImage("SquareMainScreen.jpg"); // Avery H
  clouds = loadImage("clouds.jpg");
  frameRate(30);
  allFramesClouds = Gif.getPImages(this, "cloudScreen.gif");
  allFramesPlanes = Gif.getPImages(this, "planeCrashGIF.gif");
}

void draw() {
  background(255);
  cursor(cursor);
  floatDelay = avDelay.getFloat();
  roundedDelay = nf(floatDelay, 0, 0);
  
  switch(screenState) { // Avery H set up switch statement for screens
  case HOME_SCREEN:
    int gifSpeed = 2;  // slow down speed of GIF
    int currentFramePlanes = (frameCount / gifSpeed) % allFramesPlanes.length;
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
    background(#6ab187);
    backButton.draw();
    if (busyDraw) {
      busyRoutes.drawChart();
      fill(0);
      textSize(20);
      text("Top 15 Busiest Routes", width/2, 30);
    } else if (latenessDraw) {
      latenessPlot.drawChart();
      fill(0);
      textSize(20);
      text("Delayed Flights", width/2, 30);
      color(0);
      textSize(20);
      text("Average Delay : " + roundedDelay + " minutes" + "\nLongest Delay: " + maxDelay + " minutes", 300, 100);
    } else if (originDraw) {
      originChart.drawOriginChart();
      textSize(20);
      text("Flights by State", width/2, 30);
    }
    break;
  case PIE_SCREEN:
    background(#6ab187);
    backButton.draw();
    if (originDraw) {
      pieChartOrigin.draw(width/2, height/2, width/2, height/2, 300);
      fill(0);
      textSize(20);
      text("Flights by State (and Territories)", width/2, 30);
    }
    if (latenessDraw) {
      latenessChart.draw(width/2, height/2, width/2, height/2, 300);
      fill(0);
      textSize(20);
      text("Flights by Lateness", width/2, 30);
      color(0);
      textSize(20);
      text("Average Delay : " + roundedDelay + " minutes" + "\nLongest Delay: " + maxDelay + " minutes", 130, 575);
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

void calculateDelay(DataTable table) {
  DataSeries realDepartureTimes = table.get("DEP_TIME");
  DataSeries departureTimes = table.get("CRS_DEP_TIME");
  for (int i = 0; i < departureTimes.length(); i++) {
    if (realDepartureTimes.isEmpty(i)){
      realDepartureTimes.remove(i);
      i--;
      departureTimes.remove(i);
      i--;
    }
    if (departureTimes.getInt(i) > 100) {
      int temp = departureTimes.getInt(i) / 100;
      int remainder = departureTimes.getInt(i) % 100;
      temp *= 60;
      temp += remainder;
      departureTimes.set(i, temp);
    }
    if (realDepartureTimes.getInt(i) > 100) {
      int temp = realDepartureTimes.getInt(i) / 100;
      int remainder = realDepartureTimes.getInt(i) % 100;
      temp *= 60;
      temp += remainder;
      realDepartureTimes.set(i, temp);
    }
  }
  
  tempDelays = realDepartureTimes.subtract(departureTimes);
  delays = tempDelays.copy();
  for (int i = 0; i < delays.length(); i++) {
    if (delays.getInt(i) < 0) {
      delays.remove(i);
      i--;
    }
  }
  avDelay = delays.mean();
  maxDelay = delays.max();
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
  if (screenState == CHART_SELECT) {
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
        barPanel.popup();
        break;
      case(EVENT_NULL):
        break;
    }
    switch(pieChartButton.getEvent(mouseX, mouseY)) {
      case(PIE_CHART_BUTTON):
        piePanel.popup();
        screenState = PIE_SCREEN;
        break;
      case(EVENT_NULL):
        break;
    }
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
  switch(pressHere.getEvent(mouseX, mouseY)) {
    case(HERE_BUTTON):
      screenState = CHART_SELECT;
      clickSound.play();
      break;
    case(EVENT_NULL):
      break;
  }
}
