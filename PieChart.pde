class PieChart {
  DataTable table;

  PieChart(DataTable table) {
    this.table = table;
  }

  void drawPieChart(float x, float y, float diameter, String inputAbbreviation) {
    HashMap<String, Integer> dateCounts = new HashMap<String, Integer>();
    
    DataSeries dateColumn = table.get("FL_DATE");
    String[] rawDates = dateColumn.asStringArray();
    DataSeries originColumn = table.get("ORIGIN");
    String[] origins = originColumn.asStringArray();
    
    for (int i = 0; i < dateColumn.length(); i++) {
      String date = rawDates[i];
      String abbreviation = origins[i];
      if (abbreviation.equals(inputAbbreviation)) {
        if (dateCounts.containsKey(date)) {
          int count = dateCounts.get(date);
          dateCounts.put(date, count + 1);
        } else {
          dateCounts.put(date, 1);
        }
      }
    }

    String[] dates = new String[dateCounts.size()];
    int[] counts = new int[dateCounts.size()];
    int index = 0;
    for (String date : dateCounts.keySet()) {
      dates[index] = date;
      counts[index] = dateCounts.get(date);
      index++;
    }

    // Draw the pie chart
    float total = 0;
    for (int value : counts) {
      total += value;
    }

    float startAngle = 0;
    for (int i = 0; i < counts.length; i++) {
      float angle = map(counts[i], 0, total, 0, TWO_PI);
      fill(map(i, 0, counts.length, 0, 255), map(i, 0, counts.length, 255, 0), 100); // Adjust color for each slice
      stroke(255);
      strokeWeight(1);
      
      // check if the mouse is over the slice
      boolean overSlice = mouseOverSlice(x, y, diameter, startAngle, startAngle + angle);

      // Draw the slice
      if (overSlice) {
        // Increase diameter by 20 pixels if mouse is over the slice
        float expandedDiameter = diameter + 20; 
        arc(x, y, expandedDiameter, expandedDiameter, startAngle, startAngle + angle);
      } else {
        arc(x, y, diameter, diameter, startAngle, startAngle + angle);
      }
      
      // if  mouse is hovering over slice then display label
      if (overSlice) {
        fill(0);
        textSize(20);
        String[] dateParts = dates[i].split(" ");
        String labelText = dateParts[0] + ": " + counts[i] + " flights";
        text(labelText, 490, 570);
      }

      // update startAngle for thre next slice
      startAngle += angle;
    }
  }
  
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
