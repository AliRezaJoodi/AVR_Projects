'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portb.0 = Input : Portb.0 = 1 : Key_start Alias Pinb.0
Config Portb.1 = Input : Portb.1 = 1 : Key_stop Alias Pinb.1
Config Portb.2 = Input : Portb.2 = 1 : Key_reset Alias Pinb.2


Config Timer1 = Timer , Prescale = 64                       'PRESCALE= 1|8|64|256|1024
Enable Interrupts
Enable Timer1
On Timer1 Chronometer
Stop Timer1

Dim Count(3) As Byte
Dim I As Byte
Dim Status As Word

Gosub Display_time

Do
   Debounce Key_start , 0 , Chronometer_start , Sub
   Debounce Key_stop , 0 , Chronometer_stop , Sub
   Debounce Key_reset , 0 , Chronometer_reset , Sub

   If Status <> Count(1) Then
      Status = Count(1)
      If Count(1) > 99 Then
         Count(1) = 0
         Incr Count(2)
         If Count(2) > 59 Then
            Count(2) = 0
            Incr Count(3)
         End If
      End If
      Gosub Display_time
   End If

Loop

End

'****************************************
Display_time:
   Dim Txt(3) As String * 3

   Txt(1) = Str(count(1)) : Txt(1) = Format(txt(1) , "00")
   Txt(2) = Str(count(2)) : Txt(2) = Format(txt(2) , "00")
   Txt(3) = Str(count(3)) : Txt(3) = Format(txt(i) , "00")

   Locate 1 , 1 : Lcd Txt(3) ; ":" ; Txt(2) ; ":" ; Txt(1) ; "  "
   Locate 2 , 1 : Lcd "Chronometer"
Return

'****************************************
Chronometer_start:
   Start Timer1
Return

'****************************************
Chronometer_stop:
   Stop Timer1
Return

'****************************************
Chronometer_reset:
   Stop Timer1 : Timer1 = 64286
   Count(1) = 0
   Count(2) = 0
   Count(3) = 0
   Gosub Display_time
Return

'****************************************
Chronometer:
   Timer1 = 64286
   Incr Count(1)
Return