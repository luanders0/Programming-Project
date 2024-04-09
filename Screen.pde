class Screen {

  static final int EVENT_NULL = -1;
  lateness_plot barPlot;
  ArrayList screenWidgets;
  color screenColor;

  Screen(color screenColor, ArrayList screenWidgets) {
    this.screenWidgets = screenWidgets;
    this.screenColor=screenColor;
  }

  Screen(color screenColor, lateness_plot barPlot) {
    this.screenColor = screenColor;
    this.barPlot = barPlot;
  }

  void add(Widget w) {
    screenWidgets.add(w);
  }

  void draw() {
    background(screenColor);
    if (screenWidgets != null) {
      for (int i = 0; i<screenWidgets.size(); i++) {
        Widget aWidget = (Widget)screenWidgets.get(i);
        aWidget.draw();
      }
    }
    else {
      barPlot.drawChart();
    }
  }

  int getEvent(int mx, int my) {
    for (int i = 0; i<screenWidgets.size(); i++) {
      Widget aWidget = (Widget) screenWidgets.get(i);
      int event = aWidget.getEvent(mx, my);
      if (event != EVENT_NULL) {
        return event;
      }
    }
    return EVENT_NULL;
  }

  ArrayList getWidgets() {
    return screenWidgets;
  }
}
