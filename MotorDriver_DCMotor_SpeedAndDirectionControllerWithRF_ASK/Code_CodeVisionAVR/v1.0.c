// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <lcd.h>
#include <delay.h>
#include <stdlib.h>
#include <stdio.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))
#define RELAY PORTC.0
#define LED PORTB.4

void LCD_Config(void);
void EEPROM_Load(void);
void EEPROM_Save(void);
void EEPROM_Default(void);
void Start_Sub(void);
void Motor_UP(void);
void Motor_Down(void);
void Motor_Left(void);
void Motor_Right(void);
void Motor_Stop(void);

unsigned char PWM_Motor;
eeprom unsigned char PWM_Motor_EEPROM; 
bit Status_Motor;
char buffer[16];
unsigned char key;
unsigned int t;

interrupt [EXT_INT0] void ext_int0_isr(void){
    key=0;
    do{
        //LED=1;
        if(PINB.0==1){SETBIT(key,0);} else if(PINB.0==0){CLRBIT(key,0);}
        if(PINB.1==1){SETBIT(key,1);} else if(PINB.1==0){CLRBIT(key,1);}
        if(PINB.2==1){SETBIT(key,2);} else if(PINB.2==0){CLRBIT(key,2);}
        if(PINB.3==1){SETBIT(key,3);} else if(PINB.3==0){CLRBIT(key,3);}
        //lcd_gotoxy(0,1); lcd_putsf("key= "); 
        //itoa(key,buffer); lcd_puts(buffer); lcd_putsf("    "); 
        //delay_ms(200);
        if(key==8){Motor_Left(); t=0;}
        if(key==1){Motor_Right(); t=0;} 
        if(key==4){Motor_Stop(); t=0;} 
        if(key==2){
            t=t+1; if(t>=16000){t=0; Motor_UP();}
        } 
        if(key==3){
            t=t+1; if(t>=16000){t=0; Motor_Down();}
        }        
    }while(PIND.2==1);
    LED=0;   
}

void main(void){

    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Rising Edge
    // INT1: Off
    // INT2: Off
    GICR|=0x40;
    MCUCR=0x03;
    MCUCSR=0x00;
    GIFR=0x40;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: CTC top=OCR1A
// OC1A output: Toggle
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x40;
TCCR1B=0x0B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

TIMSK=0x00;

//TCCR1A=0x40;
//TCCR1B=0x0A;
//OCR1AH=0x01;
//OCR1AL=0xF3;

DDRD.5=1; PORTD.5=0;

    DDRC.0=1; PORTC.0=0;
    DDRB.4=1; PORTB.4=0;
    
    DDRB.0=0; PORTB.0=1;
    DDRB.1=0; PORTB.1=1;
    DDRB.2=0; PORTB.2=1;
    DDRB.3=0; PORTB.3=1;
    
    DDRD.2=0;
   
    #asm("sei")  // Global enable interrupts

    LCD_Config();
    EEPROM_Default();
    EEPROM_Load();
    Start_Sub();
    
    while (1){
        //Motor_Down(); delay_ms(400);
        //LED=0;
    }
}

//********************************************************
void LCD_Config(void){
    lcd_init(16); lcd_clear();   
}

//********************************************************
void Start_Sub(void){    
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("Stop Motor");
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
    itoa(PWM_Motor,buffer); lcd_puts(buffer);         
}

//********************************************************
void Motor_UP(void){
    PWM_Motor=PWM_Motor+5; 
    if(PWM_Motor==4){PWM_Motor=0;}
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(PWM_Motor,buffer); lcd_puts(buffer); lcd_putsf("        ");
    PWM_Motor_EEPROM=PWM_Motor; delay_ms(10);
}

//********************************************************
void Motor_Down(void){
    PWM_Motor=PWM_Motor-5; 
    if(PWM_Motor==251){PWM_Motor=255;}
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(PWM_Motor,buffer); lcd_puts(buffer); lcd_putsf("        ");
    PWM_Motor_EEPROM=PWM_Motor; delay_ms(10);
}

//********************************************************
void Motor_Left(void){
    RELAY=1;
    Status_Motor=1;
    lcd_gotoxy(0,0); lcd_putsf("Rotate Left  ");
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
    itoa(PWM_Motor,buffer); lcd_puts(buffer);      
}

//********************************************************
void Motor_Right(void){
    RELAY=0;
    Status_Motor=1;
    lcd_gotoxy(0,0); lcd_putsf("Rotate Right  ");
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
    itoa(PWM_Motor,buffer); lcd_puts(buffer);  
}

//********************************************************
void Motor_Stop(void){
    Status_Motor=0;
    lcd_gotoxy(0,0); lcd_putsf("Stop Motor      ");    
}

//********************************************************
void EEPROM_Load(void){
    PWM_Motor=PWM_Motor_EEPROM;
}

//********************************************************
void EEPROM_Save(void){
    PWM_Motor_EEPROM=PWM_Motor;
    delay_ms(10);
}

//********************************************************
void EEPROM_Default(void){
    PWM_Motor=50;
    PWM_Motor_EEPROM=PWM_Motor;
    delay_ms(10); 
    PWM_Motor=PWM_Motor_EEPROM;
}
