'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Rs = Pinc.7 , E = Pinc.5 , Db4 = Pinc.3 , Db5 = Pinc.2 , Db6 = Pinc.1 , Db7 = Pinc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts

$baud = 9600
Enable Urxc
On Urxc Uart_reciver

Config Watchdog = 1024
Start Watchdog

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Timer0 = Timer , Prescale = 1024
Enable Timer0
On Timer0 32ms
Start Timer0

Config Portd.5 = Input : Portd.5 = 1 : Key_up Alias Pind.5
Config Portd.4 = Input : Portd.4 = 1 : Key_set Alias Pind.4
Config Portd.2 = Input : Portd.2 = 1 : Key_down Alias Pind.2

Config Portb.1 = Output : Portb.1 = 0 : Relay_fan Alias Portb.1
Config Portb.0 = Output : Portb.0 = 0 : Relay_heater Alias Portb.0

Config Portd.6 = Output : Portd.6 = 0 : Sound_pin Alias Portd.6

Dim W As Word

Dim Tmp As Word
Dim Temp_average As Word
Dim Final_temp As Byte
Dim Setpoint_max As Byte
Dim Setpoint_max_eeprom As Eram Byte

Dim Setpoint_min As Byte
Dim Setpoint_min_eeprom As Eram Byte

Dim Status_relay_heater As Byte
Dim Status_relay_fan As Byte
Dim Cs_temp As Word
Dim Count As Byte : Count = 0
Dim Serial_data(5) As Byte
Dim Buffer As Byte
Dim Flag As Bit
Dim Cs As Byte

Dim Set_temp_max As Byte
Dim Set_temp_min As Byte

Dim Status_exit As Bit : Status_exit = 0

Deflcdchar 0 , 28 , 20 , 28 , 32 , 32 , 32 , 32 , 32

Gosub Load_eeprom

Gosub Sound_menu

Do
   Debounce Key_set , 0 , Setting_stepoint_min , Sub
   Status_exit = 0
Loop

End


'***********************************************
Setting_stepoint_min:
   Disable Interrupts
   Stop Watchdog
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "change Setpoint:"
   Locate 2 , 1 : Lcd "Min= " ; Setpoint_min ; Chr(0) ; "C      "
   Waitms 300
Do
   Debounce Key_set , 0 , Setting_stepoint_max , Sub
   Do
      If Key_up = 0 Then
         Waitms 50
         If Key_up = 0 Then
            Gosub Sound_pressing
            Setpoint_min = Setpoint_min + 1
            Setpoint_min_eeprom = Setpoint_min
            Locate 2 , 1 : Lcd "Min= " ; Setpoint_min ; Chr(0) ; "C      "
         End If
      End If
   Loop Until Key_up = 1
   Do
      If Key_down = 0 Then
         Waitms 50
         If Key_down = 0 Then
            Gosub Sound_pressing
            Setpoint_min = Setpoint_min - 1
            Setpoint_min_eeprom = Setpoint_min
            Locate 2 , 1 : Lcd "Min= " ; Setpoint_min ; Chr(0) ; "C      "
         End If
      End If
   Loop Until Key_down = 1
Loop Until Status_exit = 1
Return

'***********************************************
Setting_stepoint_max:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "change Setpoint:"
   Locate 2 , 1 : Lcd "Max= " ; Setpoint_max ; Chr(0) ; "C      "
   Waitms 300
Do
   If Key_set = 0 Then
      Waitms 30
      If Key_set = 0 Then
         Gosub Sound_menu
         Gosub Display_lcd
         Enable Interrupts
         Reset Watchdog : Start Watchdog
         Status_exit = 1
      End If
   End If
   Do
      If Key_up = 0 Then
         Waitms 50
         If Key_up = 0 Then
            Gosub Sound_pressing
            Setpoint_max = Setpoint_max + 1
            Setpoint_max_eeprom = Setpoint_max
            Locate 2 , 1 : Lcd "Max= " ; Setpoint_max ; Chr(0) ; "C      "
         End If
      End If
   Loop Until Key_up = 1
   Do
      If Key_down = 0 Then
         Waitms 50
         If Key_down = 0 Then
            Gosub Sound_pressing
            Setpoint_max = Setpoint_max - 1
            Setpoint_max_eeprom = Setpoint_max
            Locate 2 , 1 : Lcd "Max= " ; Setpoint_max ; Chr(0) ; "C      "
         End If
      End If
   Loop Until Key_down = 1
Loop Until Status_exit = 1
Return

'***********************************************
Display_lcd:
   Locate 1 , 1 : Lcd "Min < Temp < Max"
   Locate 2 , 1 : Lcd Setpoint_min ; "    "
   Locate 2 , 5 : Lcd "< " ; Final_temp ; Chr(0) ; "C   "
   Locate 2 , 12 : Lcd "< " ; Setpoint_max ; "   "
Return

'***********************************************    32ms
32ms:
   Reset Watchdog
   Incr Count
   W = Getadc(1) : Cs_temp = W + Cs_temp
   If Count = 30 Then
      Stop Timer0
      Temp_average = Cs_temp / 30
      'Temp_average = Temp_average - 558
      Final_temp = Temp_average / 2
      Gosub Uart_transfer
      Count = 0
      Gosub Controler_heater
      Gosub Controler_fan
      Gosub Display_lcd
      Start Timer0
   End If
Return

'***********************************************
Uart_transfer:
   Udr = &HEB : Waitms 5
   Udr = Final_temp : Waitms 5
   Udr = Setpoint_max : Waitms 5
   Udr = Setpoint_min : Waitms 5
   Udr = Status_relay_heater : Waitms 5
   Udr = Status_relay_fan : Waitms 5
   Cs_temp = 0
Return

'***********************************************
Uart_reciver:
   Buffer = Udr
   If Buffer = &HAA And Count = 0 Then
      Count = 1
      Serial_data(count) = Buffer
      Cs = Buffer
      Goto E1
   End If
   If Count <> 0 Then
      Count = Count + 1
      Serial_data(count) = Buffer
      If Count = 3 Then
            If Serial_data(2) > Setpoint_min And Serial_data(2) < 255 Then Setpoint_max = Serial_data(2)
            If Serial_data(3) < Setpoint_max And Serial_data(3) < 255 Then
               Setpoint_min = Serial_data(3)
            End If
            Gosub Save_eeprom : Gosub Load_eeprom
         Count = 0
      End If
      Cs = Cs + Buffer
   End If
   E1:
Return

'***********************************************
Controler_heater:
   Set_temp_max = Setpoint_min + 1
   Set_temp_min = Setpoint_min
   If Final_temp < Set_temp_min Then
      Status_relay_heater = 1 : Set Relay_heater
   Elseif Final_temp > Set_temp_max Then
      Status_relay_heater = 0 : Reset Relay_heater
   End If
Return

'***************************************************************
Controler_fan:
   Set_temp_max = Setpoint_max
   Set_temp_min = Setpoint_max - 1
   If Final_temp > Set_temp_max Then
      Status_relay_fan = 1 : Set Relay_fan
   Elseif Final_temp <= Set_temp_min Then
      Status_relay_fan = 0 : Reset Relay_fan
   End If
Return

'***********************************************
Load_eeprom:
   Setpoint_max = Setpoint_max_eeprom
   Setpoint_min = Setpoint_min_eeprom
Return

'***********************************************
Save_eeprom:
   Setpoint_max_eeprom = Setpoint_max
   Setpoint_min_eeprom = Setpoint_min
Return

'***************************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return