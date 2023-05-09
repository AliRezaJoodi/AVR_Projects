// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <delay.h>
#include <lcd.h>
#include <stdlib.h>
#include <math.h>

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm

void Display_Start(void);
float Run(void);
char key_read(void);
char key_Convert(char);
void Mohasebe(void);
void Alamat(int);

float a=0, b=0, c=0;
char y=0, lcd[25], z;
unsigned char Key_status;

void main(void){
    lcd_init(16) ; lcd_clear();
    Display_Start();   
    while (1)
    {
        Run();
    }
}

//************************************************
void Display_Start(void){
    lcd_gotoxy(0,0); lcd_putsf("Loading ..."); 
    delay_ms(500); lcd_clear(); lcd_gotoxy(0,0);
}

//************************************************
float Run(void){
    int Loop = 1 ;
    y=key_read(); y=key_Convert(y); 
    if (y != Key_status){
        Key_status = y;
        if( y == 15 ){a=0; b=0; c=0; lcd_clear(); return 0;};
        if(y<=9){a=(a*10)+y; itoa(y,lcd); lcd_puts(lcd); delay_ms(500);};        
        if(y >=10 && y<= 15){
            if(y==15){a=0; b=0; c=0; lcd_clear(); return 0;}
            z=y;
            Alamat(y);
            while(Loop){
            y=key_read(); y=key_Convert(y); 
            if(y==15){a=0; b=0; c=0; lcd_clear(); return 0;}
                if(y<10){
                    b=(b*10)+y;
                    itoa(y,lcd);
                    lcd_puts(lcd);
                    delay_ms(500); 
                }
                else if(y==14){
                    lcd_putchar('='); 
                    Mohasebe();
                    delay_ms(500);
                    y=0; Loop=0;
                }
            }
        }
    };
return 0;
}

//************************************************
void Alamat(int Moji){
    if(Moji == 10){lcd_putchar('/');}
    if(Moji == 11){lcd_putchar('*');}
    if(Moji == 12){lcd_putchar('-');}
    if(Moji == 13){lcd_putchar('+');} 
    //delay_ms(500);      
}

//************************************************
char key_read(void){
    unsigned char key;     	
    DDRD = 0x0f; PORTD = 0xf0; delay_us(5); key = PIND;
  	DDRD = 0xf0; PORTD = 0x0f; delay_us(5); key = key | PIND;
    return key;
} 

//************************************************
char key_Convert(char key){
    unsigned char butnum; 
    unsigned char keytbl[16]={235,215 ,219 ,221 ,183 ,187 ,189 ,119 ,123 ,125,126 ,190 ,222 ,238 ,237 ,231};
        for(butnum = 0;butnum < 16;butnum ++){    
            if(key==keytbl[butnum])  break;   
  	    };
    return butnum;
}

//************************************************
void Mohasebe(void){                                          
    if(z == 10 && b != 0 ){c = a / b;};
    if(z == 11){c = a * b;};
    if(z == 12){c = a - b;};
    if(z == 13){c = a + b;};
    if(z == 10 && b == 0){lcd_putsf("Error");} else {ftoa(c , 2 , lcd); lcd_puts(lcd);};
}




