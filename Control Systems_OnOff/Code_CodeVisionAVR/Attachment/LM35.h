// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef CH_LM35
    #define CH_LM35   0
#endif

#define GAIN_LM35 1/10

//******************************************
//Input:    ADC Channel Voltage(mV)
//Output:   Temp(^C)
float Get_Temp_LM35(float mv){
    float temp=0;
    temp = mv*GAIN_LM35;
    return temp;
}