// GitHub Account:  GitHub.com/AliRezaJoodi

#include <mega32.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
#include <lcd.h>

#define GAIN    5000/1023

typedef unsigned char byte;
flash byte char0[8]={
    0b10000111,
    0b10000101,
    0b10000111,
    0b10000000,
    0b10000000,
    0b10000000,
    0b10000000,
    0b10000000
};

void Config_LCD(void);
void Display_Advertising(void);
void define_char(byte flash *pc,byte);
void Config_ADC(void);
float Read_adc(unsigned char);
float Convert(float);
void Display_LCD_1(float, float);

float Input_mV=0;
float Temp_c=0;
float Temp_k=0;

void main(void){
    Config_ADC();
    Config_LCD();
    define_char(char0,0); 
    Display_Advertising(); 
    
    while (1){
        Input_mV = Read_adc(7);
        Temp_k = Convert(Input_mV);
        Temp_c = Temp_k - 273.15;
        Display_LCD_1(Temp_k, Temp_c);
        delay_ms(300);                                        
    };
}

//********************************************************
void Config_LCD(void){
    lcd_init(16); lcd_clear();   
}

//********************************************************
void define_char(byte flash *pc,byte char_code){
    byte i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}

//********************************************************
void Config_ADC(void){
    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;

    // ADC initialization
    // ADC Clock frequency: 125.000 kHz
    // ADC Voltage Reference: AVCC pin
    ADMUX=0x40 & 0xff;
    ADCSRA=0x83;
}

//********************************************************
void Display_Advertising(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("GitHub.com");
    lcd_gotoxy(0,1); lcd_putsf("AliRezaJoodi");
    delay_ms(500); lcd_clear();
}

//********************************************************
float Read_adc(unsigned char adc_input){
    float x=0;
    ADMUX=adc_input | (0x40 & 0xff);
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    x=ADCW; x= x*GAIN;
    return x;
}

//********************************************************
float Convert(float x){
     x=x/10;	//Lm35 outputs 10mv for each C degree
     return x;
}

//********************************************************
void Display_LCD_1(float Temp_k, float Temp_c){
    char buffer[16];
    
    lcd_gotoxy(0,0); 
    lcd_putsf("Temp("); lcd_putchar(0); lcd_putsf("K):");
    ftoa(Temp_k,1,buffer); lcd_puts(buffer); lcd_putsf(" ");  
    
    lcd_gotoxy(0,1); 
    lcd_putsf("Temp("); lcd_putchar(0); lcd_putsf("C):");
    ftoa(Temp_c,1,buffer); lcd_puts(buffer); lcd_putsf(" ");    
}

