// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef CH_OVEN
    #define CH_OVEN   0
#endif

#define GAIN_OVEN 200

//******************************************
//Input:    ADC Channel Voltage(mV)
//Output:   Temp(^C)
float Get_Temp_Oven(float v){
    float temp=0;
    temp = v*GAIN_OVEN;
    return temp;
}