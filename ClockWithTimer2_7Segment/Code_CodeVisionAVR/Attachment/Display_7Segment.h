
#ifndef _INCLUDED_7SEGMENTS
    #define _INCLUDED_7SEGMENTS
    
    //#define DISABLE_DISPLAY
    #ifndef DISABLE_DISPLAY
        #define ENABLE_DISPLAY
    #endif
    
    #define DISPLAYLAG          250          //Display Lag      
    #define ACTIVATE_DIGIT      1 
    #define ACTIVATE_SEGMENT    0 

    #define S1_DDR              DDRB.4
    #define S1_PORT             PORTB.4
    #define S1_PIN              PINB.4 
    #define S1                  S1_PORT 
    
    #define S2_DDR              DDRB.3
    #define S2_PORT             PORTB.3
    #define S2_PIN              PINB.3 
    #define S2                  S2_PORT
        
    #define M1_DDR              DDRB.4
    #define M1_PORT             PORTB.4
    #define M1_PIN              PINB.4 
    #define M1                  M1_PORT 
    
    #define M2_DDR              DDRB.3
    #define M2_PORT             PORTB.3
    #define M2_PIN              PINB.3 
    #define M2                  M2_PORT
    
    #define H1_DDR              DDRB.2
    #define H1_PORT             PORTB.2
    #define H1_PIN              PINB.2
    #define H1                  H1_PORT
    
    #define H2_DDR              DDRB.1
    #define H2_PORT             PORTB.1
    #define H2_PIN              PINB.1
    #define H2                  H2_PORT
    
    #define A_DDR               DDRA.0
    #define A_PORT              PORTA.0
    #define A_PIN               PINA.0
    #define A_SEGMENT           A_PORT

    #define B_DDR               DDRA.1
    #define B_PORT              PORTA.1
    #define B_PIN               PINA.1
    #define B_SEGMENT           B_PORT

    #define C_DDR               DDRA.2
    #define C_PORT              PORTA.2
    #define C_PIN               PINA.2
    #define C_SEGMENT           C_PORT

    #define D_DDR               DDRA.3
    #define D_PORT              PORTA.3
    #define D_PIN               PINA.3
    #define D_SEGMENT           D_PORT

    #define E_DDR               DDRA.4
    #define E_PORT              PORTA.4
    #define E_PIN               PINA.4
    #define E_SEGMENT           E_PORT

    #define F_DDR               DDRA.5
    #define F_PORT              PORTA.5
    #define F_PIN               PINA.5
    #define F_SEGMENT           F_PORT

    #define G_DDR               DDRA.6
    #define G_PORT              PORTA.6
    #define G_PIN               PINA.6
    #define G_SEGMENT           G_PORT

    #define DP_DDR              DDRA.7
    #define DP_PORT             PORTA.7
    #define DP_PIN              PINA.7
    #define DP_SEGMENT          DP_PORT  
    
    #define LED_DDR             DDRA.7
    #define LED_PORT            PORTA.7
    #define LED_PIN             PINA.7
    #define LED                 LED_PORT  

    char task_blink=0;

//**************************************
void Config7Segments(void){
    #ifndef OUTPUT
        #define OUTPUT  1
    #endif

    #ifdef ENABLE_DISPLAY 
        S1_DDR=OUTPUT;  S1_PORT=!ACTIVATE_DIGIT;
        S2_DDR=OUTPUT;  S2_PORT=!ACTIVATE_DIGIT;     
        M1_DDR=OUTPUT;  M1_PORT=!ACTIVATE_DIGIT;
        M2_DDR=OUTPUT;  M2_PORT=!ACTIVATE_DIGIT;
        H1_DDR=OUTPUT;  H1_PORT=!ACTIVATE_DIGIT;
        H2_DDR=OUTPUT;  H2_PORT=!ACTIVATE_DIGIT; 
    
        A_DDR=OUTPUT;   A_PORT=!ACTIVATE_SEGMENT;
        B_DDR=OUTPUT;   B_PORT=!ACTIVATE_SEGMENT;
        C_DDR=OUTPUT;   C_PORT=!ACTIVATE_SEGMENT;
        D_DDR=OUTPUT;   D_PORT=!ACTIVATE_SEGMENT; 
        E_DDR=OUTPUT;   E_PORT=!ACTIVATE_SEGMENT;
        F_DDR=OUTPUT;   F_PORT=!ACTIVATE_SEGMENT;
        G_DDR=OUTPUT;   G_PORT=!ACTIVATE_SEGMENT;
        DP_DDR=OUTPUT;  DP_PORT=!ACTIVATE_SEGMENT;  
        
        LED_DDR=OUTPUT; LED_PORT=ACTIVATE_SEGMENT;
    #endif
}

#pragma used+

//**************************************
unsigned char _ConvertDigitTo7SegmentData(unsigned char digit){
    //0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    //A , B , C , D , E , F,
    // - , Dp 
    // C, H, R, U, T , L
    unsigned char data_7segment[25]={
    0b00111111 , 0b00000110 , 0b01011011 , 0b01001111 , 0b01100110 , 0b01101101 , 0b01111101 , 0b00000111 , 0b01111111 , 0b01101111,
    0b01110111 , 0b01111100 , 0b00111001 , 0b01011110 , 0b01111001 , 0b01110001 ,
    0b01000000 , 0b10000000 ,
    0b00111001 , 0b01110110 , 0b01010000 , 0b00111110 , 0b01111000 , 0b00111000 ,
    0b00000000
    }; 
    
    return data_7segment[digit]; 
}

//**************************************
unsigned char _Revers7SegmentData(unsigned char x){
    return x ^ 0b11111111; 
}

//**************************************
void _TurnOff7Segments(void){
    S1=!ACTIVATE_DIGIT; 
    S2=!ACTIVATE_DIGIT;
    M1=!ACTIVATE_DIGIT; 
    M2=!ACTIVATE_DIGIT; 
    H1=!ACTIVATE_DIGIT;
    H2=!ACTIVATE_DIGIT;  
    
    A_SEGMENT=!ACTIVATE_SEGMENT; 
    B_SEGMENT=!ACTIVATE_SEGMENT; 
    C_SEGMENT=!ACTIVATE_SEGMENT; 
    D_SEGMENT=!ACTIVATE_SEGMENT; 
    E_SEGMENT=!ACTIVATE_SEGMENT; 
    F_SEGMENT=!ACTIVATE_SEGMENT; 
    G_SEGMENT=!ACTIVATE_SEGMENT; 
    //DP_SEGMENT=!ACTIVATE_SEGMENT;  
}

//**************************************
void _DriveDataOn7Segment(unsigned char data){
    #ifndef CHKBIT(ADDRESS,BIT)
        #define CHKBIT(ADDRESS,BIT)  ((ADDRESS &(1<<BIT))>>BIT) 
    #endif 
   
    A_SEGMENT = CHKBIT(data,0);
    B_SEGMENT = CHKBIT(data,1);
    C_SEGMENT = CHKBIT(data,2);
    D_SEGMENT = CHKBIT(data,3);
    E_SEGMENT = CHKBIT(data,4);
    F_SEGMENT = CHKBIT(data,5);
    G_SEGMENT = CHKBIT(data,6);
    //DP_SEGMENT = CHKBIT(data,7);     
}

//**************************************
void DisplayHourAndMinValues(struct rtc time){
    unsigned char digit=0; 
    static unsigned char j=0; 
    
    _TurnOff7Segments(); 
    
    switch(j){ 
        case 0:
            digit=time.minute%10; 
            digit=_ConvertDigitTo7SegmentData(digit);
            if(ACTIVATE_SEGMENT==0){digit=_Revers7SegmentData(digit);}
            _DriveDataOn7Segment(digit);
            M1=ACTIVATE_DIGIT;
            j++;
            break;
        case 1:
            digit=time.minute/10; 
            digit=_ConvertDigitTo7SegmentData(digit);
            if(ACTIVATE_SEGMENT==0){digit=_Revers7SegmentData(digit);}
            _DriveDataOn7Segment(digit);
            M2=ACTIVATE_DIGIT;
            j++;
            break;
        case 2:
            digit=time.hour%10;
            digit=_ConvertDigitTo7SegmentData(digit);
            if(ACTIVATE_SEGMENT==0){digit=_Revers7SegmentData(digit);}
            _DriveDataOn7Segment(digit); 
            H1=ACTIVATE_DIGIT; 
            j++;
            break;
        case 3:
            digit=time.hour/10;
            digit=_ConvertDigitTo7SegmentData(digit);
            if(ACTIVATE_SEGMENT==0){digit=_Revers7SegmentData(digit);}
            _DriveDataOn7Segment(digit); 
            H2=ACTIVATE_DIGIT;
            j=0;
            break;
    }
}

//**************************************
void DisplaySecondValue(struct rtc time){
    unsigned char digit=0;
    static unsigned char j=0;
    
    _TurnOff7Segments(); 
     
    switch(j){ 
        case 0:
            digit=time.second%10; 
            digit=_ConvertDigitTo7SegmentData(digit);
            if(ACTIVATE_SEGMENT==0){digit=_Revers7SegmentData(digit);}
            _DriveDataOn7Segment(digit);
            S1=ACTIVATE_DIGIT; 
            j++;
            break;
        case 1:
            digit=time.second/10; 
            digit=_ConvertDigitTo7SegmentData(digit);
            if(ACTIVATE_SEGMENT==0){digit=_Revers7SegmentData(digit);}
            _DriveDataOn7Segment(digit);
            S2=ACTIVATE_DIGIT;
            j=0;
            break;
    }
}

//**************************************
void DisplayBlinkLED(void){
    static unsigned int i=0;
    
    if(task_blink){
        task_blink=0;
        LED=ACTIVATE_SEGMENT; 
        i=0;
    }
    
    ++i; 
    if(i>800){LED=!ACTIVATE_SEGMENT;}
}

#pragma used-    
#endif
