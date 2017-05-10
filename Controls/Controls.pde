import controlP5.*;


import netP5.*;
import oscP5.*;

OscP5 osc = new OscP5(this, 12000);
NetAddress address = new NetAddress("127.0.0.1", 4559);
ControlP5 cp5;
Knob wind;
RadioButton mode;
Slider2D bpf;
Slider2D echo;

void setup() {
  size(1000,500);
  background(0);
  cp5 = new ControlP5(this);
  wind = cp5.addKnob("window").setRange(0,16)
    .setNumberOfTickMarks(16)
    .snapToTickMarks(true)
    .setValue(8)
    .setRadius(100);
  window(8);
  mode = cp5.addRadioButton("modeChange")
    .setPosition(275, 25)
    .setSize(75, 75)
    .addItem("Silence", 0)
    .addItem("Generate", 2)
    .addItem("Loop", 1)
    .activate(0);
 modeChange(0);
 bpf = cp5.addSlider2D("filter")
   .setMaxX(128)
   .setMaxY(99)
   .setArrayValue(new float[] {100, 60})
   .setCursorX(100)
   .setCursorY(60)
   .setPosition(450, 25)
   .setSize(200, 200);
  filter(100, 60);
  echo = cp5.addSlider2D("echo")
    .setMaxX(59)
    .setMaxY(10)
    .setMinX(1)
    .setMinY(1)
    .setArrayValue(new float[] {20, 2.5})
    .setPosition(700, 25)
    .setSize(200, 200);
  echo(20, 2.5);
}

OscMessage message(String msg) {
  return new OscMessage("/rand/" + msg);
}

void window(int value) {
  OscMessage msg = message("windowsize");
  msg.add(value);
  oscEvent(msg);
}

void modeChange(int value) {
  OscMessage msg = message("change");
  msg.add(value);
  oscEvent(msg);
}

void filter(float x, float y) {
   OscMessage msg = message("bpf");
   msg.add(x);
   msg.add(y/100);
   oscEvent(msg);
}

void echo(float x, float y) {
  OscMessage msg = message("echo");
  msg.add(x/10);
  msg.add(y/10);
  oscEvent(msg);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(bpf)) {
    float[] val = bpf.getArrayValue();
    filter(val[0], val[1]);
  } else if (theEvent.isFrom(echo)) {
    float[] val = echo.getArrayValue();
    echo(val[0], val[1]);
  }
}

void draw() {
  clear();
}

void oscEvent(OscMessage msg) {
  osc.send(msg, address);
}