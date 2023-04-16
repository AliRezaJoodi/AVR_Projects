// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega16.h>
#include <delay.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

// Bit-Banged I2C Bus functions
#include <i2c.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

#define BUZZER PORTB.0
#define BUTTON PIND.6 

void test_lcd(void);
void get_srf02(void);
void sow_lenght(void);

// Declare your global variables here
unsigned char Lentgh;
unsigned char Lentgh_msb;
unsigned char Lentgh_lsb;
char lcd[25];
bit z=0;

void main(void){

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=0 
PORTB=0x04;
DDRB=0x03;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=P State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x40;
DDRD=0x00;

// Bit-Banged I2C Bus initialization
// SDA signal: PORTC bit: 1
// SCL signal: PORTA bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

if(BUTTON==0){delay_ms(30); if(BUTTON==0){z=1;}; };

BUZZER=1; delay_ms(100); BUZZER=0;

lcd_init(16);
lcd_clear();
test_lcd();
   
    while(1){
        if(BUTTON==0){
            delay_ms(30); 
            if(BUTTON==0){
                BUZZER=1; get_srf02(); sow_lenght(); BUZZER=0; delay_ms(400);
            };
        };
        if(z==1){get_srf02(); sow_lenght(); delay_ms(500); };
    };
}

//********************************
void test_lcd(void){
    lcd_gotoxy(0,0);
    lcd_putsf("Ultrasonic");
    lcd_gotoxy(0,1);
    lcd_putsf("20CM - 600CM");
    delay_ms(2000);
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Press BUTTON");        
}

//********************************
void get_srf02(void){
   //lcd_clear();
   i2c_start(); 
   i2c_write(0xE0);
   i2c_write(0);
   i2c_write(0x51);
   i2c_stop(); 
   delay_ms(70);

   i2c_start();
   i2c_write(0xE0);
   i2c_write(2);
   i2c_stop();
   delay_ms(70);
   
   i2c_start(); 
   i2c_write(0xE1); 
   Lentgh_msb=i2c_read(1);
   Lentgh_lsb=i2c_read(0);
   i2c_stop();
   
   Lentgh=((Lentgh_msb)*256)+Lentgh_lsb;
}

//********************************
void sow_lenght(void){
    lcd_clear();
    lcd_putsf("Lentgh= ");
    itoa(Lentgh , lcd); 
    lcd_puts(lcd);
    lcd_putsf(" CM") ;
}
