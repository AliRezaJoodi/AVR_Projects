'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 11059200
'$crystal = 4000000

Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Timer2 = Timer , Prescale = 32
Enable Ovf2
On Ovf2 Auto_meters
Stop Timer2
Timer2 = 0

Config Portc.0 = Output : Portc.0 = 0 : Srf05_trig Alias Portc.0
Config Portc.1 = Input : Portc.1 = 1 : Srf05_echo Alias Pinc.1

Config Portd.3 = Input : Portd.3 = 1 : Up_key Alias Pind.3
Config Portd.4 = Input : Portd.4 = 1 : Set_key Alias Pind.4
Config Portd.5 = Input : Portd.5 = 1 : Down_key Alias Pind.5
Config Portd.2 = Input : Portd.2 = 1 : Left_key Alias Pind.2
Config Portd.6 = Input : Portd.6 = 1 : Right_key Alias Pind.6

Config Portb.0 = Output : Portb.0 = 0 : Sound_pin Alias Portb.0

Dim D As Word : D = 0
Dim Lentgh_msb As Byte : Lentgh_msb = 0
Dim Lentgh_lsb As Byte : Lentgh_lsb = 0
Dim Lentgh As Long : Lentgh = 0
Dim T As Byte : T = 70
Dim I As Word : I = 0

Dim State_up_key As Bit : State_up_key = 0
Dim State_set_key As Bit : State_set_key = 0
Dim State_down_key As Bit : State_down_key = 0
Dim State_left_key As Bit : State_left_key = 0
Dim State_right_key As Bit : State_right_key = 0

Gosub Sound_menu
Gosub Display_start_text

Do
   If Left_key = 0 And State_left_key = 0 Then
      Waitms 30
      If Left_key = 0 And State_left_key = 0 Then
         State_left_key = 1
         Gosub Sound_pressing
         Gosub Get_srf05
         Gosub Show_lentgh
      End If
   End If
   If Left_key = 1 Then State_left_key = 0

   If Set_key = 0 And State_set_key = 0 Then
      Waitms 30
      If Set_key = 0 And State_set_key = 0 Then
         State_set_key = 1
         Gosub Sound_pressing
         Gosub Get_srf05
         Gosub Show_lentgh
      End If
   End If
   If Set_key = 1 Then State_set_key = 0

   If Right_key = 0 And State_right_key = 0 Then
      Waitms 30
      If Right_key = 0 And State_right_key = 0 Then
         State_right_key = 1
         Gosub Sound_pressing
         Gosub Get_srf05
         Gosub Show_lentgh
      End If
   End If
   If Right_key = 1 Then State_right_key = 0

   If Down_key = 0 And State_down_key = 0 Then
      Waitms 30
      If Down_key = 0 And State_down_key = 0 Then
         State_down_key = 1
         Gosub Sound_menu
         Gosub Setting_manual
      End If
   End If
   If Down_key = 1 Then State_down_key = 0

   If Up_key = 0 And State_up_key = 0 Then
      Waitms 30
      If Up_key = 0 And State_up_key = 0 Then
         State_up_key = 1
         Gosub Sound_menu
         Gosub Setting_auto
      End If
   End If
   If Up_key = 1 Then State_up_key = 0
Loop

End

'*****************************************
Setting_auto:
   I = 0 : Start Timer2
Return

'*****************************************
Setting_manual:
   Stop Timer2 : I = 0
Return

'*****************************************
Display_start_text:
   Cls
   Locate 1 , 1 : Lcd "Digital Meters:"
   Locate 2 , 1 : Lcd "3CM - 400CM"
   Wait 2 : Locate 2 , 1 : Lcd "Press Key       "
Return

'*****************************************
Auto_meters:
   Incr I
   If I > 675 Then
      Stop Timer2
      Gosub Get_srf05
      Gosub Show_lentgh
      I = 0 : Start Timer2
   End If
Return

'*****************************************
Get_srf05:
   Pulseout Portc , 0 , 25
   Pulsein D , Pinc , 1 , 1
   Lentgh = D * 20 : Lentgh = Lentgh / 113
Return

'*****************************************
Show_lentgh:
   Cls
   'Locate 1 , 1 : Lcd "D= " ; D
   Locate 1 , 1 : Lcd "Digital Meters:"
   Locate 2 , 1 : Lcd "Lentgh= " ; Lentgh ; " CM"
Return

'*****************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'*****************************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'*****************************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return