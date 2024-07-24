#include <Servo.h>

#include <SoftwareSerial.h>

Servo left;
Servo right;

struct __attribute__((packed)) {
  int8_t left, right;
} commandPacket;

struct __attribute__((packed)) {
  float internal_temperature,
    external_temperature,
    voltage,
    lat,
    lon;
} telemetryPacket;

SoftwareSerial wemosSerial(A1, A0);

unsigned long telemetryTs = millis();
void handleTelemetry() {
  if (millis() - telemetryTs < 1000) return;

  // здесь считываем телеметрию, пока просто рандом
  telemetryPacket.internal_temperature = (float)(random(40) + 350) / 10;
  telemetryPacket.external_temperature = (float)(random(20) + 280) / 10;
  telemetryPacket.voltage = (float)(random(50) + 750) / 10;
  telemetryPacket.lat = (float)(random(180000) - 90000) / 1000;
  telemetryPacket.lon = (float)(random(180000)) / 1000;

  wemosSerial.write((uint8_t*)&telemetryPacket, sizeof(telemetryPacket));

  telemetryTs = millis();
}

void handleCommand() {
  if (wemosSerial.available() > 0) {
    wemosSerial.readBytes((uint8_t*)&commandPacket, sizeof(commandPacket));

    Serial.println("RECEIVED PACKET");
    Serial.print("Left: ");
    Serial.print(commandPacket.left);
    Serial.print(" | Right:");
    Serial.print(commandPacket.right);
    Serial.println("\n");

    int degreeLeft = map(commandPacket.left, -64, 64, 95, 115);
    int degreeRight = map(commandPacket.right, -64, 64, 80, 100);
    attach();
    left.write(degreeLeft);
    right.write(degreeRight);
    detach();
  }
}

void attach() {
  delay(100);
  left.attach(12);
  right.attach(7);
  delay(100);
}

void detach() {
  delay(100);
  left.detach();
  right.detach();
  delay(100);
}

void setup() {
  Serial.begin(9600);
  wemosSerial.begin(9600);

  attach();
  right.write(105);
  left.write(90);
  detach();

  delay(200);
}

void loop() {
  handleCommand();
  handleTelemetry();
}
