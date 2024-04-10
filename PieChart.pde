// Zara F added pie chart for airport destinations
class PieChart {
  DataTable table;

  //Constructor
  PieChart(DataTable table) {
    this.table = table;
  }

  //Table depending on button pressed
  void setTable(DataTable table) {
    this.table = table;
  }

  //Creates the pie chart based on data from the coloumns in the table
  void drawPieChart(float x, float y, float diameter, String inputOrigin) {
    HashMap<String, Integer> carrierCounts = new HashMap<String, Integer>();

    DataSeries originColumn = table.get("DEST");
    String[] origins = originColumn.asStringArray();
    DataSeries carrierColumn = table.get("MKT_CARRIER");
    String[] carriers = carrierColumn.asStringArray();

    // Count flights for the specified origin and carrier
    for (int i = 0; i < originColumn.length(); i++) {
      String origin = origins[i];
      String carrier = carriers[i];

      if (origin.equals(inputOrigin)) {
        if (carrierCounts.containsKey(carrier)) {
          int count = carrierCounts.get(carrier);
          carrierCounts.put(carrier, count + 1);
        } else {
          carrierCounts.put(carrier, 1);
        }
      }
    }

    // Draws the pie chart
    float total = 0;
    for (int value : carrierCounts.values()) {
      total += value;
    }

    float startAngle = 0;
    int i = 0;
    for (String carrier : carrierCounts.keySet()) {
      float angle = map(carrierCounts.get(carrier), 0, total, 0, TWO_PI);

      // Set color for the slices using a gradient
      int colorStart = color(172, 254, 255);
      int colorEnd = color(111, 168, 255);
      int interColor = lerpColor(colorStart, colorEnd, (float)i / carrierCounts.size());
      fill(interColor);

      stroke(255);
      strokeWeight(1);

      // Draws the slice
      arc(x, y, diameter, diameter, startAngle, startAngle + angle);

      boolean overSlice = mouseOverSlice(x, y, diameter, startAngle, startAngle + angle);

      // Makes the slice bigger if the mouse is over the slice
      if (overSlice) {
        float expandedDiameter = diameter + 20;
        arc(x, y, expandedDiameter, expandedDiameter, startAngle, startAngle + angle);
      } else {
        arc(x, y, diameter, diameter, startAngle, startAngle + angle);
      }

      // label for all flights
      fill(0);
      textSize(20);
      String label = "Total Flights: " + int(total);
      text(label, 420, 545);

      // label for each slice with airlines
      if (overSlice) {
        fill(0);
        textSize(20);
        int flightCount = carrierCounts.get(carrier);
        String airlineName;
        switch (carrier) {
        case "AA":
          airlineName = "American Airlines";
          break;
        case "AS":
          airlineName = "Alaska Airlines";
          break;
        case "B6":
          airlineName = "JetBlue Airways";
          break;
        case "HA":
          airlineName = "Hawaiian Airlines";
          break;
        case "NK":
          airlineName = "Spirit Airlines";
          break;
        case "WN":
          airlineName = "Southwest Airlines";
          break;
        case "G4":
          airlineName = "Allegiant Air";
          break;
        case "UA":
          airlineName = "United Airlines";
          break;
        case "F9":
          airlineName = "Frontier Airlines";
          break;
        case "DL":
          airlineName = "Delta Air Lines";
          break;
        default:
          airlineName = carrier; 
          break;
        }
        String labelText = flightCount + " flights flew with " + airlineName;
        text(labelText, 420, 570);
      }

     //starts again for the next slice
      startAngle += angle;
      i++;
    }
  }
  
//EH - boolean to check if the mouse is hovering over a slice
  boolean mouseOverSlice(float x, float y, float diameter, float startAngle, float endAngle) {
    // compute angle to the mouse position
    float angleToMouse = atan2(mouseY - y, mouseX - x);
    // normalize angle to be between 0 and TWO_PI
    if (angleToMouse < 0) {
      angleToMouse += TWO_PI;
    }
    // check if angle to mouse is within the range of the current slice
    return angleToMouse >= startAngle && angleToMouse <= endAngle && dist(mouseX, mouseY, x, y) <= diameter / 2;
  }
}
