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

enum MotorStatus{
    STOP,  // 0
    LEFT,  // 1
    RIGHT, // 2
    INCR,  // 3
    DECR   // 4
};
enum MotorStatus motor_status = STOP;
    
unsigned char motor_pwm;
eeprom unsigned char motor_pwm_eeprom;
//bit motor_direction=0; 
//bit motor_run=0;

bit int_task=0;
char buffer[16];
unsigned char command;
unsigned int t;

void LCD_Config(void);
void LCD_DisplayMainPage(void);
void EEPROM_Load(void);
void EEPROM_Save(void);
void EEPROM_Default(void);
//void Start_Sub(void);
void GetCommand(void);
void Motor_IncreaseSpeed(void);
void Motor_DecreaseSpeed(void);
//void Motor_Left(void);
//void Motor_Right(void);
//void Motor_Stop(void);
void Motor_Driver(void);

interrupt [EXT_INT0] void ext_int0_isr(void){
    int_task=1;
//    command=0;
//    do{
//        //LED=1;
//        if(PINB.0==1){SETBIT(command,0);} else if(PINB.0==0){CLRBIT(command,0);}
//        if(PINB.1==1){SETBIT(command,1);} else if(PINB.1==0){CLRBIT(command,1);}
//        if(PINB.2==1){SETBIT(command,2);} else if(PINB.2==0){CLRBIT(command,2);}
//        if(PINB.3==1){SETBIT(command,3);} else if(PINB.3==0){CLRBIT(command,3);}
//        //lcd_gotoxy(0,1); lcd_putsf("command= "); 
//        //itoa(command,buffer); lcd_puts(buffer); lcd_putsf("    "); 
//        //delay_ms(200);
//        if(command==8){Motor_Left(); t=0;}
//        if(command==1){Motor_Right(); t=0;} 
//        if(command==4){Motor_Stop(); t=0;} 
//        if(command==2){
//            t=t+1; if(t>=16000){t=0; Motor_IncreaseSpeed();}
//        } 
//        if(command==3){
//            t=t+1; if(t>=16000){t=0; Motor_DecreaseSpeed();}
//        }        
//    }while(PIND.2==1);
//    LED=0;   
}

void main(void){
    enum MotorStatus motor_task = STOP;
    //enum MotorStatus motor_status = STOP;
    //char motor_status=0;


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
    DDRB.4=1; PORTB.4=0;
    
    DDRB.0=0; PORTB.0=1;
    DDRB.1=0; PORTB.1=1;
    DDRB.2=0; PORTB.2=1;
    DDRB.3=0; PORTB.3=1;
    
    DDRD.2=0;
    
    DDRD.5=1; PORTD.5=0;
    DDRC.0=1; PORTC.0=0;
    
    #asm("sei")  // Global enable interrupts

    LCD_Config();
    EEPROM_Load();
    if(0<motor_pwm || motor_pwm<255){}
        else{
            EEPROM_Default();
        }
    
    Motor_Driver(); 
    ///OCR1A=motor_pwm;
    LCD_DisplayMainPage(); 
    ///Start_Sub();
    
    while (1){
        //Motor_DecreaseSpeed(); delay_ms(400);
        //LED=0; 
        if(int_task==1){
            LED=1;
        
    do{
        GetCommand();
        
        //lcd_gotoxy(0,1); lcd_putsf("command= "); 
        //itoa(command,buffer); lcd_puts(buffer); lcd_putsf("    "); 
        //delay_ms(200);
        if(command==8){motor_status=LEFT; Motor_Driver(); LCD_DisplayMainPage(); t=0;}
        if(command==1){motor_status=RIGHT; Motor_Driver(); LCD_DisplayMainPage(); t=0;} 
        if(command==4){motor_status=STOP; Motor_Driver(); LCD_DisplayMainPage(); t=0;} 
        if(command==2){
            t=t+1; if(t>=16000){t=0; Motor_IncreaseSpeed(); EEPROM_Save(); LCD_DisplayMainPage();}
        } 
        if(command==3){
            t=t+1; if(t>=16000){t=0; Motor_DecreaseSpeed(); EEPROM_Save(); LCD_DisplayMainPage();}
        }        
    }while(PIND.2==1);
            
            LED=0;
            int_task=0;
        }
        
//        if(motor_run==1){
//            OCR1A=motor_pwm;
//        }
//        else{
//            OCR1A=0;
//        }
//        
//        if(motor_direction==1){
//            RELAY=1;
//        }
//        else{
//            RELAY=0;
//        } 
        
    }
}

//********************************************************
void GetCommand(void){
    command=0;
    if(PINB.0==1){SETBIT(command,0);} else if(PINB.0==0){CLRBIT(command,0);}
    if(PINB.1==1){SETBIT(command,1);} else if(PINB.1==0){CLRBIT(command,1);}
    if(PINB.2==1){SETBIT(command,2);} else if(PINB.2==0){CLRBIT(command,2);}
    if(PINB.3==1){SETBIT(command,3);} else if(PINB.3==0){CLRBIT(command,3);}    
}

//********************************************************
void Motor_Driver(void){
    switch(motor_status){
        case STOP: 
            RELAY=0;
            OCR1A=0; 
            break;
        case LEFT:
            RELAY=0;
            OCR1A=motor_pwm;
            break;
        case RIGHT:
            RELAY=1;
            OCR1A=motor_pwm;
            break;
//        default:    
//            RELAY=0;
//            OCR1A=0; 
//            break;
    }
}

//********************************************************
void LCD_DisplayMainPage(void){
    //lcd_clear();
    
    switch(motor_status){
        case STOP:
            lcd_gotoxy(0,0);
            lcd_putsf("Status: Stop    "); 
            break;
        case LEFT:
            lcd_gotoxy(0,0);
            lcd_putsf("Status: Left    "); 
            break;
        case RIGHT:
            lcd_gotoxy(0,0);
            lcd_putsf("Status: Right   "); 
            break;
//        default:
//            lcd_gotoxy(0,0);
//            lcd_putsf("Status: Unknown "); 
//            break;
    } 
    
    lcd_gotoxy(0,1);
    lcd_putsf("PWM= "); 
    itoa(motor_pwm,buffer); lcd_puts(buffer);
    lcd_putsf("        "); 
}

//********************************************************
void LCD_Config(void){
    lcd_init(16);
    lcd_clear();   
}

//********************************************************
//void Start_Sub(void){    
//    lcd_clear(); 
//    lcd_gotoxy(0,0); lcd_putsf("Stop Motor");
//    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
//    itoa(motor_pwm,buffer); lcd_puts(buffer);         
//}

//********************************************************
void Motor_IncreaseSpeed(void){
    motor_pwm=motor_pwm+5; 
    if(motor_pwm==4){motor_pwm=0;}
//    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(motor_pwm,buffer); lcd_puts(buffer); lcd_putsf("        ");
    ///motor_pwm_eeprom=motor_pwm; delay_ms(10); 
//    EEPROM_Save();
}

//********************************************************
void Motor_DecreaseSpeed(void){
    motor_pwm=motor_pwm-5; 
    if(motor_pwm==251){motor_pwm=255;}
//    lcd_gotoxy(0,1); lcd_putsf("PWM= "); itoa(motor_pwm,buffer); lcd_puts(buffer); lcd_putsf("        ");
    ///motor_pwm_eeprom=motor_pwm; delay_ms(10); 
//    EEPROM_Save();
}

//********************************************************
//void Motor_Left(void){
//    motor_status=LEFT;
//    //RELAY=1;
//    motor_direction=0;
//    motor_run=1;
//    lcd_gotoxy(0,0); lcd_putsf("Rotate Left  ");
//    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
//    itoa(motor_pwm,buffer); lcd_puts(buffer);      
//}

//********************************************************
//void Motor_Right(void){
//    motor_status=RIGHT;
//    //RELAY=0; 
//    motor_direction=1;
//    motor_run=1;
//    lcd_gotoxy(0,0); lcd_putsf("Rotate Right  ");
//    lcd_gotoxy(0,1); lcd_putsf("PWM= "); 
//    itoa(motor_pwm,buffer); lcd_puts(buffer);  
//}

//********************************************************
//void Motor_Stop(void){
//    motor_status=STOP;
//    motor_run=0;
//    lcd_gotoxy(0,0); lcd_putsf("Stop Motor      ");    
//}

//********************************************************
void EEPROM_Load(void){
    motor_pwm=motor_pwm_eeprom;
}

//********************************************************
void EEPROM_Save(void){
    motor_pwm_eeprom=motor_pwm;
    delay_ms(10);
}

//********************************************************
void EEPROM_Default(void){
    motor_pwm=50;
    motor_pwm_eeprom=motor_pwm;
    delay_ms(10); 
    motor_pwm=motor_pwm_eeprom;
}
