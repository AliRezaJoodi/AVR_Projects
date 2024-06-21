// GitHub Account:  GitHub.com/AliRezaJoodi
// MCU Frequency:   8Mhz

#ifndef INCLUDED_BUZZER
    #define INCLUDED_BUZZER

#include <delay.h>

#ifndef PORTS_BUZZER
    #define PORTS_BUZZER

    #define BUZZER_ACTIVE   1     
    #define BUZZER_DDR      DDRB.1
    #define BUZZER_PORT     PORTB.1
    #define BUZZER_PIN      PINB.1 
    #define BUZZER          BUZZER_PORT 
#endif

//Single beep_mode
#define BEEP_UP         0
#define BEEP_DOWN       1
#define BEEP_SET        2
#define BEEP_ERROR      3

//********************************************************
void Buzzer_Config(void){
    BUZZER_DDR=1; BUZZER_PORT=!BUZZER_ACTIVE;
}

#pragma used+

//*******************************************************
void _UpOrDownSound(void){
    BUZZER=BUZZER_ACTIVE;
    delay_ms(80);
    BUZZER=!BUZZER_ACTIVE;  
}

//*******************************************************
void _SetSound(void){    
    BUZZER=BUZZER_ACTIVE;
    delay_ms(220);
    BUZZER=!BUZZER_ACTIVE;
}

//*******************************************************
void _ErrorSound(void){
    BUZZER=BUZZER_ACTIVE;
    delay_ms(500);
    BUZZER=!BUZZER_ACTIVE;  
}

//*******************************************************
// Call in Main
void Buzzer_MakeBeep(char mode){    
    switch(mode){  
        case BEEP_UP:
            _UpOrDownSound();
            break;
        case BEEP_DOWN:
            _UpOrDownSound();
            break;
        case BEEP_SET: 
            _SetSound();
            break;
        case BEEP_ERROR: 
            _ErrorSound();
            break;
    }
} 

#pragma used-

#endif
