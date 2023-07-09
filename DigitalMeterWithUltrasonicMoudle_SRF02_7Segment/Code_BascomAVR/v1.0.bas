'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 11059200

Config Scl = Portd.7
Config Sda = Portc.0
Const Rs02w = &HE0
Const Rs02r = &HE1

Config Porta.5 = Output

Config Debounce = 30
Config Portc.5 = Input : Portc.5 = 1 : Button Alias Pinc.5

S1 Alias Portc.4 : Config S1 = Output : Set S1
S2 Alias Portc.2 : Config Portc.2 = Output : Set S2
S3 Alias Portc.1 : Config Portc.1 = Output : Set S3
S4 Alias Portc.3 : Config Portc.3 = Output : Set S4
A Alias Portc.6 : Config Portc.6 = Output : Reset A
B Alias Porta.6 : Config Porta.6 = Output : Reset B
C Alias Porta.7 : Config Porta.7 = Output : Reset C
D Alias Portc.7 : Config Portc.7 = Output : Reset D

Buzzer Alias Portd.2 : Config Buzzer = Output : Reset Buzzer

Dim I As Byte
Dim T As Byte : T = 2
Dim Lentgh_msb As Byte
Dim Lentgh_lsb As Byte
Dim Lentgh As Integer : Lentgh = 3210

Declare Sub Show(byval Lentgh As Integer)

Do
   Debounce Button , 0 , Get_srf02 , Sub
   Call Show(lentgh)
Loop

End

'****************************************
Get_srf02:
   Set Buzzer
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 0
   I2cwbyte &H51
   I2cstop : Waitms 70
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 2
   I2cstop : Waitms 70
   I2cstart
   I2cwbyte Rs02r
   I2crbyte Lentgh_msb , Ack
   I2crbyte Lentgh_lsb , Nack
   I2cstop : Waitms 70
   Lentgh = Makeint(lentgh_lsb , Lentgh_msb)
   Reset Buzzer
Return

'****************************************
Sub Show(lentgh As Integer)
Local Lentgh_mod As Integer
'Local I As Byte
'Local T As Byte : T = 2
Do
   Incr I
   Lentgh_mod = Lentgh Mod 10
   A = Lentgh_mod.0 : B = Lentgh_mod.1 : C = Lentgh_mod.2 : D = Lentgh_mod.3
   Select Case I
      Case 1:
         Reset S4 : Waitms T : Set S4
      Case 2:
         Reset S3 : Waitms T : Set S3
      Case 3:
         Reset S2 : Waitms T : Set S2
      Case 4:
         Reset S1 : Waitms T : Set S1
   End Select
   Lentgh = Lentgh \ 10
   If Lentgh = 0 Then
      I = 0
      Exit Sub
   End If
Loop
End Sub