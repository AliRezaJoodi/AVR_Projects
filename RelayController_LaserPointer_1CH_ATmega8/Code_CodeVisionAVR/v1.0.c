//GitHub Account: GitHub.com/AliRezaJoodi

#include <mega8.h>

#define SENSOR_ON PINC.1
#define SENSOR_OFF PINB.1
#define RELAY PORTD.2

void main(void){
    DDRC.1=0; PORTC.1=1;
    DDRB.1=0; PORTB.1=1;
    DDRD.2=1; PORTD.2=0;
    
    while (1){
        if (SENSOR_ON==1 & SENSOR_OFF==0){RELAY=1;} 
        if (SENSOR_ON==0 & SENSOR_OFF==1){RELAY=0;}
    }
}

