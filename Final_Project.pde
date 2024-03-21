final int BAR_WIDTH = 20;


void setup() {
  size(600, 600);
  
    //zf
  dateList = new ArrayList<String>();
  dayList = new ArrayList<Integer>();
  monthList = new ArrayList<Integer>();
  yearList = new ArrayList<Integer>();
  dayCounts = new int[7];
  date = new Dates(dateList, dayList, monthList, yearList, lines, dayCounts);
  //zf
}

void draw() {
  
}
