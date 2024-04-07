class LatenessPieChart {
  int totalFlightCount;
  int earlyFlightCount;
  int onTimeFlightCount;
  int lateFlightCount;
  int cancelledFlightCount;

  LatenessPieChart(DataTable table) {
    calculateLateness(table);
  }

  void calculateLateness(DataTable table) {
    DataSeries realDepTimes = table.get("CRS_DEP_TIME");
    String[] CrsDep = realDepTimes.asStringArray();
    DataSeries depTimes = table.get("DEP_TIME");
    String[] deps = depTimes.asStringArray();
    
    DataSeries cancelled = table.get("CANCELLED");

    for (int i = 0; i < depTimes.length(); i++) {

      totalFlightCount++;

      String CRS_DEP_TIME = CrsDep[i];

      if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 4) {
        schDepHour = Integer.parseInt(CRS_DEP_TIME.substring(0, 2));
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(2, 4));
      } else if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 3) {
        schDepHour = Integer.parseInt(CRS_DEP_TIME.substring(0, 1));
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(1));
      } else if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 2) {
        schDepHour = 0;
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(0, 2));
      } else if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 1) {
        schDepHour = 0;
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(0, 1));
      } else if (CRS_DEP_TIME != null) {
        schDepMinute = Integer.parseInt(CRS_DEP_TIME);
      }
      // handle the case if CRS_DEP_TIME is null here
      else {
        // Do something like setting default values or skipping this row.
        continue; // Skip this iteration and move to the next row.
      }

      String DEP_TIME = deps[i];

      if (DEP_TIME != null && DEP_TIME.length() == 4) {
        depHour = Integer.parseInt(DEP_TIME.substring(0, 2));
        depMinute = Integer.parseInt(DEP_TIME.substring(2, 4));
      } else if (DEP_TIME != null && DEP_TIME.length() == 3) {
        depHour = Integer.parseInt(DEP_TIME.substring(0, 1));
        depMinute = Integer.parseInt(DEP_TIME.substring(1));
      } else if (DEP_TIME != null && DEP_TIME.length() == 2) {
        depHour = 0;
        depMinute = Integer.parseInt(DEP_TIME.substring(0, 2));
      } else if (DEP_TIME != null && DEP_TIME.length() == 1) {
        depHour = 0;
        depMinute = Integer.parseInt(DEP_TIME.substring(0, 1));
      } else if (DEP_TIME != null) {
        depMinute = int(DEP_TIME);
      }
      // handle the case if CRS_DEP_TIME is null here
      else {
        // Do something like setting default values or skipping this row.
        continue; // Skip this iteration and move to the next row.
      }

      int CANCELLED = cancelled.getInt(i);

      if (CANCELLED == 1) {
        println("****Flight was cancelled****");
        cancelledFlightCount++;
      } else {
        int scheduledMinutes = schDepHour * 60 + schDepMinute;
        int actualMinutes = depHour * 60 + depMinute;

        println("scheduled: " + CRS_DEP_TIME + ", and the actual: " + DEP_TIME + ", cancelled: " + CANCELLED);
        println( schDepHour + " : " + schDepMinute);
        println( depHour + " : " + depMinute);

        if (actualMinutes < scheduledMinutes && (scheduledMinutes - actualMinutes) < 60) {
          difference = actualMinutes - scheduledMinutes;
        } else {
          if (actualMinutes < scheduledMinutes) {
            actualMinutes += 24 * 60; //add 24 hours to actual time as floght crossed midnight
          }

          difference = actualMinutes - scheduledMinutes;
        }

        if (difference < 0) {
          println("Flight was early by: " + (-difference) + " minutes");
          earlyFlightCount++;
        } else if (difference > 0) {
          println("Flight was late by: " + difference + " minutes");
          lateFlightCount++;
        } else {
          println("Flight was on time");
          onTimeFlightCount++;
        }
      }
    }
  }

  void draw(float centerX, float centerY, float x, float y, float diameter) {
    int[] flightStatus = {earlyFlightCount, onTimeFlightCount, lateFlightCount, cancelledFlightCount};
    String[] flightLabels = {"Early", "On Time", "Late", "Cancelled"};
    color[] sliceColors = {#000080, #6495ed, #ccccff, #40e0d0};

    float startAngle = 0;

    for (int i = 0; i < flightStatus.length; i++) {
      float angle = map(flightStatus[i], 0, totalFlightCount, 0, TWO_PI);
      float endAngle = startAngle + angle;


      if (mouseOverSlice(centerX, centerY, x, y, diameter, startAngle, endAngle)) {


        fill(0);
        textSize(20); // Use a bolder font and larger size
        text(flightLabels[i]+ ": " + flightStatus[i], 490, 570);
        //text(threeLetterStrings[i] + " " + counts[i], labelX, labelY);
        // Check if label position is inside the pie chart


        // Draw slice with the same color but slightly larger size
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


  boolean mouseOverSlice(float centerX, float centerY, float x, float y, float diameter, float startAngle, float endAngle) {
    // Compute angle to the mouse position
    float angleToMouse = atan2(mouseY - y, mouseX - x);
    // Normalize angle to be between 0 and TWO_PI
    if (angleToMouse < 0) {
      angleToMouse += TWO_PI;
    }
    // Check if angle to mouse is within the range of the current slice
    return angleToMouse >= startAngle && angleToMouse <= endAngle && dist(mouseX, mouseY, x, y) <= diameter / 2;
  }
}
