import processing.data.Table;
import processing.data.TableRow;

// represents the number of flights that were late departing.
Table table;
int totalFlights = 0;
int lateFlights = 0;
int onTimeFlights = 0;

void setup() {
  size(500, 500);
  table = loadTable("flights2k..csv", "header");
  
  countFlights(); // Count the total, late, and on-time flights
  
  drawPieChart(); // Draw the pie chart based on flight data
}

void countFlights() {
  for (TableRow row : table.rows()) {
    int cancelled = row.getInt("CANCELLED");
    if (cancelled == 0) { // Consider only non-cancelled flights
      totalFlights++;
      int scheduledTime = row.getInt("CRS_DEP_TIME");
      int actualTime = row.getInt("DEP_TIME");
      if (actualTime > scheduledTime) {
        lateFlights++;
      } else {
        onTimeFlights++;
      }
    }
  }
}

void drawPieChart() {
  float lastAngle = 0;
  // Define colors for on time and late flights
  color onTimeColor = color(30, 200, 150);
  color lateColor = color(255, 192, 203);
  
  for (int i = 0; i < 2; i++) { // Loop twice to draw two sections: late flights and on-time flights
    int count;
    color sectionColor;
    if (i == 0) {
      count = lateFlights;
      sectionColor = lateColor; // Set color for late flights section
      textAlign(CENTER, CENTER);
      textSize(15);
      fill(0); // Set text color to black
      float latePercentage = ((float) lateFlights / totalFlights) * 100;
      text("Flights Late: " + count + " (" + nf(latePercentage, 0, 1) + "%)", width/2 + cos(lastAngle + PI/2) * 150, height/2 + sin(lastAngle + PI/2) * 175);
    } else {
      count = onTimeFlights;
      sectionColor = onTimeColor; // Set color for on time flights section
      textAlign(CENTER, CENTER);
      textSize(15);
      fill(0); // Set text color to black
      float onTimePercentage = ((float) onTimeFlights / totalFlights) * 100;
      text("Flights On Time: " + count + " (" + nf(onTimePercentage, 0, 1) + "%)", width/2 + cos(lastAngle + PI/2) * 150, height/2 + sin(lastAngle + PI/2) * 320);
    }
    float angle = map(count, 0, totalFlights, 0, TWO_PI); // Calculate the angle for the current section
    fill(sectionColor); // Set fill color for the current section
    arc(width/2, height/2, 300, 300, lastAngle, lastAngle + angle); // Draw the arc for the current section
    lastAngle += angle; // Update the starting angle for the next section
  }
}
