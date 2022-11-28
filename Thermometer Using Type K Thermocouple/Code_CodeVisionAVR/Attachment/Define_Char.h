// GitHub Account:  GitHub.com/AliRezaJoodi

#ifndef CHAR_DEGREE
    #define CHAR_DEGREE       char1
#endif

typedef unsigned char byte;
flash byte char0[8]={
    0b10000111,
    0b10000101,
    0b10000111,
    0b10000000,
    0b10000000,
    0b10000000,
    0b10000000,
    0b10000000
};  //^

flash byte char1[8]={
    0b10001000,
    0b10010100,
    0b10001000,
    0b10000011,
    0b10000100,
    0b10000100,
    0b10000011,
    0b10000000
};  //^c

//********************************************************
//Syntax for define:    define_char(CHAR_DEGREE,0);
//Syntax for use:       lcd_putchar(0);
void define_char(byte flash *pc,byte char_code){
    byte i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) {lcd_write_byte(a++,*pc++);}
}
