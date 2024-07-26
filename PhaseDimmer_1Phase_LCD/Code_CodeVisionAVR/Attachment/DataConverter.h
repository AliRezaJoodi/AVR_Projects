// GitHub Account: GitHub.com/AliRezaJoodi

#define GET_INT(MSB,LSB)        (MSB<<8)+LSB;     
#define GET_MSB(INT)            INT>>8;
#define GET_LSB(INT)            INT&0x00FF;

#define FIX_0TO100(VALUE)       {if(VALUE<0){VALUE=0;} else if(VALUE>100){VALUE=100;}}
#define INVERSE_0TO100(VALUE)   {VALUE=100-VALUE;}

#pragma used+

//******************************************
void Convert_IntToMsbLsb(unsigned int number, char *msb, char *lsb){
    *msb=number/256;
    *lsb=number%256;   
}

//******************************************
unsigned int Convert_MsbLsbToInt(char msb, char lsb){
    unsigned int number=0;
    number = (msb*256)+lsb;
    return number;   
}

//******************************************
char Get_MsbFromInt(unsigned int number){
    char msb=0; 
    msb=number/256; 
    //msb=(number>>8);
    return msb;   
}

//******************************************
char Get_LsbFromInt(unsigned int number){
    char lsb=0; 
    lsb=number%256; 
    //lsb=number;
    return lsb;   
}

//******************************************
float Fix_0to100(float x){
    if(x<0){x=0;} else if(x>100){x=100;};
    return x;
}

//******************************************
float Inverse_0to100(float x){
    x=Fix_0to100(x);
    return 100-x;
}

//******************************************
unsigned int Convert_0to100_0to1023(float x){
    unsigned int y=0;
    x=Fix_0to100(x);
    x=x/100*1023; y=x;
    return y;       
}

//******************************************
unsigned char Convert_0to100_0to255(float x){
    unsigned char y=0;
    x=Fix_0to100(x);
    x=x/100*255; y=x;
    return y;       
}

//******************************************
float Convert_0to100_0to5V(float x){
    float y=0; 
    x=Fix_0to100(x); 
    y=x/100*5; 
    return y;       
}

//******************************************
float Convert_0to100_1to5V(float x){
    float y=0; 
    x=Fix_0to100(x); 
    y=((x/100)*(5-1))+1; 
    return y;       
}

//******************************************
float Convert_0to100_0to3V3(float x){
    float y=0; 
    x=Fix_0to100(x); 
    y=(x/100)*3.3; 
    return y;       
}

//******************************************
unsigned int Convert_0to5V_0to1023(float x){
    unsigned int y=0;  
    x=(x/5)*1023; y=x;
    return y;       
}

//******************************************
unsigned char Convert_0to5V_0to255(float x){
    unsigned char y=0;  
    x=(x/5)*255; y=x;
    return y;       
}

//******************************************
unsigned int Convert_0to3V3_0to1023(float x){
    unsigned int y=0;  
    x=(x/3.3)*1023; y=x;
    return y;       
}

//******************************************
unsigned char Convert_0to3V3_0to255(float x){
    unsigned char y=0;  
    x=(x/3.3)*255; y=x;
    return y;       
}

//******************************************
float Convert_0to1023_0to5V(unsigned int x){
    float y=x;  
    y=(y/1023)*5;
    return y;       
}

//******************************************
float Convert_0to255_0to5V(unsigned char x){
    float y=x;  
    y=(y/255)*5;
    return y;       
}

//******************************************
float Convert_0to1023_0to2V56(unsigned int x){
    float y=x;  
    y=(y/1023)*2.56;
    return y;       
}

//******************************************
float Convert_0to255_0to2V56(unsigned char x){
    float y=x;  
    y=(y/255)*2.56;
    return y;       
}

//******************************************
unsigned char Convert_0to100_153to0(float x){
    unsigned char y=0;
    x=Fix_0to100(x);
    x=x/100*153; 
    x=153-x;
    y=x;
    return y;       
}

#pragma used-
