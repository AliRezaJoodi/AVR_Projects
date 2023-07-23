// GitHub Account: GitHub.com/AliRezaJoodi

#ifndef SETBIT
    #define SETBIT(ADDRESS,BIT)         (ADDRESS|=1<<BIT)
#endif 
    
#ifndef CLRBIT
    #define CLRBIT(ADDRESS,BIT)         (ADDRESS &=~(1<<BIT))
#endif

#ifndef INT_GLOBAL_ENABLE
    #define INT_GLOBAL_ENABLE          #asm("sei") // Globally enable interrupts
#endif

#ifndef _INCLUDED_INTRUPTS
    #define _INCLUDED_INTRUPTS
    
    #define INT0_ENABLE                 SETBIT(GICR,INT0);
    #define INT0_DISABLE                CLRBIT(GICR,INT0);
    #define INT0_MODE_LOWLEVEL          MCUCR=(MCUCR & 0b11111100) | (0<<ISC01) | (0<<ISC00);
    #define INT0_MODE_ANYCHANGE         MCUCR=(MCUCR & 0b11111100) | (0<<ISC01) | (1<<ISC00);
    #define INT0_MODE_FALLINGEDGE       MCUCR=(MCUCR & 0b11111100) | (1<<ISC01) | (0<<ISC00);
    #define INT0_MODE_RISINGEDGE        MCUCR=(MCUCR & 0b11111100) | (1<<ISC01) | (1<<ISC00);

    #define INT1_ENABLE                 SETBIT(GICR,INT1);
    #define INT1_DISABLE                CLRBIT(GICR,INT1);
    #define INT1_MODE_LOWLEVEL          MCUCR=(MCUCR & 0b11110011) | (0<<ISC11) | (0<<ISC10);
    #define INT1_MODE_ANYCHANGE         MCUCR=(MCUCR & 0b11110011) | (0<<ISC11) | (1<<ISC10);
    #define INT1_MODE_FALLINGEDGE       MCUCR=(MCUCR & 0b11110011) | (1<<ISC11) | (0<<ISC10);
    #define INT1_MODE_RISINGEDGE        MCUCR=(MCUCR & 0b11110011) | (1<<ISC11) | (1<<ISC10);
    
    #define INT2_ENABLE                 SETBIT(GICR,INT2);
    #define INT2_DISABLE                CLRBIT(GICR,INT2);
    #define INT2_MODE_FALLINGEDGE       CLRBIT(MCUCSR,ISC2);
    #define INT2_MODE_RISINGEDGE        SETBIT(MCUCSR,ISC2);
    
//#pragma used+

char task_int0=0;
char task_int1=0;
char task_int2=0;

//**************************************
interrupt [EXT_INT0] void ext_int0_isr(void){
    T0_END;
    task_int0=1;
}

//**************************************
interrupt [EXT_INT1] void ext_int1_isr(void){
    task_int1=1;
}

//**************************************
interrupt [EXT_INT2] void ext_int2_isr(void){
    task_int2=1;
}
    
//**************************************
void ConfigExternalInterrupts(void){
    DDRD.2=0; PORTD.2=1;
    DDRD.3=0; PORTD.3=1;
    DDRB.2=0; PORTB.2=1;
    
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
}    

//#pragma used-    
#endif
