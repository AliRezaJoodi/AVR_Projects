#include <mega16.h>
#include <stdio.h>
#include <delay.h>
#include <stdlib.h>
#define xtal 11059200

#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))
#define CHKBIT(ADDRESS,BIT)  (ADDRESS &(1<<BIT))

#define Buzzer PORTD.7
#define LED_RED PORTD.5
#define LED_Green PORTD.6
#define Relay PORTC.0

#define Key_Read PINA.3
#define Key_Register PINC.7
#define Key_Unregister PINC.3

#define Telcard_RST PORTB.2
#define Telcard_CLK PORTB.1
#define Telcard_DATA PINA.0
#define Telcard_key PINB.0

#define Max 120

unsigned int credit;
char data[65];
//unsigned int x[10];

char buffer[16];
eeprom unsigned char Serial_Number[Max][4];

void GET_TelCard(void);
void Show_credit(void);
void t1(void);
void Sound_Error(void);
void Sound_OK(void);
unsigned char Card_NO(void);
unsigned char Card_Find(void);

void main(void){

    unsigned char z=0;
    
    DDRC.0=1; PORTC.0=0;
    DDRD.7=1; PORTD.7=0;
    DDRD.6=1; PORTD.6=0;
    DDRD.5=1; PORTD.5=0;

    DDRA.3=0; PORTA.3=1;
    DDRC.7=0; PORTC.7=1;
    DDRC.3=0; PORTC.3=1;

    DDRB.2=1; PORTB.2=0;
    DDRB.1=1; PORTB.1=0;
    DDRA.0=0; PORTA.0=1;
    DDRB.0=0; PORTB.0=1;

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

    putsf("OK");
    Sound_OK();
    
    while (1){
        if(Key_Read==0){
            GET_TelCard();
            z=Card_NO();
            if(z==1){
                z=Card_Find();
                itoa(z,buffer); puts(buffer);
            }
            else{
                Sound_Error();
            }
            delay_ms(500);    
        }
        
        if(Key_Register==0){
            //Sound_OK();
            GET_TelCard();
            //t1(); 
            //LED_Green=1;
            z=Card_NO();
            if(z==1){
                //LED_Green=1; LED_RED=0;
                t1();
                Sound_OK();
            }
            else{
                //LED_Green=0; LED_RED=1;
                Sound_Error();
            }
            delay_ms(500);
        }
    }   
}

void t1(){
    unsigned char i,j;
    Serial_Number[5][0]=data[5]; 
    Serial_Number[5][1]=data[6]; 
    Serial_Number[5][2]=data[7]; 
    Serial_Number[5][3]=data[8];    
}

unsigned char Card_Find(void){
    unsigned char i=Max;
    for(i=0;i<Max;i++){
        if(Serial_Number[i][0]==data[5] & Serial_Number[i][1]==data[6] & Serial_Number[i][2]==data[7] & Serial_Number[i][3]==data[8]){
            goto E1;
        }
    }
    E1:
    return i;    
}

unsigned char Card_NO(void){
    unsigned char i=1;
    if(data[5]==0xFF & data[6]==0xFF & data[7]==0xFF & data[8]==0xFF){
        i=0;
    }
    return i;
}

//*******************************************************
void Sound_Error(void){
    unsigned char i=0;
    Buzzer=0;
    for (i=1;i<=30;i++){
        Buzzer=1; delay_us(3000); Buzzer=0; delay_us(250);    
    } 
}

//*******************************************************
void Sound_OK(void){
    unsigned char i=0;
    Buzzer=0;
    for (i=1;i<=100;i++){
        Buzzer=1; delay_us(250); Buzzer=0; delay_us(250);    
    }     
}

//*******************************************************
void GET_TelCard(void){     
        unsigned char i,j;
        for (j=1;j<=64;j++)data[j]=0;
        Telcard_RST=1; Telcard_CLK=1; delay_ms(150);
        Telcard_RST=1;
        Telcard_CLK=1; delay_us(50); Telcard_CLK=0;
        Telcard_RST=0;
        for(j=1;j<=64;j++){
            for(i=1;i<=8;i++){
                Telcard_CLK=1; delay_us(50);
                data[j]=data[j]<<1;
                if(Telcard_DATA==1){data[j]=data[j]|0B00000001;}
                Telcard_CLK=0;
            }
            //itoa(data[j],buffer); puts(buffer);
        }    
}


//*******************************************************           
void Show_credit(void){
    itoa(credit,buffer); puts(buffer);
}
