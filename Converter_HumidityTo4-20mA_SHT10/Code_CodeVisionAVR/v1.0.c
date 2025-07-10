#include <mega8.h>               
#include <delay.h>                                      
#include <stdio.h>  
#include <alcd.h>
#include <Attachments/shtxx.h>  

#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))
#define CHKBIT(ADDRESS,BIT)  ((ADDRESS &(1<<BIT))>>BIT)
#define TOGGLEBIT(ADDRESS,BIT) (ADDRESS^=(1<<BIT))
#define EQUBIT(ADDRESS,BIT,value) {if (value) SETBIT(ADDRESS,BIT); else CLRBIT(ADDRESS,BIT);}
/*
#define ACTIVE 1
#define INACTIVE 0
#define OUTPUT 1
#define INPUT 0
*/

float temperature=0; 
float humidity=0;

void config_USART(void);
void Config_Timer1(void);
void DAC_Current(float);
void Display_Values(void);
                                
void main(void){ 
    DDRD.6=0; PORTD.6=1;
    DDRD.5=1; PORTD.5=0;
                               
   lcd_init(16); lcd_clear();
   config_USART();
   Config_Timer1();
   
   lcd_putsf("Looding ...");  
   putsf("Looding ...");
   
   DAC_Current(0); //DAC=0~100%
                                     
   while(1){
        humidity=Get_Humidity();
        temperature=Get_Temp();
        /*lcd_clear();
        sprintf(Buffer_LCD,"Humidity =%3.1f",humidity); lcd_gotoxy(0,0); lcd_puts(Buffer_LCD);
        puts(Buffer_LCD); putchar(13);  
        sprintf(Buffer_LCD,"Temp =%3.1f\xdfC",temperature); lcd_gotoxy(0,1); lcd_puts(Buffer_LCD); 
        puts(Buffer_LCD); putchar(13);  
        putchar(13);
        */ 
        Display_Values();   
        DAC_Current(humidity);
        delay_ms(250);                                  
   }
}

//***********************
void Display_Values(void){
    char txt[16]; 
    lcd_clear();
    sprintf(txt,"Humidity(%%)=%3.1f",humidity); lcd_gotoxy(0,0); lcd_puts(txt);  
    sprintf(txt,"Temp(C)=%3.1f",temperature); lcd_gotoxy(0,1); lcd_puts(txt); 
}

//******************************************
//Input=0~100%  
//Output=4~20mA
void DAC_Current(float x){
    //PWM MAX=1005  
    //PWM MIN=190
    //char buffer_lcd[16];
    float y=0; 
    if(x>100){x=100;};     //x=0~100%  
    //x=100-x;   //inverse 
    y=((x*(1005-190))*0.01)+190;
    //sprintf(buffer_lcd,"Output=%5.0f",y); lcd_gotoxy(0,1); lcd_puts(buffer_lcd); lcd_putsf("    ");
    OCR1A=y;    
    //sprintf(buffer_lcd,"PWM=%5.1f",y); lcd_gotoxy(0,1); lcd_puts(buffer_lcd); lcd_putsf("    "); 
}

//********************************************************
void Config_Timer1(void){
    DDRB.1=1; PORTB.1=0;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Fast PWM top=0x03FF
// OC1A output: Non-Inverted PWM
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.128 ms
// Output Pulse(s):
// OC1A Period: 0.128 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;    
}

//********************************************
void config_USART(void){
    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: Off
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 9600
    UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
    UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
    UBRRH=0x00;
    UBRRL=0x33;
}

