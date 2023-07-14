
#ifndef _INCLUDED_RTC
    #define _INCLUDED_RTC
    
    //#define DISABLE_RTC
    #ifndef DISABLE_RTC
        #define ENABLE_RTC
    #endif
    
    char task_1s=0;
    
    struct rtc{
        unsigned char hour;
        unsigned char minute;
        unsigned char second;
    };
    struct rtc clock; 

//**************************************
void ConfigTimer2(void){
    // Timer/Counter 2 initialization
    // Clock source: TOSC1 pin
    // Clock value: PCK2/128
    // page: Normal top=FFh
    // OC2 output: Disconnected
    ASSR=0x08;
    TCCR2=0x05;
    TCNT2=0x00;
    OCR2=0x00;
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x40; 
    #asm("sei") // Global enable interrupts
}

// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void){ 
    task_t2=1;
}

//***************************************
void IncreaseClockValues(void){
    clock.second++;
    if(clock.second>59){
        clock.second=0;  
        clock.minute++;
        if(clock.minute>59){
            clock.minute=0; 
            clock.hour++; 
            if(clock.hour>23){clock.hour=0;}    
        }
    }   
}

//***************************************
void IncreaseMinValues(void){
    clock.minute++; if(clock.minute>59){clock.minute=0;}
    clock.second=0;
}

//***************************************
void IncreaseHourValues(void){
    clock.hour++; if(clock.hour>23){clock.hour=0;}  
    clock.second=0;
}

//***************************************
void SetDefoultValueOnTheClock(void){
    clock.hour=23; clock.minute=59; clock.second=50;
}
    
#endif 
 