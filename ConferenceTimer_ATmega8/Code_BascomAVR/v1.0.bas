'Github Account: Github.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 8000000

Enable Interrupts
Config Timer2 = Timer , Prescale = 128 , Async = On

Enable Timer2
On Timer2 Sectic
Stop Timer2
'Start Timer2

Config Portd = Output
Config Pinc.0 = Output : S1 Alias Portc.0 : Set S1
Config Pinc.1 = Output : S2 Alias Portc.1 : Set S2
Config Pinc.2 = Output : S3 Alias Portc.2 : Set S3
Config Pinc.3 = Output : S4 Alias Portc.3 : Set S4
Config Pinc.4 = Output : S5 Alias Portc.4 : Set S5
Config Pinc.5 = Output : S6 Alias Portc.5 : Set S6

Digit_off Alias 0
Digit_on Alias 1

Config Debounce = 30
Config Pinb.0 = Input : Set Portb.0 : Up_key Alias Portb.0
Config Pinb.1 = Input : Set Portb.1 : Left_key Alias Portb.1
Config Pinb.2 = Input : Set Portb.2 : Downe_key Alias Portb.2
Config Pinb.3 = Input : Set Portb.3 : Right_key Alias Portb.3
Config Pinb.4 = Input : Set Portb.4 : Ok_key Alias Portb.4

Config Pind.7 = Output : Reset Portd.7 : Relay Alias Portd.7
Config Pinb.5 = Output : Reset Portb.5 : Sounder Alias Portb.5

Declare Sub Show_conference(byval A As Byte)
Declare Sub Show_second(byval A As Byte)
Declare Sub Show_min(byval A As Byte)

Dim Second_eram(10) As Eram Byte
Dim Min_eram(10) As Eram Byte

Dim Second(10) As Byte
Dim Min_(10) As Byte

Dim I As Byte
 Dim Z As Byte

For I = 0 To 10
   Second(i) = 0
   Min_(i) = 0
Next I

Dim Conference As Byte : Conference = 0

Dim Time_refresh As Byte : Time_refresh = 1
Dim Segment_data As Byte

'Min_(conference) = 12 : Second(conference) = 34

   Dim S_ As String * 6
   Dim Z_ As String * 2
   Dim Run As Bit : Run = 0

If Pinb.4 = 0 Then Gosub Erase_eeprom
Gosub Load_of_eeprom
'Start Timer2
Main:
Sound Sounder , 300 , 300

Do
   Debounce Pinb.4 , 0 , Select_conference , Sub
   Debounce Pinb.2 , 0 , Start_conference , Sub
   Debounce Pinb.0 , 0 , Pause_conference , Sub
   Debounce Pinb.1 , 0 , Min_set , Sub
   Debounce Pinb.3 , 0 , Second_set , Sub

   Gosub Relay_drive
   'Conference = 10 : Min_(1) = 56 :second(1)=23: Gosub Convert
   'Gosub Convert
   Call Show_conference(conference)
   If Conference > 0 Then
      Call Show_second(second(conference))
      Call Show_min(min_(conference))
   End If
Loop

End

'*******************************************    Show
Sub Show_conference(byval A As Byte)
   'Dim Z As Byte
   'Dim I As Byte
   I = 0
   Do
      Incr I
      Z = A Mod 10
      Segment_data = Lookup(z , Cathod_convert)
      Portd.0 = Segment_data.0 : Portd.1 = Segment_data.1 : Portd.2 = Segment_data.2 : Portd.3 = Segment_data.3
      Portd.4 = Segment_data.4 : Portd.5 = Segment_data.5 : Portd.6 = Segment_data.6       ': Portd.7 = Segment_data.7
      Select Case I
         Case 1:
            S5 = Digit_on : Waitms Time_refresh : S5 = Digit_off
         Case 2:
            S6 = Digit_on : Waitms Time_refresh : S6 = Digit_off
      End Select
      A = A \ 10
      If I = 2 Then
         I = 0 : Exit Sub
      End If
   Loop
End Sub

'*******************************************    Show
Sub Show_second(byval A As Byte)
   'Dim Z As Byte
   'Dim I As Byte
   I = 0
   Do
      Incr I
      Z = A Mod 10
      Segment_data = Lookup(z , Cathod_convert)
      Portd.0 = Segment_data.0 : Portd.1 = Segment_data.1 : Portd.2 = Segment_data.2 : Portd.3 = Segment_data.3
      Portd.4 = Segment_data.4 : Portd.5 = Segment_data.5 : Portd.6 = Segment_data.6       ': Portd.7 = Segment_data.7
      Select Case I
         Case 1:
            S1 = Digit_on : Waitms Time_refresh : S1 = Digit_off
         Case 2:
            S2 = Digit_on : Waitms Time_refresh : S2 = Digit_off
      End Select
      A = A \ 10
      If I = 2 Then
         I = 0 : Exit Sub
      End If
   Loop
End Sub

'*******************************************    Show
Sub Show_min(byval A As Byte)
   'Dim Z As Byte
   'Dim I As Byte
   I = 0
   Do
      Incr I
      Z = A Mod 10
      Segment_data = Lookup(z , Cathod_convert)
      Portd.0 = Segment_data.0 : Portd.1 = Segment_data.1 : Portd.2 = Segment_data.2 : Portd.3 = Segment_data.3
      Portd.4 = Segment_data.4 : Portd.5 = Segment_data.5 : Portd.6 = Segment_data.6       ': Portd.7 = Segment_data.7
      Select Case I
         Case 1:
            S3 = Digit_on : Waitms Time_refresh : S3 = Digit_off
         Case 2:
            S4 = Digit_on : Waitms Time_refresh : S4 = Digit_off
      End Select
      A = A \ 10
      If I = 2 Then
         I = 0 : Exit Sub
      End If
   Loop
End Sub

'*******************************************
Sectic:
   Timer2 = 0
   'Start Timer2
   'Stop Timer2
   Decr Second(conference)
   If Min_(conference) = 0 And Second(conference) = 0 Then
       Stop Timer2 : Gosub Save_to_eeprom : Run = 0
       Sound Sounder , 200 , 200 : Sound Sounder , 100 , 300       ': Goto Main
      'Gosub Stop_conference
   End If

   If Second(conference) = 255 Then
      'If Min_(conference) = 0 And Second(conference) = 255 Then
         'Gosub Stop_conference
         'Stop Timer2
         'Min_(conference) = 00 : Second(conference) = 00
         'Goto Main
         'return
      'End If
      Second(conference) = 59 : Decr Min_(conference)
   End If
   'Start Timer2
Return

'*******************************************
Start_conference:
   If Conference > 0 Then
   If Second(conference) > 0 Or Min_(conference) > 0 Then
      Run = 1 : Start Timer2 : Gosub Sectic
      Sound Sounder , 300 , 300
   End If
   End If
Return

'*******************************************
Pause_conference:
   If Conference > 0 Then
   If Second(conference) > 0 Or Min_(conference) > 0 Then
      Run = 0 : Stop Timer2 : Timer0 = 0
      Sound Sounder , 300 , 300
      Gosub Save_to_eeprom
   End If
   End If
Return

'*******************************************
Select_conference:
   'Stop Timer2
   If Run = 0 Then
      Incr Conference : If Conference = 11 Then Conference = 0
      Sound Sounder , 300 , 300
   End If
Return

'*******************************************
Stop_conference:
   Stop Timer2
   Min_(conference) = 0 : Second(conference) = 0
   Sound Sounder , 100 , 200 : Sound Sounder , 100 , 200
   Goto Main
   'Do
      'Call Show_conference(conference)
      'Call Show_second(0)
      'Call Show_min(0)
   'Loop
Return

'*******************************************
Min_set:
   If Run = 0 And Conference > 0 Then
      Sound Sounder , 300 , 300
      Left_main:
      Do
         Debounce Pinb.0 , 0 , Incr_min
         Debounce Pinb.2 , 0 , Decr_min
         Debounce Pinb.4 , 0 , Main
         Call Show_conference(conference)
         'Call Show_second(second(conference))
         Call Show_min(min_(conference))
      Loop
      Incr_min:
      Sound Sounder , 300 , 300
      Incr Min_(conference)
      If Min_(conference) = 60 Then Min_(conference) = 0
      Gosub Save_to_eeprom
      Goto Left_main
      Decr_min:
      Sound Sounder , 300 , 300
      Decr Min_(conference)
      If Min_(conference) = 255 Then Min_(conference) = 59
      Gosub Save_to_eeprom
      Goto Left_main
   End If
Return

'*******************************************
Second_set:
   If Run = 0 And Conference > 0 Then
      Sound Sounder , 300 , 300
      Right_main:
      Do
         Debounce Pinb.0 , 0 , Incr_second
         Debounce Pinb.2 , 0 , Decr_second
         Debounce Pinb.4 , 0 , Main
         Call Show_conference(conference)
         Call Show_second(second(conference))
         'Call Show_min(min_(conference))
      Loop
      Incr_second:
      Sound Sounder , 300 , 300
      Incr Second(conference)
      If Second(conference) = 60 Then Second(conference) = 0
      Gosub Save_to_eeprom
      Goto Right_main
      Decr_second:
      Sound Sounder , 300 , 300
      Decr Second(conference)
      If Second(conference) = 255 Then Second(conference) = 59
      Gosub Save_to_eeprom
      Goto Right_main
   End If
Return

'*******************************************
Relay_drive:
   If Conference > 0 And Run = 1 Then
      If Min_(conference) = 0 And Second(conference) = 0 Then
         Reset Relay
      Else
         Set Relay
      End If
   Else
      Reset Relay
   End If
Return

'*******************************************
Save_to_eeprom:
   For I = 1 To 10
      Second_eram(i) = Second(i) : Waitms 10
      Min_eram(i) = Min_(i) : Waitms 10
   Next I
   I = 0
Return

'*******************************************
Load_of_eeprom:
   For I = 1 To 10
      Second(i) = Second_eram(i)
      Min_(i) = Min_eram(i)
   Next I
   I = 0
Return

'*******************************************
Erase_eeprom:
   For I = 1 To 10
      Second_eram(i) = 0
      Min_eram(i) = 0
   Next I
   Sound Sounder , 200 , 500
   I = 0
Return

'***************************************************     Cathod_convert
Cathod_convert:
Data 63 , 6 , 91 , 79 , 102 , 109 , 125 , 7 , 127 , 111 , 64 , 128 , 56
'     0    1   2    3    4     5     6     7   8     9     -    dp    L

'***************************************************     Annode_convert
Annode_convert:
Data 192 , 249 , 164 , 176 , 153 , 146 , 130 , 248 , 128 , 144 , 191 , 127 , 199