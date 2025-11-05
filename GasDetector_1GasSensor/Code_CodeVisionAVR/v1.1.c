// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <delay.h>
#include <stdlib.h>
#include <alcd.h>

#define ADC_VREF_TYPE 0x40

#define key_up PIND.5 
#define key_set PIND.6  
#define key_down PIND.2
#define relay PORTD.7
#define Buzzer PORTC.4 

// Read the AD conversion result
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

// Declare your global variables here
void Read_the_ADC(void);
void Display_Percent(void);
void Check_off_the_Alarm(void);
void eeprom_load(void);
void eeprom_save(void);
void Setpoint_incr(void);
void Setpoint_decr(void);
void Alarm_setting(void);
void Sound_Menu(void);
void Sound_Pressing(void);
void Sound_3(void);

char buffer[16];
unsigned int adc_in;
float Input_Voltage;
unsigned char setpoint; 
eeprom unsigned char setpoint_eram; 
unsigned char setpoint_max;
unsigned char setpoint_min;
bit alarm_status;
bit key_set_status;

float Min;
eeprom float Min_eeprom;
float Max=5;
float Input_Percent;

void main(void){

    DDRD.5=0; PORTD.5=1;
    DDRD.6=0; PORTD.6=1;
    DDRD.2=0; PORTD.2=1;
    
    DDRD.7=1; PORTD.6=0;
    DDRC.4=1; PORTC.4=0;

    // ADC initialization
    // ADC Clock frequency: 691.200 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Auto Trigger Source: ADC Stopped
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x84;

    // Alphanumeric LCD initialization
    // Connections specified in the
    // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
    // RS - PORTC Bit 7
    // RD - PORTC Bit 6
    // EN - PORTC Bit 5
    // D4 - PORTC Bit 3
    // D5 - PORTC Bit 2
    // D6 - PORTC Bit 1
    // D7 - PORTC Bit 0
    // Characters/line: 16
    lcd_init(16);
    
    eeprom_load();

    if (key_set==0){
        delay_ms(30);
        if (key_set==0){
            Sound_Menu();
            Read_the_ADC();
            Min=Input_Voltage;
            Min_eeprom=Min;
        }
    } 
    if (key_set==1) key_set_status=0;
    
    Sound_Menu();

while (1){
    Read_the_ADC();
    Display_Percent();                                
    if (alarm_status==0) Check_off_the_Alarm();
    
    if (key_set==0 && key_set_status==0){
        delay_ms(30);
        if (key_set==0 && key_set_status==0){
            key_set_status=1;
            Sound_Menu();
            Alarm_setting();
        }
    } 
    if (key_set==1) key_set_status=0;
    
    if (key_up==0){
        delay_ms(30); 
        if (key_up==0){
           do{
                Sound_Pressing();
                Setpoint_incr();
                eeprom_save();
                Display_Percent();
                delay_ms(150);
           }
           while(key_up==0);
        }
    }
     
    if (key_down==0){
        delay_ms(30); 
        if (key_down==0){
            do{
                Sound_Pressing();
                Setpoint_decr();
                eeprom_save();
                Display_Percent();
                delay_ms(150);
            }
           while(key_down==0);
        }
    } 
      
    delay_ms(200); 
}
}

//*******************************************************
void Read_the_ADC(void){ 
    adc_in=read_adc(0);
    Input_Voltage=adc_in/0.2048;
    Input_Voltage=Input_Voltage/1000;
    Input_Percent=(Input_Voltage-Min)*(100/(Max-Min));
}

//*******************************************************
void Display_Percent(void){
    ftoa(Input_Percent,0,buffer); 
    lcd_gotoxy(0,0); lcd_putsf("Status: "); lcd_puts(buffer); lcd_putsf("% ");    
    ftoa(setpoint,0,buffer);
    lcd_gotoxy(0,1); lcd_putsf("Setpoint: "); lcd_puts(buffer); lcd_putsf("% ");    
}

//*******************************************************
void Check_off_the_Alarm(void){
    setpoint_max=setpoint;
    setpoint_min=setpoint-3; 
    if (Input_Percent>setpoint_max & Input_Percent<=100){
        relay=1;
        Sound_3();Sound_Menu();
    }  
    else if (Input_Percent<=setpoint_min) relay=0;    
}

//*******************************************************
void eeprom_load(void){
    setpoint = setpoint_eram;
    Min=Min_eeprom; delay_ms(10);
}

//*******************************************************
void eeprom_save(void){
      setpoint_eram = setpoint; 
      Min_eeprom=Min; delay_ms(10);
}

//*******************************************************
void Setpoint_incr(void){
    setpoint=setpoint+1; if(setpoint>100)setpoint=0;

}

//*******************************************************
void Setpoint_decr(void){
    setpoint=setpoint-1; if(setpoint>100)setpoint=0;
}

//*******************************************************
void Alarm_setting(void){
    if (alarm_status==0){alarm_status=1;} else{alarm_status=0;} 
    if (alarm_status==1){
        lcd_gotoxy(15,0); lcd_putsf("X");
        relay=0;
    }
    else{
        lcd_gotoxy(15,0); lcd_putsf(" ");
    }
}

//*******************************************************
void Sound_Menu(void){
    unsigned int i_Sound;
    for (i_Sound=1;i_Sound<=400;++i_Sound) {
        Buzzer=1; delay_us(250);
        Buzzer=0; delay_us(250);
    };    
}

//*******************************************************
void Sound_Pressing(void){
    unsigned int i_Sound;
    for (i_Sound=1;i_Sound<=400;++i_Sound) {
        Buzzer=1; delay_us(200);
        Buzzer=0; delay_us(200);
    };   
}

//*******************************************************
void Sound_3(void){
    unsigned int i_Sound;
    for (i_Sound=1;i_Sound<=100;++i_Sound) {
        Buzzer=1; delay_us(500);
        Buzzer=0; delay_us(500);
    };    
}
