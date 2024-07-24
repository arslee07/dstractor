#include <Esplora.h>
#include <XInput.h>

// смещение направлений
#define X_OFFSET 1
#define Y_OFFSET -20

// модуль значения активации
#define X_GAP 16
#define Y_GAP 16

void setup() {
  Serial.begin(9600);
  XInput.setAutoSend(false);
  XInput.begin();
}

void loop() {
  int xValue = Esplora.readJoystickX();
  int yValue = Esplora.readJoystickY();

  // калибровка
  xValue += X_OFFSET;
  yValue += Y_OFFSET;

  if (xValue >= -X_GAP && xValue <= X_GAP)
    xValue = 0;

  if (yValue >= -Y_GAP && yValue <= Y_GAP)
    yValue = 0;

  // преобразование диапазона значений для xinput
  xValue = map(xValue, -512 + X_OFFSET, 512 + X_OFFSET, 32767, -32768);
  yValue = map(yValue, -512 + Y_OFFSET, 512 + Y_OFFSET, 32767, -32768);

  XInput.setJoystick(JOY_LEFT, xValue, yValue);

  XInput.setButton(BUTTON_X, !(Esplora.readButton(SWITCH_LEFT)));
  XInput.setButton(BUTTON_Y, !(Esplora.readButton(SWITCH_UP)));
  XInput.setButton(BUTTON_B, !(Esplora.readButton(SWITCH_RIGHT)));
  XInput.setButton(BUTTON_A, !(Esplora.readButton(SWITCH_DOWN)));
  XInput.setButton(JOY_LEFT, !(Esplora.readJoystickButton()));

  XInput.send();
  delay(10);
}
