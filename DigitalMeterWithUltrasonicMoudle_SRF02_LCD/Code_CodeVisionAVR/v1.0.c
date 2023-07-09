// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega16.h>
#include <delay.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#define BUZZER PORTB.0
#define BUTTON PIND.6 

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

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
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=0 
PORTB=0x04;
DDRB=0x03;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=P State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x40;
DDRD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

if(BUTTON==0){delay_ms(30); if(BUTTON==0){z=1;}; };

BUZZER=1; delay_ms(100); BUZZER=0;

// LCD module initialization
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
