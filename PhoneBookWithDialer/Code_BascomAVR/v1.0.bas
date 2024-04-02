'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 30 , Delay = 100
Config Portd.6 = Output : Relay Alias Portd.6 : Reset Relay
Config Portd.4 = Output : Portd.4 = 0 : Sound_pin Alias Portd.4

Enable Interrupts

Config Timer0 = Timer , Prescale = 1024
On Timer0 Lable
Enable Timer0
Stop Timer0

Deflcdchar 0 , 32 , 2 , 6 , 14 , 30 , 14 , 6 , 2            'left
Deflcdchar 1 , 32 , 8 , 12 , 14 , 15 , 14 , 12 , 8          'right
Deflcdchar 2 , 4 , 10 , 21 , 4 , 4 , 4 , 32 , 32            ' up
Deflcdchar 3 , 32 , 32 , 4 , 4 , 4 , 21 , 10 , 4            ' down


Dim Key As Byte
Dim Key_status As Byte
Dim Key_old As Byte

Dim Menu_1 As Byte : Menu_1 = 4

Dim Key_bit As Bit
Dim Caracter As String * 1
Dim Name_family As String * 16
Dim Number As String * 11
Dim Cur As Byte
Dim L_cur As Byte
Dim Lock_key As Byte
Dim Tul_name As Word

Dim Address_block As Word , Address_low As Byte , Address_high As Byte
Dim Data_rw As Byte , M As Word

Dim I As Word , J As Byte
Dim I1 As Word
Dim I2 As Word
Dim I3 As Byte

Dim Find_address As Word , Find_bit As Bit
Dim Find_name As String * 16 , Find_namee As String * 16

Dim Contacts_counter As Byte
Dim Contacts_name(18) As Eram String * 15
Dim Contacts_number(18) As Eram String * 11
Dim Number_dial As String * 11

Dim Dial_status As Bit : Dial_status = 0

Dim Length As Byte

Cur = 16
L_cur = 19

Gosub Sound_menu

Main:
Reset Relay : Waitms 5

Gosub Sound_menu


'Gosub Erase_eeprom

Gosub Start_menu

'Gosub Key_test

Stop Timer1 : Timer1 = 0

Do
   Key = Getkbd() : Key = Lookup(key , Edit_key)
   If Key <> Key_status Then
      Key_status = Key
      'Cls : Lcd Key
      Select Case Key
         Case 12:
            Gosub Sound_menu
            Incr Menu_1 : If Menu_1 > 4 Then Menu_1 = 0
            Gosub Start_menu
         Case 13:
            Gosub Sound_menu
            Decr Menu_1 : If Menu_1 > 4 Then Menu_1 = 4
            Gosub Start_menu
         Case 11:
            If Menu_1 = 0 Then
               Gosub Sound_menu
               Gosub Add_name
            Elseif Menu_1 = 1 Then
               Gosub Sound_menu
               Gosub Add_name
            Elseif Menu_1 = 2 Then
               Gosub Sound_menu
               Gosub Add_name
            Elseif Menu_1 = 3 Then
               Gosub Sound_menu
               Gosub View
            Elseif Menu_1 = 4 Then
               Gosub Sound_menu
               Gosub Menu_dial
            Else
               Gosub Sound_error
            End If
         Case Else:
            If Key <> 16 Then Gosub Sound_error
      End Select
   End If
Loop

End

Lable:
   Incr I3
Return

'****************************************************
Menu_dial:
   Number = ""
   Cls : Lcd "Enter Number:"
   Locate 2 , 1 : Cursor On : Cursor Blink
   Do
      Key = Getkbd() : Key = Lookup(key , Edit_key)
      If Key <> Key_status Then
         Key_status = Key
         Select Case Key
            Case 0 To 9:
               If Length <= 10 Then
                  Number = Number + Str(key) : Length = Len(number)
                  Locate 2 , 1 : Lcd Number
                  If Dial_status = 1 Then
                     Dtmfout Key , 50
                  Else
                     Gosub Sound_pressing
                  End If
               Else
                  Gosub Sound_error
               End If
            Case 14:
               If Dial_status = 0 Then
                  Gosub Sound_menu
                  Number = "" : Length = 0
                  Locate 2 , 1 : Lcd Space(16)
                  Locate 2 , 1                              ': Cursor On : Cursor Blink
               Else
                  Gosub Sound_error
               End If
            Case 15:
               Gosub Sound_menu
               If Dial_status = 0 Then
                  Set Relay : Waitms 500
                  Dial_status = 1
                  If Number <> "" Then
                     Dtmfout Number , 50
                  End If
               Else
                  Reset Relay : Waitms 100
                  Dial_status = 0
               End If
            Case 10:
               Gosub Sound_menu
               If Dial_status = 1 Then
                  Reset Relay : Waitms 100
               End If
               Goto Main
            Case 11:
               If Number <> "" Then
                  Gosub Sound_menu
                  Number_dial = Number
                  Gosub Add_name
               Else
                  Gosub Sound_error
               End If
            Case 12:
               Gosub Sound_error
            Case 13:
               Gosub Sound_error
         End Select
      End If
   Loop
Return

'****************************************************
Key_test:
   Do
      Key = Getkbd() : Key = Lookup(key , Edit_key)
      If Key < 16 Then
         Gosub Sound_menu
         Cls : Lcd Key
      End If
   Loop
Return

'****************************************************
Add_name:
   Cls
   I = 0
   Key_old = 16
   Tul_name = 1 : Cur = 16 : L_cur = 19
   Name_family = ""
   Locate 1 , 1 : Lcd "Contact name:"
   Locate 2 , 1 : Cursor On : Cursor Blink
   'wait 500
   'Locate 2 , 1 : Lcd Key_status
   Do
      Stop Timer0 : Timer0 = 0 : I3 = 0 : Caracter = ""
      Do
         Key = Getkbd() : Key = Lookup(key , Edit_key)
         If Key <> Key_status Then
            Key_status = Key
            Select Case Key
            Case 0 To 9
            If I = 0 Then
               Start Timer0 : Timer0 = 0 : I3 = 0
               If Key <> Key_old Then
                  Key_old = Key
                  If Caracter <> "" Then
                     'Gosub Sound_menu
                     Cur = 11
                     Name_family = Name_family + Caracter
                     Locate 2 , 1 : Lcd Space(16)
                     Locate 2 , 1 : Lcd Name_family
                     Tul_name = Len(name_family)
                     Incr Tul_name
                  End If
               End If
               Key_bit = 0
               If Key = 0 Or Key = 1 Or Key = 7 Or Key = 9 Then
                  L_cur = 16
               Elseif Key = 2 Or Key = 3 Or Key = 4 Or Key = 5 Or Key = 6 Or Key = 8 Then
                  L_cur = 15
               End If
               'Gosub Sound_pressing
               Lock_key = Key
               Incr Cur : If Cur > L_cur Then Cur = 12
               Select Case Cur
                  Case 12:
                     Caracter = Lookupstr(lock_key , Mat_1)
                  Case 13:
                     Caracter = Lookupstr(lock_key , Mat_2)
                  Case 14:
                     Caracter = Lookupstr(lock_key , Mat_3)
                  Case 15:
                     Caracter = Lookupstr(lock_key , Mat_4)
                  Case 16:
                     Caracter = Lookupstr(lock_key , Mat_5)
               End Select
               If Tul_name < 17 Then
                  Gosub Sound_pressing
                  Locate 2 , Tul_name : Lcd Caracter
               Else
                  Gosub Sound_error
                  Caracter = ""
               End If
            Else
               Gosub Sound_error
            End If
            Case 14:
               If I = 0 Then
                  Gosub Sound_menu
                  Locate 2 , 1 : Lcd Space(16)
                  Name_family = "" : Tul_name = 1 : Cur = 16 : L_cur = 19
               Elseif I = 1 Then
                  I = 0
                  Gosub Sound_menu
                  Gosub Search_phone_number
                  Contacts_name(contacts_counter) = "" : Contacts_number(contacts_counter) = ""
                  Cls : Lcd "Delete Number" : Wait 1
                  Goto Main
               End If
            Case 11:
               Stop Timer1 : Timer1 = 0
               If Caracter <> "" Then
                  'Gosub Sound_menu
                  Cur = 11
                  Name_family = Name_family + Caracter
                  Locate 2 , 1 : Lcd Space(16)
                  Locate 2 , 1 : Lcd Name_family
                  Tul_name = Len(name_family)
                  Incr Tul_name
               End If
               If Name_family <> "" Then
                  Gosub Sound_menu
                  If Menu_1 = 0 Then
                     Gosub Search_phone_number
                     If Contacts_counter >= 1 And Contacts_counter <= 18 Then
                        Gosub Show_contacts_name
                        Gosub Show_contacts_number
                        I = 1
                     Else
                        'Cls
                        Locate 1 , 1 : Lcd Space(16)
                        Locate 1 , 1 : Lcd Name_family
                        Locate 2 , 1 : Lcd Space(16)
                        Locate 2 , 1 : Lcd "Not Found" : Wait 1 : Goto Main
                        Cursor Noblink : Cursor Off
                        I = 1
                     End If
                  End If
                  If Menu_1 = 1 Then
                     'Gosub Search_phone_number
                     Gosub Add_number
                  End If
                  If Menu_1 = 2 Then
                     Gosub Search_phone_number
                     If Contacts_counter >= 1 And Contacts_counter <= 18 Then
                        Gosub Delete
                     Else
                       Locate 1 , 1 : Lcd Space(16)
                       Locate 1 , 1 : Lcd Name_family
                       Locate 2 , 1 : Lcd Space(16)
                       Locate 2 , 1 : Lcd "Not Found" : Wait 1 : Goto Main

                     End If
                  End If
                  If Menu_1 = 4 Then
                     Gosub Add_number
                  End If
               Else
                  Gosub Sound_error
               End If
            Case 15:
               If Menu_1 = 0 And I = 1 Then
                  Gosub Dial_number
                  If Dial_status = 0 Then
                     Gosub Show_contacts_name
                     Gosub Show_contacts_number
                  End If
               End If
            Case 10:
               Gosub Sound_menu
               Goto Main
            'Case Else:
               'Gosub Sound_error
            End Select
         End If
         If Key = 16 Then Key_bit = 1
      Loop Until I3 > 35
      Stop Timer0 : Timer0 = 0 : I3 = 0
      If Caracter <> "" Then
         Gosub Sound_menu
         Cur = 11
         Name_family = Name_family + Caracter
         Locate 2 , 1 : Lcd Space(16)
         Locate 2 , 1 : Lcd Name_family
         Tul_name = Len(name_family)
         Incr Tul_name
      End If
   Loop
Return

'****************************************************
View:
   I = 0
   Contacts_counter = 0
   Goto F1
   'Gosub Show_contacts_name
   'Gosub Show_contacts_number
   Do
      Key = Getkbd() : Key = Lookup(key , Edit_key)
      If Key <> Key_status Then
         Key_status = Key
         Select Case Key
            Case 12:
               Gosub Sound_menu
               F1:
               Incr I
               Incr Contacts_counter : If Contacts_counter > 18 Then Contacts_counter = 1
               Name_family = Contacts_name(contacts_counter) : Waitms 10
               If Name_family <> "" Then
                  I = 0
                  Gosub Show_contacts_name
                  Gosub Show_contacts_number
                  'Locate 1 , 15 : Lcd Chr(3)
                  'Locate 2 , 15 : Lcd Chr(4)
               Else
                  If I < 18 Then
                     Goto F1
                  Else
                     Cls : Lcd "Memory is Empty" : Wait 1 : Goto Main
                  End If
               End If
            Case 13:
               Gosub Sound_menu
               F2:
               Incr I
               Decr Contacts_counter : If Contacts_counter = 0 Then Contacts_counter = 18
               Name_family = Contacts_name(contacts_counter) : Waitms 10
               If Name_family <> "" And Number <> "" Then
                  I = 0
                  Gosub Show_contacts_name
                  Gosub Show_contacts_number
                  'Locate 1 , 15 : Lcd Chr(3)
                  'Locate 2 , 15 : Lcd Chr(4)
              Else
                  If I < 18 Then
                     Goto F2
                  Else
                     Cls : Lcd "Empty Memory"
                  End If
              End If
            Case 10:
               Gosub Sound_menu
               Reset Relay : Waitms 100
               Goto Main
            Case 14:
               Gosub Sound_menu
               Contacts_name(contacts_counter) = "" : Waitms 10
               Contacts_number(contacts_counter) = "" : Waitms 10
               Cls : Lcd "Delete Number" : Wait 1
               Goto F1
            Case 15:
               Gosub Dial_number
               If Dial_status = 0 Then
                  Gosub Show_contacts_name
                  Gosub Show_contacts_number
               End If
         End Select
      End If
   Loop
Return

'****************************************************
Erase_eeprom:
   Cls : Lcd "Erase EEPROM"
   Locate 2 , 1 : Lcd "Please wait ..."
   For I1 = 1 To 18
      Contacts_name(i1) = "" : Waitms 10
      Contacts_number(i1) = "" : Waitms 10
   Next I1
   Locate 2 , 1 : Lcd "Complete Erase" : Wait 1
Return

'****************************************************
Delete:
   Contacts_name(contacts_counter) = "" : Waitms 10
   Contacts_number(contacts_counter) = "" : Waitms 10

   Cls : Lcd "Delete Number" : Wait 1 : Goto Main

Return

'****************************************************
Show_contacts_name:
   Name_family = ""
   Name_family = Contacts_name(contacts_counter) : Waitms 10
   Locate 1 , 1 : Lcd Space(16)
   Locate 1 , 1 : Lcd Name_family
   If Menu_1 = 3 Then
      Locate 1 , 16
      Lcd Chr(2)
   End If
Return

'****************************************************
Show_contacts_number:
   Number = "" : M = 0
   Number = Contacts_number(contacts_counter) : Waitms 10
   Locate 2 , 1 : Lcd Space(16)
   Locate 2 , 1 : Lcd Number
   If Menu_1 = 3 Then
      Locate 2 , 16
      Lcd Chr(3)
   End If
Return

'****************************************
Show_phone_number:
   Find_name = "" : Number = "" : M = 0
   Number = Contacts_number(contacts_counter) : Waitms 10
   Cls
   Locate 1 , 1 : Lcd Name_family
   Locate 2 , 1 : Lcd Number
Return

'****************************************
Search_phone_number:
   Cls : Lcd "Please wait ..."
   Find_name = ""                                           ': Waitms 300
    Contacts_counter = 0
    For I1 = 1 To 18
       Find_name = Contacts_name(i1) : Waitms 10
       If Find_name = Name_family Then
         Contacts_counter = I1
         Goto End_search_phone_number
       End If
    Next I1
    End_search_phone_number:
Return


'****************************************
Add_number:
I = 0

If Menu_1 = 4 Then
   Number = Number_dial
   Goto F4
End If

Cls : Cursor On : Cursor Blink
                  Tul_name = 0 : Cur = 0 : Number = ""
                  Locate 1 , 1 : Lcd "Phone number:"
                  Locate 2 , 1 : Cursor On : Cursor Blink
                  Do
                     Key = Getkbd() : Key = Lookup(key , Edit_key)
                     If Key <> Key_status Then
                        Key_status = Key
                        Select Case Key
                           Case 0 To 9:
                           If I = 0 Then
                              If Cur < 11 Then
                                 Gosub Sound_pressing
                                 Caracter = Str(key)
                                 Number = Number + Caracter
                                 Locate 2 , 1 : Lcd Space(16)
                                 Locate 2 , 1 : Lcd Number
                                 'Tul_name = Len(number)
                              Else
                                 Gosub Sound_error
                              End If
                              Incr Cur
                           Else
                              Gosub Sound_error
                           End If
                           Case 14:
                           If I = 0 Then
                              Gosub Sound_menu
                              Cur = 0 : Number = "" : Caracter = ""
                              Locate 2 , 1 : Lcd Space(16)
                           Elseif I = 1 Then
                              I = 0
                              Gosub Sound_menu
                              Gosub Search_phone_number
                              Contacts_name(contacts_counter) = "" : Waitms 10
                              Contacts_number(contacts_counter) = "" : Waitms 10
                              Cls : Lcd "Delete Number" : Wait 1
                              Goto Main
                           End If

                           Case 11:
                              If I = 0 Then

                              If Number <> "" Then
                                 Gosub Sound_menu
                                 F4:
                                 Gosub Search_phone_number
                                 If Contacts_counter <> 0 Then
                                    Cls
                                    Locate 1 , 1 : Lcd "Replace?"
                                    Locate 2 , 1 : Lcd Name_family
                                    Do
                                       Key = Getkbd() : Key = Lookup(key , Edit_key)
                                       If Key <> Key_status Then
                                          Key_status = Key
                                          Select Case Key
                                             Case 11:
                                                Gosub Sound_menu
                                                 Contacts_name(contacts_counter) = "" : Waitms 10
                                                 Contacts_number(contacts_counter) = "" : Waitms 10

                                                Gosub Save
                                                Gosub Search_phone_number
                                                Gosub Show_contacts_name
                                                Gosub Show_contacts_number
                                                I = 1
                                             Case 10:
                                                Gosub Sound_menu
                                                Goto Main
                                          End Select
                                       End If
                                    Loop
                                 Else
                                    Gosub Save
                                    Gosub Search_phone_number
                                    Gosub Show_contacts_name
                                    Gosub Show_contacts_number
                                    I = 1
                                 End If
                              Else
                                 Gosub Sound_error
                              End If
                           Else
                              Gosub Sound_error
                           End If
                           Case 10:
                              Gosub Sound_menu
                              Goto Main
                           Case 15:
                              If I = 1 Then
                                 Gosub Dial_number
                                 If Dial_status = 0 Then
                                    Gosub Show_contacts_name
                                    Gosub Show_contacts_number
                                 End If
                              End If
                        End Select
                     End If
                  Loop
Return

'****************************************
Save:
   Contacts_counter = 0
   For I = 1 To 18                                          'Step -1
      Find_name = Contacts_name(i) : Waitms 10
      If Find_name = "" Then
         Contacts_counter = I
         Exit For
      End If
   Next I
If Contacts_counter <> 0 Then


  Contacts_name(contacts_counter) = Name_family : Waitms 10
  Contacts_number(contacts_counter) = Number : Waitms 10

  Cls
  Home : Lcd "Saving Number..."
Else
   Cls : Lcd "Full Memory"
End If
  'Name_family = ""
  'Number = ""
  Wait 1
Return


'****************************************************
Start_menu:
   'Cls : Lcd "    Contacts    " : Wait 1 : Cls
   Cls : Cursor Noblink : Cursor Off
   Select Case Menu_1
      Case 0:
         Locate 1 , 4 : Lcd Chr(0)
         Locate 1 , 6 : Lcd "Search"
         Locate 1 , 13 : Lcd Chr(1)
      Case 1:
         Locate 1 , 4 : Lcd Chr(0)
         Locate 1 , 6 : Lcd " Add  "
         Locate 1 , 13 : Lcd Chr(1)
      Case 2:
         Locate 1 , 4 : Lcd Chr(0)
         Locate 1 , 6 : Lcd "Delete"
         Locate 1 , 13 : Lcd Chr(1)
      Case 3:
         Locate 1 , 4 : Lcd Chr(0)
         Locate 1 , 6 : Lcd " View "
         Locate 1 , 13 : Lcd Chr(1)
      Case 4:
         Locate 1 , 4 : Lcd Chr(0)
         Locate 1 , 6 : Lcd " Dial "
         Locate 1 , 13 : Lcd Chr(1)
   End Select
Return

'---------------------------------------------
Dial_number:
If Dial_status = 0 Then
   Name_family = Contacts_number(contacts_counter) : Waitms 100
   If Name_family <> "" Then
      Dial_status = 1
      Locate 1 , 1 : Lcd "Dial ...        "
      Set Relay : Waitms 500
      Dtmfout Name_family , 50
   Else
      Gosub Sound_error
   End If
Else
   Gosub Sound_menu
   Dial_status = 0
   Reset Relay : Waitms 500
   Locate 1 , 1 : Lcd Space(16)
   Locate 1 , 1 : Lcd "End of Dialing"
End If
Return

'***************************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Sound_pin , 30 , 1500
Return

'*************************************************

Mat_1:
Data " " , "1" , "a" , "d" , "g" , "j" , "m" , "p" , "t" , "w"

Mat_2:
Data "0" , "." , "b" , "e" , "h" , "k" , "n" , "q" , "u" , "x"

Mat_3:
Data "-" , "," , "c" , "f" , "i" , "l" , "o" , "r" , "v" , "y"

Mat_4:
Data "(" , "?" , "2" , "3" , "4" , "5" , "6" , "s" , "8" , "z"

Mat_5:
Data ")" , "!" , " " , " " , " " , " " , " " , "7" , " " , "9"

'****************************************************
Edit_key:
Data 1 , 4 , 7 , 10 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 11 , 12 , 13 , 14 , 15 , 16