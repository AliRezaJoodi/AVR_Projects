'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 150

Enable Interrupts

Config Portd.6 = Output : Relay_phone_line Alias Portd.6 : Reset Relay_phone_line
Config Portd.4 = Output : Speaker Alias Portd.4 : Reset Speaker
Config Pinc.4 = Input : Portc.4 = 0 : Pir_output_pin Alias Pinc.4
Config Pinc.3 = Input : Portc.3 = 1 : Pir_check_pin Alias Pinc.3

Dim Key As Byte
Dim Key_status As Byte

Dim Pir_output_status As Bit
Dim Pir_check_status As Bit
Dim Alarm_status As Bit : Alarm_status = 0
Dim On_off_status As Bit

Dim Phone_number As String * 11
Dim Phone_number_eeprom As Eram String * 11
Dim Z As String * 11 : Z = ""

Dim Pass As Word
Dim Pass_eeprom As Eram Word
Dim P1 As Word : P1 = 0

'Pass = 56 : Phone_number = "09112204314" : Gosub Save_to_eeprom

Gosub Sound_menu

'Wait 2 : Gosub T2
'Gosub Start_menu
Key = Getkbd() : Key = Lookup(key , Read_key)
If Key = 0 Then
   Waitms 30
   Key = Getkbd() : Key = Lookup(key , Read_key)
   If Key = 0 Then
      Gosub Default_pass
   End If
End If

Main:
Gosub Load_of_eeprom

'Writeeeprom Phone_number , 20
'Readeeprom Phone_number , 20
'Locate 2 , 1 : Lcd Phone_number
'Wait 2

Gosub Start_menu

Do
   Key = Getkbd() : Key = Lookup(key , Read_key)
   If Key < 12 Then
      'Cls : Lcd Key
      Gosub Sound_pressing
      Select Case Key
         Case 0 To 9:
            P1 = P1 * 10 : P1 = P1 + Key
            Locate 2 , 1 : Lcd "                "
            Locate 2 , 1 : Lcd P1
         Case 11:
            P1 = 0
            On_off_status = 1
            Cls : Lcd "Please Wait ..." : Wait 30
            Gosub Sound_menu
            Gosub Start_menu
         Case 10:
            If P1 = Pass Then
               On_off_status = 0
               Alarm_status = 0
               Reset Relay_phone_line
               'Gosub Start_menu
               Cls
               Locate 1 , 1 : Lcd "Pass Changed  F1"
               'Locate 2 , 1 : Lcd "F1   F2   F3"
               Locate 2 , 1 : Lcd "Phone Changed F2"
                P1 = 0
                Do
                  Key = Getkbd() : Key = Lookup(key , Read_key)
                  If Key < 12 Then
                     Gosub Sound_pressing
                     Select Case Key
                        Case 1:
                           Cls : Locate 1 , 1 : Lcd "New Pass?     "
                           Do
                              Key = Getkbd() : Key = Lookup(key , Read_key)
                              If Key < 12 Then
                                 Gosub Sound_pressing
                                 Select Case Key
                                    Case 0 To 9:
                                       P1 = P1 * 10 : P1 = P1 + Key
                                       Locate 2 , 1 : Lcd "                "
                                       Locate 2 , 1 : Lcd P1
                                    Case 11:
                                       Pass = P1 : P1 = 0
                                       Gosub Save_to_eeprom
                                       Locate 2 , 1 : Lcd "                "
                                       Locate 2 , 1 : Lcd "Pass Changed" : Waitms 1000
                                       Gosub Start_menu
                                       Goto Main
                                    Case 10:
                                       'Gosub Start_menu
                                       'Goto Main
                                       Locate 2 , 1 : Lcd "                "
                                       P1 = 0
                                 End Select
                              End If
                           Loop
                        Case 2:
                           'Phone_number = "09112203729"
                           'Phone_number = Phone_number_eeprom : Waitms 10
                           'Readeeprom Phone_number , 20
                           Cls
                           Locate 1 , 1 : Lcd "New Phone Number"
                           Locate 2 , 1 : Lcd Phone_number
                           Do
                              Key = Getkbd() : Key = Lookup(key , Read_key)
                              If Key < 12 Then
                                 'Gosub Sound_pressing
                                 Select Case Key
                                    Case 0 To 9:
                                       Gosub Sound_pressing
                                       Z = Z + Str(key)
                                       Locate 2 , 1 : Lcd "                "
                                       Locate 2 , 1 : Lcd Z
                                    Case 10:
                                       Locate 2 , 1 : Lcd "                "
                                       Z = ""
                                       Gosub Sound_pressing
                                       'Gosub Start_menu
                                       'Goto Main
                                    Case 11:
                                    If Z <> "" Then
                                       Gosub Sound_pressing
                                       Phone_number = Z : Z = ""
                                       'Phone_number_eeprom = Phone_number : Waitms 10
                                       Writeeeprom Phone_number , 20
                                       Readeeprom Phone_number , 20
                                       Locate 2 , 1 : Lcd "                "
                                       Locate 2 , 1 : Lcd "Phone Changed" : Waitms 1000
                                       Gosub Start_menu
                                       Goto Main
                                    Else
                                       Gosub Sound_error
                                    End If
                                 End Select
                              End If
                           Loop
                     End Select
                  End If
                  If Alarm_status = 1 Then Gosub Sound_error
                Loop
            End If
            P1 = 0
            Locate 2 , 1 : Lcd "                "
      End Select
   End If

   If On_off_status = 1 Then
   If Pir_output_pin = 1 Or Pir_check_pin = 1 Then
      If Alarm_status = 0 Then
         Alarm_status = 1
         Gosub Alarm_lcd
         Gosub Dial
      End If
   End If
   End If
   If Alarm_status = 1 Then Gosub Sound_error
   'Gosub Pir_scanner
Loop

End

Default_pass:
   Pass = 1111
   Pass_eeprom = Pass : Waitms 10
   Gosub Sound_menu
   Gosub Sound_error
   Cls
   Locate 1 , 1 : Lcd "Default Pass"
   Locate 2 , 1 : Lcd "1111"
   Wait 2
Return

Load_of_eeprom:
   Pass = Pass_eeprom : Waitms 10
   'Phone_number = Phone_number_eeprom : Waitms 10
   Readeeprom Phone_number , 20
Return

Save_to_eeprom:
   Pass_eeprom = Pass
   'Phone_number_eeprom = Phone_number
   Writeeeprom Phone_number , 20
Return

Start_menu:
   Cls
   If On_off_status = 0 Then
      Locate 1 , 1 : Lcd "Alarm OFF"
   Else
      Locate 1 , 1 : Lcd "Alarm ON "
   End If
   Locate 2 , 1 : Lcd "                "
Return

Alarm_lcd:
   If Pir_output_pin = 1 And Pir_check_pin = 0 Then
      Locate 1 , 1 : Lcd "Warning 1"
   Elseif Pir_output_pin = 0 And Pir_check_pin = 1 Then
      Locate 1 , 1 : Lcd "Warning 2"
   Elseif Pir_output_pin = 1 And Pir_check_pin = 1 Then
      Locate 1 , 1 : Lcd "Warning 3"
   End If
Return

Pir_scanner:
   If Pir_output_pin = 0 Then
      Locate 2 , 1 : Lcd "PIR= NO "
   Else
      Locate 2 , 1 : Lcd "PIR= YES"
      Gosub Sound_error
   End If
Return

Dial:
   Set Relay_phone_line : Waitms 500
   Locate 2 , 1 : Lcd "Dial ...        " : Waitms 10
   Dtmfout Phone_number , 50
Return

T2:
   Do
      Key = Getkbd() : Key = Lookup(key , Read_key)
      Cls : Lcd Key
   Loop
Return

Pir_check:
   If Pir_check_pin = 0 Then
      Locate 1 , 1 : Lcd "ok"
   Else
      Locate 1 , 1 : Lcd "NO"
      Gosub Sound_error
   End If
Return

'***************************************************
Sound_pressing:
   Sound Speaker , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Speaker , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Speaker , 10 , 1500
Return

'**********************************************   Read_key
Read_key:
Data 1 , 4 , 7 , 11 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 10

