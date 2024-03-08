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
void Save(unsigned char i);
void Sound_Error(void);
void Sound_OK(void);
unsigned char Normaly_data(void);
unsigned char Finder(unsigned char F1,unsigned char F2,unsigned char F3,unsigned char F4);
void Unregister_all_card(void);
void Unregister_card(unsigned char i);

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
    
    if(Key_Unregister==0){
        delay_ms(30);
        if(Key_Unregister==0){
            Sound_OK(); Sound_Error(); Sound_OK();
            Unregister_all_card();
            LED_Green=0; LED_RED=0;
        }
    }
    
    while (1){
        if(Key_Read==0){
            GET_TelCard();
            //z=Normaly_data();
            if(Normaly_data()){
                z=Finder(data[5],data[6],data[7],data[8]);
                //itoa(z,buffer); puts(buffer);
                if(z<Max){
                     Sound_OK();
                     LED_Green=1; LED_RED=0;
                     Relay=1; delay_ms(800); Relay=0; delay_ms(30);     
                }
                else{
                    Sound_Error();
                    LED_Green=0; LED_RED=1;
                }
            }
            else{
                Sound_Error();
                LED_Green=0; LED_RED=0;
            }
            delay_ms(500);    
        }
        
        if(Key_Register==0){
            GET_TelCard();
            if(Normaly_data()){
                z=Finder(data[5],data[6],data[7],data[8]);
                if(z<Max){
                    Sound_OK(); delay_ms(200); Sound_OK();
                    LED_Green=1; LED_RED=0;    
                }
                else{
                    z=Finder(0xFF,0xFF,0xFF,0xFF);
                    if(z<Max){
                        Save(z);
                        Sound_OK();
                        LED_Green=1; LED_RED=0;
                    } 
                    else{
                        Sound_Error(); delay_ms(200); Sound_Error();
                    }   
                }
            }
            else{
                //LED_Green=0; LED_RED=1;
                Sound_Error();
                LED_Green=0; LED_RED=0;
            }
            delay_ms(500);
        }
        
        if(Key_Unregister==0){
            GET_TelCard();
            if(Normaly_data()){
                z=Finder(data[5],data[6],data[7],data[8]); 
                if(z<Max){
                    Sound_OK();
                    Unregister_card(z);
                    LED_Green=0; LED_RED=1;    
                }
                else{
                    Sound_OK(); delay_ms(200); Sound_OK();
                    LED_Green=0; LED_RED=1;
                }   
            }
            else{
                Sound_Error();
                LED_Green=0; LED_RED=0;
            }
            //Sound_OK();
            //Unregister_all_card();
            //LED_Green=0; LED_RED=0;
            delay_ms(500);    
        }
    }   
}

//*******************************************************
void Unregister_card(unsigned char i){
    //unsigned char i=0;
    Serial_Number[i][0]=0xFF; //delay_ms(10); 
    Serial_Number[i][1]=0xFF; //delay_ms(10);  
    Serial_Number[i][2]=0xFF; //delay_ms(10);  
    Serial_Number[i][3]=0xFF; //delay_ms(10); 
}

//*******************************************************
void Unregister_all_card(void){
    unsigned char i=0;
    unsigned char j=0;
    for(i=0;i<Max;i++){
        for(j=0;j<4;j++){
            Serial_Number[i][j]=0xFF;
        }
    }
}

//*******************************************************
void Save(unsigned char i){
    Serial_Number[i][0]=data[5]; //delay_ms(10); 
    Serial_Number[i][1]=data[6]; //delay_ms(10);  
    Serial_Number[i][2]=data[7]; //delay_ms(10);  
    Serial_Number[i][3]=data[8]; //delay_ms(10);     
}

//*******************************************************
unsigned char Finder(unsigned char F1,unsigned char F2,unsigned char F3,unsigned char F4){
    unsigned char i=Max;
    for(i=0;i<Max;i++){
        if(Serial_Number[i][0]==F1 & Serial_Number[i][1]==F2 & Serial_Number[i][2]==F3 & Serial_Number[i][3]==F4){
            goto E1;
        }
    }
    E1:
    return i;    
}

//*******************************************************
unsigned char Normaly_data(void){
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


