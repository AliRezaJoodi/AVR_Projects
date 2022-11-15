// GitHub Account:  GitHub.com/AliRezaJoodi

#include <mega32.h>               
#include <delay.h>                                      
#include <stdio.h>  

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1b ;PORTA
#endasm
#include <lcd.h>

#include <Attachment\shtxx.h>  

float Temperature=0; 
float Humidity=0;
void Display_Values(void);
                                
void main(void){                                
    lcd_init(16); lcd_clear();
                                       
    while(1){
        Humidity=Get_Humidity(); 
        Temperature= Get_Temp();
        Display_Values();
        delay_ms(250);                                  
    }
}

//***********************
void Display_Values(void){
    char txt[16]; 
    lcd_clear();
    sprintf(txt,"Humidity(%%)=%3.1f",Humidity); lcd_gotoxy(0,0); lcd_puts(txt);  
    sprintf(txt,"Temp(C)=%3.1f",Temperature); lcd_gotoxy(0,1); lcd_puts(txt); 
}

