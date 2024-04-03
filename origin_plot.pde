import processing.core.PApplet;
import processing.data.Table;
import processing.data.TableRow;
import java.util.ArrayList;

public class OriginChart {

  Table table; // excel file loaded into object 'table'
  int colorStep = 30; // The step for grouping flights

  OriginChart(Table table) {
    this.table = table;
  }

  void drawOriginChart() {
    String[] stateAbbreviations = getStateAbbreviations();
    int[] flightsPerState = new int[stateAbbreviations.length];

    for (TableRow row : table.rows()) {
      String state = row.getString(5);
      int stateIndex = getStateIndex(state, stateAbbreviations);
      if (stateIndex != -1) {
        flightsPerState[stateIndex]++;
      }
    }

    int maxFlights = getMax(flightsPerState);

    // Calculate the dimensions and positions based on canvas size
    float chartWidth = 500;
    float chartHeight = 600;
    float barWidth = chartWidth / flightsPerState.length;
    float startX = 50;
    float startY = 500;
    float xAxisLabelX = 250;
    float xAxisLabelY = 560;
    float yAxisLabelX = 20;
    float yAxisLabelY = 10;

    // Draw the y-axis with numerical values
    fill(0);
    textAlign(RIGHT, CENTER);
    for (int i = 0; i <= maxFlights; i += 20) {
      float y = map(i, 0, maxFlights, startY, 0);
      text(i, 40, y);
      textSize(12);
      line(100, y, 600 - 100, y);
    }

    // Draw the x-axis label
    textAlign(CENTER, CENTER);
    textSize(16);
    text("STATE NAME", xAxisLabelX, xAxisLabelY);

    // Draw the y-axis label
    textAlign(CENTER, CENTER);
    rotate(-HALF_PI);
    textSize(16);
    text("NUMBER OF FLIGHTS", yAxisLabelX, yAxisLabelY);
    rotate(HALF_PI);

    // Draw bars and state abbreviations with smaller text size
    textSize(6); // Adjust the text size here
    for (int i = 0; i < flightsPerState.length; i++) {
      int flights = flightsPerState[i];
      int colorValue = getColorValue(flights);
      fill(colorValue, 100, 100);
      float barHeight = map(flights, 0, maxFlights, 0, chartHeight);
      float x = startX + i * barWidth;
      rect(x, startY - barHeight, barWidth, barHeight);

      fill(0);
      text(stateAbbreviations[i], x + barWidth / 2, startY + 15); // Adjusted the vertical position and added smaller text size
    }
  }

  // Get the index of a state abbreviation in the array
  int getStateIndex(String stateAbbreviation, String[] stateAbbreviations) {
    for (int i = 0; i < stateAbbreviations.length; i++) {
      if (stateAbbreviation.equals(stateAbbreviations[i])) {
        return i;
      }
    }
    return -1;
  }

  String[] getStateAbbreviations() {
    ArrayList<String> abbreviationsList = new ArrayList<String>();

    for (TableRow row : table.rows()) {
      String state = row.getString(5);
      if (!abbreviationsList.contains(state)) {
        abbreviationsList.add(state);
      }
    }

    return abbreviationsList.toArray(new String[0]);
  }

  // Get the maximum value from the flightsPerState array
  int getMax(int[] array) {
    int max = array[0];
    for (int i = 1; i < array.length; i++) {
      if (array[i] > max) {
        max = array[i];
      }
    }
    return max;
  }

  // Assign colors based on flight count
  // Assign blue color to all bars
int getColorValue(int flights) {
    return color(0, 0, 255); // Blue color
}

}
