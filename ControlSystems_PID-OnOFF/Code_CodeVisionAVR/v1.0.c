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

#ifndef RLY0_DDR
    #define RLY0_DDR DDRD.5
    #define RLY0_PORT PORTD.5
    #define RLY0_PIN PIND.5 
#endif
#define RLY0 RLY0_PORT
#define RLY0_INDEX 0
#define HEATER_RLY RLY0_PORT

#ifndef ACTIVATE_RLY
    #define ACTIVATE_RLY 1
#endif
#define DEACTIVATE_RLY !ACTIVATE_RLY
#define DEFAULT_RLY DEACTIVATE_RLY

void Config_IO(void);
void Config_LCD(void);
void Display_LoadingPage(unsigned int);
void Display_MainPage(float,float,float);
void Config_Timer0(void);

unsigned int count=0;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
    ++count; 
    if(count>=100){count=0;}   //Timer Period x 100 = 32.768ms x 100 = 3.2768s
}

void main(void){
    float in_v=0;
    float temp=0;
    float sp=250;
    float output_power=0; 
    
    unsigned int display_counter=0;
    
    Config_ADC();
    Config_IO();     
    Config_LCD(); 
    define_char(CHAR_DEGREE,0);
    Display_LoadingPage(250); 
    DDRD.5=1; PORTD.5=0;
    Config_Timer0();
    
    while (1){  
        in_v=Get_ADC_V(CH_OVEN); temp=Get_OvenTemp(in_v);
        output_power=PID_ControlSystem(sp,temp,1);
        if(count<=output_power){HEATER_RLY=ACTIVATE_RLY;} else {HEATER_RLY=DEACTIVATE_RLY;}   //Convert PID Controller to ON/OFF PID Controller 
         
        ++display_counter; if(display_counter>100){Display_MainPage(sp,temp,output_power); display_counter=0;}      
    }
}

//******************************************
void Config_Timer0(void){
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 7.813 kHz
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    // Timer Period: 32.768 ms
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
    TCNT0=0x00;
    OCR0=0x00;
    
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    //#asm("cli") // Global Disable interrupts
    #asm("sei") // Global Enable interrupts 
}

//******************************************
void Config_IO(void){
    #define INPUT 0   
    #define OUTPUT !INPUT
    RLY0_DDR=OUTPUT; RLY0_PORT=DEFAULT_RLY; 
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
    //lcd_gotoxy(0,1); lcd_putsf("ON/OFF PID");
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

