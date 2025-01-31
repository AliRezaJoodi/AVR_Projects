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

unsigned char motor_pwm;
eeprom unsigned char PWM_Motor_EEPROM; 
bit Status_Motor;
bit int_task=0;
char buffer[16];
unsigned char key;
unsigned int t;

interrupt [EXT_INT0] void ext_int0_isr(void){
    int_task=1;
//    key=0;
//    do{
//        //LED=1;
//        if(PINB.0==1){SETBIT(key,0);} else if(PINB.0==0){CLRBIT(key,0);}
//        if(PINB.1==1){SETBIT(key,1);} else if(PINB.1==0){CLRBIT(key,1);}
//        if(PINB.2==1){SETBIT(key,2);} else if(PINB.2==0){CLRBIT(key,2);}
//        if(PINB.3==1){SETBIT(key,3);} else if(PINB.3==0){CLRBIT(key,3);}
//        //lcd_gotoxy(0,1); lcd_putsf("key= "); 
//        //itoa(key,buffer); lcd_puts(buffer); lcd_putsf("    "); 
//        //delay_ms(200);
//        if(key==8){Motor_Left(); t=0;}
//        if(key==1){Motor_Right(); t=0;} 
//        if(key==4){Motor_Stop(); t=0;} 
//        if(key==2){
//            t=t+1; if(t>=16000){t=0; Motor_UP();}
//        } 
//        if(key==3){
//            t=t+1; if(t>=16000){t=0; Motor_Down();}
//        }        
//    }while(PIND.2==1);
//    LED=0;   
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
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC1A Period: 2.048 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
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
    
    DDRD.5=1; PORTD.5=0;
    
    #asm("sei")  // Global enable interrupts

    LCD_Config();
    EEPROM_Default();
    EEPROM_Load(); 
    OCR1A=motor_pwm; 
    Start_Sub();
    
    while (1){
        //Motor_Down(); delay_ms(400);
        //LED=0; 
        if(int_task==1){
            LED=1;
        
                key=0;
    do{
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
            int_task=0;
        }
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
    itoa(motor_pwm,buffer); lcd_puts(buffer);         
}

//********************************************************
void Motor_UP(void){
    motor_pwm=motor_pwm+5; 
    if(motor_pwm==4){motor_pwm=0;}
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(motor_pwm,buffer); lcd_puts(buffer); lcd_putsf("        ");
    PWM_Motor_EEPROM=motor_pwm; delay_ms(10);
}

//********************************************************
void Motor_Down(void){
    motor_pwm=motor_pwm-5; 
    if(motor_pwm==251){motor_pwm=255;}
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(motor_pwm,buffer); lcd_puts(buffer); lcd_putsf("        ");
    PWM_Motor_EEPROM=motor_pwm; delay_ms(10);
}

//********************************************************
void Motor_Left(void){
    RELAY=1;
    Status_Motor=1;
    lcd_gotoxy(0,0); lcd_putsf("Rotate Left  ");
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
    itoa(motor_pwm,buffer); lcd_puts(buffer);      
}

//********************************************************
void Motor_Right(void){
    RELAY=0;
    Status_Motor=1;
    lcd_gotoxy(0,0); lcd_putsf("Rotate Right  ");
    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
    itoa(motor_pwm,buffer); lcd_puts(buffer);  
}

//********************************************************
void Motor_Stop(void){
    Status_Motor=0;
    lcd_gotoxy(0,0); lcd_putsf("Stop Motor      ");    
}

//********************************************************
void EEPROM_Load(void){
    motor_pwm=PWM_Motor_EEPROM;
}

//********************************************************
void EEPROM_Save(void){
    PWM_Motor_EEPROM=motor_pwm;
    delay_ms(10);
}

//********************************************************
void EEPROM_Default(void){
    motor_pwm=50;
    PWM_Motor_EEPROM=motor_pwm;
    delay_ms(10); 
    motor_pwm=PWM_Motor_EEPROM;
}
