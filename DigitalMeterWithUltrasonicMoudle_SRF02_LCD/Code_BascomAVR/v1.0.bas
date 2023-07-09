'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 11059200
'$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Scl = Portc.0
Config Sda = Portc.1
Const Rs02w = &HE0
Const Rs02r = &HE1

Enable Interrupts
Config Timer2 = Timer , Prescale = 32
Enable Ovf2
On Ovf2 Auto_meters
Stop Timer2
Timer2 = 0

Config Portd.3 = Input : Portd.3 = 1 : Up_key Alias Pind.3
Config Portd.4 = Input : Portd.4 = 1 : Set_key Alias Pind.4
Config Portd.5 = Input : Portd.5 = 1 : Down_key Alias Pind.5
Config Portd.2 = Input : Portd.2 = 1 : Left_key Alias Pind.2
Config Portd.6 = Input : Portd.6 = 1 : Right_key Alias Pind.6

Config Portb.0 = Output : Portb.0 = 0 : Sound_pin Alias Portb.0

Dim Lentgh_msb As Byte : Lentgh_msb = 0
Dim Lentgh_lsb As Byte : Lentgh_lsb = 0
Dim Lentgh As Integer : Lentgh = 0
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
         Gosub Get_srf02
         Gosub Show_lentgh
      End If
   End If
   If Left_key = 1 Then State_left_key = 0

   If Set_key = 0 And State_set_key = 0 Then
      Waitms 30
      If Set_key = 0 And State_set_key = 0 Then
         State_set_key = 1
         Gosub Sound_pressing
         Gosub Get_srf02
         Gosub Show_lentgh
      End If
   End If
   If Set_key = 1 Then State_set_key = 0

   If Right_key = 0 And State_right_key = 0 Then
      Waitms 30
      If Right_key = 0 And State_right_key = 0 Then
         State_right_key = 1
         Gosub Sound_pressing
         Gosub Get_srf02
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
'/////////////////////////////////////////////////     End Program

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
   Locate 2 , 1 : Lcd "20CM - 600CM"
   Wait 2 : Locate 2 , 1 : Lcd "Press Key       "
Return

'*****************************************
Auto_meters:
   Incr I
   If I > 675 Then
      Stop Timer2
      Gosub Get_srf02
      Gosub Show_lentgh
      I = 0 : Start Timer2
   End If
Return

'*****************************************
Get_srf02:
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 0
   I2cwbyte &H51
   I2cstop : Waitms T
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 2
   I2cstop : Waitms T
   I2cstart
   I2cwbyte Rs02r
   I2crbyte Lentgh_msb , Ack
   I2crbyte Lentgh_lsb , Nack
   I2cstop : Waitms T
   Lentgh = Makeint(lentgh_lsb , Lentgh_msb)
Return

'*****************************************
Show_lentgh:
   Cls
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