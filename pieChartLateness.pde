void lateness() {

  table = loadTable("flights2k.csv", "header");

  println(table.getRowCount() + " total rows in table");

  for (TableRow row : table.rows()) {

    totalFlightCount++;
    
    String CRS_DEP_TIME = row.getString("CRS_DEP_TIME");
    
    if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 4){
        schDepHour = Integer.parseInt(CRS_DEP_TIME.substring(0, 2));
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(2, 4));
    }
    else if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 3){
        schDepHour = Integer.parseInt(CRS_DEP_TIME.substring(0, 1));
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(1));
    }
    else if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 2){
        schDepHour = 0;
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(0, 2));
    }
    else if (CRS_DEP_TIME != null && CRS_DEP_TIME.length() == 1){
        schDepHour = 0;
        schDepMinute = Integer.parseInt(CRS_DEP_TIME.substring(0, 1));
    }
    else if (CRS_DEP_TIME != null) {
        schDepMinute = Integer.parseInt(CRS_DEP_TIME);
    } 
    // handle the case if CRS_DEP_TIME is null here
    else {
        // Do something like setting default values or skipping this row.
        continue; // Skip this iteration and move to the next row.
    }
    
    String DEP_TIME = row.getString("DEP_TIME");
  
    if (DEP_TIME != null && DEP_TIME.length() == 4){
        depHour = Integer.parseInt(DEP_TIME.substring(0, 2));
        depMinute = Integer.parseInt(DEP_TIME.substring(2, 4));
    }
    else if (DEP_TIME != null && DEP_TIME.length() == 3){
        depHour = Integer.parseInt(DEP_TIME.substring(0, 1));
        depMinute = Integer.parseInt(DEP_TIME.substring(1));
    }
    else if (DEP_TIME != null && DEP_TIME.length() == 2){
        depHour = 0;
        depMinute = Integer.parseInt(DEP_TIME.substring(0, 2));
    }
    else if (DEP_TIME != null && DEP_TIME.length() == 1){
        depHour = 0;
        depMinute = Integer.parseInt(DEP_TIME.substring(0, 1));
    }
    else if (DEP_TIME != null) {
        depMinute = int(DEP_TIME);
    } 
    // handle the case if CRS_DEP_TIME is null here
    else {
        // Do something like setting default values or skipping this row.
        continue; // Skip this iteration and move to the next row.
    }
    
    int CANCELLED = row.getInt("CANCELLED");
    
    if (CANCELLED == 1) {
      println("****Flight was cancelled****");
      cancelledFlightCount++;
    }
    else {
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
  noStroke();
  noLoop();  // Run once and stop

  println("total: " + totalFlightCount + "\nearly: " + earlyFlightCount + "\nonTime: " + onTimeFlightCount + "\nlate: " + lateFlightCount + "\ncancelled: " + cancelledFlightCount);

  // Calculate proportions
  float earlyProportion = (float) earlyFlightCount / totalFlightCount;
  float onTimeProportion = (float) onTimeFlightCount / totalFlightCount;
  float lateProportion = (float) lateFlightCount / totalFlightCount;
  float cancelledProportion = (float) cancelledFlightCount / totalFlightCount;
  
  // Assign proportions
  flightStatus[0] = (int) (earlyProportion * 360); // Convert proportion to degrees
  flightStatus[1] = (int) (onTimeProportion * 360); // Convert proportion to degrees
  flightStatus[2] = (int) (lateProportion * 360); // Convert proportion to degrees
  flightStatus[3] = (int) (cancelledProportion * 360); // Convert proportion to degrees
  
}

void pieChart(float diameter, int[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    // Assign colors based on flight status
    if (i == 0) {
      fill(245, 174, 229); // Red for early flights
    } else if (i == 1) {
      fill(245, 147, 152); // Green for on-time flights
    } else if (i == 2) {
      fill(182, 169, 245); // Green for on-time flights
    }else {
      fill(203, 147, 245); // Blue for late flights
    }
    
    // Draw pie chart section
    strokeWeight(1);
    stroke(0);
    arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle+radians(data[i]));
    lastAngle += radians(data[i]);
  }
}
 void key() {
  String e = "Early Flights";
  String t = "On-time Flights";
  String l = "Late Flights";
  String c = "Cancelled Flights";
  fill(100);
  textSize(15);
  text(e, 45, 20, 280, 320);
  text(t, 45, 40, 280, 320);
  text(l, 45, 60, 280, 320);
  text(c, 45, 80, 280, 320);
  
  fill(245, 174, 229); // early
  square(20, 20, 20);
   fill(245, 147, 152); // on time
 
  square(20, 40, 20);
  
    fill(182, 169, 245); // late
  square(20, 60, 20);

  fill(203, 147, 245); //cancelled
  square(20, 80, 20);

 }
 
