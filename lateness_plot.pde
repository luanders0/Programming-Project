class lateness_plot {

  DataTable table;
  HashMap<String, Integer> delayedFlightsByState; // Store delayed flight count for each state
  HashMap<String, Integer> stateColors; // Store colors for each state

  lateness_plot(DataTable flightTable) {

    // Initialize delayed flights data hashmap
    delayedFlightsByState = new HashMap<String, Integer>();

    // Process data
    processData(flightTable);

  }

  void processData(DataTable flightTable) {
    // Initialize color map
    table = flightTable;

    
    stateColors = new HashMap<String, Integer>();
    DataSeries depTimes = table.get("DEP_TIME");
    DataSeries arrTimes = table.get("ARR_TIME");
    DataSeries realDepTimes = table.get("CRS_DEP_TIME");

    DataSeries stateColumn = table.get("ORIGIN_STATE_ABR");
    String[] states = stateColumn.asStringArray();

    for (int i = 0; i < depTimes.length(); i++) {
      // Get departure and arrival times
      int depTime = depTimes.getInt(i);
      int arrTime = arrTimes.getInt(i);

      // Check for valid departure and arrival times
      if (depTime != 0 && arrTime != 0) {
        // Calculate delay
        int delay = depTime - realDepTimes.getInt(i);

        // Check if flight is delayed
        if (delay > 0) {
          // Get origin state
          String originState = states[i];

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
      textSize(8); // Adjusted text size for state abbreviations
      text(state, x + barWidth / 2, height - 80); // Adjusted Y position
      x += barWidth + 5; // Increased spacing between bars
      i++;
    }

    // Draw rotated label for y-axis
    pushMatrix();
    translate(30, height / 2);
    rotate(-HALF_PI);
    textFont(createFont("Arial", 16, true)); // Setting font to Arial
    text("Number of Delayed Flights", -10, -20); // Adjusted X position
    popMatrix();

    // Draw y-axis tick marks and labels
    for (int j = 0; j <= 10; j++) {
      float y = map(j * (maxDelayedFlights / 10), 0, maxDelayedFlights, height - 100, 100);
      textSize(10);
      text((int)(j * (maxDelayedFlights / 10)), 30, y); // Adjusted X position
    }

    // Label x-axis
    textAlign(CENTER, CENTER);
    textFont(createFont("Arial", 16, true)); // Setting font to Arial
    text("State", width / 1.75, height - 60);
  }
}
