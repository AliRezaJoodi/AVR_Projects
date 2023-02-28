//GitHub Account: GitHub.com/AliRezaJood

#include <mega32a.h>
#include <stdio.h>
#include <delay.h>
#include <stdlib.h>
#include <string.h>

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

#define CHKBIT(ADDRESS,BIT)  (ADDRESS &(1<<BIT))
#define PS2_DATA PIND.3
#define LED_CapsLock PORTD.7

//bit h2=0,y=0;
unsigned int   count=0;
//unsigned char  a,x,h1=0,out=0,bitcount=11,data;
//unsigned char str[20];
//char str2[20];
char Buffer[25];
unsigned char keydata=0;
unsigned char d[8];
//unsigned char d_z[8];
unsigned char Key_pressed=0; 
unsigned char k=0;
int t=0;

bit start_bit=1;
bit parity_bit=0;
bit stop_bit=0;

unsigned char i=0;

//bit z1=0; 
bit state_CapsLock=0;
unsigned char state_Line=1;

bit Display_status=0;
unsigned char C_DATA=0;

  

void Convertor_2(unsigned char n){
    switch (n){
        case 0x71: Key_pressed=18; break; //Delete 
        case 0x6C: Key_pressed=27; break; //Home
        case 0x69: Key_pressed=26; break; //End
        case 0x70: Key_pressed=17; break; //Insert
        defallt: Key_pressed=0; break; 
    }
}

void Convertor_1(unsigned char n){
    //Key_pressed=0;
    switch (n){
        case 0x1C: Key_pressed=97; break; //a    
        case 0x32: Key_pressed=98; break; //b     
        case 0x21: Key_pressed=99; break; //c 
        case 0x23: Key_pressed=100; break; //d
        case 0x24: Key_pressed=101; break; //e
        case 0x2B: Key_pressed=102; break; //f
        case 0x34: Key_pressed=103; break; //g
        case 0x33: Key_pressed=104; break; //h
        case 0x43: Key_pressed=105; break; //i
        case 0x3B: Key_pressed=106; break; //j
        case 0x42: Key_pressed=107; break; //k
        case 0x4B: Key_pressed=108; break; //l
        case 0x3A: Key_pressed=109; break; //m
        case 0x31: Key_pressed=110; break; //n
        case 0x44: Key_pressed=111; break; //o
        case 0x4D: Key_pressed=112; break; //p
        case 0x15: Key_pressed=113; break; //q
        case 0x2D: Key_pressed=114; break; //r
        case 0x1B: Key_pressed=115; break; //s
        case 0x2C: Key_pressed=116; break; //t
        case 0x3C: Key_pressed=117; break; //u
        case 0x2A: Key_pressed=118; break; //v
        case 0x1D: Key_pressed=119; break; //w
        case 0x22: Key_pressed=120; break; //x
        case 0x35: Key_pressed=121; break; //y
        case 0x1A: Key_pressed=122; break; //z
        case 0x45: Key_pressed=48; break; //0
        case 0x16: Key_pressed=49; break; //1
        case 0x1E: Key_pressed=50; break; //2 
        case 0x26: Key_pressed=51; break; //3 
        case 0x25: Key_pressed=52; break; //4 
        case 0x2E: Key_pressed=53; break; //5 
        case 0x36: Key_pressed=54; break; //6 
        case 0x3D: Key_pressed=55; break; //7 
        case 0x3E: Key_pressed=56; break; //8 
        case 41: Key_pressed=32; break; //Space
        case 84: Key_pressed=91; break; //[
        case 91: Key_pressed=93; break; //]
        case 76: Key_pressed=59; break; //;
        case 82: Key_pressed=39; break; //'
        case 65: Key_pressed=44; break; //,
        case 73: Key_pressed=46; break; //.
        case 74: Key_pressed=47; break; ///
        case 14: Key_pressed=126; break; //~
        case 78: Key_pressed=45; break; //-
        case 85: Key_pressed=61; break; //=
        case 93: Key_pressed=92; break; //\
        case 0x05: Key_pressed=1; break; //F1
        case 0x06: Key_pressed=2; break; //F2
        case 0x04: Key_pressed=3; break; //F3
        case 0x0C: Key_pressed=4; break; //F4
        case 0x03: Key_pressed=5; break; //F5
        case 0x0B: Key_pressed=6; break; //F6
        case 0x83: Key_pressed=7; break; //F7
        case 0x0A: Key_pressed=8; break; //F8
        case 0x01: Key_pressed=9; break; //F9
        case 0x09: Key_pressed=10; break; //F10
        case 0x78: Key_pressed=11; break; //F11
        case 0x07: Key_pressed=12; break; //F12
        case 0x5A: Key_pressed=13; break; //Enter
        case 0x76: Key_pressed=34; break; //Escape
        case 0x66: Key_pressed=16; break; //Backspace
        case 0x0D: Key_pressed=35; break; //Tab
        case 0x58: Key_pressed=25; break; //Caps Lock
        case 0x77: Key_pressed=29; break; //Num Lock
        case 0x7E: Key_pressed=28; break; //Scroll Lock
        case 0x7C: Key_pressed=42; break; //*
        case 0x7B: Key_pressed=45; break; //-
        case 0x79: Key_pressed=43; break; //+
        case 0x71: Key_pressed=46; break; //.
        case 0x70: Key_pressed=48; break; //0
        case 0x69: Key_pressed=49; break; //1
        case 0x72: Key_pressed=50; break; //2
        case 0x7A: Key_pressed=51; break; //3
        case 0x6B: Key_pressed=52; break; //4
        case 0x73: Key_pressed=53; break; //5
        case 0x74: Key_pressed=54; break; //6
        case 0x6C: Key_pressed=55; break; //7
        case 0x75: Key_pressed=56; break; //8
        case 0x7D: Key_pressed=57; break; //9    
        defallt: Key_pressed=0; break;   
    }
}

void check(){
    if(d[0]==d[2] & d[1]==0xF0){Convertor_1(d[0]);}
    if(d[0]==0xE0 & d[2]==0xE0 & d[3]==0xF0 & d[1]==d[4]){Convertor_2(d[1]);}
    if(d[0]==0x12 & d[2]==0xF0 & d[3]==0x12){}      
}

void Show(){
    if(Key_pressed==25){
        state_CapsLock=~state_CapsLock;
        LED_CapsLock=state_CapsLock;
    }
    if (state_CapsLock==1){
        if(Key_pressed>=97 & Key_pressed<=122){Key_pressed=Key_pressed-32;}     
    }
    if (Key_pressed==18){lcd_clear(); lcd_gotoxy(0,0); state_Line=1;}
    if (Key_pressed==13){
        if(state_Line==1){state_Line=2; lcd_gotoxy(0,1);}
    }
    if (Key_pressed==16){
    }
    if (Key_pressed>=32 & Key_pressed<=126){
        lcd_putchar(Key_pressed);
    }
}

void Show_(){
    lcd_clear();
                if(d[0]!=0){itoa(d[0],Buffer); lcd_puts(Buffer); lcd_putsf(" ");} 
                if(d[1]!=0){itoa(d[1],Buffer); lcd_puts(Buffer); lcd_putsf(" ");}  
                if(d[2]!=0){itoa(d[2],Buffer); lcd_puts(Buffer); lcd_putsf(" ");}  
                if(d[3]!=0){itoa(d[3],Buffer); lcd_puts(Buffer); lcd_putsf(" ");} 
                //keydata=d[0]; 
                check();
                lcd_gotoxy(0,1);
                //lcd_putchar(Key_pressed); 
                itoa(Key_pressed,Buffer); lcd_puts(Buffer);
                count=0; 
                d[0]=0; d[1]=0; d[2]=0; d[3]=0; d[4]=0;d[5]=0;d[6]=0;d[7]=0;
                keydata=0;
                //delay_ms(500);
                //d_z[0]=d[0]; d_z[1]=d[1]; d_z[2]=d[2];  
}

interrupt [EXT_INT0] void ext_int0_isr(void){
    //t=0; TIMSK=0x01; 
    
    i=i+1;
    if(i==1){start_bit=PS2_DATA;} 
    if(i==2){if(PS2_DATA==1){keydata=keydata|1;}} 
    if(i==3){if(PS2_DATA==1){keydata=keydata|2;}}
    if(i==4){if(PS2_DATA==1){keydata=keydata|4;}} 
    if(i==5){if(PS2_DATA==1){keydata=keydata|8;}} 
    if(i==6){if(PS2_DATA==1){keydata=keydata|16;}}
    if(i==7){if(PS2_DATA==1){keydata=keydata|32;}}
    if(i==8){if(PS2_DATA==1){keydata=keydata|64;}} 
    if(i==9){if(PS2_DATA==1){keydata=keydata|128;}}
    if(i==10){parity_bit=PS2_DATA;} 
    if(i==11){stop_bit=PS2_DATA;}
    if(i==11 & start_bit==0 & stop_bit==1){d[count]=keydata;}
    if(i==11){
        ++C_DATA;
    }
    if(C_DATA==3){
        check();
        lcd_putchar(Key_pressed);
        C_DATA=0;
        i=0; count=0; keydata=0;
        d[0]=0; d[1]=0; d[2]=0; d[3]=0; d[4]=0;d[5]=0;d[6]=0;d[7]=0;
    }
    //if(i==11){t=0; TIMSK=0x01;} 
    if(i==11){i=0; count++; keydata=0;}
    if(i==11){start_bit=1; parity_bit=0; stop_bit=0; }             
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
    ++t;
    if(t>=100){
        TIMSK=0x00;
        Display_status=1;
        i=0; count=0; keydata=0;
        check();
        //Show();
        t=0;
    }
}

void main(void)
{

// External Interrupt(s) initialization
// INT0: On

// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02; // INT0 Mode: Falling Edge
MCUCSR=0x00;
GIFR=0x40;

ACSR=0x80;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x03;
TCNT0=0x00;
OCR0=0x00;


DDRD.3=0; PORTD.3=1;
DDRD.7=1; PORTD.7=0;

lcd_init(16);
#asm("sei")

DDRB.0=0; PORTB.0=1;

LED_CapsLock=1; delay_ms(500); LED_CapsLock=0;

//TIMSK=0x01;
//Key_pressed=97;

    while(1){
        if(Display_status==1){
            Display_status=0;
            if(Key_pressed==25){state_CapsLock=~state_CapsLock; LED_CapsLock=state_CapsLock;}
            if (state_CapsLock==1){
                if(Key_pressed>=97 & Key_pressed<=122){Key_pressed=Key_pressed-32;}     
            }
            if (Key_pressed>=32 & Key_pressed<=126){lcd_putchar(Key_pressed);}
            if (Key_pressed==18){lcd_clear(); lcd_gotoxy(0,0); state_Line=1;}
            if (Key_pressed==13 & state_Line==1){state_Line=2; lcd_gotoxy(0,1);}
            if (Key_pressed==16){}
            d[0]=0; d[1]=0; d[2]=0; d[3]=0; d[4]=0;d[5]=0;d[6]=0;d[7]=0;
        }
    };
}