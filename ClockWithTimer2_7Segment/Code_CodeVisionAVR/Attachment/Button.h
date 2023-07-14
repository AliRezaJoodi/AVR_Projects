
#include <delay.h>

#ifndef _INCLUDED_BUTTON
    #define _INCLUDED_BUTTON
    
    #ifndef DISABLE_BUTTON
        #define ENABLE_BUTTON
    #endif
    
    #define PRESSED             0  
    #define BUTTONLAG           800      //Button Lag: 0~65535  
    
    #define BUTTON1_DDR         DDRC.0
    #define BUTTON1_PORT        PORTC.0
    #define BUTTON1_PIN         PINC.0
    #define BUTTON1             BUTTON1_PIN

    #define BUTTON2_DDR         DDRC.1
    #define BUTTON2_PORT        PORTC.1
    #define BUTTON2_PIN         PINC.1
    #define BUTTON2             BUTTON2_PIN

    #define BUTTON3_DDR         DDRC.2
    #define BUTTON3_PORT        PORTC.2
    #define BUTTON3_PIN         PINC.2
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
char CheckModeButton(void){
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
char CheckMinButton_OneStep(void){
    static bit last_status=!PRESSED; 
    
    if(BUTTON2==PRESSED && last_status==!PRESSED){
        delay_ms(30);
        if(BUTTON2==PRESSED){
            last_status=PRESSED;
            return 1; 
        } 
    }
    if(BUTTON2==!PRESSED){last_status=!PRESSED;}
    
    return 0; 
}

//*************************************************
char CheckHourButton_OneStep(void){
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
char _CreateDelayForButtons(void){
    static unsigned int i=0;
    
    ++i; if(i>=BUTTONLAG){i=0; return 1;}
    
    return 0;    
}

//*************************************************
char CheckMinButton_Continuously(void){    
    if(BUTTON2==PRESSED){
        if(_CreateDelayForButtons()){return 1;} 
    }
    
    return 0; 
}

//*************************************************
char CheckHourButton_Continuously(void){    
    if(BUTTON3==PRESSED){
        if(_CreateDelayForButtons()){return 1;} 
    }
    
    return 0; 
}

#pragma used-
#endif
