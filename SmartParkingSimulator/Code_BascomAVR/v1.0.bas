'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portb.0 = Output : Buzzer Alias Portb.0 : Reset Buzzer

Config Debounce = 30

Config Portd.4 = Input : Portd.4 = 1 : Up_key Alias Pind.4 : Erase_key Alias Pind.4
Config Portd.3 = Input : Portd.3 = 1 : Set_key Alias Pind.3
Config Portd.2 = Input : Portd.2 = 1 : Down_key Alias Pind.2

Config Portb.4 = Output : Led_input_panel Alias Portb.4 : Reset Led_input_panel
Config Portb.1 = Output : Relay_input_panel Alias Portb.1 : Reset Relay_input_panel

Config Portc.2 = Output : Led_output_panel Alias Portc.2 : Reset Led_output_panel

Config Portb.2 = Input : Sensor1_input_panel Alias Pinb.2
Config Portb.3 = Input : Sensor2_input_panel Alias Pinb.3
Config Portc.0 = Input : Sensor1_output_panel Alias Pinc.0
Config Portc.1 = Input : Sensor2_output_panel Alias Pinc.1

Config Portd.6 = Input

Declare Sub Money_setting
Declare Sub Capacity_setting

Dim Money As Word
Dim E_money As Eram Word

Dim Capacity As Byte
Dim E_capacity As Eram Byte

Dim Total As Word
Dim E_total As Eram Word
Dim Car As Byte
Dim E_car As Eram Byte
Dim Cost As Integer
Dim E_cost As Eram Word
Dim Free As Byte
Dim E_free As Eram Byte

Dim Status_input As Bit : Status_input = 0
Dim Status_input2 As Bit

Dim Status_output As Bit : Status_output = 0
Dim Status_output2 As Bit : Status_output2 = 0

Dim Up_key_status As Bit : Up_key_status = 0


   If Erase_key = 0 Then
      Waitms 30
      If Erase_key = 0 Then
         Gosub Erase_eeprom
         Up_key_status = 1
      End If
   End If

Gosub Sound_start_menu

Config Watchdog = 256 : Stop Watchdog

'Gosub Eeprom_defult
Gosub Eeprom_load
Gosub Calculation
Gosub Show_variables

If Car >= Capacity Then Set Relay_input_panel

Do
   'Debounce Set_key , 0 , Erase_eeprom_cost , Sub
   If Up_key = 0 And Up_key_status = 0 Then
      Waitms 30
      If Up_key = 0 And Up_key_status = 0 Then
         Gosub Erase_eeprom_cost
         Up_key_status = 1
      End If
   End If
   If Up_key = 1 Then Up_key_status = 0

   If Set_key = 0 Then
      Waitms 30
      If Set_key = 0 Then
         Call Money_setting
      End If
   End If

   Gosub Input_check
   Gosub Output_check
Loop

End

'**********************************************
Sub Money_setting
Gosub Sound_start_menu
Cls : Lcd "Money=" ; Money ; "  "
Do
   If Up_key = 0 Then
      Waitms 30
      If Up_key = 0 Then
         Gosub Sound_key_pressing
         Incr Money                                         ': If Capacity = 31 Then Capacity = 0
         Gosub Calculation                                  ': Gosub Show_variables
         Locate 1 , 1 : Lcd "Money=" ; Money ; "  "
         Gosub Eeprom_save
         Waitms 200
      End If
   End If

   If Down_key = 0 Then
      Waitms 30
      If Down_key = 0 Then
         Gosub Sound_key_pressing
         Decr Money                                         ': If Capacity = 31 Then Capacity = 0
         Gosub Calculation                                  ': Gosub Show_variables
         Locate 1 , 1 : Lcd "Money=" ; Money ; "  "
         Gosub Eeprom_save
         Waitms 200
      End If
   End If

   If Set_key = 0 Then
      Waitms 30
      If Set_key = 0 Then
         Call Capacity_setting
      End If
   End If
Loop
End Sub

'**********************************************
Sub Capacity_setting
Gosub Sound_start_menu
Cls : Lcd "Capacity=" ; Capacity ; "  "
Do
   If Up_key = 0 Then
      Waitms 30
      If Up_key = 0 Then
         Gosub Sound_key_pressing
         Incr Capacity
         Gosub Calculation
         Locate 1 , 1 : Lcd "Capacity=" ; Capacity ; "  "
         Gosub Eeprom_save
         Waitms 250
      End If
   End If

   If Down_key = 0 Then
      Waitms 30
      If Down_key = 0 Then
         Gosub Sound_key_pressing
         Decr Capacity
         Gosub Calculation
         Locate 1 , 1 : Lcd "Capacity=" ; Capacity ; "  "
         Gosub Eeprom_save
         Waitms 250
      End If
   End If

   If Set_key = 0 Then
      Waitms 30
      If Set_key = 0 Then
        Popall
        Start Watchdog
      End If
   End If
Loop
End Sub

'**********************************************
Input_check:
   If Sensor1_input_panel = 1 And Sensor2_input_panel = 0 Then Status_input = 1
   If Sensor1_input_panel = 0 And Sensor2_input_panel = 1 Then Status_input = 0
   If Sensor2_input_panel = 1 And Status_input = 1 And Status_input2 = 0 Then
      Set Status_input2
      Set Led_input_panel
      If Car < Capacity Then
         Gosub Sound_input_car
      Else
         Gosub Sound_error
      End If
      Gosub Add_car
      Gosub Eeprom_save
      Gosub Calculation
      Gosub Show_variables
      Status_input = 0
   End If
   If Sensor1_input_panel = 0 Or Sensor2_input_panel = 0 Then Reset Led_input_panel
   If Sensor1_input_panel = 0 And Sensor2_input_panel = 0 Then Reset Status_input2
Return

'**********************************************
Output_check:
   If Sensor1_output_panel = 1 And Sensor2_output_panel = 0 Then Status_output = 1
   If Sensor1_output_panel = 0 And Sensor2_output_panel = 1 Then Status_output = 0
   If Sensor2_output_panel = 1 And Status_output = 1 And Status_output2 = 0 Then
      Set Status_output2
      Set Led_output_panel
      If Car = 0 Then
         Gosub Sound_error
      Else
         Gosub Sound_outpout_car
      End If
      Gosub Decr_car
      Gosub Eeprom_save
      Gosub Calculation
      Gosub Show_variables
      Status_output = 0
   End If
   If Sensor1_output_panel = 0 Or Sensor2_output_panel = 0 Then Reset Led_output_panel
   If Sensor1_output_panel = 0 And Sensor2_output_panel = 0 Then Reset Status_output2
Return

'**********************************************
Calculation:
   Free = Capacity - Car
   If Free > Capacity Then Free = Capacity
   If Free = 255 Then Free = 0
   Cost = Total * Money
Return

'**********************************************
Show_variables:
   Locate 1 , 1 : Lcd "Car=" ; Car ; "  "
   Locate 1 , 9 : Lcd "Free=" ; Free ; "  "
   Locate 2 , 1 : Lcd "All=" ; Total ; " "
   Locate 2 , 8 : Lcd "Cost=" ; Cost ; "    "
Return

'**********************************************
Add_car:
   If Car < Capacity Then
      Incr Total : Incr Car
   End If
   If Car >= Capacity Then Set Relay_input_panel
Return

'**********************************************
Decr_car:
   If Car > 0 Then Decr Car
   If Car < Capacity Then Reset Relay_input_panel
Return

'**********************************************
Eeprom_save:
   E_capacity = Capacity : Waitms 10
   E_money = Money : Waitms 10
   E_total = Total : Waitms 10
   E_car = Car : Waitms 10
   E_cost = Cost : Waitms 10
   E_free = Free : Waitms 10
Return

'**********************************************
Eeprom_load:
   Capacity = E_capacity : Waitms 10
   Money = E_money : Waitms 10
   Total = E_total : Waitms 10
   Car = E_car : Waitms 10
   Cost = E_cost : Waitms 10
   Free = E_free : Waitms 10
Return

'**********************************************
Erase_eeprom_cost:
   Sound Buzzer , 100 , 500
   Total = 0
   Cost = 0
   Gosub Eeprom_save
   Gosub Calculation
   Gosub Show_variables
Return

'**********************************************
Erase_eeprom:
   Sound Buzzer , 100 , 1000
   E_total = 0 : Waitms 10
   'Total = 0
   E_car = 0 : Waitms 10
   'Car = 0
   E_cost = 0 : Waitms 10
   'Cost = 0
   'Free = 0
Return

'**********************************************
Sound_start_menu:
   Sound Buzzer , 800 , 200
Return

'**********************************************
Sound_key_pressing:
   Sound Buzzer , 100 , 500
Return

'**********************************************
Sound_input_car:
   Sound Buzzer , 300 , 300
Return

'**********************************************
Sound_outpout_car:
   Sound Buzzer , 70 , 800
Return

'**********************************************
Sound_error:
   Sound Buzzer , 70 , 2000
Return

'**********************************************
Eeprom_defult:
   E_money = 2
   E_capacity = 15
Return