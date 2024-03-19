final int BAR_WIDTH = 20;
final int EVENT_NULL = 0;

//constants for latenesss pie chart
Table table;
int difference = 0;
int schDepHour = 0;
int schDepMinute = 0;
int depHour = 0;
int depMinute = 0;
int[] flightStatus = {0, 0, 0, 0}; // Index 0: early, Index 1: on time, Index 2: late, Index 3: Cancelled
int earlyFlightCount = 0;
int onTimeFlightCount = 0;
int lateFlightCount = 0;
int cancelledFlightCount = 0;
int totalFlightCount = -1;

void setup() {
  String[] lines = loadStrings("flights2k.csv");
  println("there are " + lines.length + " lines");
  size (500, 500);
}

void draw() {
  background(255);
  pieChart(300, flightStatus);
  key();
  lateness();
}
