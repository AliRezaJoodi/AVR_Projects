'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls


Config Kbd = Portb , Debounce = 50 , Delay = 150

Enable Interrupts

Config Timer0 = Timer , Prescale = 64                       'PRESCALE= 1|8|64|256|1024
On Timer0 Sound_alarm
Enable Timer0
Stop Timer0

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
'Dim Phone_number_eeprom As Eram String * 11
Dim Z As String * 16 : Z = ""

Dim Pass As String * 16
'Dim Pass_eeprom As String * 16

Dim I As Byte

'Pass = "1111" : Phone_number = "09112204314" : Gosub Save_to_eeprom

Gosub Sound_menu

Key = Getkbd() : Key = Lookup(key , Read_key)
If Key = 1 Then
   Waitms 30
   Key = Getkbd() : Key = Lookup(key , Read_key)
   If Key = 1 Then
      Gosub Default_pass
   End If
End If

Main:
Gosub Load_of_eeprom

Gosub Start_menu

Do
   Key = Getkbd() : Key = Lookup(key , Read_key)
   If Key < 16 And Key <> Key_status Then
      Select Case Key
         Case 0 To 9:
               Gosub Sound_pressing
               Z = Z + Str(key)
               Locate 2 , 1 : Lcd "                "
               Locate 2 , 1 : Lcd Z

         Case 10:
            If Z = Pass Then
               Gosub Sound_menu
               Z = ""
               Cls : Locate 1 , 1 : Lcd "New Pass?     "
               Do
                  Key = Getkbd() : Key = Lookup(key , Read_key)
                  If Key < 16 And Key <> Key_status Then
                     Select Case Key
                        Case 0 To 9:
                           Gosub Sound_pressing
                           Z = Z + Str(key)
                           Locate 2 , 1 : Lcd "                "
                           Locate 2 , 1 : Lcd Z
                        Case 13:
                           If Z <> "" Then
                              Gosub Sound_menu
                              Pass = Z : Z = ""
                              'Gosub Save_to_eeprom
                              Writeeeprom Pass , 50
                              Readeeprom Pass , 50
                              Cls : Lcd "Save Changes" : Waitms 1000
                              Gosub Start_menu
                              Goto Main
                           Else
                              Gosub Sound_error
                           End If
                        Case 12:
                           Gosub Sound_menu
                           Locate 2 , 1 : Lcd "                "
                           Z = ""
                        Case 14:
                           Gosub Sound_menu
                           Z = ""
                           Goto Main
                        Case Else:
                           Gosub Sound_error
                     End Select
                  End If
                  Key_status = Key
               Loop
            Else
               Gosub Sound_error
               Z = ""
               Gosub Start_menu
            End If
         Case 11:
            If Z = Pass Then
               Gosub Sound_menu
               Z = ""
               Cls
               Locate 1 , 1 : Lcd "New Phone Number"
               Locate 2 , 1 : Lcd Phone_number
               Do
                   Key = Getkbd() : Key = Lookup(key , Read_key)
                   If Key < 16 And Key <> Key_status Then
                     Select Case Key
                        Case 0 To 9:
                           Gosub Sound_pressing
                           Z = Z + Str(key)
                           Locate 2 , 1 : Lcd "                "
                           Locate 2 , 1 : Lcd Z
                        Case 12:
                           Locate 2 , 1 : Lcd "                "
                           Z = ""
                           Gosub Sound_menu
                        Case 13:
                           If Z <> "" Then
                              Gosub Sound_pressing
                              Phone_number = Z : Z = ""
                              Writeeeprom Phone_number , 20
                              Readeeprom Phone_number , 20
                              Cls : Lcd "Save Changes" : Waitms 1000
                              Gosub Start_menu
                              Goto Main
                              Else
                              Gosub Sound_error
                           End If
                        Case 14:
                           Gosub Sound_menu
                           Z = ""
                           Goto Main
                        Case Else:
                           Gosub Sound_error
                     End Select
                   End If
                   Key_status = Key
               Loop
            Else
               Gosub Sound_error
               Z = ""
               Gosub Start_menu
            End If
         Case 12:
            Gosub Sound_menu
            Z = ""
            Gosub Start_menu
         Case 14:
            If Z = Pass Then
               Gosub Sound_menu
               Z = ""
               On_off_status = 0
               Alarm_status = 0 : Stop Timer0 : Pwm1a = 0
               Reset Relay_phone_line
               Gosub Start_menu
            Else
               Gosub Sound_error
               Z = ""
               Gosub Start_menu
            End If
         Case 15:
            If Z = Pass Then
               Gosub Sound_menu
               If On_off_status = 0 Then
               Z = ""
               On_off_status = 1
               Cls : Lcd "Please Wait ..." : Wait 30
               Gosub Sound_menu
               Gosub Start_menu
               End If
            Else
               Gosub Sound_error
               Z = ""
               Gosub Start_menu
            End If
         Case 13:
            Gosub Sound_error
            Z = ""
            Gosub Start_menu
         Case Else:
            Gosub Sound_error
      End Select
   End If
   Key_status = Key
   If On_off_status = 1 Then
   If Pir_output_pin = 1 Or Pir_check_pin = 1 Then
      If Alarm_status = 0 Then
         Alarm_status = 1
         Gosub Alarm_lcd
         Gosub Dial
      End If
   End If
   End If
   If Alarm_status = 1 Then
      Start Timer0
   Else
      Stop Timer0
      Pwm1a = 0
   End If
Loop

End

'***************************************************
Sound_alarm:
   Incr I
   Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Down , Compare B Pwm = Disconnect , Prescale = 64
   Pwm1a = 5
   If I > 180 Then Pwm1a = 0                                ': Pwm1a = 0
Return

'***************************************************
Default_pass:
   Pass = "1111"
   'Pass_eeprom = Pass : Waitms 10
   Writeeeprom Pass , 50
   Gosub Sound_menu
   Gosub Sound_error
   Cls
   Locate 1 , 1 : Lcd "Default Password"
   Locate 2 , 1 : Lcd "1111"
   Wait 2
Return

'***************************************************
Load_of_eeprom:
   'Pass = Pass_eeprom : Waitms 10
   'Phone_number = Phone_number_eeprom : Waitms 10
   Readeeprom Pass , 50
   Readeeprom Phone_number , 20
Return

'***************************************************
Save_to_eeprom:
   'Pass_eeprom = Pass
   'Phone_number_eeprom = Phone_number
   Writeeeprom Pass , 50
   Writeeeprom Phone_number , 20
Return

'***************************************************
Start_menu:
   Cls
   If On_off_status = 0 Then
      Locate 1 , 1 : Lcd "Alarm OFF"
   Else
      Locate 1 , 1 : Lcd "Alarm ON "
   End If
   Locate 2 , 1 : Lcd "                "
Return

'***************************************************
Alarm_lcd:
   If Pir_output_pin = 1 And Pir_check_pin = 0 Then
      Locate 1 , 1 : Lcd "WARNING"
   Elseif Pir_check_pin = 1 Then
      Locate 1 , 1 : Lcd "NO CABLE"
   End If
Return


'***************************************************
Dial:
   Set Relay_phone_line : Waitms 500
   Locate 2 , 1 : Lcd "Dial ...        " : Waitms 10
   Dtmfout Phone_number , 50
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
Data 1 , 4 , 7 , 15 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 14 , 10 , 11 , 12 , 13       ',16