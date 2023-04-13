//GitHub Account: GitHub.com/AliRezaJoodi

#include <tiny26.h>

#define SENSOR_ON PINA.7
#define SENSOR_OFF PINA.2
#define RELAY PORTB.3

void main(void){
    DDRA.7=0; PORTA.7=1;
    DDRA.2=0; PORTA.2=1;
    DDRB.3=1; PORTB.3=0;
    
    while (1){
        if(SENSOR_ON==1 && SENSOR_OFF==0){RELAY=1;} 
        if(SENSOR_ON==0 && SENSOR_OFF==1){RELAY=0;}
    }
}

