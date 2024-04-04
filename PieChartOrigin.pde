// PieChart class
class PieChartOrigin {
  color startColor;
  color endColor;
  String[] data;
  String[] threeLetterStrings;
  int[] counts;
  int totalStrings;

  PieChartOrigin(String filename, color startColor, color endColor) {
    this.startColor = startColor;
    this.endColor = endColor;
    
    // Load data from CSV file
    String[] lines = loadStrings(filename);
    
    // Initialize arrays
    data = new String[lines.length];
    totalStrings = lines.length; // Assuming each line contains one three-letter string
    threeLetterStrings = new String[totalStrings];
    counts = new int[totalStrings];
    
    // Parse CSV data
    for (int i = 0; i < lines.length; i++) {
      String[] values = split(lines[i], ',');
      data[i] = values[4]; // Assuming three-letter strings are in the first column
    }
    
    // Compute frequency counts
    for (int i = 0; i < totalStrings; i++) {
      int count = 0;
      String currentString = data[i];
      // Check if the current string has already been counted
      boolean counted = false;
      for (int j = 0; j < i; j++) {
        if (currentString.equals(threeLetterStrings[j])) {
          counted = true;
          break;
        }
      }
      if (!counted) {
        threeLetterStrings[i] = currentString;
        for (int j = i; j < totalStrings; j++) {
          if (currentString.equals(data[j])) {
            count++;
          }
        }
        counts[i] = count;
      }
    }
  }

  void draw(float x, float y, float diameter) {
    float startAngle = 0;
    for (int i = 0; i < counts.length; i++) {
      float angle = map(counts[i], 0, totalStrings, 0, TWO_PI);
      float endAngle = startAngle + angle;
      // Interpolate color between startColor and endColor
      fill(lerpColor(startColor, endColor, map(i, 0, counts.length, 0, 1))); 
      arc(x, y, diameter, diameter, startAngle, endAngle);
      // Compute label position
      float labelAngle = startAngle + angle / 2;
      float labelRadius = diameter * 0.5;
      float labelX = x + cos(labelAngle) * labelRadius;
      float labelY = y + sin(labelAngle) * labelRadius;
      // Display label
      textAlign(CENTER, CENTER);
      fill(0);
      text(threeLetterStrings[i] + " " + counts[i], labelX, labelY);
      startAngle = endAngle;
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(20);
      text("Number of Flights Flown per State", width/2, 30);
    }
  }
}
