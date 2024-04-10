import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class BusyPie {
  DataTable table;
  HashMap<String, Integer> routeCounts; // Store flight counts for each route
  ArrayList<String> topRoutes; // Store top routes
  ArrayList<Integer> colors; // Store colors for each route
  int totalFlights; // Total number of flights
  color[] sliceColors = {#fa41e9, #9e30fc, #05c9e8, #04e09f, #54ed07, #98fabc}; //colours for pie slices


  BusyPie(DataTable flightTable) {
    routeCounts = new HashMap<String, Integer>();
    processData(flightTable);
    sortRoutes();
    assignColors();
  }

  void processData(DataTable flightTable) {
    table = flightTable;
    routeCounts = new HashMap<String, Integer>(); // Reset routeCounts to start fresh
    
    totalFlights = 0;
    DataSeries originColumn = table.get("ORIGIN");
    String[] origins = originColumn.asStringArray();
    DataSeries originCityColumn = table.get("ORIGIN_CITY_NAME");
    String[] originCities = originCityColumn.asStringArray();
    DataSeries destColumn = table.get("DEST");
    String[] dests = destColumn.asStringArray();
    DataSeries destCityColumn = table.get("DEST_CITY_NAME");
    String[] destCities = destCityColumn.asStringArray();
    
    for (int i = 0; i < originColumn.length(); i++) {
        String origin = origins[i];
        String originCity = originCities[i];
        String dest = dests[i];
        String destCity = destCities[i];
        
         String route = origin + " (" + originCity + ") to \n" + dest + " (" + destCity + ")";
        
        if (routeCounts.containsKey(route)) {
            int count = routeCounts.get(route);
            routeCounts.put(route, count + 1);
        } else {
            routeCounts.put(route, 1);
        }
        
        totalFlights++;
    }
}


  void sortRoutes() {
    topRoutes = new ArrayList<String>(routeCounts.keySet());
    Collections.sort(topRoutes, new Comparator<String>() {
      public int compare(String route1, String route2) {
        int count1 = routeCounts.get(route1);
        int count2 = routeCounts.get(route2);
        return Integer.compare(count2, count1);
      }
    }
    );
    // Limit to top 15 routes
    if (topRoutes.size() > 15) {
      topRoutes = new ArrayList<String>(topRoutes.subList(0, 15));
    }
  }

  void assignColors() {
    colors = new ArrayList<Integer>();
    for (int i = 0; i < topRoutes.size(); i++) {
      colors.add(color(random(255), random(255), random(255)));
    }
  }

void drawPieChart(float x, float y, float diameter) {
    int totalTopFlights = 0;
    for (String route : topRoutes) {
        totalTopFlights += routeCounts.get(route);
    }

    float startAngle = 0;
    for (String route : topRoutes) {
        float angle = map(routeCounts.get(route), 0, totalTopFlights, 0, TWO_PI);
        float endAngle = startAngle + angle;

        // Determine slice color
        int sliceColorIndex = topRoutes.indexOf(route) % sliceColors.length;
        color sliceColor = sliceColors[sliceColorIndex];

        // Draw the slice
        fill(sliceColor);
        arc(x, y, diameter, diameter, startAngle, endAngle);

        // If the mouse is over the slice make it bigger
        if (mouseOverSlice(x, y, diameter, startAngle, endAngle)) {
            float expandedDiameter = diameter + 20; // Increase diameter by 20 pixels
            arc(x, y, expandedDiameter, expandedDiameter, startAngle, endAngle);

            // Display label at the bottom right corner
            fill(0);
            textSize(20);
            String labelText = route + ": \n" + routeCounts.get(route) + " flights\n";
            text(labelText, 490, 570);
        }

        startAngle = endAngle;
    }
}



  boolean mouseOverSlice(float x, float y, float diameter, float startAngle, float endAngle) {
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
