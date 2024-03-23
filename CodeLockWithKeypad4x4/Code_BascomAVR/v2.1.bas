'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7 , E = Pina.2 , Rs = Pina.0
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 150

Config Pind.6 = Input : Portd.6 = 1 : Key Alias Pind.6
Config Portd.5 = Output : Portd.5 = 0 : Buzzer Alias Pind.5
Config Portc.3 = Output : Portc.3 = 0 : Relay Alias Portc.3

Dim Pass As String * 8
Dim Pass_eeprom As Eram String * 8
Dim K As Byte
Dim K_status As Byte
Dim Z As String * 8 : Z = ""
Dim Status_exit As Bit

If Key = 0 Then
   Gosub Sound_menu : Gosub Setting_default
End If

Gosub Eeprom_load
Gosub Display_menu1
Gosub Sound_menu

Do
   K = Getkbd() : K = Lookup(k , Read_key)
   If K < 16 And K <> K_status Then
      Select Case K
         Case 0 To 9:
            Gosub Sound_pressing
            Z = Z + Str(k)
            Locate 2 , 1 : Lcd "                "
            Locate 2 , 1 : Lcd Z
         Case 13:
            If Pass = Z Then
               Gosub Sound_menu
               Gosub Display_menu2
               Do
                  K = Getkbd() : K = Lookup(k , Read_key)
                  If K < 16 And K <> K_status Then
                     Select Case K
                        Case 10:
                           Gosub Sound_menu
                           Set Relay : Waitms 800 : Reset Relay
                        Case 11:
                           Gosub Sound_menu
                           Toggle Relay
                        Case 12:
                           Gosub Sound_menu
                           Gosub Display_menu3
                           Z = ""
                           Do
                              K = Getkbd() : K = Lookup(k , Read_key)
                              If K < 16 And K <> K_status Then
                                 Select Case K
                                    Case 0 To 9:
                                       Gosub Sound_pressing
                                       Z = Z + Str(k)
                                       Locate 2 , 1 : Lcd "                "
                                       Locate 2 , 1 : Lcd Z
                                    Case 14:
                                       Gosub Sound_menu
                                       Z = ""
                                       Locate 2 , 1 : Lcd "                " : Locate 2 , 1
                                    Case 13:
                                       If Z <> "" Then
                                          Gosub Sound_menu
                                          Pass = Z : Gosub Eeprom_save
                                          Gosub Display_menu4 : Wait 1
                                          Gosub Display_menu1
                                          Status_exit = 1
                                       Else
                                          Gosub Sound_error
                                       End If
                                    Case 15:
                                       Gosub Sound_menu
                                       Gosub Display_menu1
                                       Status_exit = 1
                                    Case Else : Gosub Sound_error
                                 End Select
                              End If
                              K_status = K
                           Loop Until Status_exit = 1
                        Case 15:
                           Gosub Sound_menu
                           Gosub Display_menu1
                           Status_exit = 1
                        Case Else : Gosub Sound_error
                     End Select
                  End If
                  K_status = K
               Loop Until Status_exit = 1
               Status_exit = 0
            Else
               Gosub Sound_error
            End If
            Z = ""
            Locate 2 , 1 : Lcd "                " : Locate 2 , 1
         Case 14:
            Gosub Sound_menu
            Z = ""
            Locate 2 , 1 : Lcd "                " : Locate 2 , 1
         Case Else:
            Gosub Sound_error
      End Select
   End If
   K_status = K
Loop

End

'**********************************
Display_menu1:
   Cls : Cursor On : Cursor Blink
   Locate 1 , 1 : Lcd "Password?"
   Locate 2 , 1
Return

'**********************************
Display_menu2:
   Cls : Cursor Off : Cursor Noblink
   Locate 1 , 1 : Lcd "Memonty= M"
   Locate 2 , 1 : Lcd "Toggle= T"
Return

'**********************************
Display_menu3:
   Cls : Cursor On : Cursor Blink
   Locate 1 , 1 : Lcd "New Pass?"
   Locate 2 , 1
Return

'**********************************
Display_menu4:
   Cls : Cursor Off : Cursor Noblink
   Locate 1 , 1 : Lcd "Pass Changed!"
Return

'**********************************
Sound_pressing:
   Sound Buzzer , 100 , 250
Return

'**********************************
Sound_menu:
   Sound Buzzer , 100 , 500
Return

'**********************************
Sound_error:
   Sound Buzzer , 10 , 1500
Return

'**********************************
Eeprom_load:
   Pass = Pass_eeprom : Waitms 10
Return

'**********************************
Eeprom_save:
   Pass_eeprom = Pass : Waitms 10
Return

'**********************************
Setting_default:
   Pass = "1111" : Pass_eeprom = Pass
   Cls :
   Locate 1 , 1 : Lcd "Memoey Erased!"
   Locate 2 , 1 : Lcd "Pass=1111"
   Wait 1 : Cls
Return

'**********************************
Read_key:
Data 1 , 4 , 7 , 15 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 13 , 10 , 11 , 14 , 12 , 16