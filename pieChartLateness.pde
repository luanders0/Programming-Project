class LatenessPieChart {  //EH - class for lateness pie chart
  int totalFlightCount;
  int earlyFlightCount;
  int onTimeFlightCount;
  int lateFlightCount;
  int cancelledFlightCount;

  LatenessPieChart(DataTable table) {
    calculateLateness(table);
  }

// calculates how late/early each flight is (or on time) 
  void calculateLateness(DataTable table) {
    DataSeries schDepTimes = table.get("CRS_DEP_TIME");
    DataSeries depTimes = table.get("DEP_TIME");
    DataSeries cancelled = table.get("CANCELLED");
    String[] CrsDep = schDepTimes.asStringArray();
    String[] deps = depTimes.asStringArray();
  
    for (int i = 0; i < depTimes.length(); i++) {
      totalFlightCount++;
      
      String CRS_DEP_TIME = CrsDep[i];
      String DEP_TIME = deps[i];
      int CANCELLED = cancelled.getInt(i);
      
      
      if (CANCELLED == 1) {
        cancelledFlightCount++;
        continue; // Skip the rest of the iteration for cancelled flights
      }
  
      // parse scheduled departure time
      int schDepHour = 0;
      int schDepMinute = 0;
      
      if (CRS_DEP_TIME != null && !CRS_DEP_TIME.isEmpty()) {
        float schDepFloat = Float.parseFloat(CRS_DEP_TIME); // parse as float
        schDepHour = int(schDepFloat / 100); // hour part
        schDepMinute = int(schDepFloat % 100); // minute part
      }
  
      // parse actual departure time
      int depHour = 0;
      int depMinute = 0;
      if (DEP_TIME != null && !DEP_TIME.isEmpty()) {
        float depFloat = Float.parseFloat(DEP_TIME); // parse as float
        depHour = int(depFloat / 100); // hour part
        depMinute = int(depFloat % 100); //  minute part
      }
  
      // difference between scheduled and actual departure time
      int scheduledMinutes = schDepHour * 60 + schDepMinute;
      int actualMinutes = depHour * 60 + depMinute;
      int difference = actualMinutes - scheduledMinutes;
  
      if (difference < 0) {
        earlyFlightCount++;
      } else if (difference > 0) {
        lateFlightCount++;
      } else {
        onTimeFlightCount++;
      }
    }
  }

//draws the pie chart
  void draw(float centerX, float centerY, float x, float y, float diameter) {
    int[] flightStatus = {earlyFlightCount, onTimeFlightCount, lateFlightCount, cancelledFlightCount};
    String[] flightLabels = {"Early", "On Time", "Late", "Cancelled"};
    color[] sliceColors = {#000080, #6495ed, #ccccff, #40e0d0};

    float startAngle = 0;

    for (int i = 0; i < flightStatus.length; i++) {
      float angle = map(flightStatus[i], 0, totalFlightCount, 0, TWO_PI);
      float endAngle = startAngle + angle;

      //if mouse is hovering over a slice
      if (mouseOverSlice(centerX, centerY, x, y, diameter, startAngle, endAngle)) {

        // labels for pie chart that show when piece is being hovered over   
        fill(0);
        textSize(20);
        text(flightLabels[i]+ ": " + flightStatus[i], 490, 570);


        // slightly increase size of slice when hovering 
        float expandedDiameter = diameter + 20; // Increase diameter by 20 pixels
        fill(sliceColors[i % sliceColors.length]);
        arc(centerX, centerY, expandedDiameter, expandedDiameter, startAngle, endAngle);
        
      } else {
        // regular drawing if mouse is not over the slice
        fill(sliceColors[i % sliceColors.length]);
        arc(centerX, centerY, diameter, diameter, startAngle, endAngle);
      }
      startAngle = endAngle;
    }
  }

//EH - boolean to check if the mouse is hovering over a slice
  boolean mouseOverSlice(float centerX, float centerY, float x, float y, float diameter, float startAngle, float endAngle) {
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
