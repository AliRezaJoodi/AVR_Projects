'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 8000000

Config Clock = Soft , Gosub = Sectic : Time$ = "23:59:50"
Enable Interrupts

Declare Sub Display_secend
Declare Sub Display_minits
Declare Sub Display_hour
Declare Sub Clock

Config Debounce = 30
Ddrc.0 = 0 : Portc.0 = 1 : Button_mode Alias Pinc.0
Ddrc.1 = 0 : Portc.1 = 1 : Button_min Alias Pinc.1
Ddrc.2 = 0 : Portc.2 = 1 : Button_hour Alias Pinc.2

Active_digit Alias 1
Deactive_digit Alias 0

Active_segment Alias 0
Deactive_segment Alias 1

S1 Alias Portb.4 : Config S1 = Output : S1 = Deactive_digit
S2 Alias Portb.3 : Config S2 = Output : S2 = Deactive_digit
M1 Alias Portb.4 : Config M1 = Output : M1 = Deactive_digit
M2 Alias Portb.3 : Config M2 = Output : M2 = Deactive_digit
H1 Alias Portb.2 : Config H1 = Output : H1 = Deactive_digit
H2 Alias Portb.1 : Config H2 = Output : H2 = Deactive_digit

Config Porta = Output
Led Alias Porta.7 : Config Led = Output : Led = Active_segment

Dim A As Byte
Dim Value As Byte
Dim Buffer As Byte
Dim Page As Byte : Page = 0
Dim I As Integer
Dim Task_blink As Byte

Do
   Gosub Display_blink

   If Page = 0 Then
      Call Display_minits
      Call Display_hour
   Else
      Call Display_secend
   End If

   Debounce Button_mode , 0 , Set_page , Sub
   If Page = 0 Then
      Debounce Button_min , 0 , Set_min , Sub
      Debounce Button_hour , 0 , Set_hour , Sub
   End If
Loop

End

'*****************************************
Display_blink:
   If Task_blink = 1 Then
      Task_blink = 0
      Led = Active_segment
      I = 0
   End If

   Incr I
   If I > 300 Then
      Led = Deactive_segment
   End If
Return

'*****************************************
Sectic:
   Task_blink = 1
Return

'**************************************************
Turn_off_display:
   S1 = Deactive_digit
   S2 = Deactive_digit
   M1 = Deactive_digit
   M2 = Deactive_digit
   H1 = Deactive_digit
   H2 = Deactive_digit
Return

'**************************************************
Drive_segment:
   Porta.0 = Buffer.0
   Porta.1 = Buffer.1
   Porta.2 = Buffer.2
   Porta.3 = Buffer.3
   Porta.4 = Buffer.4
   Porta.5 = Buffer.5
   Porta.6 = Buffer.6
   'Porta.7 = Buffer.7
Return

'**************************************************
Display_secend:
   Value = _sec Mod 10
   Buffer = Lookup(value , Data_7segment) : Buffer = Not Buffer
   Gosub Drive_segment
   Set S1
   Waitms 1 : Gosub Turn_off_display

   Value = _sec \ 10
   Value = Value Mod 10
   Buffer = Lookup(value , Data_7segment) : Buffer = Not Buffer
   Gosub Drive_segment
   Set S2
   Waitms 1 : Gosub Turn_off_display
Return

'**************************************************
Display_minits:
   Value = _min Mod 10
   Buffer = Lookup(value , Data_7segment) : Buffer = Not Buffer
   Gosub Drive_segment
   Set M1
   Waitms 1 : Gosub Turn_off_display

   Value = _min \ 10
   Value = Value Mod 10
   Buffer = Lookup(value , Data_7segment) : Buffer = Not Buffer
   Gosub Drive_segment
   Set M2
   Waitms 1 : Gosub Turn_off_display
Return

'**************************************************
Display_hour:
   Value = _hour Mod 10
   Buffer = Lookup(value , Data_7segment) : Buffer = Not Buffer
   Gosub Drive_segment
   Set H1
   Waitms 1 : Gosub Turn_off_display

   Value = _hour \ 10
   Value = Value Mod 10
   Buffer = Lookup(value , Data_7segment) : Buffer = Not Buffer
   Gosub Drive_segment
   Set H2
   Waitms 1 : Gosub Turn_off_display
Return

'**************************************************
Set_page:
   Toggle Page
Return

'**************************************************
Set_min:
   Incr _min
   If _min > 59 Then
      _min = 0
   End If
   _sec = 0
Return

'**************************************************
Set_hour:
   Incr _hour
   If _hour > 23 Then
      _hour = 0
   End If
   _sec = 0
Return

'___________________________
'0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
'A , B , C , D , E , F,
' - , Dp
'Null
Data_7segment:
Data &B00111111 , &B00000110 , &B01011011 , &B01001111 , &B01100110 , &B01101101 , &B01111101 , &B00000111 , &B01111111 , &B01101111
Data &B01110111 , &B01111100 , &B00111001 , &B01011110 , &B01111001 , &B01110001
Data &B01000000 , &B10000000
Data &B00000000