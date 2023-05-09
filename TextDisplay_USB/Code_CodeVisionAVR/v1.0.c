// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>
#include <delay.h>

unsigned char i=0;
char Buffer;
char Buffer_UART[17];

void Config_USART (void);
void Config_LCD(void);
void LcdLineCleaner(unsigned char);
void BufferCleaner(void);

void main(void){
    char i2=0;     
    
    Config_LCD();
    Config_USART();
    	
    while (1){ 
        Buffer=getchar(); 
        
        if(Buffer!=13){Buffer_UART[i]=Buffer; ++i;}          
            else{ 
                if(Buffer_UART[0]=='1'){   
                    LcdLineCleaner(0);
                    lcd_gotoxy(0,0); 
                    for(i2=1;i2<=16;++i2){
                        if(Buffer_UART[i2]>=32 & Buffer_UART[i2]<=126){lcd_putchar(Buffer_UART[i2]);}
                    }   
                } 
                
                if(Buffer_UART[0]=='2'){ 
                    LcdLineCleaner(1);
                    lcd_gotoxy(0,1); 
                    for(i2=1;i2<=16;++i2){
                        if(Buffer_UART[i2]>=32 & Buffer_UART[i2]<=126){lcd_putchar(Buffer_UART[i2]);}
                    }   
                }
                
                BufferCleaner(); i=0;  
            } 
    };
}

//**************************************
void BufferCleaner(void){
    char i=0;
    for(i=0;i<=16;++i){
        Buffer_UART[i]='';
    } 
}

//**************************************
void LcdLineCleaner(unsigned char line){
    lcd_gotoxy(0,line); lcd_putsf("                ");
}

//**************************************
void Config_USART (void){
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x47;
}

//**************************************
void Config_LCD(void){
    lcd_init(16); lcd_clear(); lcd_gotoxy(0,0);
}