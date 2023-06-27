/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2010-07-10
Author  : 
Company : 
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega16.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>

#define capacity 15

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

void Test_lcd (void);
void Show_variables (void);

// Declare your global variables here
int machines,total,cost;

// money=500;
char str[15],strm[15];
//int free ;
 
void main(void){
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=0 State3=T State2=T State1=0 State0=0 
PORTB=0x00;
DDRB=0x13;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=T State0=T 
PORTC=0x00;
DDRC=0x04;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
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

// LCD module initialization
lcd_init(16);
Test_lcd();
Show_variables();

while (1)
     // {
      // Place your code here
      //if ( PINB.2==1 && PINB.3 ==1)
      if ( PINB.2==1 ){
        if ( PORTB.4==0){PORTB.4=1;total++; machines++;}
      }
      else
      PORTB.4=0;

      if ( PINC.0==1 && PINC.1 ==1)
      {
      if ( PORTC.2==0)
      {
      PORTC.2=1;
      machines--;
      //free++
      }
      }
      else
      PORTC.2=0;
      
      cost=total*500;
      Show_variables ();
      
         if(machines>=capacity)
        {
        PORTB.1=1;
        lcd_clear();
        lcd_putsf("!ERROR!");
         
        delay_ms(200);
        }
        if(machines<capacity)
        {
        PORTB.1=0;
        }
      //}
}

//##########################################################
void Test_lcd(void)
{                                          
lcd_clear();           
lcd_putsf("test lcd");
delay_ms(2000);
lcd_clear();
}

//##########################################################

void Show_variables(void)
{
         lcd_gotoxy(0,0); lcd_putsf("mach=");
         itoa(machines,strm);
         lcd_gotoxy(5,0); lcd_puts(strm);
         
         /*lcd_gotoxy(9,0); lcd_putsf("free=");
         itoa(free,strm);
         lcd_gotoxy(15,0); lcd_puts(strm);*/
         
         lcd_gotoxy(0,1); lcd_putsf("tot=");
         itoa(total,strm);
         lcd_gotoxy(4,1); lcd_puts(strm);

         lcd_gotoxy(7,1); lcd_putsf("c=");
         itoa(cost,str);
         lcd_gotoxy(9,1);lcd_puts(str);

}