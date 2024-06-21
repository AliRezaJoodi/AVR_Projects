//GitHub Account: GitHub.com/AliRezaJoodi

#include <mega16a.h>
#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

void LCD_Config(void);
void LCD_Display_Loading(void);
void LCD_Display_ADS(void);

void main(void){

    LCD_Config();
    LCD_Display_Loading(); 
    LCD_Display_ADS();
    
    while(1){
    };
}

//********************************************************
void LCD_Config(void){
    lcd_init(16); lcd_clear();   
}

//********************************************************
void LCD_Display_Loading(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("Testing the LCD");
    lcd_gotoxy(0,1); lcd_putsf("Loading ...");
    delay_ms(500); lcd_clear();
}

//********************************************************
void LCD_Display_ADS(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("GitHub.com");
    lcd_gotoxy(0,1); lcd_putsf("AliRezaJoodi");
    //delay_ms(500); lcd_clear();
}
