class origin_plot {

  Table table; // excel file loaded into object 'table'
  int colorStep = 30; // The step for grouping flights

  void origin () {

    String[] stateAbbreviations = getStateAbbreviations(); // array 'stateAbbreviations' assign to function 'getStateAbbreviations'

    int[] flightsPerState = new int[stateAbbreviations.length]; // array 'flightsPerState' used to store the count of flights per state

    // Calculate the number of flights per state
    for (TableRow row : table.rows()) { // iterates over each row in the excel file
      String state = row.getString(5); // retrieves the string value from the column at index 5 (column 6)
      int stateIndex = getStateIndex(state, stateAbbreviations); // calls function 'getStateIndex()' to find the index of the current state abbreviation
      if (stateIndex != -1) { // if the state abbreviation is found in the 'stateAbbreviations' array
        flightsPerState[stateIndex]++; // increments element in the 'flightsPerState' array
      }
    }

    int maxFlights = getMax(flightsPerState); // calculates the maximum number of flights among all states by calling 'getMax()'

    // Draw the y-axis with numerical values
    fill(0); // black
    textAlign(RIGHT, CENTER);
    for (int i = 0; i <= maxFlights; i += 20) { // iterates from 0 to maxFlights in steps of 20
      float y = map(i, 0, maxFlights, height - 50, 0); // labels are evenly distributed along y-axis
      text(i, 90, y); // draws flight count 'i' at 90 pixels from the left of the canvas
      line(100, y, width - 100, y); // Draw the horizontal lines for the grid
    }

    // Draw the x-axis label
    textAlign(CENTER, CENTER);
    text("STATE NAME", width / 2, height - 10); // draws label at width/2 and 10 pixels from the bottom

    // Draw the y-axis label
    textAlign(CENTER, CENTER);
    rotate(-HALF_PI); // rotates so the y-axis is drawn vertically
    text("NUMBER OF FLIGHTS", -height / 2, 20); // draws label to the left of the canvas 20 pixels from the top
    rotate(HALF_PI); // resets canvas back to orginal orientation

    for (int i = 0; i < flightsPerState.length; i++) { // iterates over each element in flightsPerState array
      int flights = flightsPerState[i]; // retrieves number of flights for the current state
      int colorValue = getColorValue(flights); // determine the colour of the bar based on the number of flights
      fill(colorValue, 100, 100); // set the fill colour for the bar
      float barHeight = map(flights, 0, maxFlights, 0, height - 100); // calculate the height of the bar based on the number of flights
      float barWidth = (width - 200) / flightsPerState.length; // calculate the width of the bar based on the number of states
      float x = 100 + i * barWidth; // Start drawing bars from x = 100 // calculate the x coordinate of the current bar
      rect(x, height - barHeight - 50, barWidth, barHeight); // draw the bar as a rectangle

      // Display state abbreviation
      fill(0); // black
      text(stateAbbreviations[i], x + barWidth / 2, height - 30); // draw the state abbreviation centreed below the bar
    }
  }

  // Get the index of a state abbreviation in the array
  int getStateIndex(String stateAbbreviation, String[] stateAbbreviations) { // 'getStateIndex' takes a string 'stateAbbreviation' and an array 'stateAbbreviations'
    for (int i = 0; i < stateAbbreviations.length; i++) { // iterates over each element in array 'stateAbbrevations'
      if (stateAbbreviation.equals(stateAbbreviations[i])) {
        return i; // return the index if abbreviation is found
      }
    }
    return -1; // State abbreviation not found
  }

  String[] getStateAbbreviations() { // retrieves state abbreviations from data in the table
    ArrayList<String> abbreviationsList = new ArrayList<String>(); // creates an ArrayList to store state abbreviations

    for (TableRow row : table.rows()) { // iterates over each row in the table
      String state = row.getString(5); // retrieves state abbreviation from the column at index 5 (column 6)
      if (!abbreviationsList.contains(state)) { // add the state abbreviation to the ArrayList if it's not already
        abbreviationsList.add(state);
      }
    }

    return abbreviationsList.toArray(new String[0]); // convert the ArrayList to an array of strings
  }

  // Get the maximum value from the flightsPerState array
  int getMax(int[] array) {
    int max = array[0]; // initialises max to the first element of the array
    for (int i = 1; i < array.length; i++) { // iterate over the array starting from the second element
      if (array[i] > max) { // if the current element is bigger than the max
        max = array[i]; // the max becomes the value of the current element
      }
    }
    return max; // return max value
  }

  // Assign colors based on flight count
  int getColorValue(int flights) {
    if (flights >= 0 && flights <= 30) { // flights between 0 and 30
      return 275; // Violet
    } else if (flights >= 31 && flights <= 60) { // flights between 31 and 60
      return 255; // Indigo
    } else if (flights >= 61 && flights <= 90) { // flights between 61 and 90
      return 210; // Blue
    } else if (flights >= 91 && flights <= 120) { // flights between 91 and 120
      return 120; // Green
    } else if (flights >= 121 && flights <= 150) { // flights between 121 and 150
      return 50; // Yellow
    } else if (flights >= 151 && flights <= 180) { // flights between 151 and 180
      return 30; // Orange
    } else {
      return 0; // Red for flights higher than 180
    }
  }
}
