//GitHub Account: GitHub.com/AliRezaJoodi

#include <tiny13.h>

#define SENSOR_ON PINB.2
#define SENSOR_OFF PINB.1
#define RELAY PORTB.4

void main(void){
    DDRB.1=0; PORTB.1=1;
    DDRB.2=0; PORTB.2=1;
    DDRB.4=1; PORTB.4=0;
    
    while (1){
        if(SENSOR_ON==1 && SENSOR_OFF==0){RELAY=1;} 
        if(SENSOR_ON==0 && SENSOR_OFF==1){RELAY=0;}
    }
}

