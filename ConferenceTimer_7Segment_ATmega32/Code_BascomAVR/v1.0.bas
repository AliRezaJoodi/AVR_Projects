'Github Account: Github.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 11059200
$crystal = 8000000

Config Portd.0 = Output : Portd.0 = 1 : S1 Alias Portd.0
Config Portd.7 = Output : Portd.7 = 1 : S2 Alias Portd.7
Config Portc.4 = Output : Portc.4 = 1 : S3 Alias Portc.4
Config Portc.5 = Output : Portc.5 = 1 : S4 Alias Portc.5
Config Portc.2 = Output : Portc.2 = 1 : S5 Alias Portc.2
Config Portd.1 = Output : Portd.1 = 1 : S6 Alias Portd.1

Config Portc.1 = Output : Portc.1 = 0 : Relay Alias Portc.1
Config Portc.0 = Output : Portc.0 = 0 : Sounder Alias Portc.0

Config Porta = Output

Config Debounce = 30
Config Pind.2 = Input : Set Portd.2 : Up_key Alias Pind.2
Config Pind.6 = Input : Set Portd.6 : Left_key Alias Pind.6
Config Pind.4 = Input : Set Portd.4 : Downe_key Alias Pind.4
Config Pind.3 = Input : Set Portd.3 : Right_key Alias Pind.3
Config Pind.5 = Input : Set Portd.5 : Ok_key Alias Pind.5

Enable Interrupts
Config Timer2 = Timer , Prescale = 128 , Async = On
Enable Timer2
On Timer2 Sectic
Stop Timer2
'Start Timer2

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

Dim Time_refresh As Byte : Time_refresh = 3
Dim Segment_data As Byte

   Dim S_ As String * 6
   Dim Z_ As String * 2
   Dim Run As Bit : Run = 0

If Ok_key = 0 Then
   Waitms 30
   If Ok_key = 0 Then Gosub Erase_eeprom
End If
Gosub Load_of_eeprom
'Start Timer2

Main:
Sound Sounder , 300 , 300

Do
   Debounce Ok_key , 0 , Select_conference , Sub
   Debounce Downe_key , 0 , Start_conference , Sub
   Debounce Up_key , 0 , Pause_conference , Sub
   Debounce Left_key , 0 , Min_set , Sub
   Debounce Right_key , 0 , Second_set , Sub

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
      'Segment_data = Lookup(z , Cathod_convert)
      'Portd.0 = Segment_data.0 : Portd.1 = Segment_data.1 : Portd.2 = Segment_data.2 : Portd.3 = Segment_data.3
      'Portd.4 = Segment_data.4 : Portd.5 = Segment_data.5 : Portd.6 = Segment_data.6       ': Portd.7 = Segment_data.7
      Select Case I
         Case 1:
            Porta = Lookup(z , Convert_odd)
            Reset S5 : Waitms Time_refresh : Set S5 : Porta = 0
         Case 2:
            Porta = Lookup(z , Convert_even)
            Reset S6 : Waitms Time_refresh : Set S6
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
      'Segment_data = Lookup(z , Cathod_convert)
      'Portd.0 = Segment_data.0 : Portd.1 = Segment_data.1 : Portd.2 = Segment_data.2 : Portd.3 = Segment_data.3
      'Portd.4 = Segment_data.4 : Portd.5 = Segment_data.5 : Portd.6 = Segment_data.6       ': Portd.7 = Segment_data.7
      Select Case I
         Case 1:
            Porta = Lookup(z , Convert_odd)
            Reset S1 : Waitms Time_refresh : Set S1 : Porta = 0
         Case 2:
            Porta = Lookup(z , Convert_even)
            Reset S2 : Waitms Time_refresh : Set S2 : Porta = 0
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
      'Segment_data = Lookup(z , Cathod_convert)
      'Portd.0 = Segment_data.0 : Portd.1 = Segment_data.1 : Portd.2 = Segment_data.2 : Portd.3 = Segment_data.3
      'Portd.4 = Segment_data.4 : Portd.5 = Segment_data.5 : Portd.6 = Segment_data.6       ': Portd.7 = Segment_data.7
      Select Case I
         Case 1:
            Porta = Lookup(z , Convert_odd)
            Reset S3 : Waitms Time_refresh : Set S3 : Porta = 0
         Case 2:
            Porta = Lookup(z , Convert_even)
            Reset S4 : Waitms Time_refresh : Set S4 : Porta = 0
      End Select
      A = A \ 10
      If I = 2 Then
         I = 0 : Exit Sub
      End If
   Loop
End Sub

'*******************************************
Sectic:
   'Timer2 = 0
   'Start Timer2
   'Stop Timer2
   If Second(conference) > 0 Then
      Decr Second(conference)
   Else
      If Min_(conference) > 0 Then
         Decr Min_(conference)
         Second(conference) = 59
      End If
   End If

   'If Second(conference) = 255 Then
      'Second(conference) = 59 : Decr Min_(conference)
   'End If

   If Min_(conference) = 0 And Second(conference) = 0 Then
       Stop Timer2 : Gosub Save_to_eeprom : Run = 0
       Sound Sounder , 200 , 200 : Sound Sounder , 100 , 300       ': Goto Main
      'Gosub Stop_conference
   End If
   'Start Timer2
Return

'*******************************************
Start_conference:
   If Conference > 0 Then
   If Second(conference) > 0 Or Min_(conference) > 0 Then
      Run = 1 : Start Timer2 : Gosub Sectic
      Enable Timer2 : Enable Interrupts
      Sound Sounder , 300 , 300
   End If
   End If
Return

'*******************************************
Pause_conference:
   If Conference > 0 Then
   'If Second(conference) > 0 Or Min_(conference) > 0 Then
      Run = 0 : Stop Timer2
      Disable Timer2 : Disable Interrupts
      'Disable Timer0
      Sound Sounder , 300 , 300
      Gosub Save_to_eeprom
   'End If
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
         Debounce Up_key , 0 , Incr_min
         Debounce Downe_key , 0 , Decr_min
         Debounce Ok_key , 0 , Main
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
         Debounce Up_key , 0 , Incr_second
         Debounce Downe_key , 0 , Decr_second
         Debounce Ok_key , 0 , Main
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
   If Conference > 0 Then
      If Min_(conference) = 0 And Second(conference) = 0 Then Reset Relay
         Reset Relay
      If Run = 1 Then
         Set Relay
      Else
         Reset Relay
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

'***************************************************     Annode_convert_1
Convert_even:
Data 119 , 17 , 107 , 59 , 29 , 62 , 126 , 19 , 127 , 63 , 8
'     0     1     2    3    4    5     6    7     8     9   -

'***************************************************     Annode_convert_2
Convert_odd:
Data 126 , 24 , 109 , 61 , 27 , 55 , 119 , 28 , 127 , 63 , 1
'     0     1    2     3    4    5     6    7    8     9    -