//Github Account: Github.com/Alirezajoodi

#include<mega32.h>
#include<delay.h>
#define xtal 1000000

int i;

void main(void){
	DDRD = 0xFF;
	while(1){
		for(i = 1; i <= 128; i = i*2){
			PORTD = i;
			delay_ms(100);
		}	
			
		for(i = 128; i > 1; i = i/2){
			PORTD = i;
			delay_ms(100);
		}	
	}
}
