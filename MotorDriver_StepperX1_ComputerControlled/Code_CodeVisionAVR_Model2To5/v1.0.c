#include <mega32.h>
#include <stdio.h>

unsigned char buffer=0;
unsigned char value=0;

void main(void){
    DDRA=0b11111111; PORTA=0b00000000; 

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

    while (1){  
        buffer=getchar();      
        if(48<buffer & buffer<57){
            value=(value*10)+(buffer-48);
        }
        else if(buffer==13){
            PORTA=value; 
            value=0;
        }
    };
}
