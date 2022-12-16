// GitHub Account:  GitHub.com/AliRezaJoodi

#include <mega32.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>

unsigned int t0=0;
float pulse_number=0;
float frequency=0; 
bit status_display=0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void){  
    TCNT0=0x06;
    t0++;
    if(t0==25){
        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00); //Stop Timer0
        TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10); //Stop Timer1
        frequency=((pulse_number*65536)+TCNT1)*10; 
        status_display=1; 
        pulse_number=0; t0=0;
        TCNT0=0x06; TCNT1=0; //TCNT1H=0; TCNT1L=0;   
        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);  //Start Timer0
        TCCR1B=(1<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (1<<CS11) | (0<<CS10); //Start Timer1
    }
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void){
    pulse_number++;
}

void Config_LCD(void);
void Config_Timer0(void);
void Config_Timer1(void);
void Display_Loding(void);
void Display_MainPage(float);

void main(void){
    Config_LCD();
    Config_Timer0();
    Config_Timer1();
       
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
            
    #asm("sei")     // Global enable interrupts  
    Display_Loding();
    
    while (1){  
        if(status_display==1){
            Display_MainPage(frequency); 
            status_display=0;     
        }
    }
}

//********************************************************
void Display_MainPage(float x){
    char txt[16];
    ftoa(x,0,txt); lcd_gotoxy(0,0); lcd_putsf("In(Hz):"); lcd_puts(txt); lcd_putsf("  "); 
    //sprintf(txt,"In(Hz):%.0f",x); lcd_gotoxy(0,0); lcd_puts(txt); lcd_putsf("  ");  
    lcd_gotoxy(0,1); lcd_putsf("Frequency Meter");      
}

//********************************************************

void Config_LCD(void){
    lcd_init(16); lcd_clear();
}

//********************************************************
void Config_Timer0(void){
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 62.500 kHz
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    // Timer Period: 4 ms
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x06;
    OCR0=0x00;
}

//********************************************************
void Config_Timer1(void){
    DDRB.1=0; PORTB.1=1;
    
    // Timer/Counter 1 initialization
    // Clock source: T1 pin Falling Edge
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // Noise Canceler: On
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: On
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(1<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (1<<CS11) | (0<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
}

//******************************************
void Display_Loding(void){
    lcd_gotoxy(0,0); lcd_putsf("Loading ...");
    //delay_ms(200); lcd_clear();
}

