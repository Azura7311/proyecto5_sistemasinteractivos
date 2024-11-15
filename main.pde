import processing.net.*;
import oscP5.*;
import netP5.*;

// Global variables
OscP5 osc;
NetAddress myRemoteLocation;
OscMessage myMessage;
ArrayList<String[]> csv;
int[] oscSounds = {-1, -1, -1, -1};
int[] sequence;
int x = 50, value, max = -1, localY, shapeColor, i = 1;
int[] y = {50, 90, 130, 170};
boolean step = false;

void setup()
{
  // Window size
  size(1500, 800);
  // Load csv
  selectInput("Select a file to process:", "fileSelected");
  // Connect to pure data using OSC
  osc = new OscP5(this, 5555);
  myRemoteLocation = new NetAddress("127.0.0.1", 7311);
  // Add starting ellipses
  fill(0);
  ellipse(x, y[0], 30, 30);
  ellipse(x, y[1], 30, 30);
  ellipse(x, y[2], 30, 30);
  ellipse(x, y[3], 30, 30);
  x += 15;
}

void draw()
{
  // Only draw when the csv is ready and until all the csv has been read
  if(csv != null && sequence != null && i < sequence.length)
  {
    // When a whole step is done, send the notes to pure data to make the sound
    if(step)
    {
      step = false;
      if(oscSounds[0] != -1)
      {
        myMessage = new OscMessage("/instrument0");
        myMessage.add(1);
        osc.send(myMessage, myRemoteLocation);
        myMessage = new OscMessage("/note0");
        myMessage.add(oscSounds[0]);
        osc.send(myMessage, myRemoteLocation);
      }
      if(oscSounds[1] != -1)
      {
        myMessage = new OscMessage("/instrument1");
        myMessage.add(1);
        osc.send(myMessage, myRemoteLocation);
        myMessage = new OscMessage("/note1");
        myMessage.add(oscSounds[1]);
        osc.send(myMessage, myRemoteLocation);
      }
      if(oscSounds[2] != -1)
      {
        myMessage = new OscMessage("/instrument2");
        myMessage.add(1);
        osc.send(myMessage, myRemoteLocation);
        myMessage = new OscMessage("/note2");
        myMessage.add(oscSounds[2]);
        osc.send(myMessage, myRemoteLocation);
      }
      if(oscSounds[3] != -1)
      {
        myMessage = new OscMessage("/instrument3");
        myMessage.add(1);
        osc.send(myMessage, myRemoteLocation);
        myMessage = new OscMessage("/note3");
        myMessage.add(oscSounds[3]);
        osc.send(myMessage, myRemoteLocation);
      }
      oscSounds[0] = -1;
      oscSounds[1] = -1;
      oscSounds[2] = -1;
      oscSounds[3] = -1;
      // Stop to produce animation
      delay(500);
    }
    value = sequence[i];
    localY = y[value];
    // Select the color of the shape according to the data value. Using log scale because of the difference in sizes between the data
    shapeColor = floor(log(int(csv.get(i)[0])) * 255 / log(max));
    // 0 = Gray scale, 1 = Red, 2 = Green, 3 = Blue
    if(value == 0)
    {
      fill(shapeColor);
    }
    else if(value == 1)
    {
      fill(color(shapeColor, 0, 0));
    }
    else if(value == 2)
    {
      fill(color(0, shapeColor, 0));
    }
    else
    {
      fill(color(0, 0, shapeColor)); 
    }
    ellipse(x + 25, localY, 30, 30);
    // Set note value. Using log scale.
    oscSounds[value] = floor(log(int(csv.get(i)[0])) * 100 / log(max));
    if(value == 0)
    {
      x += 40;
      step = true;
    }
    i += 1;
    // Continue in new row after reaching the end of the window
    if(x > 1400)
    {
      x = 25;
      for(int j = 0; j < y.length; ++j)
      {
        y[j] += 180;
      }
    }
  }
}

// Get the max value from the csv
void getMaxCsv()
{
  for(int i = 0; i < csv.size(); ++i)
  {
    if(int(csv.get(i)[0]) > max)
    {
      max = int(csv.get(i)[0]);
    }
  }
}

// Load the csv and get csv-related values
void fileSelected(File selection)
{
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    BufferedReader reader = createReader(selection);
    csv = csvToList(reader);
    sequence = getSequence();
    getMaxCsv();
  }
}

// Transform the csv data into an array of arrays
ArrayList<String[]> csvToList(BufferedReader reader)
{
  ArrayList<String[]> csv = new ArrayList<String[]>();
  String[] row;
  String line;
  try
  {
    while((line = reader.readLine()) != null)
    {
      row = split(line, ",");
      csv.add(row);
    }
  }
  catch (IOException e)
  {
    e.printStackTrace();
  }
  return csv;
}
// Give each value a position in the row based in the modulus of the first of the row
int[] getSequence()
{
  int[] sequence = new int[csv.size()];
  int type = -1;
  int node = 0;
  for(int i = 0; i < csv.size(); ++i)
  {
    node = int(csv.get(i)[0]);
    if(type < 0)
    {
      type = node % 4;
    }
    sequence[i] = type;
    type -= 1;
  }
  return sequence;
}
