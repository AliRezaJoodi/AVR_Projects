#include <mega16.h>
#include <stdio.h>
#include <delay.h>
#include <stdlib.h>
#define xtal 11059200

#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))
#define CHKBIT(ADDRESS,BIT)  (ADDRESS &(1<<BIT))

#define Telcard_key PINB.0
#define read_key PINA.3
#define buzzer PORTD.7
#define LED_RED PORTD.5
#define LED_Green PORTD.6
#define Relay PORTC.0

#define RST PORTB.2
#define CLK PORTB.1
#define DATA PINA.0

unsigned int credit;
char data[64];
unsigned int x[10];

char buffer[16];

void start_sub(void);
void RED(void);
void CRD(void);
void Show_credit(void);

void main(void)
{

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

start_sub();
//SETBIT(PORTD,1);
//led=1;

putsf("OK");

    while (1){
        //CLRBIT(PORTB,1);
        PORTB.1=0;
        //CLRBIT(PORTB,2);
        PORTB.2=0;
        //putsf("Test UART");
        //delay_ms(2000);
        if(Telcard_key==0) LED_RED=1; else LED_RED=0;    
        if (read_key==0){
                delay_ms(20); 
                if (read_key==0){ 
                        buzzer=1;
                        LED_RED=0;
                        RED();
                        CRD();
                        Show_credit();
                        LED_RED=1;
                        buzzer=0;
                }
                delay_ms(500);
        }

     }   
}

//*******************************************************
void start_sub(void)
{
    buzzer=1; delay_ms(100); buzzer=0;
}

//*******************************************************
void RED(void)
    {
     
        unsigned char i,j;
        //char str[16];
        #asm("cli")
        for (j=0;j<64;j++)data[j]=0;
        delay_ms(150);
        //SETBIT(PORTB,2);
        PORTB.2=1;
        //SETBIT(PORTB,1);
        PORTB.1=1;
        delay_us(50);
        //CLRBIT(PORTB,1);
        PORTB.1=0;
        //CLRBIT(PORTB,2);
        PORTB.2=0;
        //putsf("Test RED"); 
        for(j=0;j<64;j++){
                for(i=0;i<8;i++){
                    //SETBIT(PORTB,1);
                    PORTB.1=1;
                    data[j]=data[j]<<1;
                     //if(CHKBIT(PINA,0)){
                     if(PINA.0){
                        data[j]=data[j]|0x01;
                     }
                     //CLRBIT(PORTB,1);
                     PORTB.1=0;
                }
        }
        #asm("sei")    
    }

//*******************************************************        
void CRD (void)
    {
        unsigned char i,j,n;
        x[3]=0;
        x[2]=0;
        x[1]=0;
        x[0]=0;
        n=3;
        for (j=9;j<13;j++){
                for (i=0;i<8;i++){
                        if (CHKBIT(data[j],0)){
                                x[n]++;
                            }
                        data[j]=data[j]>>1;    
                }
                 n--;   
        }
         credit=(x[3]*512+x[2]*64+x[1]*8+x[0])*50;                   
    }

//*******************************************************           
void Show_credit(void)
{
    itoa(credit,buffer);
    puts(buffer);
}
