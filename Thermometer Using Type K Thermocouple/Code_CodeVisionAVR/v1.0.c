// GitHub Account:  GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <stdio.h>
#include <delay.h>
#include <alcd.h>

#include <Attachment\Hardware_v1.0.h>
#include <Attachment\Thermocouple_K.h>
#include <Attachment\Define_Char.h>
#include <Attachment\Config_ADC.h>

float tc_mv=0;
int tc_temp;

void Config_LCD(void);
void Config_ADC(void);
float Get_ADC(unsigned char);
void Display_Temp(float,int);
void Test(void);

void main(void){
    Config_LCD();
    Config_ADC();
    
    //Test();
     
    while (1){   
        tc_mv=Get_ADC_mV(CH_TC); tc_temp=Get_Temp_TC(tc_mv);
        Display_Temp(tc_mv,tc_temp);       
        delay_ms(250);
    }
}

//******************************************
void Test(void){
    tc_mv=Get_mV_TC(1000);
    //tc_mv = -6.404; 
    //tc_temp=Get_Temp_TC(tc_mv);
    Display_Temp(tc_mv,tc_temp); 
    while(1){}
}

//******************************************
void Display_Temp(float in_mv,int temp){
    char txt[LCD_COLUMN];
    lcd_clear();
    //lcd_gotoxy(0,1); lcd_putsf("Type K TC"); 
    sprintf(txt,"TC:%4.3fmV",in_mv); lcd_gotoxy(0,0); lcd_puts(txt); //lcd_putsf("  ");
    if(-270<=temp && temp<=1372){    
        //sprintf(txt,"%4.3fmV  %4d",in_mv, tc_temp); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putchar(0); //lcd_putsf("  ");
        sprintf(txt,"TC:%4d",tc_temp); lcd_gotoxy(0,1); lcd_puts(txt); lcd_putchar(0); //lcd_putsf("  ");  
    }
    else{lcd_gotoxy(0,1); lcd_putsf("TC:Null"); lcd_putsf("    ");};  
}

//********************************************************
void Config_LCD(void){
    lcd_init(LCD_COLUMN);
    define_char(CHAR_DEGREE,0);
    lcd_clear();
}



   
