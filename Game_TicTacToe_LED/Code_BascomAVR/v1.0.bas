'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

Config Porta.0 = Output : Porta.0 = 0
Config Porta.1 = Output : Porta.1 = 0
Config Porta.2 = Output : Porta.2 = 0
Config Porta.3 = Output : Porta.3 = 0
Config Porta.4 = Output : Porta.4 = 0
Config Porta.5 = Output : Porta.5 = 0
Config Porta.6 = Output : Porta.6 = 0
Config Porta.7 = Output : Porta.7 = 0

Config Portc.0 = Output : Portc.0 = 0
Config Portc.1 = Output : Portc.1 = 0
Config Portc.2 = Output : Portc.2 = 0
Config Portc.3 = Output : Portc.3 = 0
Config Portc.4 = Output : Portc.4 = 0
Config Portc.5 = Output : Portc.5 = 0
Config Portc.6 = Output : Portc.6 = 0
Config Portc.7 = Output : Portc.7 = 0

Config Portd.3 = Output : Portd.3 = 0
Config Portd.4 = Output : Portd.4 = 0

Config Portd.6 = Output : Portd.6 = 0 : Led_yellow Alias Portd.6
Config Portd.7 = Output : Portd.7 = 0 : Led_red Alias Portd.7

Config Kbd = Portb , Debounce = 50 , Delay = 100

Dim Key As Byte
Dim Key_status As Byte

Dim Personal_status As Bit : Personal_status = 0

Dim Personal_red As Byte : Personal_red = 0
Dim Personal_yellow As Byte : Personal_yellow = 0

Dim Yellow_1 As Bit
Dim Yellow_2 As Bit
Dim Yellow_3 As Bit
Dim Yellow_4 As Bit
Dim Yellow_5 As Bit
Dim Yellow_6 As Bit
Dim Yellow_7 As Bit
Dim Yellow_8 As Bit
Dim Yellow_9 As Bit

Dim Red_1 As Bit
Dim Red_2 As Bit
Dim Red_3 As Bit
Dim Red_4 As Bit
Dim Red_5 As Bit
Dim Red_6 As Bit
Dim Red_7 As Bit
Dim Red_8 As Bit
Dim Red_9 As Bit

Dim Home_1 As Bit
Dim Home_2 As Bit
Dim Home_3 As Bit
Dim Home_4 As Bit
Dim Home_5 As Bit
Dim Home_6 As Bit
Dim Home_7 As Bit
Dim Home_8 As Bit
Dim Home_9 As Bit

Dim Play_status As Bit : Play_status = 0
Dim K As Byte

Gosub Personal_status_driver

Do
   Key = Getkbd()
   Key = Lookup(key , Convert_key2)
   If Key <> Key_status And Key < 12 Then
      Select Case Key
         Case 0:
            Play_status = 0
            Gosub Reset_all
            Gosub Red_led_drive
            Gosub Yellow_led_drive
            Gosub Personal_status_driver
         Case 1:
            If Play_status = 0 And Home_1 = 0 And Personal_status = 0 Then
               Set Red_1 : Home_1 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 1
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_1 = 0 And Personal_status = 1 Then
               Set Yellow_1 : Home_1 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 1
               Gosub Personal_status_driver
            End If
         Case 2:
            If Play_status = 0 And Home_2 = 0 And Personal_status = 0 Then
               Set Red_2 : Home_2 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 2
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_2 = 0 And Personal_status = 1 Then
               Set Yellow_2 : Home_2 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 2
               Gosub Personal_status_driver
            End If
         Case 3:
            If Play_status = 0 And Home_3 = 0 And Personal_status = 0 Then
               Set Red_3 : Home_3 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 3
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_3 = 0 And Personal_status = 1 Then
               Set Yellow_3 : Home_3 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 3
               Gosub Personal_status_driver
            End If
         Case 4:
            If Play_status = 0 And Home_4 = 0 And Personal_status = 0 Then
               Set Red_4 : Home_4 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 4
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_4 = 0 And Personal_status = 1 Then
               Set Yellow_4 : Home_4 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 4
               Gosub Personal_status_driver
            End If
         Case 5:
            If Play_status = 0 And Home_5 = 0 And Personal_status = 0 Then
               Set Red_5 : Home_5 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 5
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_5 = 0 And Personal_status = 1 Then
               Set Yellow_5 : Home_5 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 5
               Gosub Personal_status_driver
            End If
         Case 6:
            If Play_status = 0 And Home_6 = 0 And Personal_status = 0 Then
               Set Red_6 : Home_6 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 6
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_6 = 0 And Personal_status = 1 Then
               Set Yellow_6 : Home_6 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 6
               Gosub Personal_status_driver
            End If
         Case 7:
            If Play_status = 0 And Home_7 = 0 And Personal_status = 0 Then
               Set Red_7 : Home_7 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 7
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_7 = 0 And Personal_status = 1 Then
               Set Yellow_7 : Home_7 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 7
               Gosub Personal_status_driver
            End If
         Case 8:
            If Play_status = 0 And Home_8 = 0 And Personal_status = 0 Then
               Set Red_8 : Home_8 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 8
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_8 = 0 And Personal_status = 1 Then
               Set Yellow_8 : Home_8 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 8
               Gosub Personal_status_driver
            End If
            Incr K
         Case 9:
            If Play_status = 0 And Home_9 = 0 And Personal_status = 0 Then
               Set Red_9 : Home_9 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 9
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_9 = 0 And Personal_status = 1 Then
               Set Yellow_9 : Home_9 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 9
               Gosub Personal_status_driver
            End If
         Case 10:
         Case 11:
            Play_status = 0
            Gosub Reset_all
            Gosub Red_led_drive
            Gosub Yellow_led_drive
            Gosub Personal_status_driver
      End Select
      Gosub Check_win
   End If
   Key_status = Key
Loop

End

'***************************************
Red_led_drive:
   Porta.1 = Red_1
   Porta.3 = Red_2
   Porta.5 = Red_3
   Porta.7 = Red_4
   Portc.1 = Red_5
   Portc.3 = Red_6
   Portc.5 = Red_7
   Portc.7 = Red_8
   Portd.4 = Red_9
Return

'***************************************
Yellow_led_drive:
   Porta.0 = Yellow_1
   Porta.2 = Yellow_2
   Porta.4 = Yellow_3
   Porta.6 = Yellow_4
   Portc.0 = Yellow_5
   Portc.2 = Yellow_6
   Portc.4 = Yellow_7
   Portc.6 = Yellow_8
   Portd.3 = Yellow_9
Return

'***************************************
Test:
Do
   Key = Getkbd()
   If Key < 12 Then
      Print Key
   End If
Loop
Return

'***************************************
Personal_status_driver:
   Toggle Personal_status
   If Personal_status = 0 Then
      Set Led_red : Reset Led_yellow
   Else
      Reset Led_red : Set Led_yellow
   End If
Return

'***************************************
Check_win:
   If Personal_red = 15 Then
      Reset Yellow_1 : Reset Yellow_2 : Reset Yellow_3
      Reset Yellow_4 : Reset Yellow_5 : Reset Yellow_6
      Reset Yellow_7 : Reset Yellow_8 : Reset Yellow_9
      'Gosub Red_led_drive
      Gosub Yellow_led_drive
      Reset Led_red : Reset Led_yellow
      Play_status = 1
   End If
   If Personal_yellow = 15 Then
      Reset Red_1 : Reset Red_2 : Reset Red_3
      Reset Red_4 : Reset Red_5 : Reset Red_6
      Reset Red_7 : Reset Red_8 : Reset Red_9
      Gosub Red_led_drive
            'Gosub Yellow_led_drive
      Reset Led_red : Reset Led_yellow
      Play_status = 1
   End If
Return

'***************************************
Reset_all:
      Reset Yellow_1 : Reset Yellow_2 : Reset Yellow_3
      Reset Yellow_4 : Reset Yellow_5 : Reset Yellow_6
      Reset Yellow_7 : Reset Yellow_8 : Reset Yellow_9
      Reset Red_1 : Reset Red_2 : Reset Red_3
      Reset Red_4 : Reset Red_5 : Reset Red_6
      Reset Red_7 : Reset Red_8 : Reset Red_9
      Personal_red = 0 : Personal_yellow = 0
      Home_1 = 0 : Home_2 = 0 : Home_3 = 0
      Home_4 = 0 : Home_5 = 0 : Home_6 = 0
      Home_7 = 0 : Home_8 = 0 : Home_9 = 0
      K = 0
Return


'**********************************************   Convert_keypad 3*4
Convert_key:
Data 11 , 4 , 9 , 2 , 0 , 3 , 5 , 7 , 10 , 8 , 1 , 6

'**********************************************   Convert_keypad 3*4
Convert_key2:
Data 4 , 11 , 9 , 2 , 3 , 0 , 5 , 7 , 8 , 10 , 1 , 6