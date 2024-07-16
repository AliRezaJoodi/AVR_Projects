'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls
Gosub Display_loading
Gosub Display_advertising

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Const Gain = 5000 / 1023
Start Adc

Config Portb.6 = Input : Portb.6 = 1 : Up_key1 Alias Pinb.6
Config Portb.7 = Input : Portb.7 = 1 : Down_key1 Alias Pinb.7
Config Portb.5 = Input : Portb.5 = 1 : Up_key2 Alias Pinb.5
Config Portb.4 = Input : Portb.4 = 1 : Down_key2 Alias Pinb.4

Config Portc.6 = Output : Portc.6 = 0 : ALARM_LOW Alias Portc.6
Config Portc.7 = Output : Portc.7 = 0 : Alarm_high Alias Portc.7

Dim W As Word , Temp As Single
Dim Input_mv As Single

Dim Maximum_temperature As Single
Dim Maximum_temperature_eeprom As Eram Single
Dim Maximum_temperature_high As Single
Dim Maximum_temperature_low As Single

Dim Minimum_temperature As Single
Dim Minimum_temperature_eeprom As Eram Single
Dim Minimum_temperature_high As Single
Dim Minimum_temperature_low As Single

Dim T As Word : T = 300

Dim high_status As Bit
Dim low_status As Bit

'Gosub Eeprom_default
Gosub Eeprom_load

Do
   If Up_key1 = 0 Then
      Gosub Incr_maximum_temperature
      Gosub Eeprom_save
   End If
   If Down_key1 = 0 Then
      Gosub decr_maximum_temperature
      Gosub Eeprom_save
   End If
   If Up_key2 = 0 Then
      Gosub incr_minimum_temperature
      Gosub Eeprom_save
   End If
   If Down_key2 = 0 Then
      Gosub decr_minimum_temperature
      Gosub Eeprom_save
   End If
   Gosub Red_temp
   Gosub Setting_low
   Gosub Setting_high
   Gosub Show_temp
   Waitms T
Loop

End


'**********************************************
Eeprom_default:
   Maximum_temperature = 30.0
   Minimum_temperature = 20.0
   Maximum_temperature_eeprom = Maximum_temperature
   Minimum_temperature_eeprom = Minimum_temperature
Return

'**********************************************
Eeprom_save:
   Maximum_temperature_eeprom = Maximum_temperature
   Minimum_temperature_eeprom = Minimum_temperature
Return

'**********************************************
Eeprom_load:
   Maximum_temperature = Maximum_temperature_eeprom
   Minimum_temperature = Minimum_temperature_eeprom
Return

'**********************************************
Incr_maximum_temperature:
   Maximum_temperature = Maximum_temperature + 0.5
   If Maximum_temperature < 0 Or Maximum_temperature > 99 Then Maximum_temperature = 0
Return

'**********************************************
decr_maximum_temperature:
   Maximum_temperature = Maximum_temperature - 0.5
   If Maximum_temperature < 0 Or Maximum_temperature > 99 Then Maximum_temperature = 99
Return

'**********************************************
incr_minimum_temperature:
   Minimum_temperature = Minimum_temperature + 0.5
   If Minimum_temperature < 0 Or Minimum_temperature > 99 Then Minimum_temperature = 0
Return

'**********************************************
decr_minimum_temperature:
   Minimum_temperature = Minimum_temperature - 0.5
   If Minimum_temperature < 0 Or Minimum_temperature > 99 Then Minimum_temperature = 99
Return

'**********************************************
Red_temp:
   W = Getadc(7)
   Input_mv = W * Gain
   Temp = Input_mv / 10
Return

'**********************************************
Show_temp:
   Locate 1 , 1 : Lcd Fusing(minimum_temperature , "#.#")
   Locate 1 , 5 : Lcd "<"
   Locate 1 , 6 : Lcd Fusing(temp , "#.#")
   Locate 1 , 10 : Lcd "<"
   Locate 1 , 11 : Lcd Fusing(maximum_temperature , "#.#")

   Locate 2 , 1 : Lcd "Low:" ; low_status
   Locate 2 , 11 : Lcd "High:" ; high_status
Return

'**********************************************
Setting_high:
   Maximum_temperature_high = Maximum_temperature
   Maximum_temperature_low = Maximum_temperature - 1
   If Temp > Maximum_temperature_high Then
      Set Alarm_high : high_status = 1
   Elseif Temp < Maximum_temperature_low Then
      Reset Alarm_high : high_status = 0
   End If
Return

'**********************************************
Setting_low:
   Minimum_temperature_high = Minimum_temperature + 1
   Minimum_temperature_low = Minimum_temperature
   If Temp < Minimum_temperature_low Then
      Set ALARM_LOW : low_status = 1
   Elseif Temp > Minimum_temperature_high Then
      Reset ALARM_LOW : low_status = 0
   End If
Return

'**********************************************
Display_loading:
   Cls
   Locate 1 , 1 : Lcd "Testing the LCD"
   Locate 2 , 1 : Lcd "Loading ..."
   Waitms 500 : Cls
Return

'**********************************************
Display_advertising:
   Locate 1 , 1 : Lcd "GitHub.com"
   Locate 2 , 1 : Lcd "AliRezaJoodi"
   Waitms 500 : Cls
Return