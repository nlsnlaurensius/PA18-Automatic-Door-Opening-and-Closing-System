
#include <Arduino.h>
#include <LiquidCrystal.h>

#define TRIG_PIN 4    // PD4
#define ECHO_PIN 5    // PD5
#define DISTANCE_THRESHOLD 10  // Jarak (cm)

LiquidCrystal lcd(8, 9, 4, 5, 6, 7);


extern "C" {
  int main();
  void setup_lcd();
  void print_init_lcd();
  void print_door_opening_lcd();
  void print_door_closing_lcd();
  bool check_distance();  // Fungsi HC-SR04
}

// Fungsi ukur jarak dengan HC-SR04
bool check_distance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  
  unsigned long duration = pulseIn(ECHO_PIN, HIGH, 30000); // Timeout 30ms
  if (duration == 0) return false;
  
  float distance = (duration * 0.0343) / 2;
  return distance <= DISTANCE_THRESHOLD;
}

void setup_lcd() {
  Serial.begin(9600);
  lcd.begin(16, 2);
  lcd.clear();
  
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void print_init_lcd() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Pintu: TERTUTUP ");
}

void print_door_opening_lcd() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Pintu: MEMBUKA  ");
}

void print_door_closing_lcd() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Pintu: MENUTUP  ");
}

//-----------------------------------------------
void setup() {
  main();
}
//-----------------------------------------------
void loop() {}
