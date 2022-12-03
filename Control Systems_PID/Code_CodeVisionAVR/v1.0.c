#include <mega32a.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>
flash char LCD_COLUMN=16;

#include <Attachment\Define_Char.h>
#include <Attachment\Config_ADC.h>
#include <Attachment\Oven.h>
#include <Attachment\ControlSystem_PID.h>

void Config_LCD(void);
void Display_LoadingPage(unsigned int);
void Display_MainPage(float,float,float);
void Config_Timer1(void);
void PWM_Driver(float);

void main(void){
    float in_v=0;
    float temp=0;
    float sp=250;
    float output_power=0;
    unsigned int display_counter=0;
    
    Config_ADC();      
    Config_LCD(); 
    define_char(CHAR_DEGREE,0);
    Config_Timer1();
   
    Display_LoadingPage(250); 
   
    while (1){  
        in_v=Get_ADC_V(CH_OVEN); temp=Get_OvenTemp(in_v);
        output_power=PID_ControlSystem(sp,temp,1); 
        PWM_Driver(output_power); 
        
        ++display_counter; if(display_counter>100){Display_MainPage(sp,temp,output_power); display_counter=0;}   
    }
}

//******************************************
void Display_MainPage(float sp,float pv,float output_power){
    char txt[LCD_COLUMN];
    //lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("                "); 
    
    sprintf(txt,"SP:%3.0f",sp); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putchar(0); 
    sprintf(txt,"PV:%3.0f",pv); lcd_gotoxy(8,0); lcd_puts(txt);  lcd_putchar(0); 
    
    if(output_power>100){sprintf(txt,"PID=%3.1f(100%%) ",output_power); lcd_gotoxy(0,1); lcd_puts(txt);}
        else {sprintf(txt,"PID=%3.1f%%       ",output_power); lcd_gotoxy(0,1); lcd_puts(txt);}
    //lcd_gotoxy(0,1); lcd_putsf("PID Control");
}

//******************************************
void PWM_Driver(float x){
    float y=0; 
    if(x<0){x=0;} else if(x>100){x=100;}     //x=0~100%
    //x=100-x;   //inverse 
    y=(x*1023)/100;   //y=0~1023
    if(y<=0){y=0;}  //y=0~1023
    OCR1A=y;     
}

//********************************************************
void Config_Timer1(void){
    DDRD.4=1; PORTD.4=0;
    DDRD.5=1; PORTD.5=0;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 125.000 kHz
    // Mode: Ph. correct PWM top=0x03FF
    // OC1A output: Non-Inverted PWM
    // OC1B output: Inverted PWM
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 16.368 ms
    // Output Pulse(s):
    // OC1A Period: 16.368 ms Width: 0 us
    // OC1B Period: 16.368 ms Width: 16.368 ms
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (1<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
}

//******************************************
void Display_LoadingPage(unsigned int t){
    lcd_gotoxy(0,0); lcd_putsf("Please Wait ...");
    delay_ms(t); lcd_clear();
} 

//********************************************************
void Config_LCD(void){
    lcd_init(LCD_COLUMN);
    lcd_clear();
}

