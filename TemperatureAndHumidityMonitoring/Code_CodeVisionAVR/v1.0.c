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
#define OUTPUT 1
#define INPUT 0

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
 
char buffer_lcd[16]; 
unsigned char status_display=0;
bit status_key_set=0;

float humidity;
float temperature;

void Config_Buzzer(void);
void Display(void);
void Sound_Menu(void);
void define_char(byte flash *pc,byte);
                                
void main(void){ 
    Config_Buzzer();
    
    DDRB.1=0; PORTB.1=1;
    DDRB.0=1; PORTB.0=0;
                               
    lcd_init(16);
    
    //lcd_gotoxy(0,0); lcd_putsf("Please Wait ...");
    //delay_ms(400);
    define_char(char0,0);
    lcd_clear();
    
    Sound_Menu();
                                       
    while(1){
        humidity=read_sensor(0);
        temperature=read_sensor(1);
        Display(); 
        delay_ms(100);                                        
    }
}

//******************************************
void Config_Buzzer(void){
    BUZZER_Direction=OUTPUT; BUZZER=INACTIVE; 
}

//******************************************
void Display(void){
    lcd_clear();
    sprintf(buffer_lcd,"RH: %3.1f%%",humidity); lcd_gotoxy(0,0); lcd_puts(buffer_lcd);  
    sprintf(buffer_lcd,"Temp: %3.1f",temperature); lcd_gotoxy(0,1); lcd_puts(buffer_lcd); lcd_putchar(0); lcd_putsf("C   ");
}


//******************************************
void Sound_Menu(void){
    long i_Sound;
    for (i_Sound=1;i_Sound<=400;++i_Sound) {
        BUZZER=1; delay_us(250);
        BUZZER=0; delay_us(250);
    };    
}

//********************************************************
void define_char(byte flash *pc,byte char_code){
    byte i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}







