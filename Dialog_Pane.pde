class Dialog_Pane {
  String message;
  String[] buttonText;
  JFrame parent;
  JButton[] buttons;

  Dialog_Pane(String[] buttonText, String message, String title, ActionListener[] buttonListeners, int width, 
              int height) {
    this.message = message;
    this.buttonText = buttonText;
    parent = new JFrame(title);
    buttons = new JButton[buttonText.length];
    for (int i = 0; i < buttonText.length; i++) {
      buttons[i] = new JButton(buttonText[i]);
      parent.add(buttons[i]);
      buttons[i].addActionListener(buttonListeners[i]);
    }
    parent.setLayout(new FlowLayout());
    parent.setSize(width,height);
    parent.pack();
  }

  //Dialog_Pane(String[] buttonText, String message) {
  //  this.message = message;
  //  this.buttonText = buttonText;
  //  parent = new JFrame();
  //  buttons = new JButton[buttonText.length];
  //  for (int i = 0; i < buttonText.length; i++) {
  //    buttons[i] = new JButton(buttonText[i]);
  //    parent.add(buttons[i]);
  //  }
  //  parent.pack();
  //}

  void popup() {
    parent.setVisible(true);
  }
}
