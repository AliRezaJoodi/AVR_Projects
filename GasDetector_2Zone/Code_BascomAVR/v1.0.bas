'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 11059200
$crystal = 8000000

'$PROG &HFF,&HC4,&HD1,&H00' generated. Take care that the chip supports all fuse bytes.

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Debounce = 30
Config Portd.5 = Input : Portd.5 = 1 : Key_up Alias Pind.5
Config Portd.6 = Input : Portd.6 = 1 : Key_set Alias Pind.6
Config Portd.2 = Input : Portd.2 = 1 : Key_down Alias Pind.2

Config Porta.0 = Output : Reset Porta.0 : Relay_mq2 Alias Porta.0
Config Porta.2 = Output : Reset Porta.2 : Relay_mq9 Alias Porta.2
Config Portc.4 = Output : Reset Portc.4 : Buzzer Alias Portc.4

Const Pres_key_max_timer = 20000

Dim W As Word
Dim Input_voltage As Single
Dim Z1 As Single
Dim Z2 As Single

Dim mq2_Input_percent As Integer
Dim mq2_Setpoint As Byte
Dim mq2_Setpoint_eeprom As Eram Byte
'Dim mq2_Setpoint_max As Byte
'Dim mq2_Setpoint_min As Byte
Dim mq2_Setting_default As Single
Dim mq2_Setting_default_eeprom As Eram Single
Dim mq2_Status_disable As Bit : mq2_Status_disable = 0

Dim mq9_Input_percent As Integer
Dim mq9_Setpoint As Byte
Dim mq9_Setpoint_eeprom As Eram Byte
'Dim mq9_Setpoint_max As Byte
'Dim mq9_Setpoint_min As Byte
Dim mq9_Setting_default As Single
Dim mq9_Setting_default_eeprom As Eram Single
Dim mq9_Status_disable As Bit : mq9_Status_disable = 0

Dim Status_key_up As Bit : Status_key_up = 0
Dim Status_key_set As Bit : Status_key_set = 0
Dim Status_key_down As Bit : Status_key_down = 0

Dim K As Word : K = 0
Dim Status As Bit : Status = 0

if Key_set=0 and Status_key_set=0 then
   Waitms 30
   if Key_set=0 and Status_key_set=0 then
      Status_key_set=1
      Gosub Sound_menu
      Gosub Read_mq2 : mq2_Setting_default_eeprom = Input_voltage
      Gosub Read_mq9 : mq9_Setting_default_eeprom = Input_voltage
   End If
End If

'Gosub Eeprom_default
Gosub Eeprom_load
Gosub Sound_menu


Do
   Gosub Read_mq2
   Gosub Read_mq9
   Gosub Display_lcd

   If mq2_Status_disable = 0 Then Gosub Alarm_mq2
   If mq9_Status_disable = 0 Then Gosub Alarm_mq9

   If Key_up = 0 And Status_key_up = 0 Then
      Waitms 30
      If Key_up = 0 And Status_key_up = 0 Then
         Status_key_up = 1
         Gosub Sound_menu
         Toggle mq2_Status_disable
         'If mq2_Status_disable = 1 Then Reset Relay_mq2
         Reset Relay_mq2
      End If
   End If
   If Key_up = 1 Then Status_key_up = 0

   If Key_down = 0 And Status_key_down = 0 Then
      Waitms 30
      If Key_down = 0 And Status_key_down = 0 Then
         Status_key_down = 1
         Gosub Sound_menu
         Toggle mq9_Status_disable
         'If mq9_Status_disable = 1 Then Reset Relay_mq9
         Reset Relay_mq9
      End If
   End If
   If Key_down = 1 Then Status_key_down = 0

   if Key_set=0 and Status_key_set=0 then
      Waitms 30
      if Key_set=0 and Status_key_set=0 then
         Status_key_set=1
         Gosub Setting_mq2_Setpoint
      End If
   end if
   if Key_set=1 then Status_key_set=0

   Status = 0
   Waitms 100
Loop

End

'**********************************
Setting_mq2_Setpoint:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Smoke Detector"
   Locate 2 , 1 : Lcd "Setting: " ; mq2_Setpoint ; "% "
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr mq2_Setpoint
            If mq2_Setpoint > 100 Then mq2_Setpoint = 0
            mq2_Setpoint_eeprom = mq2_Setpoint
            Locate 2 , 1 : Lcd "Setting: " ; mq2_Setpoint ; "%   "
            K = 0
         End If
      Loop Until Key_up = 1

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr mq2_Setpoint
            If mq2_Setpoint > 100 Then mq2_Setpoint = 100
            mq2_Setpoint_eeprom = mq2_Setpoint
            Locate 2 , 1 : Lcd "Setting: " ; mq2_Setpoint ; "%   "
            K = 0
         End If
      Loop Until Key_down = 1

      If Key_set = 0 And Status_key_set = 0 Then
         Waitms 30
         If Key_set = 0 And Status_key_set = 0 Then
            Status_key_set = 1
            Gosub Sound_menu
            Gosub Setting_mq9_Setpoint
         End If
      End If
      If Key_set = 1 Then Status_key_set = 0

   Loop Until Status = 1
Return


'**********************************
Setting_mq9_Setpoint:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Gas Detector"
   Locate 2 , 1 : Lcd "Setting: " ; mq9_Setpoint ; "% "
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr mq9_Setpoint
            If mq9_Setpoint > 100 Then mq9_Setpoint = 0
            mq9_Setpoint_eeprom = mq9_Setpoint
            Locate 2 , 1 : Lcd "Setting: " ; mq9_Setpoint ; "%   "
            K = 0
         End If
      Loop Until Key_up = 1

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr mq9_Setpoint
            If mq9_Setpoint > 100 Then mq9_Setpoint = 100
            mq9_Setpoint_eeprom = mq9_Setpoint
            Locate 2 , 1 : Lcd "Setting: " ; mq9_Setpoint ; "%   "
            K = 0
         End If
      Loop Until Key_down = 1

      If Key_set = 0 And Status_key_set = 0 Then
         Waitms 30
         If Key_set = 0 And Status_key_set = 0 Then
            Status_key_set = 1
            Gosub Sound_menu
            Cls : Status = 1
         End If
      End If
      If Key_set = 1 Then Status_key_set = 0

   Loop Until Status = 1
Return

'**********************************
Read_mq2:
   W = Getadc(1)
   Input_voltage = W*4.8828: Input_voltage = Input_voltage / 1000
   Z1 = Input_voltage -mq2_Setting_default : Z1 = Z1 * 100
   Z2 = 5 - mq2_Setting_default
   mq2_Input_percent = Z1 / Z2
Return

'**********************************
Read_mq2_:
   W = Getadc(1)
   Input_voltage = W*4.8828: Input_voltage = Input_voltage / 1000
   Z1 = Input_voltage -mq2_Setting_default
   Z2 = 5 - mq2_Setting_default
   mq2_Input_percent = Z1 *100: mq2_Input_percent = mq2_Input_percent/Z2
Return

'**********************************
Read_mq9:
   W = Getadc(3)
   Input_voltage = W*4.8828
   Input_voltage = Input_voltage / 1000
   Z1 = Input_voltage -mq9_Setting_default : Z1 = Z1 * 100
   Z2 = 5 - mq9_Setting_default
   mq9_Input_percent = Z1 / Z2
Return


'**********************************
Display_lcd:
   Locate 1 , 1 : Lcd "Smoke: " ; mq2_Input_percent ; "%   "
   Locate 2 , 1 : Lcd "Gas: " ; mq9_Input_percent ; "%   "

   If mq2_Status_disable = 1 Then
      Locate 1 , 16 : Lcd "X"
   Else
      Locate 1 , 16 : Lcd " "
   End If

   If mq9_Status_disable = 1 Then
      Locate 2 , 16 : Lcd "X"
   Else
      Locate 2 , 16 : Lcd " "
   End If

Return

'**********************************
Alarm_mq2:
   If mq2_Input_percent > mq2_Setpoint Then
      If mq2_Status_disable = 0 Then Set Relay_mq2
      Gosub Sound_error : Gosub Sound_menu
   End If
Return

'**********************************
Alarm_mq9:
   If mq9_Input_percent > mq9_Setpoint Then
      If mq9_Status_disable = 0 Then Set Relay_mq9
      Gosub Sound_error : Gosub Sound_menu
   End If
Return

'**********************************
Eeprom_default:
   mq2_Setpoint_eeprom = 15
   mq9_Setpoint_eeprom = 15
Return

'**********************************
Eeprom_load:
   mq2_Setpoint = mq2_Setpoint_eeprom
   mq9_Setpoint = mq9_Setpoint_eeprom
   mq2_Setting_default = mq2_Setting_default_eeprom
   mq9_Setting_default = mq9_Setting_default_eeprom
Return

'**********************************
Eeprom_save:
   mq2_Setpoint_eeprom = mq2_Setpoint
   mq9_Setpoint_eeprom = mq9_Setpoint
Return

'**********************************
Sound_pressing:
   Sound Buzzer , 400 , 200
Return

'**********************************
Sound_menu:
   Sound Buzzer , 400 , 250
Return

'**********************************
Sound_error:
   Sound Buzzer , 100 , 500
Return