// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega16a.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>
#include <stdlib.h>

struct dimmer{
    float load;         //0~100
    float ocr;
    unsigned int i;  
    char disconnect; 
    char turnoff;
};
struct dimmer phase1; 
    
#include "Attachment\Timer0.h"
#include "Attachment\ExternalIntrupts.h"
#include "Attachment\Button.h"
#include "Attachment\DataConverter.h"

void ConfigLCD(void);
void DisplayLoadingPage(void);
void DisplayMainPage(void);

void main(void){
    float old_value=0;
    
    ConfigButtons(); 
    ConfigLCD();
    DisplayLoadingPage();
    
    ConfigExternalInterrupts();
    INT0_MODE_RISINGEDGE;
        
    ConfigTimer0ForPWM();
    T0_OC0_INVERTED; 
    OCR0=153;    //From min to max with 153~0

    INT_GLOBAL_ENABLE;
    
    phase1.load=5; 
    phase1.ocr=Convert_0to100_153to0(phase1.load);
    OCR0=phase1.ocr;
    DisplayMainPage();

    while(1){ 
        if(CheckIncrButton_Continuously()){
            phase1.load+=0.1; if(phase1.load>100){phase1.load=0;} 
        }
        
        if(CheckDecrButton_Continuously()){
            phase1.load-=0.1; if(phase1.load<0){phase1.load=100;} 
        }
        
        if(CheckSetButton()){
            phase1.turnoff=!phase1.turnoff;  
        }
         
        if(old_value!=phase1.load){
            old_value=phase1.load;
            phase1.ocr=Convert_0to100_153to0(phase1.load);
            OCR0=phase1.ocr; 
            DisplayMainPage();
        }
       
        if(task_int0){
            task_int0=0; 
            phase1.i=0; phase1.disconnect=0;
        }
         
        ++phase1.i;
        if(phase1.i>600){
            phase1.i=0;  
            phase1.disconnect=1;
        }
        
        if(phase1.disconnect || phase1.turnoff){T0_OC0_DISCONNECT;}
        if(!phase1.disconnect && !phase1.turnoff){T0_OC0_INVERTED;} 
    }
}

//**********************************
void DisplayMainPage(void){
    char txt[16];
    unsigned char decimals=1;
    
    if(phase1.load<10){decimals=1;} 
        else if(phase1.load<100){decimals=1;} 
            else{decimals=0;}
            
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("Out(0-100%)="); ftoa(phase1.load,decimals,txt); lcd_puts(txt); lcd_putsf("  "); 
    lcd_gotoxy(0,1); lcd_putsf("OCR0(153-0)="); itoa(OCR0,txt); lcd_puts(txt); lcd_putsf("  ");
    //lcd_gotoxy(0,1); lcd_putsf("Dimmer");    
}

//********************************************************
void ConfigLCD(void){
    lcd_init(16); lcd_clear();   
}

//********************************************************
void DisplayLoadingPage(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("Testing the LCD");
    lcd_gotoxy(0,1); lcd_putsf("Loading ...");
    //delay_ms(500); lcd_clear();
}





