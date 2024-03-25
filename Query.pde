class Query {
  int state;
  String query;
  String[] responses;

  Query(String query, String[] responses) {
    this.query = query;
    this.responses = responses;
  }

  void askQuestion () {
    println(query);
    println("Please enter a number between 1 and " + responses.length + ".");
    for (int i = 0; i < responses.length; i++) {
      print("" + (i+1));
      print(": ");
      println(responses[i]);
    }
  }

  void getAnswer() {
    response = key;
    if (response >= 1 && response <= responses.length) {
      state = response;
    } 
    else if (true) {
      state = -1;
      println("Error, please enter a number between 1 and " + responses.length + ".");
    }
    else {
      state = -1;
      input.next();
      println("Error, please enter a number");
    }
  }
