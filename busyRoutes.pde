import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class busyRoutes {
  Table table;
  HashMap<String, Integer> routeCounts; // Store flight counts for each route
  ArrayList<String> topRoutes; // Store top routes

  busyRoutes(Table flightTable) {
    // Load CSV file
    table = flightTable;

    // Initialize route counts hashmap
    routeCounts = new HashMap<String, Integer>();

    // Process data
    processData();

    // Sort routes by flight count
    sortRoutes();

    // Display chart
    drawChart();
  }

  void processData() {
    // Iterate through each row in the CSV
    for (TableRow row : table.rows()) {
      // Get origin and destination airports
      String origin = row.getString("ORIGIN");
      String destination = row.getString("DEST");

      // Create a route string (combination of origin and destination)
      String route = origin + "-" + destination;

      // Increment the count for this route in the hashmap
      if (routeCounts.containsKey(route)) {
        int count = routeCounts.get(route);
        routeCounts.put(route, count + 1);
      } else {
        routeCounts.put(route, 1);
      }
    }
  }

  void sortRoutes() {
    // Convert hashmap to arraylist of route strings
    topRoutes = new ArrayList<String>(routeCounts.keySet());

    // Sort the routes based on flight count
    Collections.sort(topRoutes, new Comparator<String>() {
      public int compare(String route1, String route2) {
        int count1 = routeCounts.get(route1);
        int count2 = routeCounts.get(route2);
        return Integer.compare(count2, count1); // Sort in descending order
      }
    });
  }

void drawChart() {
  // Determine the maximum number of flights
  int maxFlights = routeCounts.get(topRoutes.get(0));

  // Determine the dimensions of the chart
  int startX = 50;
  int startY = 50;
  int chartWidth = width - startX - 50; // Adjusted width
  int chartHeight = height - startY - 100; // Adjusted height

  // Calculate the width of each bar
  float barWidth = chartWidth / (float) min(10, topRoutes.size());

  textSize(16);
  fill(0);
  pushMatrix(); // Save the current transformation matrix
  translate(startX - 10, startY + chartHeight); // Move the origin to the end of the y-axis
  rotate(-HALF_PI); // Rotate the coordinate system by -90 degrees
  text("Flights", chartWidth / 2, -30); // Draw the label
  popMatrix(); // Restore the previous transformation matrix

  // Draw x-axis
  line(startX, startY + chartHeight, startX + chartWidth, startY + chartHeight);
  text("Routes", startX + chartWidth / 2, startY + chartHeight + 40);

  textSize(10);

   int maxYValue = (int) ceil((maxFlights / 50.0)) * 50;

  int numTicks = min(17, maxYValue / 5); 
  for (int i = 0; i <= numTicks; i++) {
    float y = map(i * 5, 0, maxYValue, startY + chartHeight, startY);
    text(i * 5, startX - 10, y - 10);
  }

  // Draw bars for each route
  for (int i = 0; i < min(10, topRoutes.size()); i++) {
    String route = topRoutes.get(i);
    int flights = routeCounts.get(route);

    // Calculate bar height based on flight count
    float barHeight = map(flights, 0, maxYValue, 0, chartHeight * 1.7); 

    // Calculate the position of the bar
    float barX = startX + i * barWidth + barWidth / 4; // Adjusted bar position
    float barY = startY + chartHeight - barHeight;

    // Draw bar
    fill(0, 0, 255);
    rect(barX, barY, barWidth / 2, barHeight); // Adjusted bar width

    // Draw route label
    fill(0);
    textAlign(CENTER);
    text(route, barX + barWidth / 4, startY + chartHeight + 20); // Adjusted label position
  }
  textSize(16);
  }


}
