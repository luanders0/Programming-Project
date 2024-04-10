// Zara F created pie chart to show the amount of flights by state
class PieChartOrigin {
  DataTable table; 
  String[] twoLetterStrings;
  int[] counts;
  int totalStrings;
  color[] sliceColors = {#acfeff, #89e2ff, #6fa8ff, #5349ff, #7420ff, #98fabc};

  // Constructor
  PieChartOrigin(DataTable table) {
    this.table = table;
    initializeData();
  }

  // sorting + initialising the data
  void initializeData() {
    DataSeries originColumn = table.get("ORIGIN_STATE_ABR");
    String[] origins = originColumn.asStringArray();


    totalStrings = originColumn.length();
    twoLetterStrings = new String[totalStrings];
    counts = new int[totalStrings];

    for (int i = 0; i < totalStrings; i++) {
      int count = 0;
      String currentString = origins[i];
      
      // Check if the current string has already been counted
      boolean counted = false;
      for (int j = 0; j < i; j++) {
        if (currentString.equals(twoLetterStrings[j])) {
          counted = true;
          break;
        }
      }
      if (!counted) {
        twoLetterStrings[i] = currentString;
        for (int j = i; j < totalStrings; j++) {
          if (currentString.equals(origins[j])) {
            count++;
          }
        }
        counts[i] = count;
      }
    }
  }

// getting the full names of states for the labels
  String getStateFullName(String stateAbbreviation) {
    switch (stateAbbreviation) {
    case "AL":
      return "Alabama";
    case "AK":
      return "Alaska";
    case "AZ":
      return "Arizona";
    case "AR":
      return "Arkansas";
    case "CA":
      return "California";
    case "CO":
      return "Colorado";
    case "CT":
      return "Connecticut";
    case "DE":
      return "Delaware";
    case "FL":
      return "Florida";
    case "GA":
      return "Georgia";
    case "HI":
      return "Hawaii";
    case "ID":
      return "Idaho";
    case "IL":
      return "Illinois";
    case "IN":
      return "Indiana";
    case "IA":
      return "Iowa";
    case "KS":
      return "Kansas";
    case "KY":
      return "Kentucky";
    case "LA":
      return "Louisiana";
    case "ME":
      return "Maine";
    case "MD":
      return "Maryland";
    case "MA":
      return "Massachusetts";
    case "MI":
      return "Michigan";
    case "MN":
      return "Minnesota";
    case "MS":
      return "Mississippi";
    case "MO":
      return "Missouri";
    case "MT":
      return "Montana";
    case "NE":
      return "Nebraska";
    case "NV":
      return "Nevada";
    case "NH":
      return "New Hampshire";
    case "NJ":
      return "New Jersey";
    case "NM":
      return "New Mexico";
    case "NY":
      return "New York";
    case "NC":
      return "North Carolina";
    case "ND":
      return "North Dakota";
    case "OH":
      return "Ohio";
    case "OK":
      return "Oklahoma";
    case "OR":
      return "Oregon";
    case "PA":
      return "Pennsylvania";
    case "PR":
      return "Puerto Rico";
    case "RI":
      return "Rhode Island";
    case "SC":
      return "South Carolina";
    case "SD":
      return "South Dakota";
    case "TN":
      return "Tennessee";
    case "TX":
      return "Texas";
    case "UT":
      return "Utah";
    case "VT":
      return "Vermont";
    case "VA":
      return "Virginia";
    case "WA":
      return "Washington";
    case "WV":
      return "West Virginia";
    case "WI":
      return "Wisconsin";
    case "WY":
      return "Wyoming";
    default:
      return "Unknown";
    }
  }


  // Draws the pie chart
  void draw(float centerX, float centerY, float x, float y, float diameter) {
    float startAngle = 0;
    for (int i = 0; i < counts.length; i++) {
      float angle = map(counts[i], 0, totalStrings, 0, TWO_PI);
      float endAngle = startAngle + angle;

      // Check if mouse is over the current slice
      if (mouseOverSlice(centerX, centerY, x, y, diameter, startAngle, endAngle)) {
        fill(0);
        textSize(20); // Use a bolder font and larger size
        text(getStateFullName(twoLetterStrings[i])+", " + twoLetterStrings[i] + ": " + counts[i], 490, 570);

        float expandedDiameter = diameter + 20; // Increase diameter by 20 pixels
        fill(sliceColors[i % sliceColors.length]);
        arc(centerX, centerY, expandedDiameter, expandedDiameter, startAngle, endAngle);
      } else {
        // Regular drawing if mouse is not over the slice
        fill(sliceColors[i % sliceColors.length]);
        arc(centerX, centerY, diameter, diameter, startAngle, endAngle);
      }
      startAngle = endAngle;
    }
  }
// updates the table if the user changes the table amount e.g. 2K, 10K
  void updateTable(DataTable table) {
    this.table = table;
    initializeData();
  }

//EH - boolean to check if the mouse is hovering over a slice
  boolean mouseOverSlice(float centerX, float centerY, float x, float y, float diameter, float startAngle, float endAngle) {
    // Compute angle to the mouse position
    float angleToMouse = atan2(mouseY - centerY, mouseX - centerX);
    // Normalize angle to be between 0 and TWO_PI
    if (angleToMouse < 0) {
      angleToMouse += TWO_PI;
    }
    // Check if angle to mouse is within the range of the current slice
    return angleToMouse >= startAngle && angleToMouse <= endAngle && dist(mouseX, mouseY, centerX, centerY) <= diameter / 2;
  }
}
