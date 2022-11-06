// GitHub Account:     GitHub.com/AliRezaJoodi

#include <mega32.h>               
#include <delay.h>                                      
#include <stdio.h>  
#include <ds18b20.h>  
#include <stdlib.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
#include <lcd.h>
             
// 1 Wire Bus functions
#asm
   .equ __w1_port=0x1B ;PORTA
   .equ __w1_bit=0
#endasm
#include <1wire.h>

typedef unsigned char byte;
flash byte char0[8]={
    0b10000111,
    0b10000101,
    0b10000111,
    0b10000000,
    0b10000000,
    0b10000000,
    0b10000000,
    0b10000000
};

flash byte char1[8]={
    0b10001000,
    0b10010100,
    0b10001000,
    0b10000011,
    0b10000100,
    0b10000100,
    0b10000011,
    0b10000000
};

void define_char(byte flash *pc,byte);
void Display_Temp(float);
            
void main(void){       
    float temp;                       
    lcd_init(16); 
    define_char(char0,0); define_char(char1,1);
    Display_Temp(0);
                                      
    while(w1_init()>0){
        temp=ds18b20_temperature(0);    
        Display_Temp(temp);
        delay_ms(250);                              
    }
}

//****************************************************
void Display_Temp(float x){
    char txt[32]; 
    lcd_clear();
    ///sprintf(txt,"Temp =%3.1f\xdfC",x);
    
    lcd_clear();
    //lcd_gotoxy(0,0); lcd_putsf("Temp:"); ftoa(x,1,txt); lcd_puts(txt); lcd_putchar(0); lcd_putsf("C");   
    //lcd_gotoxy(0,0); lcd_putsf("Temp:"); ftoa(x,1,txt); lcd_puts(txt); lcd_putchar(1); 
    lcd_gotoxy(0,0); lcd_putsf("Temp("); lcd_putchar(1); lcd_putsf("):"); ftoa(x,1,txt); lcd_puts(txt); 
    lcd_gotoxy(0,1); lcd_putsf("DS1820 Sensor");
}

//********************************************************
void define_char(byte flash *pc,byte char_code){
    byte i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}

