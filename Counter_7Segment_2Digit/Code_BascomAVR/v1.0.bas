'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 1000000

Active Alias 1
Inactive Alias 0

S_a Alias Portd.0 : Config S_a = Output : S_a = 1
S_b Alias Portd.1 : Config S_b = Output : S_b = 1
S_c Alias Portd.2 : Config S_c = Output : S_c = 1
S_d Alias Portd.3 : Config S_d = Output : S_d = 1
S_e Alias Portd.4 : Config S_e = Output : S_e = 1
S_f Alias Portd.5 : Config S_f = Output : S_f = 1
S_g Alias Portd.6 : Config S_g = Output : S_g = 1
S_dp Alias Portd.7 : Config S_dp = Output : S_dp = 1

S1 Alias Portb.0 : Config S1 = Output : S1 = Inactive
S2 Alias Portb.1 : Config S2 = Output : S2 = Inactive

Config Debounce = 30
Input_counter Alias Pinb.3 : Config Portb.3 = Input
Button_reset Alias Pinb.2 : Config Portb.2 = Input : Portb.2 = 1

Dim Value As Byte : Value = 0
Dim Value_eeprom As Eram Byte

Dim Value_copy As Byte
Dim Digit As Byte
Dim I As Byte
Declare Sub Show()
Value_copy = Value

'Gosub Eeprom_defoult
Gosub Eeprom_load

Do
   Call Show() : Waitus 350
   Debounce Input_counter , 1 , Value_incr , Sub.
   Debounce Button_reset , 0 , Value_reset , Sub
Loop

End

'**********************************
Value_incr:
   Incr Value : If Value > 99 Then Value = 0
   Gosub Eeprom_save
   Gosub Dispaly_update
Return

'**********************************
Value_reset:
   Value = 0
   Gosub Eeprom_save
   Gosub Dispaly_update
Return

'**********************************
Eeprom_defoult:
   Value_eeprom = 0 : Waitms 10
Return

'**********************************
Eeprom_load:
   Value = Value_eeprom
Return

'**********************************
Eeprom_save:
   Value_eeprom = Value : Waitms 10
Return

'**********************************
Sub Show()
   Dim Buffer As Byte

   S1 = Inactive : S2 = Inactive
   Digit = Value_copy Mod 10
   Buffer = Lookup(digit , Data_7segment) : Buffer = Not Buffer
   S_a = Buffer.0 : S_b = Buffer.1 : S_c = Buffer.2 : S_d = Buffer.3 : S_e = Buffer.4 : S_f = Buffer.5 : S_g = Buffer.6 : S_dp = Buffer.7

   Incr I
   Select Case I
      Case 1:
         S1 = Active
      Case 2:
         S2 = Active
   End Select

   Value_copy = Value_copy \ 10
   If Value_copy = 0 Then
      Gosub Dispaly_update
   End If
End Sub

'**********************************
Dispaly_update:
   I = 0 : Value_copy = Value
Return

'___________________________
'0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
'A , B , C , D , E , F,
' - , Dp
Data_7segment:
Data &B00111111 , &B00000110 , &B01011011 , &B01001111 , &B01100110 , &B01101101 , &B01111101 , &B00000111 , &B01111111 , &B01101111 _
  , &B01110111 , &B01111100 , &B00111001 , &B01011110 , &B01111001 , &B01110001 _
  , &B01000000 , &B10000000