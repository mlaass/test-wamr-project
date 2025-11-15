#include <Arduino.h>

void setup() {
  // USB CDC needs this on ESP32-C3
  Serial.begin(115200);

  // Wait for USB CDC connection (important for ESP32-C3)
  while (!Serial && millis() < 5000) {
    delay(10);
  }

  delay(500);

  Serial.println();
  Serial.println();
  Serial.println("=================================");
  Serial.println("WeAct ESP32-C3FH4 CoreBoard Test");
  Serial.println("=================================");
  Serial.print("Chip Model: ");
  Serial.println(ESP.getChipModel());
  Serial.print("CPU Freq: ");
  Serial.print(ESP.getCpuFreqMHz());
  Serial.println(" MHz");
  Serial.print("Free Heap: ");
  Serial.println(ESP.getFreeHeap());
  Serial.println("=================================");
  Serial.println("SUCCESS - Board is working!");
  Serial.println("=================================");
}

void loop() {
  static unsigned long count = 0;
  Serial.print("Loop ");
  Serial.print(count++);
  Serial.print(" - Heap: ");
  Serial.println(ESP.getFreeHeap());
  delay(1000);
}
