'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Enable Interrupts

Config Int1 = Falling
On Int1 Ringtone_counters
Enable Int1

Config Timer0 = Timer , Prescale = 1024                     'PRESCALE= 1|8|64|256|1024
On Timer0 Reset_ringtone_counters
Enable Timer0                                               ' Or  Enable Ovf0
Stop Timer0

Config Timer1 = Timer , Prescale = 1024                     'PRESCALE= 1|8|64|256|1024
On Timer1 Timing_5_min
Enable Timer1                                               ' Or  Enable Ovf0
Stop Timer1

Config Timer2 = Timer , Prescale = 64
Enable Ovf2
On Ovf2 Enable_status
Stop Timer2
Timer2 = 0

Config Watchdog = 256
Stop Watchdog

Config Debounce = 30

Config Portb.1 = Input
Config Portc.6 = Input
Config Portd.0 = Input

Config Portc = Input

Config Porta.0 = Output : Porta.0 = 0 : Relay_1 Alias Porta.0
Config Porta.1 = Output : Porta.1 = 0 : Relay_2 Alias Porta.1
Config Porta.2 = Output : Porta.2 = 0 : Relay_3 Alias Porta.2
Config Porta.3 = Output : Porta.3 = 0 : Relay_4 Alias Porta.3
Config Porta.4 = Output : Porta.4 = 0 : Relay_5 Alias Porta.4
Config Porta.5 = Output : Porta.5 = 0 : Relay_6 Alias Porta.5
Config Porta.6 = Output : Porta.6 = 0 : Relay_7 Alias Porta.6
Config Porta.7 = Output : Porta.7 = 0 : Relay_8 Alias Porta.7

Config Portd.6 = Output : Portd.6 = 0 : Relay_dial Alias Portd.6
Config Portd.5 = Output : Portd.5 = 0 : Sound_pin Alias Portd.5

Config Portc.1 = Input : Portc.1 = 0 : Key_interrupts Alias Pinc.1
Config Portb.2 = Input : Portb.2 = 1 : Key_default_pass Alias Pinb.2

Const Max_enter_pass = 3

'Dim Phone_number As String * 11 : Phone_number = "09112204314"
Dim Key As Byte : Key = 0
Dim P1 As Word : P1 = 0
'Dim Pass As Word : Pass = 4321
Dim Password As String * 16
Dim Password_eeprom As Eram String * 16

Dim Relay_number As String * 1
Dim Relay_status As Byte
Dim Relay_status_ As String * 1
Dim Relay_status_eeprom As Eram Byte

Dim Ringtone As Byte

Dim Key_interrupts_status As Bit : Key_interrupts_status = 0

Dim Tools_timer0 As Word

Dim Z As String * 16 : Z = ""
Dim Z2 As String * 16
Dim I As Byte : I = 0
Dim Tools_timer2 As Word

Dim Status_timer As Byte
Dim Status_timer_eeprom As Eram Byte
Dim False_counter As Byte
Dim False_counter_eeprom As Eram Byte
Dim Timing As Byte
Dim Status_disable As Bit

Dim Status_exit As Bit : Status_exit = 0

'Dim I5 As Byte
'Password_eeprom = "1111"
'Relay_status_eeprom = 0
'False_counter_eeprom = 0
False_counter = False_counter_eeprom
'Gosub T1

'Relay_status = 0 : Gosub Relay_drive
'Set Relay_1 : Wait 2
'Gosub Test_ton_decoder
'Waitms 500 : Gosub Dial_ton
'Gosub Get_key
'Wait 1 : Gosub Ring_tone

'Relay_status = 0 : Gosub Save_eeprom


If Key_default_pass = 0 Then
   Waitms 30
   If Key_default_pass = 0 Then
      Gosub Default_pass
      False_counter_eeprom = 0
      Status_timer_eeprom = 0
      Set Relay_dial : Wait 1 : Reset Relay_dial : Waitms 200
   End If
End If

Gosub Eeprom_load
Gosub Relay_drive

Password = Password_eeprom

Main:
   'Ring_counter = 0
   'Reset Relay_2
   'Enable Int1
If Status_timer = 1 Then
    Start Timer1
End If

Do
   Gosub Read_key
   Select Case Key
      Case 1 To 10:
         If Key = 10 Then Key = 0
         Z = Z + Str(key)
      Case 12:
         If Z = Password Then
            Z = ""
            Gosub Sound_menu
            Timing = 35 : Gosub Timing_5_min
            Do
               Gosub Read_key
               Select Case Key
                  Case 1 To 10:
                     If Key = 10 Then Key = 0
                     Z = Z + Str(key)
                     'Porta = Key
                     Incr I
                     If I = 1 And Z = "0" Then
                        Gosub Sound_error
                        I = 0 : Z = ""
                     End If
                     'If I = 1 And Z = "9" Then
                        'Gosub Sound_error
                        'I = 0 : Z = ""
                     'End If
                     If I = 2 Then
                        I = 0
                        Relay_number = Mid(z , 1 , 1)
                        Relay_status_ = Mid(z , 2 , 1)
                        Gosub Relay_driver
                        Gosub Relay_drive
                        Z = ""
                     End If
                  Case 12:
                     Z = ""
                     Gosub Sound_menu : Waitms 300
                     Reset Relay_dial
                     'Start Watchdog
                     Status_exit = 1
                     'Exit Do
                     'Goto Main
                  End Select
            Loop Until Status_exit = 1
            Status_exit = 0
         Else
            Gosub Sound_error : Waitms 300
            Status_timer = 1 : Status_timer_eeprom = 1
            Timing = 0 : Start Timer1
            Incr False_counter : False_counter_eeprom = False_counter
            If False_counter >= Max_enter_pass Then
               'Status_timer = 1 : Status_timer_eeprom = 1
               'Start Timer1
               Reset Relay_dial : Waitms 100
               'Start Watchdog
            End If
         End If
         Z = ""
      Case 11:
         If Z = Password Then
            Z = ""
            Gosub Sound_menu
            Timing = 35 : Gosub Timing_5_min
            'Set Relay_5
            Do
               Gosub Read_key
               Select Case Key
                  Case 1 To 10:
                     If Key = 10 Then Key = 0
                     Z = Z + Str(key)
                  Case 11:
                     If Z <> "" Then
                     Gosub Sound_menu
                     Z2 = Z
                     Z = ""
                     Do
                        Gosub Read_key
                        Select Case Key
                           Case 1 To 10:
                              If Key = 10 Then Key = 0
                              Z = Z + Str(key)
                           Case 11:
                              If Z2 = Z Then
                                 Password = Z : Z = "" : Z2 = ""
                                 Password_eeprom = Password
                                 Gosub Sound_menu
                              Else
                                 Gosub Sound_error
                              End If
                              Reset Relay_dial
                              'Start Watchdog
                              Status_exit = 1
                              'Goto Main
                        End Select
                     Loop Until Status_exit = 1
                     'Exit Do
                     Else
                        Gosub Sound_error
                     End If
               End Select
            Loop Until Status_exit = 1
            Status_exit = 0
         Else
            Gosub Sound_error : : Waitms 300
            Z = ""
            Incr False_counter : False_counter_eeprom = False_counter
            Timing = 0 : Start Timer1
            If False_counter >= Max_enter_pass Then
               Status_timer = 1 : Status_timer_eeprom = 1
               Reset Relay_dial : Waitms 100
               'Start Watchdog
               'Start Timer1
            End If
         End If
   End Select
Loop

End

'************************************************
Timing_5_min:
   Incr Timing
   If Timing >= 35 Then
      Timing = 0
      Stop Timer1
      False_counter = 0 : False_counter_eeprom = 0
      Status_disable = 0
      Status_timer = 0 : Status_timer_eeprom = 0
      'Set Relay_3
   End If
Return

'************************************************
Default_pass:
   Password = "1111"
   Password_eeprom = Password : Waitms 10
Return

'************************************************
Enable_status:
   Incr Tools_timer2
   If Tools_timer2 > 7000 Then
      Stop Timer2
      Gosub Sound_error
      Reset Relay_dial : Waitms 100
      Tools_timer2 = 0 : Timer2 = 0
      'Start Watchdog
      'Wait 1
      'Goto Main
   End If
Return

'************************************************
Relay_driver:
   If Relay_number = "1" Then
      If Relay_status_ = "1" Then
         Set Relay_status.0 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.0 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "2" Then
      If Relay_status_ = "1" Then
         Set Relay_status.1 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.1 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "3" Then
      If Relay_status_ = "1" Then
         Set Relay_status.2 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.2 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "4" Then
      If Relay_status_ = "1" Then
         Set Relay_status.3 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.3 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "5" Then
      If Relay_status_ = "1" Then
         Set Relay_status.4 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.4 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "6" Then
      If Relay_status_ = "1" Then
         Set Relay_status.5 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.5 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "7" Then
      If Relay_status_ = "1" Then
         Set Relay_status.6 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.6 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "8" Then
      If Relay_status_ = "1" Then
         Set Relay_status.7 : Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Reset Relay_status.7 : Gosub Sound_menu
      Else
         Gosub Sound_error
      End If
   End If
   If Relay_number = "9" Then
      If Relay_status_ = "1" Then
         Relay_status = 255
         Gosub Sound_menu
      Elseif Relay_status_ = "0" Then
         Relay_status = 0
         Gosub Sound_error
      End If
   End If
Return

'************************************************
Read_key:
   Do
      Debounce Key_interrupts , 1 , label1
   Loop
   label1:
   Key.0 = Pinc.5 : Key.1 = Pinc.4 : Key.2 = Pinc.3 : Key.3 = Pinc.2
   Key = Key And &B00001111
   Timer2 = 0 : Tools_timer2 = 0
Return

'************************************************
Ringtone_counters:
   Start Timer0
   Timer0 = 0 : Tools_timer0 = 0
   If False_counter < Max_enter_pass Then Incr Ringtone
   If Ringtone >= 3 Then
      Ringtone = 0
      Stop Timer0 : Timer0 = 0 : Tools_timer0 = 0
      Set Relay_dial : Waitms 100
      Start Timer2
      Waitms 100 : Sound Sound_pin , 700 , 300
   End If
Return

'************************************************
Reset_ringtone_counters:
   Incr Tools_timer0
   If Tools_timer0 > 254 Then
      Tools_timer0 = 0
      Ringtone = 0
      Stop Timer0
   End If
Return

'***************************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'***************************************************
Sound_menu:
   Waitms 400 : Sound Sound_pin , 100 , 500
   Waitms 50 : Sound Sound_pin , 100 , 500
Return

'***************************************************
Sound_error:
   Waitms 400 : Sound Sound_pin , 50 , 1700
Return

'**********************************************
Relay_drive:
   Gosub Eeprom_save
   Relay_1 = Relay_status.0
   Relay_2 = Relay_status.1
   Relay_3 = Relay_status.2
   Relay_4 = Relay_status.3
   Relay_5 = Relay_status.4
   Relay_6 = Relay_status.5
   Relay_7 = Relay_status.6
   Relay_8 = Relay_status.7
Return

'**********************************************
Eeprom_save:
   Relay_status_eeprom = Relay_status : Waitms 10
   Status_timer_eeprom = Status_timer
Return

'**********************************************
Eeprom_load:
   Relay_status = Relay_status_eeprom : Waitms 10
   Status_timer = Status_timer_eeprom
   False_counter = False_counter_eeprom
Return

'************************************************
Test_ton_decoder:
   Disable Interrupts
   Do
      Relay_1 = Pinc.5
      Relay_2 = Pinc.4
      Relay_3 = Pinc.3
      Relay_4 = Pinc.2
   Loop
Return