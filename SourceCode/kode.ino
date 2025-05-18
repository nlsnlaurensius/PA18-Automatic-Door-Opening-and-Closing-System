#include <avr/io.h>
#include <avr/interrupt.h>

#define TRIG_PIN 2    
#define ECHO_PIN 3    

// Sensor Parameters
#define PROXIMITY_THRESHOLD 30  
#define SENSOR_CHECK_INTERVAL 250 

volatile uint16_t distance_cm = 0;
volatile uint8_t sensor_door_trigger = 0;

unsigned long last_sensor_reading = 0;

extern "C" {
  extern volatile uint8_t servo_position;
  extern volatile uint8_t override_flag;
  
  void move_servo_left(void);
  void move_servo_right(void);
  void print_door_opening(void);
  void print_door_closing(void);
}

void setup() {
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  
}
