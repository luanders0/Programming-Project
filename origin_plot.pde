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
    float startX = 100;
    float startY = 350;
    float xAxisLabelX = 300;
    float xAxisLabelY = 560;
    float yAxisLabelX = -600 / 2;
    float yAxisLabelY = 20;

    // Draw the y-axis with numerical values
    fill(0);
    textAlign(RIGHT, CENTER);
    for (int i = 0; i <= maxFlights; i += 20) {
      float y = map(i, 0, maxFlights, startY, 0);
      text(i, 90, y);
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
  int getColorValue(int flights) {
    if (flights >= 0 && flights <= 30) {
      return 275;
    } else if (flights >= 31 && flights <= 60) {
      return 255;
    } else if (flights >= 61 && flights <= 90) {
      return 210;
    } else if (flights >= 91 && flights <= 120) {
      return 120;
    } else if (flights >= 121 && flights <= 150) {
      return 50;
    } else if (flights >= 151 && flights <= 180) {
      return 30;
    } else {
      return 0;
    }
  }
}
