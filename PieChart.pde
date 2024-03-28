//ZF
class PieChart {
  Table table;
  
  PieChart(Table table) {
    this.table = table;
  }

  void drawPieChart(float x, float y, float diameter, String inputAbbreviation) {
    HashMap<String, Integer> dateCounts = new HashMap<String, Integer>();

   
    for (TableRow row : table.rows()) {
      String date = row.getString("FL_DATE"); 
      String abbreviation = row.getString("ORIGIN"); 
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
      arc(x, y, diameter, diameter, startAngle, startAngle + angle);
      startAngle += angle;


      float labelX = x + cos(startAngle - angle / 2) * diameter / 2;
      float labelY = y + sin(startAngle - angle / 2) * diameter / 2;
      textAlign(CENTER, CENTER);
      fill(0);
      String[] dateParts = dates[i].split(" ");
      text(dateParts[0], labelX, labelY); // Display only the date part
    }
  }
}
