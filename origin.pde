// ella mcentee added bar charts for the states flights departed from

// import necessary libraries
import processing.core.PApplet;
import processing.data.Table;
import processing.data.TableRow;
import java.util.ArrayList;

public class OriginChart {

  DataTable table; // excel file loaded into object 'table'

  OriginChart(DataTable table) { // constructor taking DataTable object as parameter
    this.table = table; // initialise table with parameter
  }
  
  void setTable (DataTable table) {
    this.table = table;
  }

  void drawOriginChart() { // method to draw 2k origin chart
    DataSeries stateColumn = table.get("ORIGIN_STATE_ABR"); // get column named 'ORIGIN' from excel table
    String[] stateList = new String[stateColumn.length()]; 
    stateList = stateColumn.asStringArray(); // convert the data in stateColumn to an array of strings
    
    String[] stateAbbreviations = getStateAbbreviations(stateList); // get the different state abbreviations from the stateList 
    int[] flightsPerState = new int[stateAbbreviations.length]; // initialise an array to store the count of flights per state

    // count the flights per state
    for (String state : stateList) { 
      int stateIndex = getStateIndex(state, stateAbbreviations); // get the index of the state abbreviation
      if (stateIndex != -1) {
        flightsPerState[stateIndex]++; // increment the count of flights for the corresponding state
      }
    }

   int maxFlights = getMax(flightsPerState); // get the maximum number of flights to draw the y axis 

    // Calculate the dimensions and positions based on canvas size
    float chartWidth = width - 100; 
    float chartHeight = height - 200; 
    float barWidth = chartWidth / flightsPerState.length;
    float startX = 50;
    float startY = height - 100; 
    float xAxisLabelX = width / 2;
    float xAxisLabelY = height - 50; 

    // Draw the y-axis with numerical values
    fill(0);
    for (int i = 0; i <= maxFlights; i += 20) {
      float y = map(i, 0, maxFlights, startY, 100); 
      text(i, 30, y);
      textSize(12);
    line(startX, y, startX + chartWidth, y); // horizontal grid lines
    }

    // Draw the x-axis label
    textSize(16);
    text("State", xAxisLabelX, xAxisLabelY);

    // draw rotated label for y axis 
    pushMatrix();
    translate(10, height / 2);
    rotate(-HALF_PI); // Rotating text label vertically
    textAlign(CENTER, CENTER);
    text("Number of Flights", 0, 0); 
    popMatrix();

    // Draw bars and state abbreviations with smaller text size
    textSize(10); 
    for (int i = 0; i < flightsPerState.length; i++) {
      int flights = flightsPerState[i];
      fill(0, 0, 255);
      float barHeight = map(flights, 0, maxFlights, 0, chartHeight);
      float x = startX + i * barWidth;
      rect(x, startY - barHeight, barWidth, barHeight); // draw bars

      // state abbreviations
      fill(0);
      textSize(7);
      text(stateAbbreviations[i], x + barWidth / 2, startY + 15); 
      
    }
    textSize(16);
  }

  // Get the index of a state abbreviation in the array
  int getStateIndex(String stateAbbreviation, String[] stateAbbreviations) {
    for (int i = 0; i < stateAbbreviations.length; i++) {
      if (stateAbbreviation.equals(stateAbbreviations[i])) {
        return i; //return the index of the state abbreviation if found in the array 
      }
    }
    return -1; // if state abbreviation is not found in array
  }

  // method to get the different state abbreivations from the stateList
  String[] getStateAbbreviations(String[] stateList) {
    ArrayList<String> abbreviationsList = new ArrayList<String>();

    for (String state : stateList) {
      if (!abbreviationsList.contains(state)) { // check if the state abbreviation is not in the list 
        abbreviationsList.add(state); // add the abbrevation to the list 
      }
    }

    return abbreviationsList.toArray(new String[0]); // convert the abbrevation list to an array
  }

  // get the maximum value from the flightsPerState array
  int getMax(int[] array) {
    int max = array[0]; // initialise max with the first element of the array
    for (int i = 1; i < array.length; i++) { // starts with the second element, iterates through each element
      if (array[i] > max) { // if current element is greater than the max 
        max = array[i]; // updates the max to the current element
      }
    }
    return max; // returns the maximum value of flights per state
  }
}
