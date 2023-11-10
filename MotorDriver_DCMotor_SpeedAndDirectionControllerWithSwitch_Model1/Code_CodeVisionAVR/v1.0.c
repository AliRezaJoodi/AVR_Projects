/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2011/12/05
Author  : 
Company : 
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega32a.h>
#include <delay.h>
#include <stdlib.h>
//#include <math.h>
//#include <stdio.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

void Start_sub(void);
void Up_PWM(void);
void Down_PWM(void);
void Stop_Motor(void);
void Left_Motor(void);
void Right_Motor(void);

// Declare your global variables here
unsigned char PWM_Motor=0;
eeprom unsigned char PWM_Motor_eeprom=0;
char LCD_Buffer[3];
unsigned char k=0;
//unsigned char Max_k=10;

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=P State3=P State2=P State1=P State0=P 
PORTB=0x1F;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTC=0x00;
DDRC=0x03;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=0 State3=0 State2=P State1=T State0=T 
PORTD=0x04;
DDRD=0x18;

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
// Clock value: 8000.000 kHz
// Mode: Ph. correct PWM top=00FFh
// OC1A output: Discon.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x21;
TCCR1B=0x01;
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

// LCD module initialization
lcd_init(16);

#define in3 PORTC.0
#define in4 PORTC.1
#define Up_key PINB.4
#define Down_key PINB.2
#define Left_key PINB.3
#define Right_key PINB.0
#define Stop_key PINB.1
#define Max_k 8

Start_sub();
    while (1){    
        if(Left_key==0){
            delay_ms(30);
            Left_Motor();
            delay_ms(500);
        }
        if(Right_key==0){
            delay_ms(30);
            Right_Motor();
            delay_ms(500);
        }
        if(Stop_key==0){
            delay_ms(30);
            Stop_Motor();
            delay_ms(500);
        }        
        if(Up_key==0){
            k=k+1; delay_ms(30);
            if(k>=Max_k){
             k=0;
             Up_PWM();
            }
        }
        if(Down_key==0){
            k=k+1; delay_ms(30);
            if(k>=Max_k){
             k=0;
             Down_PWM();
            }
        }
    };
}

//**************************************************
void Start_sub(void){
    in3=0; in4=0;
    PWM_Motor=PWM_Motor_eeprom; delay_ms(10);
    OCR1B=PWM_Motor;
    //PWM_Motor=125;
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("Stop Motor   ");
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(PWM_Motor,LCD_Buffer); lcd_puts(LCD_Buffer); lcd_putsf("  ");   
}

//**************************************************

void Up_PWM(void){
    PWM_Motor=PWM_Motor+5; if(PWM_Motor==4)PWM_Motor=0;
    PWM_Motor_eeprom=PWM_Motor; delay_ms(10);
    OCR1B=PWM_Motor;
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(PWM_Motor,LCD_Buffer); lcd_puts(LCD_Buffer); lcd_putsf("  "); 
}

//**************************************************
void Down_PWM(void){
    PWM_Motor=PWM_Motor-5; if(PWM_Motor==251)PWM_Motor=255;
    PWM_Motor_eeprom=PWM_Motor; delay_ms(10);
    OCR1B=PWM_Motor;
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(PWM_Motor,LCD_Buffer); lcd_puts(LCD_Buffer); lcd_putsf("  "); 
}

//**************************************************
void Stop_Motor(void){
    in3=0; in4=0;
    lcd_gotoxy(0,0); lcd_putsf("Stop Motor   ");
}

//**************************************************
void Left_Motor(void){
    in3=0; in4=1;
    lcd_gotoxy(0,0); lcd_putsf("Rotate Left  ");
}

//**************************************************
void Right_Motor(void){
    in3=1; in4=0;
    lcd_gotoxy(0,0); lcd_putsf("Rotate Right ");
}
