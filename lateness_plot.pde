class lateness_plot {

  Table table;
  HashMap<String, Integer> delayedFlightsByState; // Store delayed flight count for each state
  HashMap<String, Integer> stateColors; // Store colors for each state

  lateness_plot(Table flightTable) {

    // Load CSV file
    table = flightTable;

    // Initialize delayed flights data hashmap
    delayedFlightsByState = new HashMap<String, Integer>();

    // Process data
    processData();

    // Display chart
    drawChart();
  }

  void processData() {
    // Initialize color map
    stateColors = new HashMap<String, Integer>();

    for (TableRow row : table.rows()) {
      // Get departure and arrival times
      int depTime = row.getInt("DEP_TIME");
      int arrTime = row.getInt("ARR_TIME");

      // Check for valid departure and arrival times
      if (depTime != 0 && arrTime != 0) {
        // Calculate delay
        int delay = depTime - row.getInt("CRS_DEP_TIME");

        // Check if flight is delayed
        if (delay > 0) {
          // Get origin state
          String originState = row.getString("ORIGIN_STATE_ABR");

          // Update delayed flights count for origin state
          if (!delayedFlightsByState.containsKey(originState)) {
            delayedFlightsByState.put(originState, 1);
          } else {
            delayedFlightsByState.put(originState, delayedFlightsByState.get(originState) + 1);
          }

          // Assign a random color to the state if not assigned yet
          if (!stateColors.containsKey(originState)) {
            stateColors.put(originState, color(random(255), random(255), random(255)));
          }
        }
      }
    }
  }

  void drawChart() {
  // Determine the range of delayed flights counts
  int maxDelayedFlights = 0;
  for (int count : delayedFlightsByState.values()) {
    maxDelayedFlights = Math.max(maxDelayedFlights, count);
  }

  // Draw bars for each state
  float barWidth = (width - 100) / (float)delayedFlightsByState.size(); // Adjusted width
  float x = 50; // Adjusted starting x-coordinate
  int i = 0;
  for (String state : delayedFlightsByState.keySet()) {
    int count = delayedFlightsByState.get(state);
    float barHeight = map(count, 0, maxDelayedFlights, 0, height - 200); // Adjusted height
    fill(0, 0, 255); // Set blue color for bars
    rect(x, height - 100 - barHeight, barWidth, barHeight);
    fill(0);
    textAlign(CENTER);
    textSize(8); // Adjusted text size for state abbreviations
    text(state, x + barWidth / 2, height - 80); // Adjusted Y position
    x += barWidth + 5; // Increased spacing between bars
    i++;
  }

  // Draw rotated label for y-axis
  pushMatrix();
  translate(30, height / 2);
  rotate(-HALF_PI);
  textAlign(CENTER, CENTER);
  textFont(createFont("Arial", 16,true)); // Setting font to Arial 
  text("Number of Delayed Flights", -10, -20); // Adjusted X position
  popMatrix();

  // Draw y-axis tick marks and labels
  for (int j = 0; j <= 10; j++) {
    float y = map(j * (maxDelayedFlights / 10), 0, maxDelayedFlights, height - 100, 100);
    textAlign(RIGHT, CENTER);
    textSize(10);
    text((int)(j * (maxDelayedFlights / 10)), 40, y); // Adjusted X position
  }

  // Label x-axis
  textAlign(CENTER, CENTER);
    textFont(createFont("Arial", 16,true)); // Setting font to Arial 
  text("State", width / 1.75, height - 60);
}
}
