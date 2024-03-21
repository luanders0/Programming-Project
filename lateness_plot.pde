class lateness_plot{

Table table;
HashMap<String, Integer> delayedFlightsByState; // Store delayed flight count for each state
HashMap<String, Integer> stateColors; // Store colors for each state

  lateness_plot(Table flightTable){

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
  float barWidth = (width - 400) / (float)delayedFlightsByState.size(); // Adjusted width
  float x = 180; // Adjusted starting x-coordinate (shifted to the right)
  int i = 0;
  for (String state : delayedFlightsByState.keySet()) {
    int count = delayedFlightsByState.get(state);
    float barHeight = map(count, 0, maxDelayedFlights, 0, height - 200); // Adjusted height
    fill(stateColors.get(state));
    rect(x, height - 100 - barHeight, barWidth, barHeight);
    fill(0);
    textAlign(CENTER);
    text(state, x + barWidth / 2, height - 80); // Adjusted Y position
    x += barWidth + 5; // Increased spacing between bars
    i++;
  }

  // Draw legend with two columns
  int legendX = 20; // Initial X position for legend
  int legendY = 20; // Initial Y position for legend
  int legendItemSpacing = 25; // Adjusted spacing between legend items
  int itemsPerColumn = delayedFlightsByState.size() / 2;
  int count = 0;
  for (String state : delayedFlightsByState.keySet()) {
    if (count == itemsPerColumn) {
      legendX += 50; // Move to the next column
      legendY = -480; // Reset Y position
    }
    fill(stateColors.get(state));
    rect(legendX, legendY + count * legendItemSpacing, 20, 15);
    fill(0);
    text(state, legendX + 30, legendY + 10 + count * legendItemSpacing);
    count++;
  }

  // Draw rotated label for y-axis
  pushMatrix();
  translate(30, height / 2);
  rotate(-HALF_PI);
  textAlign(CENTER, CENTER);
  textSize(18);
  textFont(createFont("Arial", 18, true)); // Setting font to Arial and making it bold
  text("Number of Delayed Flights", -10, 100); // Adjusted X position
  popMatrix();

  // Draw y-axis tick marks and labels
  for (int j = 0; j <= 10; j++) {
    float y = map(j * (maxDelayedFlights / 10), 0, maxDelayedFlights, height - 100, 100);
    textAlign(RIGHT, CENTER);
    textSize(10);
    text((int)(j * (maxDelayedFlights / 10)), 172, y); // Adjusted X position
  }

  // Label x-axis
  textAlign(CENTER, CENTER);
  textSize(18);
  text("State", width / 1.75, height - 60);
}
}
