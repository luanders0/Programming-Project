void lateness() {

  for (TableRow row : table.rows()) {

    totalFlightCount++;

    String CRS_DEP_TIME = row.getString("CRS_DEP_TIME");

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

    String DEP_TIME = row.getString("DEP_TIME");

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

    int CANCELLED = row.getInt("CANCELLED");

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
  noStroke();
  noLoop();  // Run once and stop
  background(#daf2f9);

  println("total: " + totalFlightCount + "\nearly: " + earlyFlightCount + "\nonTime: " + onTimeFlightCount + "\nlate: " + lateFlightCount + "\ncancelled: " + cancelledFlightCount);

  // Calculate proportions

  float earlyProportion = (float) earlyFlightCount / totalFlightCount;
  float onTimeProportion = (float) onTimeFlightCount / totalFlightCount;
  float lateProportion = (float) lateFlightCount / totalFlightCount;
  float cancelledProportion = (float) cancelledFlightCount / totalFlightCount; // Include cancelled flights

  println("early proportion: " + earlyProportion + "\nOn Time proportion: " + onTimeProportion + "\nlate proportion: " + lateProportion + "\ncancelled proportion: " + cancelledProportion);

  // Assign proportions
  flightStatus[0] = (int) (earlyProportion * 360); // Convert proportion to degrees
  flightStatus[1] = (int) (onTimeProportion * 360); // Convert proportion to degrees
  flightStatus[2] = (int) (lateProportion * 360); // Convert proportion to degrees
  flightStatus[3] = (int) (cancelledProportion * 360); // Convert proportion to degrees
}

void pieChart(float diameter, int[] data) {
  float total = 0;

  // Calculate the total sum of data
  for (int i = 0; i < data.length; i++) {
    total += data[i];
  }

  float lastAngle = 0;

  for (int i = 0; i < data.length; i++) {
    float proportion = data[i] / total;

    if (i == 0) {
      fill(#349ae0); // blue - early flights
    } else if (i == 1) {
      fill(255, 255, 255); // white - on time flights
    } else if (i == 2) {
      fill(#faf2b4); // yellow - late flights
    } else {
      fill(#a098a0); // gray - cancelled flights
    }

    float angle = proportion * TWO_PI;
    arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle + angle);
    lastAngle += angle;
  }
}
void key() {
  //String e = ("Early Flights: " + earlyFlightCount);
  //String t = ("On-time Flights: " + onTimeFlightCount);
  //String l = ("Late Flights: " + lateFlightCount);
  //String c = ("Cancelled Flights: " + cancelledFlightCount);
  fill(100);
  textSize(17);
  text("Early Flights: " + earlyFlightCount, 110, 460);
  text("On-time Flights: " + onTimeFlightCount, 115, 490);
  text("Late Flights: " + lateFlightCount, 110, 520);
  text("Cancelled Flights: " + cancelledFlightCount, 125, 550);

  fill(#349ae0); // early
  square(15, 450, 20);

  fill(255, 255, 255); // on time
  square(15, 480, 20);

  fill(#faf2b4); // late
  square(15, 510, 20);

  fill(#a098a0); //cancelled
  square(15, 540, 20);
}
