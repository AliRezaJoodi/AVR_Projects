#include <mega32a.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>
flash char LCD_COLUMN=16;

#include <Attachment\Define_Char.h>
#include <Attachment\Config_ADC.h>
#include <Attachment\LM35.h>
#include <Attachment\ControlSystem_OnOff.h>

#ifndef RLY0_DDR
    #define RLY0_DDR DDRC.1
    #define RLY0_PORT PORTC.1
    #define RLY0_PIN PINC.1 
#endif
#define RLY0 RLY0_PORT
#define RLY0_INDEX 0
#define HEATER_RLY RLY0_PORT

#ifndef RLY1_DDR
    #define RLY1_DDR DDRC.2
    #define RLY1_PORT PORTC.2
    #define RLY1_PIN PINC.2 
#endif
#define RLY1 RLY1_PORT
#define RLY1_INDEX 0
#define COOLER_RLY RLY1_PORT

#ifndef ACTIVATE_RLY
    #define ACTIVATE_RLY 1
#endif
#define DEACTIVATE_RLY !ACTIVATE_RLY
#define DEFAULT_RLY DEACTIVATE_RLY

void Config_LCD(void);
void Display_Loading(void);
void Config_IO(void);
void Display_Temp(float,float);
void Display2_Temp(float,float);

void main(void){
    float in_mv=0; float temp=0;
    float sp=25; 
    float hystersis=10;
    
    Config_ADC();      
    Config_IO();
    Config_LCD(); 
    define_char(CHAR_DEGREE,0);
    Display_Loading(); 
    
    while (1){
        in_mv=Get_ADC_mV(CH_LM35); temp=Get_Temp_LM35(in_mv);  
        Display_Temp(sp,temp);
        HEATER_RLY=OnOff_ControlSystem2_Heater(sp,temp,hystersis);
        COOLER_RLY=OnOff_ControlSystem2_Cooler(sp,temp,hystersis);
    }
}

//******************************************
void Display_Temp(float sp,float temp){
    char txt[LCD_COLUMN]; 
    sprintf(txt,"Temp=%3.1f",temp); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putchar(0); lcd_putsf("  ");
    sprintf(txt,"Setpoint=%3.1f",sp); lcd_gotoxy(0,1); lcd_puts(txt); lcd_putchar(0); lcd_putsf("  ");
}

//******************************************
void Display2_Temp(float sp,float temp){
    char txt[LCD_COLUMN]; 
    sprintf(txt,"PV=%2.0f",temp); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putchar(0); lcd_putsf(" ");
    sprintf(txt,"SP=%2.0f",sp); lcd_gotoxy(8,0); lcd_puts(txt); lcd_putchar(0); lcd_putsf(" ");
    lcd_gotoxy(0,1); lcd_putsf("ON/OFF Control"); 
}

//******************************************
void Config_IO(void){
    #define INPUT 0   
    #define OUTPUT !INPUT
    RLY0_DDR=OUTPUT; RLY0_PORT=DEFAULT_RLY; 
    RLY1_DDR=OUTPUT; RLY1_PORT=DEFAULT_RLY;
}

//********************************************************
void Config_LCD(void){
    lcd_init(LCD_COLUMN);
    lcd_clear();
}

//********************************************************
void Display_Loading(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("Testing the LCD");
    lcd_gotoxy(0,1); lcd_putsf("Loading ...");
    delay_ms(500); lcd_clear();
}
