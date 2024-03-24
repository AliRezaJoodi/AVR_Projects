'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 11059200

$include "Attachment\Hardware_Model2_v1.0_A.inc"

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

$include "Attachment\Hardware_Model2_v1.0_B.inc"

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
