//GitHub Account: GitHub.com/AliRezaJoodi

#include <tiny2313.h>

#define SENSOR_ON PIND.6
#define SENSOR_OFF PINB.6
#define RELAY PORTD.5

void main(void){
    DDRD.6=0; PORTD.6=1;
    DDRB.6=0; PORTB.6=1;
    DDRD.5=1; PORTD.5=0;
    
    while (1){
        if(SENSOR_ON==1 && SENSOR_OFF==0){RELAY=1;} 
        if(SENSOR_ON==0 && SENSOR_OFF==1){RELAY=0;}
    }
}

