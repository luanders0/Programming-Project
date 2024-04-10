//Roisin s added bar charts for the top 15 busy routes

class busyRoutes {
  DataTable table;
  HashMap<String, Integer> routeCounts; // Store flight counts for each route
  ArrayList<String> topRoutes; // Store top routes

  busyRoutes(DataTable flightTable) {

    // Initialize route counts hashmap
    routeCounts = new HashMap<String, Integer>();

    // Process data
    processData(flightTable);

    // Sort routes by flight count
    sortRoutes();

    // Display chart
    drawChart();
  }

  // Method to process flight data and count routes
  void processData(DataTable flightTable) {
    // Iterate through each row in the CSV
    table = flightTable;
    
    DataSeries originColumn = table.get("ORIGIN");
    DataSeries destColumn = table.get("DEST");

    String[] origins = originColumn.asStringArray();
    String[] dests = destColumn.asStringArray();
    
    for (int i = 0; i < destColumn.length(); i++) {
      // Get origin and destination airports
      String origin = origins[i]; //<>//
      String destination = dests[i];

      // Create a route string (combination of origin and destination)
      String route = origin + "-" + destination;

      // Increment the count for this route in the hashmap //<>//
      if (routeCounts.containsKey(route)) {
        int count = routeCounts.get(route);
        routeCounts.put(route, count + 1);
      } else {
        routeCounts.put(route, 1);
      }
    }
  }

  // Method to sort routes by flight count
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
  int startY = 105;
  int chartWidth = width - startX - 50; 
  int chartHeight = height - startY - 100; 

  // Calculate the width of each bar
  float barWidth = chartWidth / (float) min(15, topRoutes.size());

  // Draw x-axis
  line(startX, startY + chartHeight, startX + chartWidth, startY + chartHeight);
  text("ROUTE", startX + chartWidth / 2, startY + chartHeight + 40);
  textSize(10);

  // Determine the scale factor for bar heights
  float scaleFactor = (float) chartHeight / maxFlights;

  // Draw bars for each route
  for (int i = 0; i < min(15, topRoutes.size()); i++) {
    String route = topRoutes.get(i);
    int flights = routeCounts.get(route);

    // Calculate bar height based on flight count and scale factor
    float barHeight = flights * scaleFactor;

    // Calculate the position of the bar
    float barX = startX + i * barWidth + barWidth / 4; 
    float barY = startY + chartHeight - barHeight;

    // Draw bar
    fill(0, 0, 255);
    rect(barX, barY, barWidth / 2, barHeight); 

    // Put the number on top of the bar if mouse is over it
    if (mouseX > barX && mouseX < barX + barWidth / 2 && mouseY > barY && mouseY < barY + barHeight) {
      textAlign(CENTER, BOTTOM);
      fill(255, 0, 0); 
      textSize(12); 
      text(flights, barX + barWidth / 4, barY - 5); 
    }

    // Draw route label
    fill(0);
    textAlign(CENTER);
    textSize(7); // Adjusted text size for route labels
    text(route, barX + barWidth / 4, startY + chartHeight + 20); 
  }
  textSize(16);
}

}
