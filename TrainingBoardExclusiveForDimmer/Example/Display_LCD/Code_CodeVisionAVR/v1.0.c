//GitHub Account:     GitHub.com/AliRezaJoodi

#include <mega16a.h>
#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

void Configuration_LCD(void);
void Display_Loading(void);
void Display_Advertising(void);

void main(void){

    Configuration_LCD();
    Display_Loading(); 
    //Display_Advertising();
    
    while(1){
    };
}

//********************************************************
void Configuration_LCD(void){
    lcd_init(16); lcd_clear();   
}

//********************************************************
void Display_Loading(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("Testing the LCD");
    lcd_gotoxy(0,1); lcd_putsf("Loading ...");
    //delay_ms(500); lcd_clear();
}

//********************************************************
void Display_Advertising(void){
    lcd_clear(); 
    lcd_gotoxy(0,0); lcd_putsf("GitHub.com");
    lcd_gotoxy(0,1); lcd_putsf("AliRezaJoodi");
    delay_ms(500); lcd_clear();
}
