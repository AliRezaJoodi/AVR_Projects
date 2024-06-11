// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>               
#include <delay.h>                                      
#include <stdio.h>  
#include <Attachment/shtxx.h>   

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

#define BUZZER PORTC.3
#define BUZZER_Direction DDRC.3

#define RELAY_DEHUMIDIFIERS PORTC.4
#define RELAY_DEHUMIDIFIERS_Direction DDRC.4
#define RELAY_HUMIDIFIER PORTC.5
#define RELAY_HUMIDIFIER_Direction DDRC.5
#define RELAY_FAN PORTC.2
#define RELAY_FAN_Direction DDRC.2
#define RELAY_HEATER PORTC.1
#define RELAY_HEATER_Direction DDRC.1

#define KEY_UP1 PINC.0
#define KEY_UP1_Direction DDRC.0
#define KEY_UP1_Pullup PORTC.0
#define KEY_DOWN1 PIND.5
#define KEY_DOWN1_Direction DDRD.5
#define KEY_DOWN1_Pullup PORTD.5
#define KEY_SET PIND.4
#define KEY_SET_Direction DDRD.4
#define KEY_SET_Pullup PORTD.4
#define KEY_UP2 PIND.7
#define KEY_UP2_Direction DDRD.7
#define KEY_UP2_Pullup PORTD.7
#define KEY_DOWN2 PIND.6
#define KEY_DOWN2_Direction DDRD.6
#define KEY_DOWN2_Pullup PORTD.6

#define HYSTERESIS 1
#define ACTIVE 1
#define INACTIVE 0
#define OUTPUT 1
#define INPUT 0

void Config_Buzzer(void);
void Config_Relays(void);
void Config_Keys(void);
void Display_MainPage(void);
void Display_humidity_controler(void);
void Display_temperature_controler(void);
void Sound_Menu(void);
void Sound_Pressing(void);
void Sound_Error(void);
void Eeprom_Load(void);
void Eeprom_Save(void);
void Eeprom_Defult(void);
void Activation_Dehumidifiers(void);
void Activation_Humidifier(void);
void Activation_Heater(void);
void Activation_Fan(void);
 
//char buffer_lcd[16]; 
unsigned char status_display=0;
bit status_key_set=0;

float humidity;
float humidity_min;
eeprom float humidity_min_eeprom;
float humidity_max;
eeprom float humidity_max_eeprom;

float temperature;
float temperature_min;
eeprom float temperature_min_eeprom;
float temperature_max;
eeprom float temperature_max_eeprom;
                                
void main(void){ 
    Config_Buzzer();
    Config_Relays();
    Config_Keys();
    
    DDRB.1=0; PORTB.1=1;
    DDRB.0=1; PORTB.0=1;
                               
    lcd_init(16);
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("Please Wait ...");
        
    if(KEY_DOWN1==0 && KEY_DOWN2==0){
        Eeprom_Defult();
        lcd_clear();
        lcd_gotoxy(0,0); lcd_putsf("Please Wait ...");
        lcd_gotoxy(0,1); lcd_putsf("Default Settings");
        delay_ms(400);
    }

    Eeprom_Load();
    Sound_Menu();
                                       
    while(1){
        delay_ms(100);
        //Display_MainPage();
        
        humidity= Get_Humidity();
        temperature= Get_Temp();
        
        if(KEY_SET==0 && status_key_set==0){
            status_key_set=1;
            Sound_Menu();
            status_display++; if(status_display>2){status_display=0;}
        }
        if(KEY_SET==1){status_key_set=0;}
        
        if(status_display==0){Display_MainPage();}
            else if(status_display==1){Display_humidity_controler();}
                else if(status_display==2){Display_temperature_controler();}
        
        while(KEY_UP1==0 && status_display==1){
            Sound_Pressing();
            humidity_min=humidity_min+0.5; if(humidity_min>(humidity_max-1)){humidity_min=0;}
            Display_humidity_controler();
            humidity_min_eeprom=humidity_min; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_DOWN1==0 && status_display==1){
            Sound_Pressing();
            humidity_min=humidity_min-0.5; if(humidity_min<=0){humidity_min=(humidity_max-1);}
            Display_humidity_controler();
            humidity_min_eeprom=humidity_min; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_UP2==0 && status_display==1){
            Sound_Pressing();
            humidity_max=humidity_max+0.5; if(humidity_max>100){humidity_max=(humidity_min+1);}
            Display_humidity_controler();
            humidity_max_eeprom=humidity_max; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_DOWN2==0 && status_display==1){
            Sound_Pressing();
            humidity_max=humidity_max-0.5; if(humidity_max<(humidity_min+1)){humidity_max=100;}
            Display_humidity_controler();
            humidity_max_eeprom=humidity_max; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_UP1==0 && status_display==2){
            Sound_Pressing();
            temperature_min=temperature_min+0.5; if(temperature_min>(temperature_max-1)){temperature_min=0;}
            Display_temperature_controler();
            temperature_min_eeprom=temperature_min; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_DOWN1==0 && status_display==2){
            Sound_Pressing();
            temperature_min=temperature_min-0.5; if(temperature_min<=0){temperature_min=(temperature_max-1);}
            Display_temperature_controler();
            temperature_min_eeprom=temperature_min; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_UP2==0 && status_display==2){
            Sound_Pressing();
            temperature_max=temperature_max+0.5; if(temperature_max>100){temperature_max=(temperature_min+1);}
            Display_temperature_controler();
            temperature_max_eeprom=temperature_max; delay_ms(10);
            delay_ms(20);
        }
        
        while(KEY_DOWN2==0 && status_display==2){
            Sound_Pressing();
            temperature_max=temperature_max-0.5; if(temperature_max<(temperature_min+1)){temperature_max=100;}
            Display_temperature_controler();
            temperature_max_eeprom=temperature_max; delay_ms(10);
            delay_ms(20);
        }
        
        Activation_Dehumidifiers();
        Activation_Humidifier();
        Activation_Heater();
        Activation_Fan();                                            
    }
}

//******************************************
void Config_Buzzer(void){
    BUZZER_Direction=OUTPUT; BUZZER=INACTIVE; 
}

//******************************************
void Config_Relays(void){
    RELAY_DEHUMIDIFIERS_Direction=OUTPUT; RELAY_DEHUMIDIFIERS=INACTIVE;
    RELAY_HUMIDIFIER_Direction=OUTPUT; RELAY_HUMIDIFIER=INACTIVE;
    RELAY_FAN_Direction=OUTPUT; RELAY_FAN=INACTIVE;
    RELAY_HEATER_Direction=OUTPUT; RELAY_HEATER=INACTIVE;
}

//******************************************
void Config_Keys(void){
    KEY_UP1_Direction=INPUT; KEY_UP1_Pullup=ACTIVE;
    KEY_DOWN1_Direction=INPUT; KEY_DOWN1_Pullup=ACTIVE;
    KEY_SET_Direction=INPUT; KEY_SET_Pullup=ACTIVE;
    KEY_UP2_Direction=INPUT; KEY_UP2_Pullup=ACTIVE;
    KEY_DOWN2_Direction=INPUT; KEY_DOWN2_Pullup=ACTIVE;
}

//******************************************
void Display_MainPage(void){
    char txt[16]; 
    lcd_clear();

    sprintf(txt,"RH(%%): %3.1f",humidity); lcd_gotoxy(0,0); lcd_puts(txt);  
    sprintf(txt,"Temp(C): %3.1f",temperature); lcd_gotoxy(0,1); lcd_puts(txt); 
}

//******************************************
void Display_humidity_controler(void){
    char txt[16];
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("RH Controler: ");
    sprintf(txt,"%3.1f<%3.1f<%3.1f",humidity_min,humidity,humidity_max); lcd_gotoxy(0,1); lcd_puts(txt);
}

//******************************************
void Display_temperature_controler(void){
    char txt[16];
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("Temp Controler: ");
    sprintf(txt,"%3.1f<%3.1f<%3.1f",temperature_min,temperature,temperature_max); lcd_gotoxy(0,1); lcd_puts(txt);
}

//******************************************
void Activation_Dehumidifiers(void){
    if(humidity>humidity_max){RELAY_DEHUMIDIFIERS=ACTIVE;}
    else if(humidity<(humidity_max-HYSTERESIS)){RELAY_DEHUMIDIFIERS=INACTIVE;}
}

//******************************************
void Activation_Humidifier(void){
    if(humidity<humidity_min){RELAY_HUMIDIFIER=ACTIVE;}
    else if(humidity>(humidity_min+HYSTERESIS)){RELAY_HUMIDIFIER=INACTIVE;}
}

//******************************************
void Activation_Heater(void){
    if(temperature<temperature_min){RELAY_HEATER=ACTIVE;}
    else if(temperature>(temperature_min+HYSTERESIS)){RELAY_HEATER=INACTIVE;}
}

//******************************************
void Activation_Fan(void){
    if(temperature>temperature_max){RELAY_FAN=ACTIVE;}
    else if(temperature<(temperature_max-HYSTERESIS)){RELAY_FAN=INACTIVE;}
}

//******************************************
void Sound_Menu(void){
    long i_Sound;
    for (i_Sound=1;i_Sound<=400;++i_Sound) {
        BUZZER=1; delay_us(250);
        BUZZER=0; delay_us(250);
    };    
}

//******************************************
void Sound_Pressing(void){
    //unsigned int i_Sound;
    long i_Sound;
    for (i_Sound=1;i_Sound<=400;++i_Sound) {
        BUZZER=1; delay_us(200);
        BUZZER=0; delay_us(200);
    };   
}

//******************************************
void Sound_Error(void){
    long i_Sound;
    for (i_Sound=1;i_Sound<=100;++i_Sound) {
        BUZZER=1; delay_us(500);
        BUZZER=0; delay_us(500);
    };    
}

//******************************************
void Eeprom_Save(void){

}

//******************************************
void Eeprom_Load(void){
    humidity_min=humidity_min_eeprom; delay_ms(10);
    humidity_max=humidity_max_eeprom; delay_ms(10);
    temperature_min=temperature_min_eeprom; delay_ms(10);
    temperature_max=temperature_max_eeprom; delay_ms(10);
}

//******************************************
void Eeprom_Defult(void){
    humidity_min_eeprom=40; delay_ms(10);
    humidity_max_eeprom=80; delay_ms(10);
    temperature_min_eeprom=25; delay_ms(10);
    temperature_max_eeprom=45; delay_ms(10);
}





