#include <Firmata.h>

void setup()
{
  Firmata.setFirmwareVersion(FIRMATA_MAJOR_VERSION, FIRMATA_MINOR_VERSION);
  Firmata.attach(START_SYSEX, sysexCallback);
  Firmata.begin(57600);
}

void loop()
{
  while(Firmata.available()) {
    Firmata.processInput();
  }
}

void sysexCallback(byte command, byte argc, byte*argv)
{
  switch(command){
  case 0x01: // LED Blink Command
    if(argc < 3) break;
    byte blink_pin;
    byte blink_count;
    int delayTime;
    blink_pin = argv[0];
    blink_count = argv[1];
    delayTime = argv[2] * 100;

    pinMode(blink_pin, OUTPUT);
    byte i;
    for(i = 0; i < blink_count; i++){
      digitalWrite(blink_pin, true);
      delay(delayTime);
      digitalWrite(blink_pin, false);
      delay(delayTime);
    }
    break;
  }
}
