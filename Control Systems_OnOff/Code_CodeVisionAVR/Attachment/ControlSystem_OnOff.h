// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef ACTIVATE_COOLER
    #define ACTIVATE_COOLER 1
#endif
#define DEACTIVATE_COOLER !ACTIVATE_COOLER
#define DEFAULT_COOLER DEACTIVATE_COOLER

#ifndef ACTIVATE_HEATER
    #define ACTIVATE_HEATER 1
#endif
#define DEACTIVATE_HEATER !ACTIVATE_HEATER
#define DEFAULT_HEATER DEACTIVATE_HEATER

//******************************************
char Control_Cooler(float sp,float pv, float hystersis){
    float error=0;
    static char cooler=0;
    
    error=sp-pv;
    if(error<-(hystersis/2)){cooler=ACTIVATE_COOLER;}
        else if(error>(hystersis/2)){cooler=DEACTIVATE_COOLER;};   
    
    return cooler;        
}

//******************************************
char Control2_Cooler(float sp,float pv, float hystersis){
    float error=0;
    static char cooler=0;
    
    error=sp-pv;
    if(error<-(hystersis/2)){cooler=ACTIVATE_COOLER;}
        else if(error>0){cooler=DEACTIVATE_COOLER;};   
    
    return cooler;        
}

//******************************************
char Control_Heater(float sp,float pv, float hystersis){
    float error=0;
    static char heater=0;
    
    error=sp-pv;
    if(error>(hystersis/2)){heater=ACTIVATE_HEATER;}   
        else if(error<-(hystersis/2)){heater=DEACTIVATE_HEATER;};
     
    return heater;        
}

//******************************************
char Control2_Heater(float sp,float pv, float hystersis){
    float error=0;
    static char heater=0;
    
    error=sp-pv;
    if(error>(hystersis/2)){heater=ACTIVATE_HEATER;}   
        else if(error<0){heater=DEACTIVATE_HEATER;};
     
    return heater;        
}