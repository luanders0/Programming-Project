import processing.data.Table;
import processing.data.TableRow;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class BusyPie {
  Table table;
  HashMap<String, Integer> routeCounts; // Store flight counts for each route
  ArrayList<String> topRoutes; // Store top routes
  ArrayList<Integer> colors; // Store colors for each route
  int totalFlights; // Total number of flights
  
  BusyPie(Table flightTable) {
    table = flightTable;
    routeCounts = new HashMap<String, Integer>();
    processData();
    sortRoutes();
    assignColors();
  }
  
  void processData() {
    totalFlights = 0;
    for (TableRow row : table.rows()) {
      String origin = row.getString("ORIGIN");
      String destination = row.getString("DEST");
      String route = origin + "-" + destination;
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
    });
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
    fill(colors.get(topRoutes.indexOf(route)));
    arc(x, y, diameter, diameter, startAngle, endAngle);
    
     // Calculate label position
    float labelAngle = startAngle + angle / 2;
    float labelRadius = diameter / 2.5;
    float labelX = x + cos(labelAngle) * labelRadius;
    float labelY = y + sin(labelAngle) * labelRadius;
    
    // Draw label
    textAlign(CENTER, CENTER);
    fill(0);
    String[] routeCities = route.split("-");
    String label = routeCities[0] + " to " + routeCities[1] + ": " + routeCounts.get(route) + " flights";
    text(label, labelX, labelY);
    
    startAngle = endAngle;
  }
}
}
