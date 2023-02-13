// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef CH_OVEN
    #define CH_OVEN   0
#endif

#define GAIN_OVEN 200

//******************************************
//Input:    ADC Channel Voltage(mV)
//Output:   Temp(^C)
float Get_OvenTemp(float volt){
    float temp=0;
    temp = volt*GAIN_OVEN;
    return temp;
}