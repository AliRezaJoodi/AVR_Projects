'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000
$hwstack=32
$swstack=10
$framesize=40

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 150

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Timer0 = Timer , Prescale = 1024                     'PRESCALE= 1|8|64|256|1024
On Timer0 Lable
Enable Timer0                                               ' Or  Enable Ovf0
Stop Timer0

Config Porta.0 = Output : Reset Porta.0 : GAS_Relay Alias Porta.0
Config Porta.3 = Output : Reset Porta.3 : TEMP_Relay Alias Porta.3
Config Portd.6 = Output : Relay_phone_line Alias Portd.6 : Reset Relay_phone_line
Config Portd.4 = Output : Reset Portd.4 : Buzzer Alias Portd.4

CONST DELAY_KEY=300

CONST ERR_ENABLE=0
CONST ERR_TEMP_RELAY=1
CONST ERR_TEMP_SOUND=2
CONST ERR_TEMP_DIAL=3
CONST ERR_GAS_RELAY=4
CONST ERR_GAS_SOUND=5
CONST ERR_GAS_DIAL=6
CONST HISTORY_DIAL=7

Dim W As Word
Dim Gas_value As Single
dim gas_percent as single
Dim gas_offset As Single
Dim gas_offset_eeprom As Eram Single
Dim GAS_Setpoint As Single
Dim GAS_Setpoint_eeprom As Eram Single                           ':Setpoint_eerom=2.5
Dim GAS_Setpoint_max As Single
Dim GAS_Setpoint_min As Single

Dim temp_value As Single
Dim temp_Setpoint As Single
Dim temp_Setpoint_eeprom As Eram Single                           ':Setpoint_eerom=2.5
Dim temp_Setpoint_max As Single
Dim temp_Setpoint_min As Single

Dim error_gas_relay As Bit: error_gas_relay=0
Dim error_gas_sound As Bit: error_gas_sound=0
Dim error_gas_dial As Bit: error_gas_dial=0

Dim Status_alarm_disable As Bit : Status_alarm_disable = 0
Dim State_alarm_on As Bit

Dim Status_key_set As Bit : Status_key_set = 0

Dim Key As Byte
Dim history_key As Byte

Dim Phone_number As String * 11
Dim Phone_number_eeprom As Eram String * 11                 ': Phone_number_eeprom = "09112204314"
Dim Z As String * 16 : Z = ""

'Dim Status_dial As Bit : Status_dial = 0
Dim Status_exit As Bit : Status_exit = 0
Dim Status_enable_change_number As Bit : Status_enable_change_number = 0

Dim K1 As Word

dim buffer_lcd as string *16
dim buffer_str as string *16
dim buffer2 as Single
dim buffer_int as Integer

DIM Status as Byte :Status=1

'dim z1 as Integer

'Gosub eeprom_defulte
Gosub Eeprom_load
Gosub Sound_menu

Do
   Gosub GET_temp_SENSOR:Gosub check_temp_error
   Gosub GET_GAS_SENSOR:Gosub Converter
   if gas_percent<0 then
      gosub Calibrated_GAS
      'Gosub GET_GAS_SENSOR
      Gosub Converter
   end if
   Gosub check_gas_error
   GOSUB DISPLAY_MAIN
   Gosub driver_relays
   Gosub driver_sound
   Gosub driver_Dial

   Key = Getkbd() : Key = Lookup(key , Read_key)
   If Key < 16 and history_key<>key Then
      history_key=key
      Select Case Key
         Case 10:
            Gosub Sound_menu
            Gosub Setting_Temp
         Case 11:
            Gosub Sound_menu
            Gosub Setting_Gas
         Case 12:
            Gosub Sound_menu
            Gosub Calibration_Gas
         Case 13:
            Gosub Sound_menu
            Gosub Edit_number
         Case 15:
            Gosub Sound_menu
            'gosub Calibrated_GAS
            TOGGLE Status.ERR_ENABLE
            if Status.ERR_ENABLE=0 then
            'Status.ERR_TEMP_RELAY=0
            'Status.ERR_TEMP_SOUND=0
            'Status.ERR_TEMP_DIAL=0
            'Status.HISTORY_DIAL = 0
            Status=0
            Stop Timer0 : Timer0 = 0:K1 = 0
            end if
            'K1=600:gosub Lable
            'Status.HISTORY_DIAL = 0
            GOSUB DISPLAY_MAIN
            Waitms DELAY_KEY
         Case Else:
            Gosub Sound_error
      End Select
   End If
   history_key=key
Loop

End

'***************************************************
Setting_Temp:
   cls
   buffer2=TEMP_Setpoint
   do
      locate 1,1: lcd "Temp Setpoint:"
      Locate 2,1:
      buffer_lcd="SV:"
      buffer2=ROUND(buffer2):buffer_int=buffer2:buffer_str = Str(buffer_int): buffer_str = Format(buffer_str,"00")
      buffer_lcd=buffer_lcd+buffer_str
      LCD buffer_lcd;chr(0)

      Key = Getkbd() : Key = Lookup(key , Read_key)
      If Key < 16 and history_key<> key Then
         Select Case Key
            Case 0 To 9:
                  Gosub Sound_pressing
                  buffer2= buffer2*10:buffer2=buffer2+key
                  Locate 2 , 1 : Lcd "                "
            Case 10
               If buffer2>0 and buffer2<=100 Then
                  Gosub Sound_menu
                  TEMP_Setpoint= buffer2
                  TEMP_Setpoint_eeprom = TEMP_Setpoint
                  Locate 2,1:lcd "                "
                  Locate 2,1: lcd "Saving ...":Waitms 900 : Cls
               Else
                  Gosub Sound_error
               End If
            case 14:
                Gosub Sound_menu
                buffer2 =0
                Locate 2 , 1 : Lcd "                "
            Case 15:
               Gosub Sound_menu
               cls
               exit do
            Case Else:
               Gosub Sound_error
         End Select
      end if
      history_key=key
   loop
   history_key=key
Return

'***************************************************
Setting_Gas:
   cls
   buffer2=GAS_Setpoint
   do
      locate 1,1: lcd "Gas Setpoint:"
      Locate 2,1:
      buffer_lcd="SV:"
      buffer2=ROUND(buffer2):buffer_int=buffer2:buffer_str = Str(buffer_int): buffer_str = Format(buffer_str,"00")
      buffer_lcd=buffer_lcd+buffer_str+"%"
      LCD buffer_lcd

      Key = Getkbd() : Key = Lookup(key , Read_key)
      If Key < 16 and history_key<> key Then
         Select Case Key
            Case 0 To 9:
                  Gosub Sound_pressing
                  buffer2= buffer2*10:buffer2=buffer2+key
                  Locate 2 , 1 : Lcd "                "
            Case 11:
               If buffer2>0 and buffer2<=100 Then
                  Gosub Sound_menu
                  GAS_Setpoint = buffer2 : 'Z = ""
                  GAS_Setpoint_eeprom = GAS_Setpoint
                  Locate 2,1:lcd "                "
                  Locate 2,1: lcd "Saving ...":Waitms 900 : Cls
               Else
                  Gosub Sound_error
               End If
            case 14:
                Gosub Sound_menu
                buffer2 =0
                Locate 2 , 1 : Lcd "                "
            Case 15:
               Gosub Sound_menu
               cls
               exit do
            Case Else:
               Gosub Sound_error
         End Select
      end if
      history_key=key
   loop
   history_key=key
Return

'***************************************************
Calibration_Gas:
   cls
   DO
      Gosub GET_GAS_SENSOR:Gosub Converter
      locate 1,1: lcd "Gas Calibration:"
      Locate 2,1:
      buffer_lcd="PV:"
      gas_percent=ROUND(gas_percent):buffer_int=gas_percent:buffer_str = Str(buffer_int): buffer_str = Format(buffer_str,"00")
      buffer_lcd=buffer_lcd+buffer_str+"%"+"  "
      LCD buffer_lcd
      Key = Getkbd() : Key = Lookup(key , Read_key)
      If Key < 16 and history_key<> key Then
         Select Case Key
            Case 12:
               Gosub Sound_menu
               'Gosub Calibration_Gas
               gas_offset=Gas_value
               gas_offset_eeprom=gas_offset
               'exit do
            Case 15:
               Gosub Sound_menu
               cls
               exit do
            Case Else:
               Gosub Sound_error
         End Select
      end if
      history_key=key
   LOOP
   history_key=key
Return

'***************************************************
Edit_number:
   cls
   z=Phone_number
   DO
      locate 1,1: lcd "Phone Number:"
      'Locate 2,1:lcd "                "
      Locate 2,1:Lcd z

      Key = Getkbd() : Key = Lookup(key , Read_key)
      If Key < 16 and history_key<> key Then
         Select Case Key
            Case 0 To 9:
                  Gosub Sound_pressing
                  Z = Z + Str(key)
                  Locate 2 , 1 : Lcd "                "
                  'Locate 2 , 1 : Lcd Z
            Case 13:
               If Z <> "" Then
                  Gosub Sound_menu
                  Phone_number = Z : 'Z = ""
                  Phone_number_eeprom = Phone_number
                  Locate 2,1:lcd "                "
                  Locate 2,1: lcd "Saving ...":Waitms 900 : Cls
                  'exit do
               Else
                  Gosub Sound_error
               End If
            case 14:
                Gosub Sound_menu
                'Phone_number = ""
                z=""
                Locate 2 , 1 : Lcd "                " ': Locate 2 , 1
            Case 15:
               Gosub Sound_menu
               cls
               exit do
            Case Else:
               Gosub Sound_error
         End Select
      end if
      history_key=key
   LOOP
   history_key=key
Return

'***************************************************
Lable:
   Incr K1
   If K1 = 600 Then
      Stop Timer0 : Timer0 = 0
      'Status.HISTORY_DIAL = 0
      Status=1
      Gosub driver_relays
      Reset Relay_phone_line
      'Reset Relay_phone_line : Waitms 100 : Reset GAS_Relay : Waitms 100
      Wait 1
      K1 = 0
   End If
Return

'***************************************************
Dial:
   Set Relay_phone_line : Waitms 500
   'Locate 2 , 1 : Lcd "Dial ...        " : Waitms 10
   Dtmfout Phone_number , 50
   'Start Timer0
Return

'**********************************
GET_GAS_SENSOR:
   W = Getadc(1)
   Gas_value = W / 0.2048
   Gas_value = Gas_value / 1000
Return

'**********************************
Converter:
   gas_percent=gas_value-gas_offset
   gas_percent=gas_percent*100
   buffer2=5-gas_offset
   gas_percent=gas_percent/buffer2
Return

'**********************************
Calibrated_GAS:
   gas_offset=Gas_value
   gas_offset_eeprom=gas_offset :waitms 10
   'Gosub Converter
Return

'**********************************
GET_temp_SENSOR:
   W = Getadc(2)
   temp_value = W *4.8828
   temp_value = temp_value / 10
Return

'**********************************
Display_lcd:
      Locate 1 , 1 : Lcd "Input: " ; Fusing(gas_percent , "#.##") ; "%  "
      If Status_alarm_disable = 0 And State_alarm_on = 1 Then
         Locate 2 , 1 : Lcd "**** Alarm ****"
      Else
         Locate 2 , 1 : Lcd "Setpoint: " ; Fusing(GAS_setpoint , "#.#") ; "v  "
      End If
Return

'**********************************
DISPLAY_MAIN:
   Deflcdchar 0,24,24,3,4,4,4,3,32
   Deflcdchar 1,4,14,14,14,31,31,4,32   'Ring Logo
   'TEMP_value=25.3
   'local buffer as string *11
   buffer_lcd="PV:"
   ' 1,1 :lcd "PV:"
      'buffer= Fusing(TEMP_value , "##.#") ':buffer=format(buffer,"00.0")
   gas_percent=ROUND(gas_percent):buffer_int=gas_percent:buffer_str = Str(buffer_int): buffer_str = Format(buffer_str,"00")
   buffer_lcd=buffer_lcd+buffer_str+"%"+"   "
   'locate 1,4:LCD Fusing(gas_percent , "#.#") ;"%";"  "
   locate 1,1:LCD buffer_lcd
   locate 1,10:lcd Fusing(temp_value , "##.#") ;chr(0);"    "

   if Status.ERR_ENABLE =0 then
      Locate 1 , 16 : Lcd "X"
   Else
      Locate 1 , 16 : Lcd " "
   End If

   buffer_lcd="SV:"
   GAS_Setpoint=ROUND(GAS_Setpoint):buffer_int=GAS_Setpoint:buffer_str = Str(buffer_int): buffer_str = Format(buffer_str,"00")
   buffer_lcd=buffer_lcd+buffer_str+"%"
   if Status.ERR_GAS_RELAY=1 then
      buffer_lcd=buffer_lcd+chr(1)+"  "
   else
      buffer_lcd=buffer_lcd+"   "
   end if

   locate 2,1:LCD buffer_lcd

   locate 2,10:'lcd Fusing(TEMP_Setpoint , "##.#") ;chr(0)
   TEMP_Setpoint=ROUND(TEMP_Setpoint):buffer_int=TEMP_Setpoint:buffer_str = Str(buffer_int): buffer_str = Format(buffer_str,"00")
   buffer_lcd=buffer_str
   lcd  buffer_lcd ;chr(0)
   if Status.ERR_TEMP_RELAY=1 then lcd chr(1)
   lcd "    "
Return

'**********************************
check_temp_error:
   temp_Setpoint_max = temp_Setpoint
   temp_Setpoint_min = temp_Setpoint - 3
   If temp_value >= temp_Setpoint_max Then
      Status.ERR_TEMP_RELAY=1
      Status.ERR_TEMP_SOUND=1
      Status.ERR_TEMP_DIAL=1
   Elseif temp_value < temp_Setpoint_min Then
      'Status.ERR_TEMP_RELAY=0
      'Status.ERR_TEMP_SOUND=0
      'Status.ERR_TEMP_DIAL=0
   End If
Return

'**********************************
check_gas_error:
   gas_Setpoint_max = gas_Setpoint
   gas_Setpoint_min = gas_Setpoint - 0.3
   If gas_percent >= gas_Setpoint_max Then
      Status.ERR_GAS_RELAY=1
      Status.ERR_GAS_SOUND=1
      Status.ERR_GAS_DIAL=1
   Elseif gas_percent < gas_Setpoint_min Then
      'Status.ERR_GAS_RELAY=0
      'Status.ERR_GAS_SOUND=0
      'Status.ERR_GAS_DIAL=0
   End If
Return

'**********************************
driver_relays:
   if Status.ERR_ENABLE=1 then
      TEMP_Relay=Status.ERR_TEMP_RELAY
      GAS_Relay=Status.ERR_GAS_RELAY
   else
      TEMP_Relay=0
      GAS_Relay=0
   end if
Return

'**********************************
driver_sound:
   if Status.ERR_ENABLE=1 then
      if Status.ERR_TEMP_SOUND=1 or Status.ERR_GAS_SOUND=1 then  Gosub Sound_error
   end if
return

'**********************************
driver_Dial:
   if Status.ERR_ENABLE=1 then
      if Status.ERR_TEMP_DIAL=1 or Status.ERR_GAS_DIAL=1 then
         if Status.HISTORY_DIAL = 0 then
            Gosub Dial
            Status.HISTORY_DIAL = 1
            Start Timer0
         end if
      end if
   else
      Reset Relay_phone_line
   end if
return

'**********************************
gas_Setpoint_add:
   GAS_Setpoint = GAS_Setpoint + 0.1 : If GAS_Setpoint > 5 Then GAS_Setpoint = 0
Return

'**********************************
gas_Setpoint_reduce:
   GAS_Setpoint = GAS_Setpoint - 0.1 : If GAS_Setpoint < 0 Then GAS_Setpoint = 5
Return

'**********************************
eeprom_defulte:
   GAS_Setpoint_eeprom = 30
   gas_offset_eeprom=0
   temp_Setpoint_eeprom=35
   Phone_number_eeprom="09112204314"
return

'**********************************
Eeprom_load:
   GAS_Setpoint = GAS_Setpoint_eeprom
   gas_offset=gas_offset_eeprom
   temp_Setpoint=temp_Setpoint_eeprom
   Phone_number = Phone_number_eeprom
Return

'**********************************
EEprom_save:
   GAS_Setpoint_eeprom = GAS_Setpoint
   gas_offset_eeprom=gas_offset
   temp_Setpoint_eeprom=temp_Setpoint
Return

'**********************************
Sound_pressing:
   Sound Buzzer , 100 , 250
Return

'**********************************
Sound_menu:
   Sound Buzzer , 100 , 500
Return

'**********************************
Sound_error:
   Sound Buzzer , 10 , 1500
Return

'**********************************************   Read_key
Read_key:
Data 1 , 4 , 7 , 15 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 14 , 10 , 11 , 12 , 13       ',16