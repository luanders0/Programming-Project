//zara f
class Dates {
String FL_DATE;
Table table;
int i = 1;
//void setup() {
//    size(500, 500);

//  table = loadTable("flights2k.csv", "header");

//  println(table.getRowCount() + " total rows in table");

//  for (TableRow row : table.rows()) {

//    String MKT_CARRIER = row.getString("MKT_CARRIER");
//    String origin = row.getString("ORIGIN");
//    String ORIGIN_CITY_NAME = row.getString("ORIGIN_CITY_NAME");
//    String FL_DATE = row.getString("FL_DATE");

// println(origin + " (" + ORIGIN_CITY_NAME + ") has an ID of " + MKT_CARRIER + " was scheduled at " + FL_DATE);
// println(FL_DATE);
 
// String[] list = split(FL_DATE, '/');
// println(list[int(FL_DATE)]);
 
// //FL_DATE + " "+list+" " 

//}

void draw (){
   background(#3AA8FA);
   PFont mono;
   mono = createFont("Georgia-Italic-15.vlw",50);
   textFont(mono);
   fill(#020405);
   table = loadTable("flights2k.csv", "header");
   
   
   for (TableRow row : table.rows()) {
   String Flight = row.getString("FL_DATE");
  
   String[] lines = loadStrings("flights2k.csv");
   for(lines.length >= i ){
     String[] Flights = split(Flight, ' ');
   text(Flights[int(Flight)], 100, 100, 400, 400);
   }
}
}
}
