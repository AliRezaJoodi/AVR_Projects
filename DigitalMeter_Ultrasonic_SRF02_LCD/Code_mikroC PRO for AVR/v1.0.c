// GitHub Account: GitHub.com/AliRezaJoodi

// LCD module connections
sbit LCD_RS at PORTA0_bit;
sbit LCD_EN at PORTA2_bit;
sbit LCD_D4 at PORTA4_bit;
sbit LCD_D5 at PORTA5_bit;
sbit LCD_D6 at PORTA6_bit;
sbit LCD_D7 at PORTA7_bit;
sbit LCD_RS_Direction at DDA0_bit;
sbit LCD_EN_Direction at DDA2_bit;
sbit LCD_D4_Direction at DDA4_bit;
sbit LCD_D5_Direction at DDA5_bit;
sbit LCD_D6_Direction at DDA6_bit;
sbit LCD_D7_Direction at DDA7_bit;

// Software I2C connections
sbit Soft_I2C_Scl_Output    at PORTC0_bit;
sbit Soft_I2C_Sda_Output    at PORTC1_bit;
sbit Soft_I2C_Scl_Input     at PINC0_bit;
sbit Soft_I2C_Sda_Input     at PINC1_bit;
sbit Soft_I2C_Scl_Direction at DDC0_bit;
sbit Soft_I2C_Sda_Direction at DDC1_bit;


//char txt4[] = "www.M32.ir";
unsigned char RS02w = 0xE0;
unsigned char RS02r = 0xE1;
unsigned char Lentgh_MSB = 0;
unsigned char Lentgh_LSB = 0;
unsigned int Lentgh= 0;


void Read_Lentgh_SRF02()
{
     Lentgh = 0; Lentgh_MSB = 0; Lentgh_LSB = 0;
     Soft_I2C_Start();
     Soft_I2C_Write(RS02w);
     Soft_I2C_Write(0);
     Soft_I2C_Write(0x51);
     Soft_I2C_Stop();
     //Soft_I2C_Break();
     Delay_ms(70);
     Soft_I2C_Start();
     Soft_I2C_Write(RS02w);
     Soft_I2C_Write(2);
     Soft_I2C_Stop();
     //Soft_I2C_Break();
     Delay_ms(70);
     Soft_I2C_Start();
     Soft_I2C_Write(RS02r);
     Lentgh_Msb = Soft_I2C_Read(1);
     Lentgh_Lsb = Soft_I2C_Read(0);
     Soft_I2C_Stop();
     //Soft_I2C_Break();
     Delay_ms(70);
     Lentgh=(Lentgh_MSB*256)+Lentgh_LSB;
}

void Display_Lentgh(){
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Chr(1,9, ((Lentgh / 100)  % 10) + 48);
  Lcd_Chr(1,10, ((Lentgh / 10)   % 10) + 48);
  Lcd_Chr(1,11, (Lentgh % 10)          + 48);
  Lcd_Out(1, 12, "CM ");
  Lcd_Out(1, 1, "Lentgh= ");
  Lcd_Cmd(_LCD_CURSOR_OFF);
}

void main(){
       Lcd_Init();
       Soft_I2C_Init();
       Lcd_Cmd(_LCD_CLEAR);
       Lcd_Cmd(_LCD_CURSOR_OFF);
       Display_Lentgh();
 while(1) {
           Read_Lentgh_SRF02();
           Display_Lentgh();
           Delay_ms(400);
   }
}