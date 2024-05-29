'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 8000000

Enable Interrupts
Config Timer1 = Timer , Prescale = 1                        'PRESCALE= 1|8|64|256|1024
On Timer1 Lable
Enable Timer1                                               ' Or  Enable Ovf0
Stop Timer1

Config Portc.5 = Output : Portc.5 = 1 : S1 Alias Portc.5

Config Portc.0 = Output : Portc.0 = 0 : 7segment_a Alias Portc.0
Config Portc.1 = Output : Portc.1 = 0 : 7segment_F Alias Portc.1
Config Portc.2 = Output : Portc.2 = 0 : 7segment_G Alias Portc.2
Config Portc.3 = Output : Portc.3 = 0 : 7segment_B Alias Portc.3
Config Portc.4 = Output : Portc.4 = 0 : 7segment_Dp Alias Portc.4
Config Portb.3 = Output : Portb.3 = 0 : 7segment_D Alias Portb.3
Config Portb.4 = Output : Portb.4 = 0 : 7segment_E Alias Portb.4
Config Portb.5 = Output : Portb.5 = 0 : 7segment_c Alias Portb.5

Config Pinb.1 = Input : Set Portb.1 : Key Alias Pinb.1
Config Portd.2 = Output : Portd.2 = 1 : Buzzer Alias Portd.2

Dim Seting_time As Word : Seting_time = 60

Dim I As Byte
Dim A As Byte : A = 2
Dim D As Byte : D = 64
Dim A2 As Word

Dim Status_key As Bit

Gosub Sound_menu : Gosub Driver
Start Timer1

Do
   If Key = 0 Then
      Waitms 300
      If Key = 0 Then
         'Status_key = 1
         If Status_key = 0 Then
            Gosub Sound_key
            Status_key = 1
         End If
         Do
            'A2 = Timer1
            'A = A2 Mod 10
            A = Rnd(7)
            D = Lookup(a , Cathod_display)
            Gosub Driver
         Loop Until A <> 0                                  'And A < 7
      End If
   End If
   If Key = 1 Then Status_key = 0
   'Waitms 300
Loop

End

'***************************************
Driver:
   7segment_a = D.0
   7segment_b = D.1
   7segment_c = D.2
   7segment_d = D.3
   7segment_e = D.4
   7segment_f = D.5
   7segment_g = D.6
Return

'**************************
Lable:
   Incr I
   If I > Seting_time Then
      Stop Timer0
      'Gosub Sound_key
      Gosub Driver
      Start Timer0
      I = 0
   End If
Return

'***************************************
Sound_error:
   Sound Buzzer , 10 , 1500
Return

'***************************************
Sound_key:
   Sound Buzzer , 100 , 250
Return

'***************************************
Sound_menu:
   Sound Buzzer , 70 , 300
Return

'***************************************
Cathod_display:
Data 63 , 6 , 91 , 79 , 102 , 109 , 125 , 7 , 127 , 111 , 64 , 128 , 56
'     0    1   2    3    4     5     6     7   8     9     -    dp    L