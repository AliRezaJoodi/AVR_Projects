// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <delay.h>


#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

#define CHKBIT(ADDRESS,BIT)  (ADDRESS &(1<<BIT))
#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))

#define Hc05_Reset PORTC.2
#define Hc05_Key PORTD.6

#define Relay_0 PORTA.0
#define Relay_1 PORTA.1
#define Relay_2 PORTA.2
#define Relay_3 PORTA.3
#define Relay_4 PORTA.4
#define Relay_5 PORTA.5
#define Relay_6 PORTA.6
#define Relay_7 PORTA.7

#define Key PIND.3

void Driver_Relay(void);
void Preparation(void);
void Eeprom_Save(void);
void Eeprom_Load(void);
void Default(void);
void check(unsigned char k);

unsigned char Status_Relay;
eeprom unsigned char Status_Relay_EEPROM; 
bit Status_Key;
bit j;

unsigned char T;
unsigned char I;

char s;
unsigned char z;

void main(void){
    DDRC.2=1; PORTC.2=1; 
    DDRD.6=1; PORTD.6=0;
    
    DDRA.0=1; PORTA.0=0;
    DDRA.1=1; PORTA.1=0;
    DDRA.2=1; PORTA.2=0;
    DDRA.3=1; PORTA.3=0;
    DDRA.4=1; PORTA.4=0;
    DDRA.5=1; PORTA.5=0;
    DDRA.6=1; PORTA.6=0;
    DDRA.7=1; PORTA.7=0;
    
    Default();
    Eeprom_Load();
    Driver_Relay();
     
    while (1){
        s=getchar();
        switch(s){
            case 'a':check(0); Eeprom_Save(); Driver_Relay();
            case 'b':Status_Relay=0b00000010; Relay_1=1;
            case 'c':
            Status_Relay=Status_Relay^0b00000100; Eeprom_Save(); Driver_Relay();
            //j=CHKBIT(Status_Relay,2);
            //if(j=0){Status_Relay||0b00000100;} else{Status_Relay&0b11111011;}
            Eeprom_Save(); Driver_Relay();
            case 'd':Status_Relay=0b00001000;
            case 'e':Status_Relay=0b00010000;
            case 'f':Status_Relay=0b00100000;
            case 'g':Status_Relay=0b01000000;
            case 'h':Status_Relay=0b10000000;
            case 'i':Status_Relay=0b11111111; Eeprom_Save(); Driver_Relay();
            case 'j':Status_Relay=0b00000000;
        }   
    };
}

//********************************************************
void check(unsigned char k){
    if(CHKBIT(Status_Relay,k)==0){Status_Relay=0b00000001;}
    if(CHKBIT(Status_Relay,k)==1){Status_Relay=0b00000000;} 
}

//********************************************************
void Driver_Relay(void){
    Relay_0=CHKBIT(Status_Relay,0);
    Relay_1=CHKBIT(Status_Relay,1);
    Relay_2=CHKBIT(Status_Relay,2);
    Relay_3=CHKBIT(Status_Relay,3);
    Relay_4=CHKBIT(Status_Relay,4);
    Relay_5=CHKBIT(Status_Relay,5);
    Relay_6=CHKBIT(Status_Relay,6);
    Relay_7=CHKBIT(Status_Relay,7);    
}

//********************************************************
void Preparation(void){
}

//********************************************************
void Eeprom_Save(void){
    Status_Relay_EEPROM=Status_Relay; delay_ms(10);
}

//********************************************************
void Eeprom_Load(void){
    Status_Relay=Status_Relay_EEPROM; delay_ms(10);
}

//********************************************************
void Default(void){
    Status_Relay=0b00000000; Status_Relay_EEPROM=Status_Relay; delay_ms(10); 
}
