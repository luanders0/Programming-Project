//zara f
class Dates {
  
Table table;
ArrayList<Integer> dayList, monthList, yearList;
ArrayList<String> dateList;
String lines;
int[] dayCounts;
int pieSingle;
  
  // Constructor
  //this.dates=dates
  Dates(String dates, int days, int months, int years, String line1, int dCounts){
    dateList = dates;
    dayList =  days;
    monthList = months;
    yearList = years;
    lines = line1;
    dayCounts = dCounts;
  }
  //dateList = new ArrayList<String>();
  //dayList = new ArrayList<Integer>();
  //monthList = new ArrayList<Integer>();
  //yearList = new ArrayList<Integer>();
  
  // Initialize array for counting month occurrences
  //dayCounts = new int[7]; // Index 0 is not used
  
  for (TableRow row : table.rows()) {
    String dateTimeString = row.getString("FL_DATE");
    String[] dateParts = dateTimeString.split(" ");
    dateList.add(dateParts[0]);
    String[] dateComponents = dateParts[0].split("/");

    int month = Integer.parseInt(dateComponents[2]); 
    int day = Integer.parseInt(dateComponents[1]); 
    int year = Integer.parseInt(dateComponents[0]); 
    
    dayList.add(day);
    monthList.add(month);
    yearList.add(year);
    
     dayCounts[day]++;

    //println(monthList);
  
  for (int i = 1; i <= 6; i++) {
    println("Day " + i + " count: " + dayCounts[i]);
  }
  
  void barChart{
      //rewrite to adapt the screen
  line(60, 470, 60, 45); 
  line(60, 470, 450, 470);
  float barWidth = width / (dayCounts.length  + 1);
  float maxDataValue = (max(dayCounts ) - 1);
  
  for (int i = 1; i < dayCounts.length; i++) {
    float x = i * barWidth;
    float y = map(dayCounts[i], 0, maxDataValue, height, 50);
    float barHeight = height - y;
    

  fill(0, 0, 255);
  rect(x , y , barWidth - 10 , barHeight - 30);
  fill(0);
  textAlign(CENTER, BOTTOM);
  text(dayCounts[i], x + barWidth / 2, y - 5);
  textAlign(CENTER, TOP);
  text("01/0" + i +"/2022", x + barWidth / 2, height - 28);
}
  textAlign(CENTER, BOTTOM);
  text("Dates planes flown",230,height - 5); 
  textAlign(RIGHT, BOTTOM);
  translate(30, height / 2); // Translate to the desired position
  rotate(-HALF_PI); // Rotate the text by -90 degrees
  text("Amount of planes flown", 0, 0); 
  }
  }
 
  }
