// GitHub Account:  GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <stdio.h>
#include <delay.h>
#include <alcd.h>

#include <Attachment\Hardware_v1.0.h>
#include <Attachment\Table_Thermocouple_K.h>
#include <Attachment\Define_Char.h>

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input){
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}

float tc_mv=0;
int tc_temp;

void Config_LCD(void);
void Config_ADC(void);
float Get_ADC_Thermocouple(void);
void Display_Temp(float,int);
void Test(void);

void main(void){
    Config_LCD();
    define_char(char0,0);
    Config_ADC();
     
    while (1){   
        tc_mv=Get_ADC_Thermocouple(); tc_temp=Converter_Thermocouple_K(tc_mv);
        Display_Temp(tc_mv,tc_temp);       
        delay_ms(250);
    }
}

//******************************************
void Test(void){
    //tc_mv=Table_TC_K[70];
    tc_mv = -6.404; 
    tc_temp=Converter_Thermocouple_K(tc_mv);
    Display_Temp(tc_mv,tc_temp); 
    while(1){}
}

//******************************************
float Get_ADC_Thermocouple(void){
    float out=0;
    unsigned int x=0;  
    x=read_adc(CH_ADC_TC);
    out=x; 
    out=out*GAIN_ADC;
    out=out*GAIN_TC;   
    return out;
}

//********************************************************
// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
void Config_ADC(void){
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
}

//******************************************
void Display_Temp(float in_mv,int temp){
    char txt[LCD_COLUMN];
    lcd_clear();
    lcd_gotoxy(0,1); lcd_putsf("Type K TC"); 
    if(-270<=temp && temp<=1372){    
        sprintf(txt,"%3.3fmV  %4d",in_mv, tc_temp); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putchar(0); //lcd_putsf("  "); 
    }
    else{lcd_gotoxy(0,0); lcd_putsf("TC:Null"); lcd_putsf("    ");};  
}

//********************************************************
void Config_LCD(void){
    lcd_init(LCD_COLUMN);
    lcd_clear();
}



   
