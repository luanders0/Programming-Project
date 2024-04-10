class Widget { // Lukas A added widget functionality (not debugged) 3/14/2024
  int x, y, width, height, fontSize;
  String label; int event;
  color widgetColor, labelColor, backgroundColor;
  PFont widgetFont;
  boolean mouseOver;
  PImage image;

  Widget(int x,int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event){ 
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor; 
    this.widgetFont=widgetFont;
    labelColor= color(0);
   }
   
  Widget(int x,int y, int width, int height, int fontSize, String label, color widgetColor, PFont widgetFont, int event){ // Avery H edited to fit different widget types
    this.x=x; 
    this.y=y; 
    this.width = width;
    this.height = height;
    this.fontSize = fontSize;
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor; 
    this.widgetFont=widgetFont;
    labelColor= color(255);
   }
   
  Widget(int x,int y, PImage image, int event){
    this.x=x; 
    this.y=y; 
    this.width = image.width; 
    this.height= image.height;
    this.event=event; 
    this.image = image;
   }
   
   void draw(){
    if (image != null) {
      image(image, x, y);
    }
    else {
      fill(widgetColor);
      rect(x,y,width,height, 10);
   
      fill(labelColor);
      text(label, x + width/2, y + height/2);
      textAlign(CENTER, CENTER);
      
    }
  }
  int getEvent(int mX, int mY){
     if(mX>x && mX < x+width && mY >y && mY <y+height){
        return event;
     }
     return EVENT_NULL;
  }
}
