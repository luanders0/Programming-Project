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

//String userInput = "";
boolean pieUserInput = true;


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

//
PieChart pieChart;
String userInput = "";
//

boolean latenessDraw = false;
boolean popupDrawn = false;

Screen latenessScreen, pieScreen;
ActionListener[] buttonListeners = new ActionListener[4];
Dialog_Pane buttonPanel;
lateness_plot latenessPlot;



Button button;
PImage homeScreen;
PImage clouds;
int screenState;
MainScreen mainScreen;

void setup() {
  size(600, 600);
  
  table = loadTable("flights2k.csv", "header");
  println(table.getRowCount() + " total rows in table");
  
  //ZF  
  userInput = showInputBox(); // Prompt user for input
  pieChart = new PieChart(table);
  //zf
  
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
  
  String[] buttonText = {"Sort by Lateness", "Button2", "Button3", "Sort By Destination Airport"};
  
  buttonPanel = new Dialog_Pane(buttonText, "Choose Your Button", "Buttons", buttonListeners, 300, 200);
  
  lateness_plot latenessPlot = new lateness_plot(table);
  
  latenessScreen = new Screen(color(255), latenessPlot);
  
  button = new Button(width/2, height/2, 200, 60, "Lateness Chart");
  
  homeScreen = loadImage("SquareMainScreen.jpg");
  clouds = loadImage("ChartScreen.jpg");

  mainScreen = new MainScreen(homeScreen, clouds);
}

void draw() {
  background(255);

  switch(screenState) {
    case HOME_SCREEN:
      image(homeScreen, 0, 0);
      break;
    case CHART_SELECT:
      image(clouds, 0, 0);
      mainScreen.flightsScreen();
      mainScreen.mouseOver();
      mainScreen.flightsScreen2();
      mainScreen.mouseOver2();
      mainScreen.backButton();
      break;
    case BAR_CHART_2K: // bar chart 2k
      background(0);
      mainScreen.backButton();
      if (!popupDrawn) {
        buttonPanel.popup();
        popupDrawn = true;
      }
      buttonPanel.popup();
      if (latenessDraw) {
        latenessScreen.draw();
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
      //ZF
       background(#9DE4F0);
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
    if( pieUserInput == true ) {  
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
