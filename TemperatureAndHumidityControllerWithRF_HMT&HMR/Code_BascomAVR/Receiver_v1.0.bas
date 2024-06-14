'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

$baud = 9600
Enable Interrupts
Disable Urxc
On Urxc Uart_reciver

Config Lcdpin = Pin , Rs = Pina.0 , E = Pina.2 , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portb.1 = Output
Config Porta.3 = Output

Config Portc.3 = Output : Reset Portc.3 : Buzzer Alias Portc.3

Config Portc.0 = Input : Portc.0 = 1 : Key_up_1 Alias Pinc.0
Config Portd.3 = Input : Portd.3 = 1 : Key_down_1 Alias Pind.3
Config Portd.4 = Input : Portd.4 = 1 : Key_set Alias Pind.4
Config Portd.7 = Input : Portd.7 = 1 : Key_up_2 Alias Pind.7
Config Portd.2 = Input : Portd.2 = 1 : Key_down_2 Alias Pind.2

Config Portc.4 = Output : Portc.4 = 0 : Relay_dehumidifiers Alias Portc.4
Config Portc.5 = Output : Portc.5 = 0 : Relay_humidifier Alias Portc.5
Config Portc.2 = Output : Portc.2 = 0 : Relay_fan Alias Portc.2
Config Portc.1 = Output : Portc.1 = 0 : Relay_heater Alias Portc.1

Dim Status_key_set As Bit

Dim I As Byte
Dim Z As Single

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

Dim Buffer_uart As Byte
Dim S As String * 11
Dim Address As String * 3 : Address = "123"

Dim Status As Byte : Status = 0

Dim Len_s As Byte

'Gosub Eeprom_defult
Gosub Eeprom_load
Cls : Lcd "NO Signal"
Enable Urxc

Do


   If Key_up_1 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_humidity_minimum : Minimum_humidity_eeprom = Minimum_humidity
         Gosub Display_humidity_controler
         Status = 1
         Waitms T1
      Loop Until Key_up_1 = 1
   End If

   If Key_down_1 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_humidity_minimum : Minimum_humidity_eeprom = Minimum_humidity
         Gosub Display_humidity_controler
         Waitms T1
         Status = 1
      Loop Until Key_down_1 = 1
   End If

   If Key_up_2 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_humidity_maximum : Maximum_humidity_eeprom = Maximum_humidity
         Gosub Display_humidity_controler
         Status = 1
         Waitms T1
      Loop Until Key_up_2 = 1
   End If

   If Key_down_2 = 0 And Status_display = 1 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_humidity_maximum : Maximum_humidity_eeprom = Maximum_humidity
         Gosub Display_humidity_controler
         Status = 1
         Waitms T1
      Loop Until Key_down_2 = 1
   End If

   If Key_up_1 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_temperature_minimum : Minimum_temperature_eeprom = Minimum_temperature
         Gosub Display_temperature_controler
         Status = 1
         Waitms T1
      Loop Until Key_up_1 = 1
   End If

   If Key_down_1 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_temperature_minimum : Minimum_temperature_eeprom = Minimum_temperature
         Gosub Display_temperature_controler
         Status = 1
         Waitms T1
      Loop Until Key_down_1 = 1
   End If

   If Key_up_2 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Up_temperature_maximum : Maximum_temperature_eeprom = Maximum_temperature
         Gosub Display_temperature_controler
         Status = 1
         Waitms T1
      Loop Until Key_up_2 = 1
   End If

   If Key_down_2 = 0 And Status_display = 2 Then
      Gosub Sound_key_pressing
      Do
         Gosub Down_temperature_maximum : Maximum_temperature_eeprom = Maximum_temperature
         Gosub Display_temperature_controler
         Status = 1
         Waitms T1
      Loop Until Key_down_2 = 1
   End If

   If Key_set = 0 And Status_key_set = 0 Then
      Status_key_set = 1
      Gosub Sound_menu
      Incr Status_display : If Status_display > 2 Then Status_display = 0
      Cls

      If Status_display = 0 Then
         Enable Urxc
      Else
         Disable Urxc
      End If

   End If
   If Key_set = 1 Then Status_key_set = 0


   'If Status = 1 Then

   'Rh_liner = 60
   'Temp = 25

   If Status_display = 0 And Status = 1 Then
      Status = 0
      Gosub Display_0
   End If
   If Status_display = 1 Then Gosub Display_humidity_controler
   If Status_display = 2 Then Gosub Display_temperature_controler

   'If Status = 1 And Rh_liner <> 0 And Temp <> 0 Then
   If Status = 1 Then
      Status = 0
      Gosub Setting_relay_dehumidifiers
      Gosub Setting_relay_humidifier
      Gosub Setting_relay_heater
      Gosub Setting_relay_fan
   End If
   'Status = 0
   'End If

Loop

End

'***********************************************
Uart_reciver:
   Buffer_uart = Udr
   Select Case Buffer_uart
      Case 32 To 126:
         S = S + Chr(buffer_uart)
      Case 13:
         Disable Urxc : Waitms 10
         Address = Mid(s , 1 , 3)

         If Address = "123" Then
            Len_s = Len(s) - 3
            Address = Mid(s , 4 , Len_s)
            Rh_liner = Val(address)
         End If

         If Address = "124" Then
            Len_s = Len(s) - 3
            Address = Mid(s , 4 , Len_s)
            Temp = Val(address)
         End If

         Status = 1
         'Gosub Display_0
         S = ""
         Enable Urxc
   End Select
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
   Locate 2 , 12 : Lcd Fusing(maximum_humidity , "#.#")
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