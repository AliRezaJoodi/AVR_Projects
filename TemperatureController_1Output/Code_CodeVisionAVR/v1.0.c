// GitHub Account:  GitHub.com/AliRezaJoodi

#include <mega16a.h>
#include <delay.h>
#include <stdlib.h>

// Alphanumeric LCD Module functions
#include <alcd.h>
#include "Attachment\Buzzer.h"

#define LED1 PORTB.1
#define LED2 PORTB.2
#define RELAY PORTD.7
#define BUTTON_UP PIND.5 
#define BUTTON_SET PIND.6 
#define BUTTON_DOWN PIND.2  

#define ADC_VREF_TYPE 0x40
unsigned int read_adc(unsigned char);

void Button_Config(void);
void Relay_Config(void);
void LEDs_Config(void);
void ADC_Config(void);
float Temp_Get(void);
void LCD_Display_MainPage(void);
void Termostat(void);
void EEPROM_Default(void);
void EEPROM_Load(void);
void EEPROM_Save(void);
void Set_SP_Increase(void);
void Set_SP_Decrease(void);

float temp;
float setpoint; 
eeprom float setpoint_eeprom; 

void main(void){
    float _temp_buffer=25;
    
    Button_Config();
    Relay_Config();
    LEDs_Config();
    ADC_Config();
    lcd_init(16);
    Buzzer_Config(); 
    
    //EEPROM_Default();
    EEPROM_Load();
    LCD_Display_MainPage();
    Buzzer_MakeBeep(BEEP_SET);
    
    while(1){
        temp=Temp_Get();
        if(temp!=_temp_buffer){ 
            LCD_Display_MainPage();
            _temp_buffer=temp;
        }
                                      
        Termostat(); 
        
        if(BUTTON_UP==0){
            delay_ms(120);
            while(BUTTON_UP==0){
                Set_SP_Increase();
                LCD_Display_MainPage();
                Buzzer_MakeBeep(BEEP_UP);
                //delay_ms(30);    
            }
           EEPROM_Save();
        } 
         
        if(BUTTON_DOWN==0){
            delay_ms(120);
            do{
                Set_SP_Decrease();
                LCD_Display_MainPage(); 
                Buzzer_MakeBeep(BEEP_DOWN);
                //delay_ms(30);    
            }
            while(BUTTON_DOWN==0);
           EEPROM_Save();
        }   
    }
}

//*******************************************************
float Temp_Get(void){
    float _temp=0; 
    unsigned int _buffer=0;
    unsigned char _i=0;
    
    do{
        _buffer=_buffer+read_adc(0);
        ++_i;
    }
    while(_i<100); 
    _temp=_buffer/100; 
     
    return _temp/2.048;
}

//*******************************************************
void LCD_Display_MainPage(void){
    char text[16];
    
    ftoa(temp,1,text);
    lcd_gotoxy(0,0); lcd_putsf("Temp(C):"); lcd_puts(text); 
    ftoa(setpoint,1,text);
    lcd_gotoxy(0,1); lcd_putsf("Setpoint:"); lcd_puts(text);  
}

//*******************************************************
void Termostat(void){
    float _max=0;
    float _min=0;

    _max=setpoint;
    _min=setpoint-5;
     
    if(temp>_max){RELAY=0; LED1=0;}  
        else if(temp<=_min){RELAY=1; LED1=1;}    
}

//*******************************************************
void EEPROM_Default(void){
    setpoint_eeprom = 30; delay_ms(10);
}

//*******************************************************
void EEPROM_Load(void){
    setpoint = setpoint_eeprom;
}

//*******************************************************
void EEPROM_Save(void){
    setpoint_eeprom = setpoint; delay_ms(10);
}

//*******************************************************
void Set_SP_Increase(void){
    setpoint=setpoint+0.1; 
    if(setpoint>150){setpoint=150;}
}

//*******************************************************
void Set_SP_Decrease(void){
    setpoint=setpoint-0.1; 
    if(setpoint<0){setpoint=0;}
}

//*******************************************************
void Button_Config(void){ 
    DDRD.5=0; PORTD.5=1;
    DDRD.6=0; PORTD.6=1;
    DDRD.2=0; PORTD.2=1;
}

//*******************************************************
void Relay_Config(void){
    DDRD.7=1; PORTD.2=0;
}

//*******************************************************
void LEDs_Config(void){
    DDRB.1=1; PORTB.1=0;
    DDRB.2=1; PORTB.2=0;
}

//*******************************************************
void ADC_Config(void){
    // ADC initialization
    // ADC Clock frequency: 691.200 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Auto Trigger Source: ADC Stopped
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x84;
}

//*******************************************************
unsigned int read_adc(unsigned char adc_input){
    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    return ADCW;
}
