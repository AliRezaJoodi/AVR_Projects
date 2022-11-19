'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
'$hwstack = 64
'$swstack = 64
'$framesize = 64

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts

Config Portb.1 = Input : Portb.1 = 1
Config Timer1 = Counter , Edge = Falling
Enable Timer1
Counter1 = 0
On Ovf1 Management_pulse

Config Timer0 = Timer , Prescale = 64
Enable Timer0
On Ovf0 Management_time

Dim Frequency As Long , I_time As Long , I_pulse As Byte
Dim Status As Long

Gosub Display_loading

Start Timer0 : Start Timer1

Do
   If Frequency <> Status Then
      Gosub Display_value
      Status = Frequency
   End If
Loop

End

'********************************
Management_pulse:
   Incr I_pulse
Return

'********************************
Management_time:
   Incr I_time
   If I_time = 675 Then
      Stop Timer0 : Stop Timer1
      Frequency = I_pulse * 65536 : Frequency = Frequency + Counter1
      Counter1 = 0 : I_pulse = 0 : Timer0 = 0 : I_time = 0
      Start Timer0 : Start Timer1
   End If
Return

'**********************************************
Display_value:
   Cls
   Locate 1 , 1 : Lcd "F(HZ): " ; Frequency ; "   "
   Locate 2 , 1 : Lcd "Frequency Meter"
Return

'**********************************************
Display_loading:
   Cls
   Locate 1 , 1 : Lcd "Loading ..."
   Locate 2 , 1 : Lcd "Frequency Meter"
Return