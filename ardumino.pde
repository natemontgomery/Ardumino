/*
 * MIDI Piezo Drum Kit
 *
 * Based on code from todbot, modified to use Schmitt trigger in circuit
 *
 * Uses four piezos as drum pads for midi control
 *
 * DIN-5 pinout:                                  _____ 
 *    pin 2 - Gnd                                /     \
 *    pin 4 - 220 ohm resistor to +5V           | 3   1 |  MIDI jack
 *    pin 5 - Arduino D1 (TX)                   |  5 4  |
 *    all other pins - unconnected               \__2__/
 */

// what midi channel we're sending on
// ranges from 0-15
// one channel is enough for all sounds
#define drumchan           1

// general midi drum notes
// will depend on MIDI interface/program
#define note_bassdrum     35
#define note_snaredrum    38
#define note_hihatclosed  42
#define note_hihatopen    44
#define note_crash        49

// define the pins we use
#define piezoAPin  5
#define piezoBPin  6
#define piezoCPin  9
#define piezoDPin  10
#define ledPin     13  // for midi out status

int val,t;
int piezoAState = LOW;
int piezoBState = LOW;
int piezoCState = LOW;
int piezoDState = LOW;
int currentStateA = LOW;
int currentStateB = LOW;
int currentStateC = LOW;
int currentStateD = LOW;

void setup() {
  pinMode(piezoAPin, INPUT);
  pinMode(piezoBPin, INPUT);
  pinMode(piezoCPin, INPUT);
  pinMode(piezoDPin, INPUT);
  pinMode(ledPin, OUTPUT);
  Serial.begin(31250);   // set MIDI baud rate
}

void loop() {
  // piezos are passed through an inverting schmitt trigger
  // in order to keep everything strictly digital
  currentStateA = digitalRead(piezoAPin);
  if (currentStateA==HIGH && piezoAState==LOW) {
    noteOn(drumchan,note_hihatopen, 100);
  }
  if (currentStateA==LOW && piezoAState==HIGH) {
    noteOff(drumchan,note_hihatopen,0);
  }
  piezoAState=currentStateA;
  
  currentStateB = digitalRead(piezoBPin);
  if (currentStateB==HIGH && piezoBState==LOW) {
    noteOn(drumchan,note_hihatopen, 100);
  }
  if (currentStateB==LOW && piezoBState==HIGH) {
    noteOff(drumchan,note_hihatopen,0);
  }
  piezoBState=currentStateB;
  
  currentStateC = digitalRead(piezoCPin);
  if (currentStateC==HIGH && piezoCState==LOW) {
    noteOn(drumchan,note_hihatopen, 100);
  }
  if (currentStateC==LOW && piezoCState==HIGH) {
    noteOff(drumchan,note_hihatopen,0);
  }
  piezoCState=currentStateC;
  
  currentStateD = digitalRead(piezoDPin);
  if (currentStateD==HIGH && piezoDState==LOW) {
    noteOn(drumchan,note_hihatopen, 100);
  }
  if (currentStateD==LOW && piezoDState==HIGH) {
    noteOff(drumchan,note_hihatopen,0);
  }
  piezoDState=currentStateD;
}

// Send a MIDI note-on message.  Like pressing a piano key
// channel ranges from 0-15
void noteOn(byte channel, byte note, byte velocity) {
  midiMsg( (0x90 | channel), note, velocity);
}

// Send a MIDI note-off message.  Like releasing a piano key
void noteOff(byte channel, byte note, byte velocity) {
  midiMsg( (0x80 | channel), note, velocity);
}

// Send a general MIDI message
void midiMsg(byte cmd, byte data1, byte data2) {
  digitalWrite(ledPin,HIGH);  // indicate we're sending MIDI data
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
  digitalWrite(ledPin,LOW);
}

