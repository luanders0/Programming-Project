class Dialog_Pane { //Lukas A added Dialog_Pane class 26/3/24
  JFrame parent;
  JPanel panel;

  Dialog_Pane(String[] buttonText, String message, String title, ActionListener[] buttonListeners, int width, 
              int height) {
    parent = new JFrame(title, null);
    panel = new JPanel();
    
    panel.setLayout(new FlowLayout());
    parent.setLayout(new BorderLayout());
    
    JLabel label = new JLabel(message);
    label.setHorizontalAlignment(SwingConstants.CENTER);
    parent.add(label, BorderLayout.NORTH);
    
    JButton[] buttons = new JButton[buttonText.length];
    for (int i = 0; i < buttonText.length; i++) {
      buttons[i] = new JButton(buttonText[i]);
      panel.add(buttons[i]);
      buttons[i].addActionListener(buttonListeners[i]);
    }
    parent.add(panel, BorderLayout.CENTER);
    parent.setSize(width,height);
    parent.setLocationRelativeTo(null);
    parent.pack();
  }

  Dialog_Pane(JRadioButton[] radioButtons, String message) {
    parent = new JFrame();
    JRadioButton[] buttons = new JRadioButton[radioButtons.length];
    
    
    parent.pack();
  }

  void popup() {
    parent.setVisible(true);
  }
  
  String getInput(String message) {
    String input = JOptionPane.showInputDialog(parent, message, null);
    return input;
  }
}
