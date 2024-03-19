Table table;

void setup(){
  size(1000, 600);
  table = loadTable("flights2k.csv", "header");
  textAlign(LEFT, CENTER);
}

void draw () {
  background(255);
  
  // Initialize stateAbbreviations array 
  String[] stateAbbreviations = getStateAbbreviations();
  
  int[] flightsPerState = new int[stateAbbreviations.length];
  
  // Calculate the number of flights per state
  for (TableRow row : table.rows()) {
    String state = row.getString(5); // Assuming state column is at index 5
    int stateIndex = getStateIndex(state, stateAbbreviations);
    if (stateIndex != -1) {
      flightsPerState[stateIndex]++;
    }
  }
  
  // Draw the bar chart
  float barWidth = width / flightsPerState.length;
  for (int i = 0; i < flightsPerState.length; i++) {
    float barHeight = map(flightsPerState[i], 0, getMax(flightsPerState), 0, height - 100);
    float x = i * barWidth;
    float y = height - barHeight - 50;
    
    // Display state abbreviation
    fill(0);
    text(stateAbbreviations[i], x + barWidth / 2, height - 30);
    
    // Display bar
    fill(getStateColor(stateAbbreviations[i]));
    rect(x, y, barWidth, barHeight);
  }
}

// Modify getStateColor to return a color based on state abbreviation
color getStateColor(String stateAbbreviation) {
  switch (stateAbbreviation) {
    case "NY":
      return color(255, 0, 0);  // Red for NY
    case "VA":
      return color(0, 0, 255);  // Blue for VA
    case "FL":
      return color(255,200,200); // Baby Pink for FL
    case "WA":
      return color(252, 186, 3); // Yellow for WA
    case "HI":
      return color(3, 252, 198); // Turquoise for HI
    case "IL":
      return color(136, 3, 252); // Purple for IL
    case "NV":
      return color(252, 3, 244); // Pink for NV
    default:
      return color(0, 255, 0);  // Default to green for unknown states
  }
}

// Modify getMax to get the maximum value from the flightsPerState array
int getMax(int[] array) {
  int max = array[0];
  for (int i = 1; i < array.length; i++) {
    if (array[i] > max) {
      max = array[i];
    }
  }
  return max;
}

// Helper method to get the index of a state abbreviation in the array
int getStateIndex(String stateAbbreviation, String[] stateAbbreviations) {
  for (int i = 0; i < stateAbbreviations.length; i++) {
    if (stateAbbreviation.equals(stateAbbreviations[i])) {
      return i;
    }
  }
  return -1; // State abbreviation not found
}

// Helper method to dynamically get state abbreviations from data
String[] getStateAbbreviations() {
  ArrayList<String> abbreviationsList = new ArrayList<String>();
  
  for (TableRow row : table.rows()) {
    String state = row.getString(5); // Assuming state column is at index 5
    if (!abbreviationsList.contains(state)) {
      abbreviationsList.add(state);
    }
  }
  
  return abbreviationsList.toArray(new String[0]);
}
