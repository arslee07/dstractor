#include <ArduinoJson.h>
#include <ArduinoJson.hpp>
#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>
#include <SoftwareSerial.h>

SoftwareSerial arduinoSerial(D7, D8);

const char* ssid = "DSTractor";
const char* password = "traktorist";

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

StaticJsonDocument<256> commandJson;
StaticJsonDocument<256> telemetryJson;
char telemetryJson_buf[256];

WebSocketsServer webSocket = WebSocketsServer(7041);

void webSocketEvent(uint8_t num, WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_DISCONNECTED:
      {
        Serial.printf("[%u] Disconnected!\n", num);
        if (webSocket.connectedClients() == 0) {
          Serial.println("All clients disconnected! Resetting position...");
          commandPacket.left = 0;
          commandPacket.right = 0;
          arduinoSerial.write((uint8_t*)&commandPacket, sizeof(commandPacket));
        }
      }
      break;
    case WStype_CONNECTED:
      {
        IPAddress ip = webSocket.remoteIP(num);
        Serial.printf("[%u] Connected from %d.%d.%d.%d\n", num, ip[0], ip[1], ip[2], ip[3]);
      }
      break;
    case WStype_TEXT:
      {
        deserializeJson(commandJson, payload);
        commandPacket.left = commandJson["left"].as<int8_t>();
        commandPacket.right = commandJson["right"].as<int8_t>();
        arduinoSerial.write((uint8_t*)&commandPacket, sizeof(commandPacket));
      }
      break;
  }
}

void poll_sensors() {
  if (!(arduinoSerial.available() > 0)) return;

  arduinoSerial.readBytes((uint8_t*)&telemetryPacket, sizeof(telemetryPacket));

  telemetryJson["internal_temperature"] = telemetryPacket.internal_temperature;
  telemetryJson["external_temperature"] = telemetryPacket.external_temperature;
  telemetryJson["voltage"] = telemetryPacket.voltage;
  telemetryJson["lat"] = telemetryPacket.lat;
  telemetryJson["lon"] = telemetryPacket.lon;

  size_t sz = serializeJson(telemetryJson, telemetryJson_buf);
  webSocket.broadcastTXT(telemetryJson_buf, sz);
}

void setup() {
  Serial.begin(9600);
  arduinoSerial.begin(9600);

  delay(500);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  webSocket.begin();
  webSocket.onEvent(webSocketEvent);

  Serial.print("ESP8266 Web Server's IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  webSocket.loop();
  poll_sensors();
}
