#include <mega8.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

#define   columns   24

#define Data_0  PORTD.7
#define Data_1  PORTD.6
#define Data_2  PORTD.5
#define Data_3  PORTB.7
#define Data_4  PORTB.6
#define Data_5  PORTD.4
#define Data_6  PORTD.3
#define Data_7  PORTD.2

#define Column_a  PORTC.4
#define Column_b  PORTC.5
#define Column_c  PORTC.3
#define Column_d  PORTC.2
#define Column_e  PORTC.1
#define Column_f  PORTC.0
#define Column_g  PORTB.5
#define Column_h  PORTB.4

#define Matrix_1  PORTB.1
#define Matrix_2  PORTB.2
#define Matrix_3  PORTB.3

void Decode_data(void);
void Erase_data(void);

const char font[] = { 
 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 ,
 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 ,
 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 ,
 0x00 , 0x00 , 0x60 , 0xFA , 0xFA , 0x60 , 0x00 , 0x00 ,//!
 0x00 , 0xC0 , 0xE0 , 0x00 , 0x00 , 0xE0 , 0xC0 , 0x00 ,//"
 0x28 , 0xFE , 0xFE , 0x28 , 0xFE , 0xFE , 0x28 , 0x00 ,//#
 0x00 , 0x24 , 0x74 , 0xD6 , 0xD6 , 0x5C , 0x48 , 0x00 ,//$
 0x62 , 0x66 , 0x0C , 0x18 , 0x30 , 0x66 , 0x46 , 0x00 ,//%
 0x0C , 0x5E , 0xF2 , 0xBA , 0xEC , 0x5E , 0x12 , 0x00 ,//&
 0x00 , 0x00 , 0x20 , 0xE0 , 0xC0 , 0x00 , 0x00 , 0x00 ,//'
 0x00 , 0x00 , 0x38 , 0x7C , 0xC6 , 0x82 , 0x00 , 0x00 ,//
 0x00 , 0x00 , 0x82 , 0xC6 , 0x7C , 0x38 , 0x00 , 0x00 ,//)
 0x10 , 0x54 , 0x7C , 0x38 , 0x38 , 0x7C , 0x54 , 0x10 ,//*
 0x00 , 0x10 , 0x10 , 0x7C , 0x7C , 0x10 , 0x10 , 0x00 ,//+
 0x00 , 0x00 , 0x01 , 0x07 , 0x06 , 0x00 , 0x00 , 0x00 ,//,
 0x00 , 0x10 , 0x10 , 0x10 , 0x10 , 0x10 , 0x10 , 0x00 ,//-
 0x00 , 0x00 , 0x00 , 0x06 , 0x06 , 0x00 , 0x00 , 0x00 ,//.
 0x06 , 0x0C , 0x18 , 0x30 , 0x60 , 0xC0 , 0x80 , 0x00 ,///
 0x38 , 0x7C , 0xC6 , 0x92 , 0xC6 , 0x7C , 0x38 , 0x00 ,//0
 0x00 , 0x02 , 0x42 , 0xFE , 0xFE , 0x02 , 0x02 , 0x00 ,//1
 0x42 , 0xC6 , 0x8E , 0x9A , 0x92 , 0xF6 , 0x66 , 0x00 ,//2
 0x44 , 0xC6 , 0x92 , 0x92 , 0x92 , 0xFE , 0x6C , 0x00 ,//3
 0x18 , 0x38 , 0x68 , 0xCA , 0xFE , 0xFE , 0x0A , 0x00 ,//4
 0xF4 , 0xF6 , 0x92 , 0x92 , 0x92 , 0x9E , 0x8C , 0x00 ,//5
 0x3C , 0x7E , 0xD2 , 0x92 , 0x92 , 0x1E , 0x0C , 0x00 ,//6
 0xC0 , 0xC0 , 0x8E , 0x9E , 0xB0 , 0xE0 , 0xC0 , 0x00 ,//7
 0x6C , 0xFE , 0x92 , 0x92 , 0x92 , 0xFE , 0x6C , 0x00 ,//8
 0x60 , 0xF2 , 0x92 , 0x92 , 0x96 , 0xFC , 0x78 , 0x00 ,//9
 0x00 , 0x00 , 0x00 , 0x66 , 0x66 , 0x00 , 0x00 , 0x00 ,//:
 0x00 , 0x00 , 0x01 , 0x67 , 0x66 , 0x00 , 0x00 , 0x00 ,//;
 0x00 , 0x00 , 0x10 , 0x38 , 0x6C , 0xC6 , 0x82 , 0x00 ,//<
 0x00 , 0x24 , 0x24 , 0x24 , 0x24 , 0x24 , 0x24 , 0x00 ,//=
 0x00 , 0x82 , 0xC6 , 0x6C , 0x38 , 0x10 , 0x00 , 0x00 ,//>
 0x40 , 0xC0 , 0x80 , 0x9A , 0xBA , 0xE0 , 0x40 , 0x00 ,//?
 0x7C , 0xFE , 0x82 , 0xBA , 0xBA , 0xF8 , 0x78 , 0x00 ,//@
 0x3E , 0x7E , 0xD0 , 0x90 , 0xD0 , 0x7E , 0x3E , 0x00 ,//A
 0x82 , 0xFE , 0xFE , 0x92 , 0x92 , 0xFE , 0x6C , 0x00 ,//B
 0x38 , 0x7C , 0xC6 , 0x82 , 0x82 , 0xC6 , 0x44 , 0x00 ,//C
 0x82 , 0xFE , 0xFE , 0x82 , 0xC6 , 0x7C , 0x38 , 0x00 ,//D
 0x82 , 0xFE , 0xFE , 0x92 , 0xBA , 0x82 , 0xC6 , 0x00 ,//E
 0x82 , 0xFE , 0xFE , 0x92 , 0xB8 , 0x80 , 0xC0 , 0x00 ,//F
 0x38 , 0x7C , 0xC6 , 0x82 , 0x8A , 0xCC , 0x4E , 0x00 ,//G
 0xFE , 0xFE , 0x10 , 0x10 , 0x10 , 0xFE , 0xFE , 0x00 ,//H
 0x00 , 0x00 , 0x82 , 0xFE , 0xFE , 0x82 , 0x00 , 0x00 ,//I
 0x0C , 0x0E , 0x02 , 0x82 , 0xFE , 0xFC , 0x80 , 0x00 ,//J
 0x82 , 0xFE , 0xFE , 0x10 , 0x38 , 0xEE , 0xC6 , 0x00 ,//K
 0x82 , 0xFE , 0xFE , 0x82 , 0x02 , 0x06 , 0x0E , 0x00 ,//L
 0xFE , 0xFE , 0x70 , 0x38 , 0x70 , 0xFE , 0xFE , 0x00 ,//M
 0xFE , 0xFE , 0x60 , 0x30 , 0x18 , 0xFE , 0xFE , 0x00 ,//N
 0x7C , 0xFE , 0x82 , 0x82 , 0x82 , 0xFE , 0x7C , 0x00 ,//O
 0x82 , 0xFE , 0xFE , 0x92 , 0x90 , 0xF0 , 0x60 , 0x00 ,//P
 0x7C , 0xFE , 0x82 , 0x82 , 0x87 , 0xFF , 0x7D , 0x00 ,//Q
 0x82 , 0xFE , 0xFE , 0x90 , 0x98 , 0xFE , 0x66 , 0x00 ,//R
 0x00 , 0x44 , 0xE6 , 0xB2 , 0x9A , 0xCE , 0x44 , 0x00 ,//S
 0x00 , 0xE0 , 0xC2 , 0xFE , 0xFE , 0xC2 , 0xE0 , 0x00 ,//T
 0xFC , 0xFE , 0x02 , 0x02 , 0x02 , 0xFE , 0xFC , 0x00 ,//U
 0xF8 , 0xFC , 0x06 , 0x02 , 0x06 , 0xFC , 0xF8 , 0x00 ,//V
 0xFC , 0xFE , 0x06 , 0x1C , 0x06 , 0xFE , 0xFC , 0x00 ,//W
 0xC6 , 0xEE , 0x38 , 0x10 , 0x38 , 0xEE , 0xC6 , 0x00 ,//X
 0x00 , 0xE0 , 0xF2 , 0x1E , 0x1E , 0xF2 , 0xE0 , 0x00 ,//Y
 0xE2 , 0xC6 , 0x8E , 0x9A , 0xB2 , 0xE6 , 0xCE , 0x00 ,//Z
 0x00 , 0x00 , 0xFE , 0xFE , 0x82 , 0x82 , 0x00 , 0x00 ,//[
 0x80 , 0xC0 , 0x60 , 0x30 , 0x18 , 0x0C , 0x06 , 0x00 ,//\
 0x00 , 0x00 , 0x82 , 0x82 , 0xFE , 0xFE , 0x00 , 0x00 ,//]
 0x10 , 0x30 , 0x60 , 0xC0 , 0x60 , 0x30 , 0x10 , 0x00 ,//^
 0x01 , 0x01 , 0x01 , 0x01 , 0x01 , 0x01 , 0x01 , 0x01 ,//_
 0x00 , 0x00 , 0x20 , 0xE0 , 0xC0 , 0x00 , 0x00 , 0x00 ,//'
 0x04 , 0x2E , 0x2A , 0x2A , 0x3C , 0x1E , 0x02 , 0x00 ,//a
 0x82 , 0xFE , 0xFC , 0x22 , 0x22 , 0x3E , 0x1C , 0x00 ,//b
 0x1C , 0x3E , 0x22 , 0x22 , 0x22 , 0x36 , 0x14 , 0x00 ,//c
 0x1C , 0x3E , 0x22 , 0xA2 , 0xFC , 0xFE , 0x02 , 0x00 ,//d
 0x1C , 0x3E , 0x2A , 0x2A , 0x2A , 0x3A , 0x18 , 0x00 ,//e
 0x12 , 0x7E , 0xFE , 0x92 , 0x90 , 0xC0 , 0x40 , 0x00 ,//f
 0x19 , 0x3D , 0x25 , 0x25 , 0x1F , 0x3E , 0x20 , 0x00 ,//g
 0x82 , 0xFE , 0xFE , 0x10 , 0x20 , 0x3E , 0x1E , 0x00 ,//h
 0x00 , 0x00 , 0x22 , 0xBE , 0xBE , 0x02 , 0x00 , 0x00 ,//i
 0x00 , 0x06 , 0x07 , 0x01 , 0x01 , 0xBF , 0xBE , 0x00 ,//j
 0x82 , 0xFE , 0xFE , 0x08 , 0x1C , 0x36 , 0x22 , 0x00 ,//k
 0x00 , 0x00 , 0x82 , 0xFE , 0xFE , 0x02 , 0x00 , 0x00 ,//l
 0x3E , 0x3E , 0x30 , 0x1E , 0x30 , 0x3E , 0x1E , 0x00 ,//m
 0x20 , 0x3E , 0x1E , 0x20 , 0x20 , 0x3E , 0x1E , 0x00 ,//n
 0x1C , 0x3E , 0x22 , 0x22 , 0x22 , 0x3E , 0x1C , 0x00 ,//o
 0x21 , 0x3F , 0x1F , 0x25 , 0x24 , 0x3C , 0x18 , 0x00 ,//p
 0x18 , 0x3C , 0x24 , 0x25 , 0x1F , 0x3F , 0x21 , 0x00 ,//q
 0x22 , 0x3E , 0x1E , 0x32 , 0x20 , 0x30 , 0x10 , 0x00 ,//r
 0x12 , 0x3A , 0x2A , 0x2A , 0x2A , 0x2E , 0x24 , 0x00 ,//s
 0x20 , 0x20 , 0xFC , 0xFE , 0x22 , 0x26 , 0x04 , 0x00 ,//t
 0x3C , 0x3E , 0x02 , 0x02 , 0x3C , 0x3E , 0x02 , 0x00 ,//u
 0x38 , 0x3C , 0x06 , 0x02 , 0x06 , 0x3C , 0x38 , 0x00 ,//v
 0x3C , 0x3E , 0x06 , 0x1C , 0x06 , 0x3E , 0x3C , 0x00 ,//w
 0x22 , 0x36 , 0x1C , 0x08 , 0x1C , 0x36 , 0x22 , 0x00 ,//x
 0x39 , 0x3D , 0x05 , 0x05 , 0x05 , 0x3F , 0x3E , 0x00 ,//y
 0x00 , 0x32 , 0x26 , 0x2E , 0x3A , 0x32 , 0x26 , 0x00 ,//z
 0x00 , 0x10 , 0x10 , 0x7C , 0xEE , 0x82 , 0x82 , 0x00 ,//{
 0x00 , 0x00 , 0x00 , 0xFE , 0xFE , 0x00 , 0x00 , 0x00 ,//|
 0x00 , 0x82 , 0x82 , 0xEE , 0x7C , 0x10 , 0x10 , 0x00 ,//}
 0x40 , 0xC0 , 0x80 , 0xC0 , 0x40 , 0xC0 , 0x80 , 0x00 ,//~
};

char Text[30]="www.M32.ir";
unsigned char dat[700];
unsigned char z;    
unsigned char Text_length=0; 
    unsigned int k1 = 0;
    unsigned int k2 = 0;
    unsigned int k3 = 0;
    unsigned char Segment=0;
    unsigned int Scan = 0; 
    
void main(void)
{
    unsigned int s = 0;
    unsigned int e = 0;
    unsigned char Refresh=0;
    unsigned char Spead=3;
    //unsigned int Scan = 0; 
    unsigned int i = 0;
    unsigned int b = 0;
    unsigned int d = 0;
    unsigned char dd;
    //unsigned char Segment=0;
    char buffer[] ;
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;
    DDRB=0xFF; PORTB=0x00;
    DDRC=0x7F; PORTC=0x00;
    DDRD=0xFC; PORTD=0x00;
    Erase_data();
    //for(i=0;i<=105;i++){ itoa(dat[i],buffer);puts(buffer);putchar(13);}
    Decode_data();
    //for(i=0;i<=105;i++){ itoa(dat[i],buffer);puts(buffer);putchar(13);}
    putsf("MAIN");putchar(13);               
    while(1)
	{  
        for(s=0;s<=z;s++)
        {
        //itoa(s,buffer);puts(buffer);putchar(13);
            e=s+7;
            for(Refresh=1;Refresh<=Spead;Refresh++)
            {
                //itoa(Refresh,buffer);puts(buffer);putchar(13);
                Scan=0b00000001;
                for(i=s;i<=e;i++)
                {
                    //itoa(i,buffer);puts(buffer);putchar(13);
                    Segment=0b00000001;
                    for(b=0;b<3;b++)
                    {
                        //itoa(b,buffer);puts(buffer);putchar(13);
                        d=(b*8)+i;
                        dd=dat[d];
                        //putchar(dd);//putchar(13);
                        //dd=0b00001100;
                        //itoa(dat[d],buffer);puts(buffer);putchar(13);
                        if ((dd&0b00000001)>=1){Data_7=1;} else { Data_7=0;}; 
                        if ((dd&0b00000010)>=1){Data_6=1;} else { Data_6=0;}; 
                        if ((dd&0b00000100)>0){Data_5=1;} else { Data_5=0;}; 
                        if ((dd&0b00001000)>0){Data_4=1;} else { Data_4=0;}; 
                        if ((dd&0b00010000)>0){Data_3=1;} else { Data_3=0;}; 
                        if ((dd&0b00100000)>0){Data_2=1;} else { Data_2=0;}; 
                        if ((dd&0b01000000)>0){Data_1=1;} else { Data_1=0;}; 
                        if ((dd&0b10000000)>0){Data_0=1;} else { Data_0=0;};
                        //Segment=2^b;
                        //itoa(Segment,buffer);puts(buffer);putchar(13);
                        if ((Segment&0b00000001)>0){Matrix_1=1;} else { Matrix_1=0;};
                        if ((Segment&0b00000010)>0){Matrix_2=1;} else { Matrix_2=0;}; 
                        if ((Segment&0b00000100)>0){Matrix_3=1;} else { Matrix_3=0;};
                        Segment=Segment<<1;
                        delay_us(1);Matrix_1=0;Matrix_2=0;Matrix_3=0;
                        //putsf("ok");putchar(13);   
                    }
                    //itoa(Scan,buffer);puts(buffer);putchar(13);
                    Column_h=1;
                    //if ((Scan&0b10000000)>0){Column_h=1;} else {Column_h=0;}; 
                    if ((Scan&0b01000000)>0){Column_g=1;} else {Column_g=0;};
                    if ((Scan&0b00100000)>0){Column_f=1;} else {Column_f=0;};
                    if ((Scan&0b00010000)>0){Column_e=1;} else {Column_e=0;};
                    if ((Scan&0b00001000)>0){Column_d=1;} else {Column_d=0;};
                    if ((Scan&0b00000100)>0){Column_c=1;} else {Column_c=0;};
                    if ((Scan&0b00000010)>0){Column_b=1;} else {Column_b=0;};
                    if ((Scan&0b00000001)>0){Column_a=1;} else {Column_a=0;}; 
                    Scan=Scan<<1;
                    delay_ms(2);
                    Column_a=0; Column_b=0; Column_c=0; Column_d=0; Column_e=0; Column_f=0; Column_g=0; Column_h=0;
                    //putsf("ok");putchar(13); 
                }    
            }    
        };
	}            
} 

void Decode_data(void)
{
    unsigned int Data_number = columns;
    char Character = 0;
    unsigned int Character_ascii = 0; 
    unsigned char j=0;

    char buffer[] ;
putsf("Decode_data_Start");putchar(13);
    Text_length=strlen(Text);
    //itoa(Text_length,buffer);puts(buffer);putchar(13);
    z=((columns/8)+Text_length)*8;
    //itoa(z,buffer);puts(buffer);putchar(13);
    for (j=0;j<Text_length;j++) 
    {
        Character=Text[j];
        //putchar(Character);// putchar(13);
        Character_ascii=toascii(Character);
        //itoa(Character_ascii,buffer);puts(buffer);putchar(13);
        k1=(Character_ascii-30)*8;
        k2=k1+7;
        //itoa(k2,buffer);puts(buffer);putchar(13);
        for(k3=k1;k3<=(k1+7);k3++)
        {
            dat[Data_number]=font[k3];
            //itoa(k3,buffer);puts(buffer);putchar(13);
            //itoa(Data_number,buffer); putsf("dat["); puts(buffer); putsf("]= "); itoa(dat[Data_number],buffer); puts(buffer);putchar(13);
            Data_number=Data_number+1;
        };   
    };
   //dat[150]=65;
   //for(j=0;j<=105;j++){ itoa(dat[j],buffer);puts(buffer);putchar(13);}
   //putchar(dat[150]);putchar(13);
}

void Erase_data(void)
{
    unsigned int i=0;
putsf("Erase_data_Start");putchar(13);
    for (i=1;i<701;i++) { dat[i]=0; };
}
