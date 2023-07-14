// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <delay.h>

char task_t2=0;
    
#include "Attachment\RTC_Timer2InAsyncTimerMode.h" 
#include "Attachment\Button.h"
#include "Attachment\Display_7Segment.h"

void main(void){
    bit page=0;
    
    ConfigButtons();
    Config7Segments();
    ConfigTimer2(); 
    SetDefoultValueOnTheClock();

    while(1){ 
    
        if(task_t2){ 
            task_t2=0;
            task_1s=1;
            task_blink=1;
        }  
    
        if(task_1s){
            task_1s=0;
            IncreaseClockValues(); 
        }  
        
        DisplayBlinkLED(); 
        if(page==0){DisplayHourAndMinValues(clock);} else{DisplaySecondValue(clock);} 
        delay_us(DISPLAYLAG);
      
        if(CheckModeButton()){page=!page;}
        if(CheckMinButton_OneStep() && page==0){IncreaseMinValues();}   
        //if(CheckMinButton_Continuously() && page==0){IncreaseMinValues();}    
        if(CheckHourButton_OneStep() && page==0){IncreaseHourValues();}
        //if(CheckHourButton_Continuously() && page==0){IncreaseHourValues();}      
    };
}