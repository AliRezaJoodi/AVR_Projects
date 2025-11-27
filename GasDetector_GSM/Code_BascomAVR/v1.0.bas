'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 11059200
'$prog &HFF , &HFF , &HD1 , &H00                             ' generated. Take care that the chip supports all fuse bytes.
Enable Interrupts
$baud = 9600
'Enable Urxc
'On Urxc Lable

Open "comd.2:9600,8,n,1" For Output As #1
Print #1 , "START"

'Config Portc.4 = Output : Portc.4 = 0 : Charge_enable Alias Portc.4
Config Portc.5 = Output : Portc.5 = 1 : Sim300cz_enable Alias Portc.5
'Config Pind.7 = Input : On_off_pin Alias Pind.7


Config Timer0 = Timer , Prescale = 1024                     'PRESCALE= 1|8|64|256|1024
On Timer0 Timer0_sub
Enable Timer0                                               ' Or  Enable Ovf0
'Stop Timer0
Start Timer0

'Config Pind.2 = Input
'Config Int0 = Falling
'On Int0 No_power
'Enable Int0

Config Debounce = 30
Config Pind.3 = Input : Portd.3 = 1 : Change_password_button Alias Pind.3

Config Portc.3 = Output : Reset Portc.3 : Relay Alias Portc.3

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Dim A As Byte
Dim S As String * 254
Dim I As Word
Dim Tim As Word : Tim = 0
Dim Dial_number As String * 13 : Dial_number = "+989112204314"
Dim Dial_number_eeprom As Eram String * 13
Dial_number = Dial_number_eeprom : Waitms 10

Dim Charge_level As Byte
Dim Charge_status As Byte
Dim Sim_status As Bit
Dim Phone_status As Bit
'Dim Pin_status As Bit
Dim Z As String * 10

Dim W As Word
Dim Sens_1 As Single

'Gosub Start_sim
'Wait 2 : Gosub Test1
'Gosub Send_sms
'Wait 1
'Gosub Get_charge : Waitms 500
'Gosub Sim_chek
'I = 0 : Gosub Dialling
'Gosub En_sim300cz
'Gosub Off_sim300cz
Gosub On_off_sim
Gosub On_sim300cz
'Gosub Start_sim
'Gosub Dialling
'End
Do
   'Gosub Read_sim
   'Wait 10
   'Gosub On_off_sim : Wait 10
   Debounce Change_password_button , 0 , Change_dial_number , Sub
Loop



End

'******************************************
Red_sensor:
   W = Getadc(1) : Sens_1 = W / 0.2048 : Sens_1 = Sens_1 / 1000
   'Print #1 , Sens_1 : Wait 1
Return

'******************************************
Relay_driver:
   If Sens_1 > 2.5 Then
      Set Relay
      'Gosub No_power
      'End
   Elseif Sens_1 < 1.5 Then
      Reset Relay
   End If
Return

Lable:
   A = Inkey()
      Select Case A
         Case 0:
         Case 13 :
           'If S <> "" Then Print #1 , S
           'Print #1 , S
           'Gosub Get_charge
           S = ""
         Case 10 :
           'If S <> "" Then Print #1 , S
           'Print #1 , S
           'S = ""
         Case Else
           S = S + Chr(a)
      End Select
Return

Test1:
   'Print "ATE0" : Waitms 30
   'Print "ATD" ; "09112204314;"
   Print "AT+CBC" : Waitms 500
Return

Start_sim:
Print "AT" : Waitms 500
Print "AT" : Waitms 500
Print "AT" : Waitms 500
Print "AT" : Waitms 500
Print "AT" : Waitms 500
Print "ATE0" : Waitms 500
Print "ATE0" : Waitms 500
Print "AT+CMGF=1" : Waitms 500
Print "AT" : Waitms 500
Print "AT" : Waitms 1000
Return

Command_chek:
   Z = Mid(s , 2 , 3)
Return



'********************************************** Timer0_sub
Timer0_sub:
   Stop Timer0
   W = Getadc(1) : Sens_1 = W / 0.2048 : Sens_1 = Sens_1 / 1000
      If Sens_1 > 2.5 Then
         Set Relay : Waitms 10
         Gosub On_off_sim
         Gosub On_sim300cz
         Gosub Dialling
   Elseif Sens_1 < 1.5 Then
      Reset Relay
   End If
   'Gosub Relay_driver
   Incr Tim
   If Tim > 1265 Then
      Gosub On_off_sim
      Gosub On_sim300cz
      'Gosub Charge_contoler

      Tim = 0
   End If
   Start Timer0
Return

'********************************************** Dialling
Dialling:
   Incr I
   S = ""
   Print #1 , "Dialling " ; Dial_number
   Print "ATD" ; Dial_number ; ";"                          ': Waitms 300
   Do
      A = Inkey()                                           ': Incr I
      Select Case A
         Case 0:
         Case 13:
           If S = "BUSY" Or S = "NO CARRIER" Or S = "ERROR" Or S = "NO ANSWER" Then Exit Do
           S = ""
         Case 10:
           If S = "BUSY" Or S = "NO CARRIER" Or S = "ERROR" Or S = "NO ANSWER" Then Exit Do
           S = ""
         Case Else
           S = S + Chr(a)
      End Select
   Loop                                                     ' Until I > 5000
    If S <> "" Then Print #1 , S
    If S <> "BUSY" And I <= 3 Then
      Wait 2 : S = "" : Goto Dialling
    End If
    If S <> "BUSY" Then Gosub Sms_sending
    I = 0 : S = "" : A = 0
    Print #1 , "END Dialling"
Return

'********************************************** Sms_sending
Sms_sending:
   Print #1 , "Sms_sending"
   Print "AT+CMGF=1" : Waitms 500
   Print "AT+CMGS=" ; Chr(34) ; Dial_number ; Chr(34) : Waitms 100
   Print "Risk of gas leaks" ; Chr(26) : Waitms 550
Return

'********************************************** Sim_chek
Sim_chek:
   Z = ""
   S = ""
   Print #1 , "Sim_chek"
   Print "AT+CSMINS?"
   Do
      A = Inkey()                                           ': Incr I
      Select Case A
         Case 0:
         Case 13:
            Z = Mid(s , 2 , 6)
            If Z = "CSMINS" Then Exit Do
            S = ""
         Case 10:
            Z = Mid(s , 2 , 6)
            If Z = "CSMINS" Then Exit Do
            S = ""
         Case Else
           S = S + Chr(a)
      End Select
   Loop
   Print #1 , S
   Z = Mid(s , 12 , 1)
   If Z = "1" Then
      Sim_status = 1
   Elseif Z = "0" Then
      Sim_status = 0
   End If
   'Print #1 , Z
   If Sim_status = 1 Then Print #1 , "sim_ok"
Return

'********************************************** No_electricity
No_power:
   'Stop Timer0
   Waitms 100
   'If Pind.2 = 0 Then
      Print #1 , "No_power"
      Gosub On_off_sim
      Gosub On_sim300cz
      If Phone_status = 1 Then
         I = 0 : Gosub Dialling
      End If
   'End If
   'Start Timer0
Return

'********************************************** Off_sim300cz
Off_sim300cz:
   If Phone_status = 1 Then
      Print #1 , "Off_sim300cz"
      Print "AT+CPOWD=1" : Wait 5
   End If
Return

'********************************************** En_sim300cz
On_sim300cz:
   If Phone_status = 0 Then
      Print #1 , "On_sim300cz"
      Reset Sim300cz_enable : Wait 2 : Set Sim300cz_enable : Wait 10
      Gosub Start_sim
      Print #1 , "END On_sim300cz"
   End If
Return

'********************************************** On_off_sim
On_off_sim:
   Z = "" : S = "" : I = 0
   Print #1 , "On_off_sim"
   Print "AT+CFUN?"
   Do
      A = Inkey() : Incr I                                  ': Incr I
      Select Case A
         Case 0:
         Case 13:
            Z = Mid(s , 2 , 4)
            If Z = "CFUN" Then Exit Do
            S = "" : I = 0
         Case 10:
            Z = Mid(s , 2 , 4)
            If Z = "CFUN" Then Exit Do
            S = "" : I = 0
         Case Else
           S = S + Chr(a)
      End Select
   Loop Until I > 65000
   Z = Mid(s , 8 , 1)
   If Z = "1" Then
      Phone_status = 1 : Print #1 , "PHONE ON"
   Else                                                     'if Z = "0" Then
      Phone_status = 0 : Print #1 , "PHONE OFF"
   End If
   'Print #1 , Z
   Z = "" : S = "" : I = 0
Return

'********************************************** Change_dial_number
Change_dial_number:
   Stop Timer0
   'Disable Int0
   Z = "" : S = "" : I = 0
   Print #1 , "Change_password"
   Print "AT" : Waitms 500
   Print "AT+CLCC"
      Do
      A = Inkey() : Incr I                                  ': Incr I
      Select Case A
         Case 0:
         Case 13:
            Z = Mid(s , 2 , 4)
            If Z = "CLCC" Then Exit Do
            S = "" : I = 0
         Case 10:
            Z = Mid(s , 2 , 4)
            If Z = "CLCC" Then Exit Do
            S = "" : I = 0
         Case Else
           S = S + Chr(a)
      End Select
   Loop Until I > 65000
   Z = Mid(s , 19 , 13)
   I = Len(z)
   If I >= 11 Then
      'Z = Mid(s , 19 , 13)
      Dial_number = Z
      Dial_number_eeprom = Dial_number : Waitms 10
   End If
   Print #1 , Z
   Wait 2
   Gosub On_off_sim
   Gosub On_sim300cz
   If Phone_status = 1 Then
      I = 0 : Gosub Dialling
   End If
   Z = "" : S = "" : I = 0
   'Enable Int0
   Start Timer0
Return