#include "Arduino.h"
#include "PlainProtocol.h"
#include "blunoAccessory.h"

#define minute3 180 * 1000

PlainProtocol myBLUNO(Serial, 115200);
blunoAccessory myAccessory;

int humidity = 0;
int temperature = 0;

void setup() {
  myAccessory.begin();
  myBLUNO.init();

  temperature = myAccessory.readTemperature();
  humidity = myAccessory.readHumidity();
}

void loop()
{
  if (myBLUNO.available()) {
    if (myBLUNO.equals("TEMP")) {
      myBLUNO.write("TEMP", temperature);
    }
    else if (myBLUNO.equals("HUMID")) {
      myBLUNO.write("HUMID", humidity);
    }
    else {
      myBLUNO.write("UNKNOWN", -1);
    }
  }

  static unsigned long DHT11Timer = millis();
  if (millis() - DHT11Timer >= minute3) {
    DHT11Timer = millis();

    temperature = myAccessory.readTemperature();
    myBLUNO.write("TEMP", temperature);

    humidity = myAccessory.readHumidity();
    myBLUNO.write("HUMID", humidity);
  }
}
