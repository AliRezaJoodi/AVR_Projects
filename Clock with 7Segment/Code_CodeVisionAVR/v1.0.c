// GitHub Account:     GitHub.com/AliRezaJoodi

#include <mega32.h>
#include <delay.h>

#define M1_DDR DDRB.4
#define M1_PORT PORTB.4
#define M1_PIN PINB.4
#define M1 M1_PORT

#define M2_DDR DDRB.3
#define M2_PORT PORTB.3
#define M2_PIN PINB.3
#define M2 M2_PORT

#define H1_DDR DDRB.2
#define H1_PORT PORTB.2
#define H1_PIN PINB.2
#define H1 H1_PORT

#define H2_DDR DDRB.1
#define H2_PORT PORTB.1
#define H2_PIN PINB.1
#define H2 H2_PORT

#define ACTIVATE_7SEGMENT 1
#define DEACTIVATE_7SEGMENT !ACTIVATE_7SEGMENT

#define LED_DDR DDRB.0
#define LED_PORT PORTB.0
#define LED_PIN PINB.0
#define LED LED_PORT

#define ACTIVATE_LED 0
#define DEACTIVATE_LED !ACTIVATE_LED

#define BUTTON1_DDR DDRC.0
#define BUTTON1_PORT PORTC.0
#define BUTTON1_PIN PINC.0
#define BUTTON1 BUTTON1_PIN

#define BUTTON2_DDR DDRC.1
#define BUTTON2_PORT PORTC.1
#define BUTTON2_PIN PINC.1
#define BUTTON2 BUTTON2_PIN

#define BUTTON3_DDR DDRC.2
#define BUTTON3_PORT PORTC.2
#define BUTTON3_PIN PINC.2
#define BUTTON3 BUTTON3_PIN

#define PRESS_BUTTON 0
#define DEFAULT_BUTTON !PRESS_BUTTON

unsigned char second;
unsigned char minute;
unsigned char hour;
unsigned int i=0;
unsigned char j=0;
unsigned char digit=0;

//0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
//A , B , C , D , E , F,
// - , Dp
unsigned char data_7segment[18]={
0b00111111 , 0b00000110 , 0b01011011 , 0b01001111 , 0b01100110 , 0b01101101 , 0b01111101 , 0b00000111 , 0b01111111 , 0b01101111,
0b01110111 , 0b01111100 , 0b00111001 , 0b01011110 , 0b01111001 , 0b01110001 ,
0b01000000 , 0b10000000}; 
    
// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void){
    second++;
    if(second > 59){
        second=0;  minute++;
            if(minute > 59){
                minute=0; hour++;
                if(hour > 23) {hour=0;}    
            }
    }
    LED=ACTIVATE_LED; i=0;       
}

void Config_IO(void);
void Config_Timer2(void);
void Display_Clock(void);
void Display_Second(void);

void main(void){
    bit mode=0;
    unsigned char status_button1;
    unsigned char status_button2;
    unsigned char status_button3;

    Config_IO();
    Config_Timer2();
    #asm("sei") // Global enable interrupts 

    hour=23; minute=59; second=50;

    while (1){
        ++i; if(i>800){LED=DEACTIVATE_LED;} 
        
        if (mode==0){Display_Clock();} else {Display_Second();} 
        delay_us(250);
      
        if(BUTTON1==PRESS_BUTTON & status_button1==DEFAULT_BUTTON){
            mode=!mode;
            status_button1=PRESS_BUTTON; 
        }
        if(BUTTON1==DEFAULT_BUTTON){status_button1=DEFAULT_BUTTON;} 
           
        if(BUTTON2==PRESS_BUTTON & status_button2==DEFAULT_BUTTON & mode==0){
            minute++; if(minute>59){minute=0;}
            status_button2=PRESS_BUTTON; 
        }
        if(BUTTON2==DEFAULT_BUTTON){status_button2=DEFAULT_BUTTON;}
             
        if(BUTTON3==PRESS_BUTTON & status_button3==DEFAULT_BUTTON & mode==0){
            hour++; if(hour>23){hour=0;}
            status_button3=PRESS_BUTTON; 
        }
        if(BUTTON3==DEFAULT_BUTTON){status_button3=DEFAULT_BUTTON;}      
    };
}

//**************************************
void Display_Second(void){
    //PORTA=0b11111111;
    H2=DEACTIVATE_7SEGMENT; H1=DEACTIVATE_7SEGMENT; M2=DEACTIVATE_7SEGMENT; M1=DEACTIVATE_7SEGMENT; 
    switch(j){ 
        case 0:
            digit=second%10; M1=ACTIVATE_7SEGMENT;
            break;
        case 1:
            digit=second/10; M2=ACTIVATE_7SEGMENT;
            break;
    }
    PORTA=data_7segment[digit] ^ 0b11111111; 
    j++; if(j>1){j=0;}
}

//**************************************
void Display_Clock(void){
    //PORTA=0b11111111;
    H2=DEACTIVATE_7SEGMENT; H1=DEACTIVATE_7SEGMENT; M2=DEACTIVATE_7SEGMENT; M1=DEACTIVATE_7SEGMENT; 
    switch(j){ 
        case 0:
            digit=minute%10; M1=ACTIVATE_7SEGMENT;
            break;
        case 1:
            digit=minute/10; M2=ACTIVATE_7SEGMENT;
            break;
        case 2:
            digit=hour%10; H1=ACTIVATE_7SEGMENT; 
            break;
        case 3:
            digit=hour/10; H2=ACTIVATE_7SEGMENT;
            break;
    }
    PORTA=data_7segment[digit] ^ 0b11111111;
    j++; if(j>3){j=0;}
}

//**************************************
void Config_Timer2(void){
    // Timer/Counter 2 initialization
    // Clock source: TOSC1 pin
    // Clock value: PCK2/128
    // Mode: Normal top=FFh
    // OC2 output: Disconnected
    ASSR=0x08;
    TCCR2=0x05;
    TCNT2=0x00;
    OCR2=0x00;
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x40;
}

//**************************************
void Config_IO(void){
    #define OUTPUT 1
    #define INPUT 0 
    #define PULL_UP 1
    #define PULL_DOWN 0
    
    BUTTON1_DDR=INPUT; BUTTON1_PORT=PULL_UP;
    BUTTON2_DDR=INPUT; BUTTON2_PORT=PULL_UP;
    BUTTON3_DDR=INPUT; BUTTON3_PORT=PULL_UP;
    
    M1_DDR=OUTPUT; M1_PORT=DEACTIVATE_7SEGMENT;
    M2_DDR=OUTPUT; M2_PORT=DEACTIVATE_7SEGMENT;
    H1_DDR=OUTPUT; H1_PORT=DEACTIVATE_7SEGMENT;
    H2_DDR=OUTPUT; H2_PORT=DEACTIVATE_7SEGMENT;
    LED_DDR=OUTPUT; LED_PORT=DEACTIVATE_LED; 
    
    DDRA=0xFF; PORTA=0xFF;
}
