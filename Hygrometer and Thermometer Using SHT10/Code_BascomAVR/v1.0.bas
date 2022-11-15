'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

$hwstack = 32                                               ' default use 32 for the hardware stack
$swstack = 10                                               ' default use 10 for the SW stack
$framesize = 40                                             ' default use 40 for the frame space


Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Dim I As Byte
Dim Z As Single
Dim Z1 As Single
Dim Z2 As Single
Dim Z3 As Single

Dim Data_byte As Byte
Dim Data_msb As Byte
Dim Data_lsb As Byte
Dim Data_word As Word
Dim Crc As Byte

Dim Temp As Single
Dim Rh_liner As Single
Dim Command As Byte

Sck Alias Portc.1
Dataout Alias Portc.0
Datain Alias Pinc.0

Config Portc.1 = Output
Config Portc.0 = Output

'Gosub Signal_reset : Waitms 10
'Gosub Setting_default
'Gosub Status_register_write : Waitms 10
'Gosub status_register_read : Wait 2

Gosub Display_lcd
Gosub Signal_reset : Waitms 10

Do
   Command = &B00000101 : Gosub Get_sht10
   'Gosub Calcula_rh_liner_8bit
   Gosub Calcula_rh_liner_12bit

   Command = &B00000011 : Gosub Get_sht10
   'Gosub Calcula_temp_12bit
   Gosub Calcula_temp_14bit

   Gosub Dispaly_uart
   Gosub Display_lcd

   Wait 1
Loop

End

'*******************************************
Status_register_write:
   Gosub Signal_start
   Command = &B00000110 : Shiftout Dataout , Sck , Command , 1
   Gosub Signal_ack
   Command = &B00000000 : Shiftout Dataout , Sck , Command , 1
   Gosub Signal_ack
Return

'*******************************************
Status_register_read:
   Gosub Signal_start
   Command = &B00000111
   Shiftout Dataout , Sck , Command , 1
   Gosub Signal_ack
   Gosub Read_byte : Data_msb = Data_byte
   Gosub Signal_ack
   Gosub Read_byte : Crc = Data_byte
   Print "Status Register=" ; Data_msb
   Print "Checksum=" ; Crc
   Print
Return

'*******************************************
Setting_default:
   Gosub Signal_start
   Command = &B00011110 : Shiftout Dataout , Sck , Command , 1
   Gosub Signal_ack
   Waitms 100
Return

'*******************************************
Get_sht10:
   Gosub Signal_start
   Gosub Send_command
   Gosub Signal_ack
   Gosub Wait_for_data_ready
   Gosub Read_byte : Data_msb = Data_byte
   Gosub Signal_ack
   Gosub Read_byte : Data_lsb = Data_byte
   Gosub Signal_ack
   Gosub Read_byte : Crc = Data_byte
   'PRINT "CRC="; CRC
   Gosub Signal_end
   Data_msb = Data_msb And &B00111111
   Data_word = Makeint(data_lsb , Data_msb)
Return

'*******************************************
Signal_reset:
   Config Portc.1 = Output                                  ': Portc.1 = 1
   Config Portc.0 = Output                                  ': Portc.0 = 1
   Reset Sck : Set Dataout : Waitus 1
   For I = 1 To 9
      Set Sck : : Waitus 1 :
      Reset Dataout : Waitus 1
   Next I
Return

'*******************************************
Signal_start:
   Config Portc.1 = Output                                  ': Portc.1 = 1
   Config Portc.0 = Output                                  ': Portc.0 = 1
   Reset Sck : Set Dataout : Waitus 1
   Set Sck : : Waitus 1 :
   Reset Dataout : Waitus 1
   Reset Sck : Waitus 1
   Set Sck : Waitus 1
   Set Dataout : : Waitus 1
   Reset Sck : Waitus 1
   Crc = 0
Return

'*******************************************
Send_command:
   Config Portc.1 = Output : Portc.1 = 0
   Config Portc.0 = Output : Portc.0 = 0
   Shiftout Dataout , Sck , Command , 1
Return

'*******************************************
Wait_for_data_ready:
   Config Portc.1 = Output                                  ': Portc.1 = 0
   Config Portc.0 = Input                                   ': Portc.0 = 0
   Set Dataout
   For I = 1 To 255
      If Dataout = 0 Then Exit For
      Waitms 1
   Next
Return

'*******************************************
Read_byte:
   Config Portc.1 = Output : Portc.1 = 0
   Config Portc.0 = Input : Portc.0 = 1
   Shiftin Datain , Sck , Data_byte , 1
Return

'*******************************************
Signal_ack:
   Config Portc.1 = Output                                  ': Portc.1 = 0
   Config Portc.0 = Output                                  ': Portc.0 = 0
   Reset Dataout : Reset Sck
   Set Sck : Waitus 1
   Reset Sck
   'Set Dataout
Return

'*******************************************
Signal_end:
   Config Portc.1 = Output                                  ': Portc.1 = 1
   Config Portc.0 = Output                                  ': Portc.0 = 1
   Set Dataout : Waitus 1
   Set Sck : Waitus 1
   Reset Sck : Waitus 1
Return

'*******************************************
Calcula_rh_liner_12bit:
   'Print "Data_RH_12bit=" ; Data_word
   Rh_liner = Data_word * Data_word
   Rh_liner = Rh_liner * -0.0000015955
   Z = 0.0367 * Data_word
   Rh_liner = Rh_liner + Z
   Rh_liner = Rh_liner - 2.0468


   Z1 = Temp - 25
   Z2 = 0.00008 * Data_word : Z2 = Z2 + 0.01
   Z3 = Rh_liner

   Rh_liner = Z1 * Z2 : Rh_liner = Rh_liner + Z3
Return

'*******************************************
Calcula_rh_liner_8bit:
   'Print "Data_RH_8bit=" ; Data_word
   Rh_liner = Data_word * Data_word
   Rh_liner = Rh_liner * -0.00040854
   Z = 0.5872 * Data_word
   Rh_liner = Rh_liner + Z
   Rh_liner = Rh_liner - 2.0468
   '«œ«„Â œ«—œ
Return

'*******************************************
Calcula_temp_14bit:
   Temp = 0.01 * Data_word
   Temp = Temp - 40.1
Return

'*******************************************
Calcula_temp_12bit:
   Temp = 0.04 * Data_word
   Temp = Temp - 40.1
Return

'*******************************************
Dispaly_uart:
   Print
   Print "Rh_liner= " ; Rh_liner ; "%"
   Print "Temp= " ; Temp
Return

'*******************************************
Display_lcd:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 1 : Lcd "RH: " ; Fusing(rh_liner , "#.#") ; "%  "
   Locate 2 , 1 : Lcd "Temp: " ; Fusing(temp , "#.#") ; Chr(0) ; "C  "
Return