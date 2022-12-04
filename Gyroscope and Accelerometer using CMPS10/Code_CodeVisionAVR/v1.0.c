// GitHub Account:     GitHub.com/AliRezaJoodi

#include <mega8.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=3
   .equ __scl_bit=4
#endasm
#include <i2c.h>

#define LED PORTC.3

void Display_Compass(void);
void Display_Pitch_angle(void);
void Display_Roll_angle(void);
void Display_Magnetometer(void);
void Display_Accelerometer(void);
void Get_Compass(void);
void Get_Pitch_angle(void);
void Get_Roll_angle(void);
void Get_Magnetometer(void);
void Get_Accelerometer(void);

unsigned int Compass;
unsigned char Pitch_angle;
unsigned char Roll_angle ;
unsigned int Magnetometer_X;
unsigned int Magnetometer_Y;
unsigned long int Magnetometer_Y1;
unsigned int Magnetometer_Z;
unsigned int Accelerometer_X;
unsigned int Accelerometer_Y;
unsigned int Accelerometer_Z;

void main(void){

    DDRC.3=1; PORTC.3=1;

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

    i2c_init();
     
    while (1){
        LED=0;
        Get_Compass(); Display_Compass();
        Get_Pitch_angle(); Display_Pitch_angle();
        Get_Roll_angle(); Display_Roll_angle();
        Get_Magnetometer(); Display_Magnetometer();
        Get_Accelerometer(); Display_Accelerometer();
        putchar(13);
        LED=1;
        delay_ms(1000);
    };
    
}

//******************************************
void Display_Compass(void){
    float Compass_1;
    Compass_1=Compass;
    //sprintf(Buffer,"Compass:%2.1f",Compass_1/10); puts(Buffer); putchar(13);    
    printf("Compass: %3.1f",Compass_1/10); putchar(13);    
}

//******************************************
void Display_Pitch_angle(void){
    printf("Pitch angle: %d",Pitch_angle); putchar(13);
}

//******************************************
void Display_Roll_angle(void){
    printf("Roll angle: %d",Roll_angle); putchar(13);
}

//******************************************
void Display_Magnetometer(void){
    printf("Magnetometer X,Y,Z: %d , %d , %d",Magnetometer_X,Magnetometer_Y,Magnetometer_Z); putchar(13);
}

//******************************************
void Display_Accelerometer(void){
    printf("Accelerometer X,Y,Z: %d , %d , %d",Accelerometer_X,Accelerometer_Y,Accelerometer_Z); putchar(13);
}

//******************************************
void Get_Compass(void){
    unsigned char Compass_msb; 
    unsigned char Compass_lsb; 
    i2c_start(); 
    i2c_write(0xC0);
    i2c_write(2);
    i2c_stop();
    delay_ms(70);
    i2c_start();
    i2c_write(0xC1);
    Compass_msb=i2c_read(1);
    Compass_lsb=i2c_read(0);
    i2c_stop();
    Compass=(Compass_msb*256)+Compass_lsb;
}

//******************************************
void Get_Pitch_angle(void){
    i2c_start(); 
    i2c_write(0xC0);
    i2c_write(4);
    i2c_stop();
    delay_ms(70);
    i2c_start();
    i2c_write(0xC1);
    Pitch_angle=i2c_read(0);
    i2c_stop();
}

//******************************************
void Get_Roll_angle(void){
    i2c_start(); 
    i2c_write(0xC0);
    i2c_write(5);
    i2c_stop();
    delay_ms(70);
    i2c_start();
    i2c_write(0xC1);
    Roll_angle=i2c_read(0);
    i2c_stop();
}

//******************************************
void Get_Magnetometer(void){
    unsigned char Magnetometer_X_msb;
    unsigned char Magnetometer_X_lsb;
    unsigned char Magnetometer_Y_msb;
    unsigned char Magnetometer_Y_lsb;
    unsigned char Magnetometer_Z_msb;
    unsigned char Magnetometer_Z_lsb;
    i2c_start(); 
    i2c_write(0xC0);
    i2c_write(10);
    i2c_stop();
    delay_ms(70);
    i2c_start();
    i2c_write(0xC1);
    Magnetometer_X_msb=i2c_read(1); //delay_ms(10);
    Magnetometer_X_lsb=i2c_read(1); //delay_ms(10);
    Magnetometer_Y_msb=i2c_read(1); //delay_ms(10);   
    Magnetometer_Y_lsb=i2c_read(1); //delay_ms(10);   
    Magnetometer_Z_msb=i2c_read(1); //delay_ms(10);
    Magnetometer_Z_lsb=i2c_read(0); //delay_ms(10);
    i2c_stop();
     
    printf("Magnetometer_Y_msb: %d",Magnetometer_Y_msb); putchar(13);
    printf("Magnetometer_Y_lsb: %d",Magnetometer_Y_lsb); putchar(13);
    Magnetometer_X=(Magnetometer_X_msb*256)+Magnetometer_X_lsb;
    //Magnetometer_Y=(Magnetometer_Y_msb*256)+Magnetometer_Y_lsb;
    Magnetometer_Y1=Magnetometer_Y_msb*256;
    Magnetometer_Y1=Magnetometer_Y1+Magnetometer_Y_lsb;
    //Magnetometer_Y=65533;
    printf("Magnetometer_Y1: %d",Magnetometer_Y1); putchar(13);
    Magnetometer_Z=(Magnetometer_Z_msb*256)+Magnetometer_Z_lsb;   
}

//******************************************
void Get_Accelerometer(void){
    unsigned char Accelerometer_X_msb;
    unsigned char Accelerometer_X_lsb;
    unsigned char Accelerometer_Y_msb;
    unsigned char Accelerometer_Y_lsb;
    unsigned char Accelerometer_Z_msb;
    unsigned char Accelerometer_Z_lsb;
    i2c_start(); 
    i2c_write(0xC0);
    i2c_write(16);
    i2c_stop();
    delay_ms(70);
    i2c_start();
    i2c_write(0xC1);
    Accelerometer_X_msb=i2c_read(1);
    Accelerometer_X_lsb=i2c_read(1); 
    Accelerometer_Y_msb=i2c_read(1); 
    Accelerometer_Y_lsb=i2c_read(1); 
    Accelerometer_Z_msb=i2c_read(1); 
    Accelerometer_Z_lsb=i2c_read(0); 
    i2c_stop(); 
    Accelerometer_X=(Accelerometer_X_msb*256)+Accelerometer_X_lsb;
    Accelerometer_Y=(Accelerometer_Y_msb*256)+Accelerometer_Y_lsb;
    Accelerometer_Z=(Accelerometer_Z_msb*256)+Accelerometer_Z_lsb;
}
