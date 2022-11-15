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
    DATA_DDR=OUTPUT; DATA_PORT =1; 
    SCK_DDR=OUTPUT; SCK_PORT=1; delay_us(1);
    DATA_PORT=0; delay_us(1);
    SCK_PORT=0; delay_us(1);
    SCK_PORT=1; delay_us(1);
    DATA_PORT=1; delay_us(1);
    SCK_PORT=0; delay_us(1); 
}

//****************************************************
void Connection_Reset_Sequence(void){
    unsigned char i;
    DATA_DDR=OUTPUT; DATA_PORT=1;
    SCK_DDR=OUTPUT; //SCK_PORT=0; 
    for (i=0; i<9; i++){
        SCK_PORT=1; delay_us(1); 
        SCK_PORT=0; delay_us(1);
    }
    Transmission_Start();
    delay_ms(100);
}

//****************************************************
char Get_Ack(void){
    char ack=1;
    DATA_DDR = INPUT;
    SCK_PORT = 1;
    ack = DATA_PIN;
    SCK_PORT = 0;
    return ack;        
}

//****************************************************
void Write(unsigned char command){ 
    unsigned char i;
    DATA_DDR = OUTPUT; DATA_PORT=0; SCK_PORT=0; delay_us(1);
    
    for(i = 0b10000000; i > 0; i /= 2){
        if(i & command){DATA_PORT=1;} else{DATA_PORT=0;} 
        SCK_PORT = 1; SCK_PORT = 0;
    } 
} 

//****************************************************
void Send_Ack(char ack){
    DATA_DDR = OUTPUT; DATA_PORT = ack;
    SCK_PORT = 1; SCK_PORT = 0;
}

//****************************************************
unsigned char Read(void){
    unsigned char i, value = 0;
    DATA_DDR = INPUT;
    SCK_PORT = 0;
    
    for(i = 0b10000000; i > 0; i /= 2){
        SCK_PORT = 1;
        if(DATA_PIN){value = value | i;}
        SCK_PORT = 0;
    } 
    
    return value;
}

//****************************************************
//Soft reset, resets the interface, clears the status register to default values.
void Soft_Reset(){
    Transmission_Start();
    Write(RESET);
    delay_ms(20);
}

//****************************************************
// Read the sensor value. Reg is register to read from
unsigned int Full_Communication(int Reg){
    char error=1; 
    unsigned char msb=0, lsb=0, crc=0;  
    unsigned int value=0;
    
    Transmission_Start();
    Write(Reg); error = Get_Ack(); //error=1;
    if(error==0){
        while(DATA_PIN);
        msb = Read(); Send_Ack(0);
        lsb = Read(); Send_Ack(0);
        crc = Read(); Send_Ack(1);  //crc will use for nev version.
        value=(msb*256)+lsb;
    }   
    
    return value; 
}

//****************************************************
float Get_Temp(void){
    unsigned int so_t=0;
    float temp=0;
    
    so_t = Full_Communication(MEASURE_TEMP);
    if(so_t != 0){
        temp = -40.1 + (0.01*so_t);  //VDD=5V 
    }
     
    return temp;
}

//****************************************************
float Get_Humidity(void){
    unsigned int  so_rh=0;
    float rh_linear=0, temp=0, rh_true=0;
    
    so_rh = Full_Communication(MEASURE_HUMI);
    if (so_rh !=0){
        rh_linear= -2.0468+(0.0367*so_rh)+((-1.5955E-6)*so_rh*so_rh);    
        delay_ms(1); temp=Get_Temp();     
        rh_true=((temp-25)*(0.01+0.00008*so_rh))+rh_linear; 
    }
    
    return rh_true;
}
