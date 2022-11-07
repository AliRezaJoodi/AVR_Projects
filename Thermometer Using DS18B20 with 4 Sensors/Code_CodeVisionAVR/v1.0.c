// GitHub Account:     GitHub.com/AliRezaJoodi

#include <mega32.h>                                                  
#include <stdio.h>
#include <stdlib.h>   
#include <delay.h>

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
#include <ds18b20.h> 

unsigned char maximum_number;
unsigned char rom_codes[8][9];

typedef unsigned char byte;
flash byte char0[8]={
    0b10001000,
    0b10010100,
    0b10001000,
    0b10000011,
    0b10000100,
    0b10000100,
    0b10000011,
    0b10000000
}; 

void Configuration_LCD(void);
void define_char(byte flash *pc,byte);
void Display_loading(void);
void Display_Temps(void);
void Display2_Temps(void);

float temp[4];
               
void main(void){       
    int i=0;
                          
    Configuration_LCD();
    define_char(char0,0);
    Display_loading();
    
    w1_init();
    maximum_number=w1_search(0xf0,rom_codes);      
                                                   
    while(1){
        for(i=0;i<maximum_number;i++){
            temp[i]= ds18b20_temperature(rom_codes[i]);
        } 
        Display2_Temps();
        delay_ms(250);                                        
    }
}

//**************************************************
void Display2_Temps(void){
    char txt[16];
    lcd_clear();
    ftoa(temp[0],1,txt); lcd_gotoxy(0,0); lcd_putsf("1:"); lcd_puts(txt); lcd_putchar(0); 
    ftoa(temp[1],1,txt); lcd_gotoxy(8,0); lcd_putsf("2:"); lcd_puts(txt); lcd_putchar(0);   
    ftoa(temp[2],1,txt); lcd_gotoxy(0,1); lcd_putsf("3:"); lcd_puts(txt); lcd_putchar(0); 
    ftoa(temp[3],1,txt); lcd_gotoxy(8,1); lcd_putsf("4:"); lcd_puts(txt); lcd_putchar(0);     
}

//**************************************************
void Display_Temps(void){
    char txt[16];
    lcd_clear();
    sprintf(txt,"1:%3.1f",temp[0]); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putchar(0);   
    sprintf(txt,"2:%3.1f",temp[1]); lcd_gotoxy(8,0); lcd_puts(txt); lcd_putchar(0); 
    sprintf(txt,"3:%3.1f",temp[2]); lcd_gotoxy(0,1); lcd_puts(txt); lcd_putchar(0); 
    sprintf(txt,"4:%3.1f",temp[3]); lcd_gotoxy(8,1); lcd_puts(txt); lcd_putchar(0);         
}

//**************************************************
void define_char(byte flash *pc,byte char_code){
    byte i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}

//********************************************************
void Display_loading(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("DS18B20 Driver");
    lcd_gotoxy(0,1); lcd_putsf("Loading ...");
    //delay_ms(500); lcd_clear();
}

//********************************************************
void Configuration_LCD(void){
    lcd_init(16); lcd_clear();   
}
