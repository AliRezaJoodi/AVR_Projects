// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef ADC_VREF_TYPE
    #define ADC_VREF_TYPE   ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))    // Voltage Reference: AVCC pin 
    //#define ADC_VREF_TYPE   ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))    // Voltage Reference: Int., cap. on AREF 
    //#define ADC_VREF_TYPE   ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))    // Voltage Reference: AREF pin
#endif

#ifndef GAIN_ADC
    #define GAIN_ADC        5000/1023
#endif

//******************************************
// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Auto Trigger Source: ADC Stopped
void Config_ADC(void){
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
}

//******************************************
// Read the AD conversion result
unsigned int Get_ADC_Int(unsigned char adc_input){
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}

//******************************************
float Get_ADC_mV(unsigned char ch){
    float out=0;
    unsigned int x=0;  
    x=Get_ADC_Int(ch);
    out=x; 
    out=out*GAIN_ADC; 
    return out;
}

//******************************************
float Get_ADC_V(unsigned char ch){
    float out=0; 
    out=Get_ADC_mV(ch);
    out=out/1000;  
    return out;
}

