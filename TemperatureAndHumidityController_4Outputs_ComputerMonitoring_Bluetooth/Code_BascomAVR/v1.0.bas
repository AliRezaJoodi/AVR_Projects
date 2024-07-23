'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 8000000
$crystal = 11059200

$baud = 9600
Enable Urxc
On Urxc Uart_reciver

Config Lcdpin = Pin , Rs = Pina.0 , E = Pina.2 , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portb.3 = Output : Portb.3 = 1 : Hc05_reset Alias Portb.3
Config Portb.2 = Output : Portb.2 = 0 : Hc05_key Alias Portb.2

Sck Alias Portb.0
Dataout Alias Portb.1
Datain Alias Pinb.1

Config Portb.1 = Output
Config Porta.3 = Output

Config Portc.3 = Output : Reset Portc.3 : Buzzer Alias Portc.3

Config Portc.0 = Input : Portc.0 = 1 : Key_up_1 Alias Pinc.0
Config Portd.5 = Input : Portd.5 = 1 : Key_down_1 Alias Pind.5
Config Portd.4 = Input : Portd.4 = 1 : Key_set Alias Pind.4
Config Portd.7 = Input : Portd.7 = 1 : Key_up_2 Alias Pind.7
Config Portd.6 = Input : Portd.6 = 1 : Key_down_2 Alias Pind.6

Config Portc.5 = Output : Portc.5 = 0 : Relay_humidifier Alias Portc.5
Config Portc.4 = Output : Portc.4 = 0 : Relay_dehumidifiers Alias Portc.4
Config Portc.2 = Output : Portc.2 = 0 : Relay_fan Alias Portc.2
Config Portc.1 = Output : Portc.1 = 0 : Relay_heater Alias Portc.1

Declare Sub My(byval I1 As Single )

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

'Gosub Eeprom_defult
Gosub Eeprom_load
Gosub Signal_reset : Waitms 10

Do
   If Key_up_1 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_humidity_minimum : Minimum_humidity_eeprom = Minimum_humidity
         Gosub Display_humidity_controler
         Waitms T1
      Loop Until Key_up_1 = 1
   End If

   If Key_down_1 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_humidity_minimum : Minimum_humidity_eeprom = Minimum_humidity
         Gosub Display_humidity_controler
         Waitms T1
      Loop Until Key_down_1 = 1
   End If

   If Key_up_2 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_humidity_maximum : Maximum_humidity_eeprom = Maximum_humidity
         Gosub Display_humidity_controler
         Waitms T1
      Loop Until Key_up_2 = 1
   End If

   If Key_down_2 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_humidity_maximum : Maximum_humidity_eeprom = Maximum_humidity
         Gosub Display_humidity_controler
         Waitms T1
      Loop Until Key_down_2 = 1
   End If

   If Key_up_1 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_temperature_minimum : Minimum_temperature_eeprom = Minimum_temperature
         Gosub Display_temperature_controler
         Waitms T1
      Loop Until Key_up_1 = 1
   End If

   If Key_down_1 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_temperature_minimum : Minimum_temperature_eeprom = Minimum_temperature
         Gosub Display_temperature_controler
         Waitms T1
      Loop Until Key_down_1 = 1
   End If

   If Key_up_2 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_temperature_maximum : Maximum_temperature_eeprom = Maximum_temperature
         Gosub Display_temperature_controler
         Waitms T1
      Loop Until Key_up_2 = 1
   End If

   If Key_down_2 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_temperature_maximum : Maximum_temperature_eeprom = Maximum_temperature
         Gosub Display_temperature_controler
         Waitms T1
      Loop Until Key_down_2 = 1
   End If

   If Key_set = 0 And Status_key_set = 0 Then
      Status_key_set = 1
      Gosub Sound_menu
      Incr Status_display : If Status_display > 2 Then Status_display = 0
      Cls
   End If
   If Key_set = 1 Then Status_key_set = 0

   Command = &B00000101 : Gosub Get_sht10
   Gosub Calcula_rh_liner_12bit

   Command = &B00000011 : Gosub Get_sht10
   Gosub Calcula_temp_14bit

   If Status_display = 0 Then Gosub Display_0
   If Status_display = 1 Then Gosub Display_humidity_controler
   If Status_display = 2 Then Gosub Display_temperature_controler

   Gosub Setting_relay_dehumidifiers
   Gosub Setting_relay_humidifier
   Gosub Setting_relay_heater
   Gosub Setting_relay_fan

   Gosub Uart_transfer
Loop

End

'***********************************************
Sub My(byval I1 As Single)
   I1 = I1 * 10 : I1 = Round(i1) : Buffer_s = Str(i1) : Buffer_w = Val(buffer_s)
   Buffer_lsb = Low(buffer_w)
   Buffer_msb = High(buffer_w)
End Sub

'***********************************************
Uart_transfer:
   Udr = &HEB : Waitms 5

   Call My(minimum_humidity)
   Udr = Buffer_msb : Waitms 5
   Udr = Buffer_lsb : Waitms 5

   Call My(rh_liner)
   Udr = Buffer_msb : Waitms 5
   Udr = Buffer_lsb : Waitms 5

   Call My(maximum_humidity)
   Udr = Buffer_msb : Waitms 5
   Udr = Buffer_lsb : Waitms 5

   Call My(minimum_temperature)
   Udr = Buffer_msb : Waitms 5
   Udr = Buffer_lsb : Waitms 5

   Call My(temp)
   Udr = Buffer_msb : Waitms 5
   Udr = Buffer_lsb : Waitms 5

   Call My(maximum_temperature)
   Udr = Buffer_msb : Waitms 5
   Udr = Buffer_lsb : Waitms 5

   Status_relays = Status_relays And &B00001111
   Udr = Status_relays : Waitms 5
Return

'***********************************************
Uart_reciver:

Return

'**********************************************
Setting_relay_humidifier:
   Minimum_humidity_high = Minimum_humidity + 1
   Minimum_humidity_low = Minimum_humidity
   If Rh_liner < Minimum_humidity_low Then
      Set Relay_humidifier
      Status_relays.0 = 1
   Elseif Rh_liner > Minimum_humidity_high Then
      Reset Relay_humidifier
      Status_relays.0 = 0
   End If
Return

'**********************************************
Setting_relay_dehumidifiers:
   Maximum_humidity_high = Maximum_humidity
   Maximum_humidity_low = Maximum_humidity - 1
   If Rh_liner > Maximum_humidity_high Then
      Set Relay_dehumidifiers
      Status_relays.1 = 1
   Elseif Rh_liner < Maximum_humidity_low Then
      Reset Relay_dehumidifiers
      Status_relays.1 = 0
   End If
Return

'**********************************************
Setting_relay_fan:
   Maximum_temperature_high = Maximum_temperature
   Maximum_temperature_low = Maximum_temperature - 1
   If Temp > Maximum_temperature_high Then
      Set Relay_fan
      Status_relays.2 = 1
   Elseif Temp < Maximum_temperature_low Then
      Reset Relay_fan
      Status_relays.2 = 0
   End If
Return

'**********************************************
Setting_relay_heater:
   Minimum_temperature_high = Minimum_temperature + 1
   Minimum_temperature_low = Minimum_temperature
   If Temp < Minimum_temperature_low Then
      Set Relay_heater
      Status_relays.3 = 1
   Elseif Temp > Minimum_temperature_high Then
      Reset Relay_heater
      Status_relays.3 = 0
   End If
Return

'**********************************************
Eeprom_load:
   Maximum_humidity = Maximum_humidity_eeprom
   Minimum_humidity = Minimum_humidity_eeprom

   Maximum_temperature = Maximum_temperature_eeprom
   Minimum_temperature = Minimum_temperature_eeprom
Return

'**********************************************
Up_humidity_minimum:
   Minimum_humidity = Minimum_humidity + 0.5
   If Minimum_humidity < 0 Or Minimum_humidity > 99 Then Minimum_humidity = 0
Return

'**********************************************
Down_humidity_minimum:
   Minimum_humidity = Minimum_humidity - 0.5
   If Minimum_humidity < 0 Or Minimum_humidity > 99 Then Minimum_humidity = 99
Return

'**********************************************
Up_humidity_maximum:
   Maximum_humidity = Maximum_humidity + 0.5
   If Maximum_humidity < 0 Or Maximum_humidity > 99 Then Maximum_humidity = 0
Return

'**********************************************
Down_humidity_maximum:
   Maximum_humidity = Maximum_humidity - 0.5
   If Maximum_humidity < 0 Or Maximum_humidity > 99 Then Maximum_humidity = 99
Return

'**********************************************
Up_temperature_minimum:
   Minimum_temperature = Minimum_temperature + 0.5
   If Minimum_temperature < 0 Or Minimum_temperature > 99 Then Minimum_temperature = 0
Return

'**********************************************
Down_temperature_minimum:
   Minimum_temperature = Minimum_temperature - 0.5
   If Minimum_temperature < 0 Or Minimum_temperature > 99 Then Minimum_temperature = 99
Return

'**********************************************
Up_temperature_maximum:
   Maximum_temperature = Maximum_temperature + 0.5
   If Maximum_temperature < 0 Or Maximum_temperature > 99 Then Maximum_temperature = 0
Return

'**********************************************
Down_temperature_maximum:
   Maximum_temperature = Maximum_temperature - 0.5
   If Maximum_temperature < 0 Or Maximum_temperature > 99 Then Maximum_temperature = 99
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
   Gosub Signal_start
   Gosub Send_command
   Gosub Signal_ack
   Gosub Wait_for_data_ready
   Gosub Read_byte : Data_msb = Data_byte
   Gosub Signal_ack
   Gosub Read_byte : Data_lsb = Data_byte
   Gosub Signal_ack
   Gosub Read_byte : Crc = Data_byte
   Gosub Signal_end
   Data_msb = Data_msb And &B00111111
   Data_word = Makeint(data_lsb , Data_msb)
Return

'*******************************************
Signal_reset:
   Config Portb.0 = Output                                  ': PortB.1 = 1
   Config Portb.1 = Output                                  ': PortA.3 = 1
   Reset Sck : Set Dataout : Waitus 1
   For I = 1 To 9
      Set Sck : : Waitus 1 :
      Reset Dataout : Waitus 1
   Next I
Return

'*******************************************
Signal_start:
   Config Portb.0 = Output                                  ': PortB.1 = 1
   Config Portb.1 = Output                                  ': PortA.3 = 1
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
   Config Portb.0 = Output : Portb.0 = 0
   Config Portb.1 = Output : Portb.1 = 0
   Shiftout Dataout , Sck , Command , 1
Return

'*******************************************
Wait_for_data_ready:
   Config Portb.0 = Output
   Config Portb.1 = Input
   Set Dataout
   For I = 1 To 255
      If Dataout = 0 Then Exit For
      Waitms 1
   Next
Return

'*******************************************
Read_byte:
   Config Portb.0 = Output : Portb.0 = 0
   Config Portb.1 = Input : Portb.1 = 1
   Shiftin Datain , Sck , Data_byte , 1
Return

'*******************************************
Signal_ack:
   Config Portb.0 = Output
   Config Portb.1 = Output
   Reset Dataout : Reset Sck
   Set Sck : Waitus 1
   Reset Sck
   'Set Dataout
Return

'*******************************************
Signal_end:
   Config Portb.0 = Output
   Config Portb.1 = Output
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

'*******************************************
Display_0:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 1 : Lcd "RH: " ; Fusing(rh_liner , "#.#") ; "%  "
   Locate 2 , 1 : Lcd "Temp: " ; Fusing(temp , "#.#") ; Chr(0) ; "C  "
Return

'*******************************************
Display_humidity_controler:
   Locate 1 , 1 : Lcd "RH Controler: "
   Locate 2 , 1 : Lcd Fusing(minimum_humidity , "#.#")
   Locate 2 , 5 : Lcd "<"
   Locate 2 , 6 : Lcd Fusing(rh_liner , "#.#")
   Locate 2 , 10 : Lcd "<"
   Locate 2 , 11 : Lcd Fusing(maximum_humidity , "#.#")
Return

'*******************************************
Display_temperature_controler:
   Locate 1 , 1 : Lcd "Temp Controler: "
   Locate 2 , 1 : Lcd Fusing(minimum_temperature , "#.#")
   Locate 2 , 5 : Lcd "<"
   Locate 2 , 6 : Lcd Fusing(temp , "#.#")
   Locate 2 , 10 : Lcd "<"
   Locate 2 , 11 : Lcd Fusing(maximum_temperature , "#.#")
Return

'**********************************
Sound_key_pressing:
   Sound Buzzer , 400 , 200
Return

'**********************************
Sound_menu:
   Sound Buzzer , 300 , 250
Return

'**********************************
Sound_error:
   Sound Buzzer , 100 , 500
Return

'**********************************
Eeprom_defult:
   Maximum_humidity_eeprom = 70
   Minimum_humidity_eeprom = 40
   Maximum_temperature_eeprom = 35
   Minimum_temperature_eeprom = 20
Return