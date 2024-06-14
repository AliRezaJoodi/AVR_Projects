'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 8000000
$crystal = 11059200

$baud = 9600

Enable Interrupts
Config Timer0 = Timer , Prescale = 256                      'PRESCALE= 1|8|64|256|1024
On Timer0 Uart_transfer
Enable Timer0                                               ' Or  Enable Ovf0
Stop Timer0

'Config Portd.5 = Output : Portd.5 = 1 : Hc05_reset Alias Portd.5
'Config Portd.6 = Output : Portd.6 = 0 : Hc05_key Alias Portd.6

Config Portd.6 = Output : Portd.6 = 0 : Led Alias Portd.6

Sck Alias Portc.7
Dataout Alias Portc.6
Datain Alias Pinc.6

'Config Portb.1 = Output
'Config Porta.3 = Output

Dim Status_key_set As Bit

Dim I As Byte
Dim Z As Single

Dim Data_byte As Byte
Dim Data_msb As Byte
Dim Data_lsb As Byte
Dim Data_word As Word
Dim Crc As Byte

Dim Temp As Single
Dim Rh_liner As Single
Dim Command As Byte

Dim Status_display As Byte : Status_display = 0
Dim Status_relays As Byte : Status_relays = 0

Dim Minimum_humidity As Single
Dim Minimum_humidity_eeprom As Eram Single
Dim Minimum_humidity_high As Single
Dim Minimum_humidity_low As Single

Dim Maximum_humidity As Single
Dim Maximum_humidity_eeprom As Eram Single
Dim Maximum_humidity_high As Single
Dim Maximum_humidity_low As Single

Dim Minimum_temperature As Single
Dim Minimum_temperature_eeprom As Eram Single
Dim Minimum_temperature_high As Single
Dim Minimum_temperature_low As Single

Dim Maximum_temperature As Single
Dim Maximum_temperature_eeprom As Eram Single
Dim Maximum_temperature_high As Single
Dim Maximum_temperature_low As Single

Const T1 = 200
Const Accuracy = 1

Dim Buffer_s As String * 10
Dim Buffer_w As Word
Dim Buffer_lsb As Byte
Dim Buffer_msb As Byte

Dim I2 As Word
Dim I1 As Word

Gosub Signal_reset : Waitms 10

Command = &B00000101 : Gosub Get_sht10 : Gosub Calcula_rh_liner_12bit
Command = &B00000011 : Gosub Get_sht10 : Gosub Calcula_temp_14bit

Start Timer0

Do
   Command = &B00000101 : Gosub Get_sht10 : Gosub Calcula_rh_liner_12bit
   'Rh_liner = 55.2
   'Print "123" ; Fusing(rh_liner , "#.#")

   Command = &B00000011 : Gosub Get_sht10 : Gosub Calcula_temp_14bit
   'Temp = 24.1
   'Print "124" ; Fusing(temp , "#.#")
Loop

End

'***********************************************
Uart_transfer:
   Incr I2

   If I2 = 10 Then
      Set Led
      Print "123" ; Fusing(rh_liner , "#.#")
      'Print 0
      Reset Led
      'I2 = 0
   End If

   If I2 = 20 Then
      Set Led
      Print "124" ; Fusing(temp , "#.#")
      Reset Led
      I2 = 0
   End If

   'Waitms 50

   'Set Led
   'Print "124" ; "20.6" :
   'Reset Led
   'Waitms 10

   'Fusing(rh_liner , "#.#")
   'Fusing(temp , "#.#")
Return

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
   Gosub Signal_start                                       ': Gosub Uart_transfer
   Gosub Send_command                                       ': Gosub Uart_transfer
   Gosub Signal_ack                                         ': Gosub Uart_transfer
   Gosub Wait_for_data_ready
   Gosub Read_byte : Data_msb = Data_byte                   ': Gosub Uart_transfer
   Gosub Signal_ack                                         ': Gosub Uart_transfer
   Gosub Read_byte : Data_lsb = Data_byte                   ': Gosub Uart_transfer
   Gosub Signal_ack                                         ': Gosub Uart_transfer
   Gosub Read_byte : Crc = Data_byte                        ': Gosub Uart_transfer
   Gosub Signal_end                                         ': Gosub Uart_transfer
   Data_msb = Data_msb And &B00111111
   Data_word = Makeint(data_lsb , Data_msb)
Return

'*******************************************
Signal_reset:
   Config Portc.6 = Output                                  ': PortB.1 = 1
   Config Portc.7 = Output                                  ': PortA.3 = 1
   Reset Sck : Set Dataout : Waitus 1
   For I = 1 To 9
      Set Sck : : Waitus 1 :
      Reset Dataout : Waitus 1
   Next I
Return

'*******************************************
Signal_start:
   Config Portc.6 = Output                                  ': PortB.1 = 1
   Config Portc.7 = Output                                  ': PortA.3 = 1
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
   Config Portc.6 = Output : Portc.6 = 0
   Config Portc.7 = Output : Portc.7 = 0
   Shiftout Dataout , Sck , Command , 1
Return

'*******************************************
Wait_for_data_ready:
   Config Portc.7 = Output
   Config Portc.6 = Input
   Set Dataout
   For I = 1 To 255
      If Dataout = 0 Then Exit For
      Waitms 1
   Next
Return

'*******************************************
Read_byte:
   Config Portc.7 = Output : Portc.7 = 0
   Config Portc.6 = Input : Portc.6 = 1
   Shiftin Datain , Sck , Data_byte , 1
Return

'*******************************************
Signal_ack:
   Config Portc.7 = Output
   Config Portc.6 = Output
   Reset Dataout : Reset Sck
   Set Sck : Waitus 1
   Reset Sck
   'Set Dataout
Return

'*******************************************
Signal_end:
   Config Portc.7 = Output
   Config Portc.6 = Output
   Set Dataout : Waitus 1
   Set Sck : Waitus 1
   Reset Sck : Waitus 1
Return

'*******************************************
Calcula_rh_liner_12bit:
   Rh_liner = Data_word * Data_word
   Rh_liner = Rh_liner * -0.0000015955
   Z = 0.0367 * Data_word
   Rh_liner = Rh_liner + Z
   Rh_liner = Rh_liner - 2.0468
Return

'*******************************************
Calcula_temp_14bit:
   Temp = 0.01 * Data_word
   Temp = Temp - 40.1
Return