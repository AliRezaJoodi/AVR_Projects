// GitHub Account: GitHub.com/AliRezaJoodi

#include <mega32a.h>
#include <io.h>
#include <delay.h>
#include <math.h>

#define SETBIT(ADDRESS,BIT)  (ADDRESS|=1<<BIT)
#define CLRBIT(ADDRESS,BIT)  (ADDRESS &=~(1<<BIT))
#define CHKBIT(ADDRESS,BIT)  ((ADDRESS &(1<<BIT))>>BIT)

#define ACTIVE 1
#define INACTIVE 0
#define DEVICE_ACTIVE 1
#define DEVICE_INACTIVE 0
#define CONFIG_OUTPUT 1
#define CONFIG_INPUT 0
#define VOLTAGE_HIGH  1
#define VOLTAGE_LOW 0

#define SENSOR0_Direction DDRA.7
#define SENSOR0_Pullup PORTA.7
#define SENSOR0 PINA.7
#define SENSOR1_Direction DDRA.6
#define SENSOR1_Pullup PORTA.6
#define SENSOR1 PINA.6
#define SENSOR2_Direction DDRA.5
#define SENSOR2_Pullup PORTA.5
#define SENSOR2 PINA.5
#define SENSOR3_Direction DDRA.4
#define SENSOR3_Pullup PORTA.4
#define SENSOR3 PINA.4
#define SENSOR4_Direction DDRA.2
#define SENSOR4_Pullup PORTA.2
#define SENSOR4 PINA.2
#define SENSOR5_Direction DDRA.1
#define SENSOR5_Pullup PORTA.1
#define SENSOR5 PINA.1
#define SENSOR6_Direction DDRA.0
#define SENSOR6_Pullup PORTA.0
#define SENSOR6 PINA.0
#define SENSOR7_Direction DDRA.3
#define SENSOR7_Pullup PORTA.3
#define SENSOR7 PINA.3

#define LED0_Direction DDRC.0
#define LED0_Pullup PORTC.0
#define LED0 PORTC.0
#define LED1_Direction DDRC.1
#define LED1_Pullup PORTC.1
#define LED1 PORTC.1
#define LED2_Direction DDRC.2
#define LED2_Pullup PORTC.2
#define LED2 PORTC.2 
#define LED3_Direction DDRC.3
#define LED3_Pullup PORTC.3
#define LED3 PORTC.3 
#define LED4_Direction DDRC.5
#define LED4_Pullup PORTC.5
#define LED4 PORTC.5
#define LED5_Direction DDRC.6
#define LED5_Pullup PORTC.6
#define LED5 PORTC.6 
#define LED6_Direction DDRC.7
#define LED6_Pullup PORTC.7
#define LED6 PORTC.7 
#define LED7_Direction DDRC.4
#define LED7_Pullup PORTC.4
#define LED7 PORTC.4 

#define MOTOR_LEFT_EN_Direction DDRD.4
#define MOTOR_LEFT_EN_Pullup PORTD.4
#define MOTOR_LEFT_EN PORTD.4
#define MOTOR_LEFT_IN1_Direction DDRD.2
#define MOTOR_LEFT_IN1_Pullup PORTD.2
#define MOTOR_LEFT_IN1 PORTD.2
#define MOTOR_LEFT_IN2_Direction DDRD.7
#define MOTOR_LEFT_IN2_Pullup PORTD.7
#define MOTOR_LEFT_IN2 PORTD.7

#define MOTOR_RIGHT_EN_Direction DDRD.5
#define MOTOR_RIGHT_EN_Pullup PORTD.5
#define MOTOR_RIGHT_EN PORTD.5
#define MOTOR_RIGHT_IN1_Direction DDRD.3
#define MOTOR_RIGHT_IN1_Pullup PORTD.3
#define MOTOR_RIGHT_IN1 PORTD.3
#define MOTOR_RIGHT_IN2_Direction DDRD.6
#define MOTOR_RIGHT_IN2_Pullup PORTD.6
#define MOTOR_RIGHT_IN2 PORTD.6

#define KEY_Direction DDRB.3
#define KEY_Pullup PORTB.3
#define KEY PINB.3

unsigned char sensor_value=0;
bit status_key=0;
bit status_test=0;

void Config_LEDS(void);
void Config_Sensors(void);
void Config_Key(void);
void Test_LEDS(unsigned int x);
void Config_Motors(void);
void Test_Motor_Left(float x);
void Test_Motor_Right(float x);
void Config_Timer1(void);
void LEDs_Driver(unsigned char x);
unsigned char Get_Sensors(void);
void Decide(unsigned char x);
void Motors_Driver(int x1,int x2);
unsigned char Standardization(unsigned char x);

void main(void){
    unsigned char buffer=0;
   Config_LEDS();
   Config_Timer1(); 
   Config_Motors(); 
   Config_Sensors();
   Config_Key();
   CLRBIT(SFIOR,PUD); 
   
   //Test_LEDS(150); 
   //Test_Motor_Left(1023);
   //Test_Motor_Right(1023);
   
    while (1){ 
        if(KEY==0 && status_key==0){ 
            delay_ms(30);
            if(KEY==0 && status_key==0){
                status_key=1; 
                status_test=status_test^1;
                if(status_test==1){
                    Motors_Driver(0,0);  
                }
            }
        } 
        if(KEY==1){status_key=0;} 
        
        sensor_value=Get_Sensors(); 
        //sensor_value=sensor_value ^ 0b11111111; 
        sensor_value=Standardization(sensor_value);  
        //sensor_value=0b11000000;     //for test Motors_Driver();
        LEDs_Driver(sensor_value); 
        ///buffer=!sensor_value &&
        if(status_test==0){
            Decide(sensor_value);  
            buffer=sensor_value;
        }                                     
    }
}

//********************************************************
void Decide(unsigned char x){
    if(x==0b10001000){Motors_Driver(100,100);}
        else if(x==0b10010100){Motors_Driver(100,100);} 
            else if(x==0b10100010){Motors_Driver(100,100);} 
                else if(x==0b11000001){Motors_Driver(100,100);}
                    else if(x==0b00000100){Motors_Driver(100,100);}
                        else if(x==0b10001100){Motors_Driver(100,0);}
                            else if(x==0b00000010){Motors_Driver(100,0);}
                                else if(x==0b00000001){Motors_Driver(100,0);}
                                    else if(x==0b10000100){Motors_Driver(100,100);}
                                        else if(x==0b10000001){Motors_Driver(70,0);}
                                            else if(x==0b10000110){Motors_Driver(100,0);}
                                                else if(x==0b00010000){Motors_Driver(100,100);}   
                                                    else if(x==0b10011000){Motors_Driver(0,100);}
                                                        else if(x==0b00100000){Motors_Driver(0,100);}
                                                            else if(x==0b01000000){Motors_Driver(0,100);}
                                                                else if(x==0b10010000){Motors_Driver(100,100);}
                                                                    else if(x==0b11000000){Motors_Driver(0,70);}
                                                                        else if(x==0b10110000){Motors_Driver(0,100);}
}

//********************************************************
void Motors_Driver(int x1,int x2){
    float y1=0; 
    float y2=0; 
    
    if(x1>100){x1=100;} else if(x1<-100){x1=-100;}
    y1=x1; y1=y1*10.23;     
    if(x1>0){OCR1B=y1; MOTOR_LEFT_IN1=ACTIVE; MOTOR_LEFT_IN2=INACTIVE;}    
        else if(x1<0){OCR1B=(y1*-1); MOTOR_LEFT_IN1=INACTIVE; MOTOR_LEFT_IN2=ACTIVE;} 
            else{OCR1B=0; MOTOR_LEFT_IN1=INACTIVE; MOTOR_LEFT_IN2=INACTIVE;}
         
    if(x2>100){x2=100;} else if(x2<-100){x2=-100;}
    y2=x2; y2=y2*10.23; 
    if(x2>0){OCR1A=y2; MOTOR_RIGHT_IN1=ACTIVE; MOTOR_RIGHT_IN2=INACTIVE;}    
        else if(x2<0){OCR1A=(y2*-1); MOTOR_RIGHT_IN1=INACTIVE; MOTOR_RIGHT_IN2=ACTIVE;} 
            else{OCR1A=0; MOTOR_RIGHT_IN1=INACTIVE; MOTOR_RIGHT_IN2=INACTIVE;}
}

//********************************************************
unsigned char Standardization(unsigned char x){
    unsigned char i=0;
    unsigned char buffer=0; 
    unsigned char y=0; 
    for(i==0;i<=7;i++){
        if(CHKBIT(x,i)==1){buffer++;}    
    }
    if(buffer>4){y=x^0b11111111;} else{y=x;} 
    return y;
}

//********************************************************
void Config_Key(void){
    KEY_Direction=CONFIG_INPUT; KEY_Pullup=ACTIVE;
}

//********************************************************
unsigned char Get_Sensors(void){
    unsigned char y=0b00000000;  
    y=(SENSOR7<<7)|(SENSOR6<<6)|(SENSOR5<<5)|(SENSOR4<<4)|(SENSOR3<<3)|(SENSOR2<<2)|(SENSOR1<<1)|(SENSOR0<<0); 
    return y;   
}

//********************************************************
void Config_Sensors(void){
    SENSOR0_Direction=CONFIG_INPUT; SENSOR0_Pullup=INACTIVE;  
    SENSOR1_Direction=CONFIG_INPUT; SENSOR1_Pullup=INACTIVE;
    SENSOR2_Direction=CONFIG_INPUT; SENSOR2_Pullup=INACTIVE;
    SENSOR3_Direction=CONFIG_INPUT; SENSOR3_Pullup=INACTIVE;
    SENSOR4_Direction=CONFIG_INPUT; SENSOR4_Pullup=INACTIVE;
    SENSOR5_Direction=CONFIG_INPUT; SENSOR5_Pullup=INACTIVE;
    SENSOR6_Direction=CONFIG_INPUT; SENSOR6_Pullup=INACTIVE;
    SENSOR7_Direction=CONFIG_INPUT; SENSOR7_Pullup=INACTIVE;      
}

//********************************************************
void LEDs_Driver(unsigned char x){
    LED0= CHKBIT(x,0); 
    LED1= CHKBIT(x,1);  
    LED2= CHKBIT(x,2);  
    LED3= CHKBIT(x,3);  
    LED4= CHKBIT(x,4);  
    LED5= CHKBIT(x,5);  
    LED6= CHKBIT(x,6);  
    LED7= CHKBIT(x,7);    
}

//********************************************************
void Config_Timer1(void){
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 250.000 kHz
    // Mode: Fast PWM top=0x03FF
    // OC1A output: Non-Inverted PWM
    // OC1B output: Non-Inverted PWM
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 4.096 ms
    // Output Pulse(s):
    // OC1A Period: 4.096 ms Width: 0 us
    // OC1B Period: 4.096 ms Width: 0 us
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
}
//********************************************************
void Test_Motor_Right(float x){
    OCR1A=0; MOTOR_RIGHT_IN1=INACTIVE; MOTOR_RIGHT_IN2=INACTIVE;
    OCR1B=0; MOTOR_LEFT_IN1=INACTIVE; MOTOR_LEFT_IN2=INACTIVE; 
    while (1){
        OCR1A=x;
        MOTOR_RIGHT_IN1=ACTIVE; MOTOR_RIGHT_IN2=INACTIVE; 
        LED0=INACTIVE; LED1=INACTIVE; LED2=INACTIVE; LED3=ACTIVE; LED4=INACTIVE; LED5=INACTIVE; LED6=ACTIVE; LED7=INACTIVE;
        delay_ms(2000);      
     
        OCR1A=x;
        MOTOR_RIGHT_IN1=INACTIVE; MOTOR_RIGHT_IN2=ACTIVE; 
        LED0=INACTIVE; LED1=INACTIVE; LED2=INACTIVE; LED3=INACTIVE; LED4=INACTIVE; LED5=INACTIVE; LED6=ACTIVE; LED7=ACTIVE;
        delay_ms(2000);  
    }
}

//********************************************************
void Test_Motor_Left(float x){
    OCR1B=0; MOTOR_LEFT_IN1=INACTIVE; MOTOR_LEFT_IN2=INACTIVE; 
    OCR1A=0; MOTOR_RIGHT_IN1=INACTIVE; MOTOR_RIGHT_IN2=INACTIVE; 
    while (1){
        OCR1B=x;
        MOTOR_LEFT_IN1=ACTIVE; MOTOR_LEFT_IN2=INACTIVE; 
        LED0=ACTIVE; LED1=INACTIVE; LED2=INACTIVE; LED3=ACTIVE; LED4=INACTIVE; LED5=INACTIVE; LED6=INACTIVE; LED7=INACTIVE;
        delay_ms(2000);      
    
        OCR1B=x;
        MOTOR_LEFT_IN1=INACTIVE; MOTOR_LEFT_IN2=ACTIVE; 
        LED0=ACTIVE; LED1=INACTIVE; LED2=INACTIVE; LED3=INACTIVE; LED4=INACTIVE; LED5=INACTIVE; LED6=INACTIVE; LED7=ACTIVE;
        delay_ms(2000);  
    }
}

//********************************************************
void Config_Motors(void){
    MOTOR_LEFT_EN_Direction=CONFIG_OUTPUT; MOTOR_LEFT_EN=DEVICE_INACTIVE;
    MOTOR_LEFT_IN1_Direction=CONFIG_OUTPUT; MOTOR_LEFT_IN1=DEVICE_INACTIVE; 
    MOTOR_LEFT_IN2_Direction=CONFIG_OUTPUT; MOTOR_LEFT_IN2=DEVICE_INACTIVE; 
    
    MOTOR_RIGHT_EN_Direction=CONFIG_OUTPUT; MOTOR_RIGHT_EN=DEVICE_INACTIVE;
    MOTOR_RIGHT_IN1_Direction=CONFIG_OUTPUT; MOTOR_RIGHT_IN1=DEVICE_INACTIVE; 
    MOTOR_RIGHT_IN2_Direction=CONFIG_OUTPUT; MOTOR_RIGHT_IN2=DEVICE_INACTIVE;     
}

//********************************************************
void Test_LEDS(unsigned int x){
    unsigned char buffer=0b00000001;
    while (1){  
        LEDs_Driver(buffer); delay_ms(x); 
        buffer=buffer<<1; if(buffer==0){buffer=0b00000001;}
    }
}

//********************************************************
void Config_LEDS(void){
    LED0_Direction=CONFIG_OUTPUT; LED0=DEVICE_INACTIVE; 
    LED1_Direction=CONFIG_OUTPUT; LED1=DEVICE_INACTIVE;
    LED2_Direction=CONFIG_OUTPUT; LED2=DEVICE_INACTIVE; 
    LED3_Direction=CONFIG_OUTPUT; LED3=DEVICE_INACTIVE;
    LED4_Direction=CONFIG_OUTPUT; LED4=DEVICE_INACTIVE;
    LED5_Direction=CONFIG_OUTPUT; LED5=DEVICE_INACTIVE;
    LED6_Direction=CONFIG_OUTPUT; LED6=DEVICE_INACTIVE;
    LED7_Direction=CONFIG_OUTPUT; LED7=DEVICE_INACTIVE;
}
