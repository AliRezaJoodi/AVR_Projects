#include <delay.h>

#define DATA PINB.1
#define SCK PORTB.0
#define DATAO PORTB.1
#define DATAD DDRB.1
#define MEASURE_TEMP 0x03 
#define MEASURE_HUMI 0x05 
#define RESET        0x1e 

void sht_start(void){
    DATAD = 1; // DATA is output
    DATAO = 1;
    SCK = 0;
    SCK = 1;
    DATAO = 0;
    SCK = 0;
    SCK = 1;
    DATAO = 1;
    SCK = 0; 
}

//****************************************************
char sht_write(unsigned char Byte){ 
    unsigned char i, error = 0;
    DATAD = 1; // Data is an output 
    delay_us(5);
    for(i = 0x80; i > 0; i /= 2){
        SCK = 0;
        if(i & Byte){DATAO = 1;} else{DATAO = 0;} 
        SCK = 1;
    } 
    SCK = 0;
    DATAD = 0; // DATA is input
    SCK = 1;
    error = DATA;
    SCK = 0;
    return(error);
} 

//****************************************************
unsigned char sht_read(unsigned char ack){
    unsigned char i, val = 0;
    DATAD = 0; // DATA is INPUT
    for(i = 0x80; i > 0; i /= 2){
        SCK = 1;
        if(DATA){val = val | i;}
        SCK = 0;
    } 
    DATAD = 1; // DATA is output
    DATAO = ! ack;
    SCK = 1;
    SCK = 0;
    return(val);
}

//****************************************************
void connection_reset(void){
    unsigned char i;
    DATAD=1;
    DATAO=1;
    for (i=0;i<9;i++){
        SCK=1;
        delay_us(2);
        SCK=0;
        delay_us(2);
    }
    DATAO=1;
    sht_start();
    delay_ms(100);
}

//****************************************************
void sht_reset(){
    sht_start();
    sht_write(RESET);
    delay_ms(100);
}

//****************************************************
// Read the sensor value. Reg is register to read from
unsigned int ReadSensor(int Reg){
    unsigned char msb, lsb, crc;
    sht_start();
    sht_write(Reg);
    while(DATA);
    msb = sht_read(1);
    lsb = sht_read(1);
    crc = sht_read(0);
    return(((unsigned short) msb << 8) | (unsigned short) lsb); 
}

//****************************************************
float read_sensor(char humidity0temperture1){
    long int income,temp;
    float out,out0,t;
    switch(humidity0temperture1){
        case 0:
            income = ReadSensor(MEASURE_HUMI);
            out0=(-2.0468+(0.0367*income)+(-1.5955E-6*(income*income))); 
            temp=income;
            delay_ms(500);
            ReadSensor(MEASURE_TEMP);
            t = -40.1 + 0.01*income;
            out=(t-25)*(0.01+0.00008*temp)+out0;
            break;
        case 1:
            income = ReadSensor(MEASURE_TEMP);
            out = -40.1 + 0.01*income;
            break; 
    }
    return(out);
}