class PieChartOrigin {
    DataTable table; // DataTable object to store the data
    String[] threeLetterStrings;
    int[] counts;
    int totalStrings;
    color[] sliceColors = {#acfeff, #89e2ff, #6fa8ff, #5349ff, #7420ff, #98fabc};

    // Constructor that takes a DataTable object as input
    PieChartOrigin(DataTable table) {
        setTable(table);
        initializeData(); // Call the method to initialize data
    }
  
    // Method to set the DataTable object
    void setTable(DataTable table) {
        this.table = table;
    }

    // Method to initialize data
    void initializeData() {
        // Extract necessary data from the DataTable object
        DataSeries originColumn = table.get("ORIGIN");
        String[] origins = originColumn.asStringArray();
 
        // Initialize arrays
        totalStrings = originColumn.length(); // Assuming each row corresponds to one three-letter string
        threeLetterStrings = new String[totalStrings];
        counts = new int[totalStrings];

        // Compute frequency counts
        for (int i = 0; i < totalStrings; i++) {
            int count = 0;
            String currentString = origins[i];
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
                    if (currentString.equals(origins[j])) {
                        count++;
                    }
                }
                counts[i] = count;
            }
        }
    }
        void updateTable(DataTable table) {
        setTable(table);
        initializeData();
    }

    // Draw method similar to the original one
    void draw(float centerX, float centerY, float x, float y, float diameter) {
        // Draw the pie chart using the extracted data
        float startAngle = 0;
        for (int i = 0; i < counts.length; i++) {
            float angle = map(counts[i], 0, totalStrings, 0, TWO_PI);
            float endAngle = startAngle + angle;

            // Check if mouse is over the current slice
            if (mouseOverSlice(centerX, centerY, x, y, diameter, startAngle, endAngle)) {
                fill(0);
                textSize(20); // Use a bolder font and larger size
                text(threeLetterStrings[i] + ": " + counts[i], 490, 570);

                float expandedDiameter = diameter + 20; // Increase diameter by 20 pixels
                fill(sliceColors[i % sliceColors.length]);
                arc(centerX, centerY, expandedDiameter, expandedDiameter, startAngle, endAngle);
            } else {
                // Regular drawing if mouse is not over the slice
                fill(sliceColors[i % sliceColors.length]);
                arc(centerX, centerY, diameter, diameter, startAngle, endAngle);
            }
            startAngle = endAngle;
        }
    }

    // MouseOverSlice method similar to the original one
    boolean mouseOverSlice(float centerX, float centerY, float x, float y, float diameter, float startAngle, float endAngle) {
        // Compute angle to the mouse position
        float angleToMouse = atan2(mouseY - centerY, mouseX - centerX);
        // Normalize angle to be between 0 and TWO_PI
        if (angleToMouse < 0) {
            angleToMouse += TWO_PI;
        }
        // Check if angle to mouse is within the range of the current slice
        return angleToMouse >= startAngle && angleToMouse <= endAngle && dist(mouseX, mouseY, centerX, centerY) <= diameter / 2;
    }
}
