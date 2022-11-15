#include <delay.h>

#define OUTPUT 1
#define INPUT 0

#define DATA_DDR DDRC.0
#define DATA_PORT PORTC.0
#define DATA_PIN PINC.0

#define SCK_DDR DDRC.1
#define SCK_PORT PORTC.1
#define SCK_PIN PINC.1

#define MEASURE_TEMP 0b00000011 
#define MEASURE_HUMI 0b00000101 
#define RESET        0b00011110 

//****************************************************
void Transmission_Start(void){
    SCK_DDR=OUTPUT; SCK_PORT=0; 
    DATA_DDR=OUTPUT; DATA_PORT =1;
    SCK_PORT=1;
    DATA_PORT=0;
    SCK_PORT=0;
    SCK_PORT=1;
    DATA_PORT=1;
    SCK_PORT=0; 
}

//****************************************************
void Connection_Reset_Sequence(void){
    unsigned char i;
    DATA_DDR=OUTPUT; DATA_PORT=1;
    SCK_DDR=OUTPUT; //SCK_PORT=0; 
    for (i=0; i<9; i++){
        SCK_PORT=0; delay_us(1); 
        SCK_PORT=1; delay_us(1);
    }
    //SCK_DDR=0;
    Transmission_Start();
    delay_ms(100);
}

//****************************************************
char sht_write(unsigned char byte){ 
    unsigned char i, error = 0;
    DATA_DDR = OUTPUT; 
    delay_us(5);
    for(i = 0x80; i > 0; i /= 2){
        SCK_PORT = 0;
        if(i & byte){DATA_PORT=1;} else{DATA_PORT=0;} 
        SCK_PORT = 1;
    } 
    SCK_PORT = 0;
    DATA_DDR = INPUT;
    SCK_PORT = 1;
    error = DATA_PIN;
    SCK_PORT = 0;
    return(error);
} 

//****************************************************
unsigned char sht_read(unsigned char ack){
    unsigned char i, val = 0;
    DATA_DDR = INPUT;
    for(i = 0x80; i > 0; i /= 2){
        SCK_PORT = 1;
        if(DATA_PIN){val = val | i;}
        SCK_PORT = 0;
    } 
    DATA_DDR = OUTPUT; 
    DATA_PORT = ! ack;
    SCK_PORT = 1;
    SCK_PORT = 0;
    return(val);
}

//****************************************************
void sht_reset(){
    Transmission_Start();
    sht_write(RESET);
    delay_ms(100);
}

//****************************************************
// Read the sensor value. Reg is register to read from
unsigned int ReadSensor(int Reg){
    unsigned char msb, lsb, crc;
    Transmission_Start();
    sht_write(Reg);
    while(DATA_PIN);
    msb = sht_read(1);
    lsb = sht_read(1);
    crc = sht_read(0); 
    return(((unsigned short) msb << 8) | (unsigned short) lsb); 
}

//****************************************************
float Get_Temp(void){
    unsigned int so_t;
    float temp;
    so_t = ReadSensor(MEASURE_TEMP);
    temp = -40.1 + (0.01*so_t);  //VDD=5V
    return temp;
}

//****************************************************
float Get_Humidity(void){
    unsigned int  so_rh;
    float rh_linear, temp, rh_true;
    so_rh = ReadSensor(MEASURE_HUMI);
    rh_linear= -2.0468+(0.0367*so_rh)+((-1.5955E-6)*so_rh*so_rh);    
    delay_ms(250);temp=Get_Temp();     
    rh_true=((temp-25)*(0.01+0.00008*so_rh))+rh_linear; 
    return rh_true;
}
