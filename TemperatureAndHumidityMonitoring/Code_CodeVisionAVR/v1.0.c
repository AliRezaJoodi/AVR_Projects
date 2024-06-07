// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>               
#include <delay.h>                                      
#include <stdio.h>  
#include <Attachment/shtxx.h>  

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

#define BUZZER PORTC.3
#define BUZZER_Direction DDRC.3

#define ACTIVE 1
#define INACTIVE 0

float humidity=0;
float temperature=0;

void Config_Buzzer(void);
void Sound_Menu(void);
void Display_MainPage(void);
                                
void main(void){ 
    Config_Buzzer();
    
    DDRB.1=0; PORTB.1=1;
    DDRB.0=1; PORTB.0=0;
                               
    lcd_init(16);   
    lcd_gotoxy(0,0); lcd_putsf("Please Wait ...");
    
    Sound_Menu();
                                       
    while(1){
        humidity= Get_Humidity();
        temperature= Get_Temp();
        Display_MainPage(); 
        delay_ms(100);                                        
    }
}

//******************************************
void Config_Buzzer(void){
    BUZZER_Direction=OUTPUT; BUZZER=INACTIVE; 
}

//******************************************
void Display_MainPage(void){
    char txt[16]; 
    lcd_clear();
    sprintf(txt,"RH(%%)=%3.1f",humidity); lcd_gotoxy(0,0); lcd_puts(txt);  
    sprintf(txt,"Temp(C)=%3.1f",temperature); lcd_gotoxy(0,1); lcd_puts(txt); 
}

//******************************************
void Sound_Menu(void){
    long i_Sound;
    for (i_Sound=1;i_Sound<=400;++i_Sound) {
        BUZZER=1; delay_us(250);
        BUZZER=0; delay_us(250);
    };    
}







