// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef KP
    #define KP 0.5
#endif

#ifndef KI
    #define KI 0.000001
#endif

#ifndef KD
    #define KD 0.1
#endif

//******************************************
float PID_ControlSystem(float sp,float pv,char status){
    float error=0; 
    static float error_last=0;
    float value_p=0;
    static float value_i=0;
    float value_d=0;
    float value_pid=0;
    
    if(status==0){value_i=0;} 
    
    error=sp-pv;
    value_p=KP*error;
    value_i=value_i+(KI*error);
    value_d=(error-error_last)*KD; error_last=error; 
    value_pid=value_p+value_i+value_d;     
    
    return value_pid; 
}