//GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32A.h>
#include <stdio.h>
#include <delay.h>
//#define xtal 8000000

#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))
#define CHKBIT(ADDRESS,BIT)  (ADDRESS &(1<<BIT))

//#define Telcard_key PIND.2
#define BUTTON PIND.3
#define BUZZER PORTD.6
#define LED PORTD.1

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

unsigned int credit;
char data[64];
unsigned int x[10];

char S[11];

void Start(void);
void ReadData_TelCard(void);
void CalculateCredit_TelCard(void);
void DisplayCredit(void);

void main(void){

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=P 
PORTB=0x01;
DDRB=0x00;

// Port D initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=0 State4=0 State3=T State2=T State1=0 State0=T 
//PORTD=0x00;
//DDRD=0x32;

// Port D initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=In 
// State7=P State6=0 State5=0 State4=0 State3=P State2=P State1=0 State0=P 
PORTD=0x8D;
DDRD=0x72;

lcd_init(16);
lcd_gotoxy(0,0);
Start();
//SETBIT(PORTD,1);
//LED=1;

    while (1){
        CLRBIT(PORTD,5);
        CLRBIT(PORTD,4);
        //putsf("Test UART");
        //delay_ms(2000);
        //if(Telcard_key==0) LED=1; else LED=0;    
        if(BUTTON==0){
            delay_ms(30); 
            if(BUTTON==0){ 
                BUZZER=1;
                LED=0;
                ReadData_TelCard();
                CalculateCredit_TelCard();
                DisplayCredit();
                LED=1;
                BUZZER=0;
            }
            delay_ms(500);
        }

     }   
}

//*******************************************************
void Start(void){
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("TelCard Reader");
    BUZZER=1; delay_ms(100); BUZZER=0;
}

//*******************************************************
void ReadData_TelCard(void){     
    unsigned char i,j;
    //char str[16];
    #asm("cli")
    for (j=0;j<64;j++)data[j]=0;
    delay_ms(150);
    SETBIT(PORTD,4);
    SETBIT(PORTD,5);
    delay_us(50);
    CLRBIT(PORTD,5);
    CLRBIT(PORTD,4);
    //putsf("Test RED"); 
    for(j=0;j<64;j++){
        for(i=0;i<8;i++){
            SETBIT(PORTD,5);
            data[j]=data[j]<<1;
            if(CHKBIT(PINB,0)){
                data[j]=data[j]|0x01;
            }
            CLRBIT(PORTD,5);
        }
    }
    #asm("sei")    
}

//*******************************************************        
void CalculateCredit_TelCard(void){
    unsigned char i,j,n;
    x[3]=0;
    x[2]=0;
    x[1]=0;
    x[0]=0;
    n=3;
    for(j=9; j<=12; j++){
        for(i=0; i<8; i++){
            if(CHKBIT(data[j],0)){x[n]++;}
            data[j]=data[j]>>1;    
        }
        n--;   
    }
    ///credit=((x[3]*512)+(x[2]*64)+(x[1]*8)+(x[0]*1))*50;  
    credit=((x[0]*1)+(x[1]*8)+(x[2]*64)+(x[3]*512))*50;                  
}

//*******************************************************           
void DisplayCredit(void){
    lcd_clear();
    sprintf(S,"%d Rial",credit); lcd_puts(S);
}
