// GitHub Account: GitHub.com/AliRezaJoodi

#include <delay.h>

#ifndef _INCLUDED_BUTTON
    #define _INCLUDED_BUTTON
    
    #ifndef DISABLE_BUTTON
        #define ENABLE_BUTTON
    #endif

    #define PRESSED             0  
    #define BUTTONLAG           1200      //Button Lag: 0~65535
        
    #define BUTTON1_DDR         DDRB.6
    #define BUTTON1_PORT        PORTB.6
    #define BUTTON1_PIN         PINB.6
    #define BUTTON1             BUTTON1_PIN
    
    #define BUTTON2_DDR         DDRB.5
    #define BUTTON2_PORT        PORTB.5
    #define BUTTON2_PIN         PINB.5
    #define BUTTON2             BUTTON2_PIN
    
    #define BUTTON3_DDR         DDRB.4
    #define BUTTON3_PORT        PORTB.4
    #define BUTTON3_PIN         PINB.4
    #define BUTTON3             BUTTON3_PIN  
      
//*************************************************
void ConfigButtons(void){
    #ifndef INPUT
        #define INPUT   0
    #endif

    #ifdef ENABLE_BUTTON
        BUTTON1_DDR=INPUT; BUTTON1_PORT=!PRESSED;  
        BUTTON2_DDR=INPUT; BUTTON2_PORT=!PRESSED;
        BUTTON3_DDR=INPUT; BUTTON3_PORT=!PRESSED;
    #endif
}

#pragma used+

//*************************************************
char CheckSetButton(void){
    static bit last_status=!PRESSED; 
    
    if(BUTTON3==PRESSED && last_status==!PRESSED){
        delay_ms(30);
        if(BUTTON3==PRESSED){
            last_status=PRESSED;
            return 1;
        } 
    }
    if(BUTTON3==!PRESSED){last_status=!PRESSED;} 
    return 0;
}

//*************************************************
char CheckIncrButton_OneStep(void){
    static bit last_status=!PRESSED; 
    
    if(BUTTON1==PRESSED && last_status==!PRESSED){
        delay_ms(30);
        if(BUTTON1==PRESSED){
            last_status=PRESSED;
            return 1; 
        } 
    }
    if(BUTTON1==!PRESSED){last_status=!PRESSED;}
    
    return 0; 
}

//*************************************************
char _CreateDelayForButtons(void){
    static unsigned int i=0;
    
    ++i; if(i>=BUTTONLAG){i=0; return 1;}
    
    return 0;    
}

//*************************************************
char CheckIncrButton_Continuously(void){    
    if(BUTTON1==PRESSED){
        if(_CreateDelayForButtons()){return 1;} 
    }
    
    return 0; 
}

//*************************************************
char CheckDecrButton_Continuously(void){    
    if(BUTTON2==PRESSED){
        if(_CreateDelayForButtons()){return 1;} 
    }
    
    return 0; 
}

#pragma used-
#endif
