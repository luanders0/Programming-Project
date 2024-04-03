import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class busyRoutes{
Table table1;
HashMap<String, Integer> routeCounts; // Store flight counts for each route
ArrayList<String> topRoutes; // Store top routes
  
  void busyRoutes(Table flightTable) {
 
  // Load CSV file
    table = flightTable;

  //table = loadTable("flights2k..csv", "header");
 
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
  // Draw top N routes
  int barWidth = 20;
  int startX = 100;
  int startY = 100;
  int maxHeight = height - 200;
  int maxFlights = routeCounts.get(topRoutes.get(0));
  
    textSize(16);
  // Draw y-axis
  stroke(0);
  line(startX, startY, startX, startY + maxHeight);
  textAlign(RIGHT, CENTER);
  fill(0);
  pushMatrix(); // Save the current transformation matrix
  translate(startX - 10, startY + maxHeight); // Move the origin to the end of the y-axis
  rotate(-HALF_PI); // Rotate the coordinate system by -90 degrees
  text("Flights", 200, -30); // Draw the label
  popMatrix(); // Restore the previous transformation matrix
  
  // Draw x-axis
  line(startX, startY + maxHeight, startX + (min(10, topRoutes.size()) * 60), startY + maxHeight);
  textAlign(CENTER, CENTER);
  text("Routes", startX + (min(10, topRoutes.size()) * 60) / 2, startY + maxHeight + 60);
  
    textSize(12);
 
  // Draw bars for each route
  for (int i = 0; i < min(10, topRoutes.size()); i++) {
    String route = topRoutes.get(i);
    int flights = routeCounts.get(route);
   
    // Calculate bar height based on flight count
    float barHeight = map(flights, 0, maxFlights, 0, maxHeight);
   
    // Draw bar
    fill(0, 0, 255);
    rect(startX + i * 60, startY + maxHeight - barHeight, barWidth, barHeight);
   
    // Draw route label
    fill(0);
    textAlign(LEFT, CENTER);
    text(route, startX + i * 60, startY + maxHeight + 20);
  }
}
}
