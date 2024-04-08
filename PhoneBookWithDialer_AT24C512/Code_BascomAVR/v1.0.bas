'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portd , Debounce = 30 , Delay = 100

Config Portb.0 = Output : Portb.0 = 0 : Sound_pin Alias Portb.0

Config Timer1 = Timer , Prescale = 1024

Config Scl = Portc.0
Config Sda = Portc.1
Config I2cdelay = 1

Declare Function Write_eeprom(address As Word , Caracter As String ) As String
Declare Function Read_eeprom(address As Word ) As String

Deflcdchar 0 , 32 , 2 , 6 , 14 , 30 , 14 , 6 , 2
Deflcdchar 1 , 32 , 8 , 12 , 14 , 15 , 14 , 12 , 8

Dim Key As Byte
Dim Key_status As Byte
Dim Key_old As Byte

Dim Menu_1 As Byte : Menu_1 = 0

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

Dim Find_address As Word , Find_bit As Bit
Dim Find_name As String * 16 , Find_namee As String * 16

Cur = 16
L_cur = 19

Main:
'Cursor Noblink :Cursor Off
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
            Incr Menu_1 : If Menu_1 > 2 Then Menu_1 = 0
            Gosub Start_menu
         Case 13:
            Gosub Sound_menu
            Decr Menu_1 : If Menu_1 > 2 Then Menu_1 = 3
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
            Else
               Gosub Sound_error
            End If
         Case Else:
            If Key <> 16 Then Gosub Sound_error
      End Select
   End If
Loop

End

'*****************************
Key_test:
   Do
      Key = Getkbd() : Key = Lookup(key , Edit_key)
      If Key < 16 Then
         Gosub Sound_menu
         Cls : Lcd Key
      End If
   Loop
Return

'*****************************
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
      Stop Timer1 : Timer1 = 0 : Caracter = ""
      Do
         Key = Getkbd() : Key = Lookup(key , Edit_key)
         If Key <> Key_status Then
            Key_status = Key
            Select Case Key
            Case 0 To 9
            If I = 0 Then
               Start Timer1 : Timer1 = 0
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
                  Caracter = Chr(255)
                  Caracter = Write_eeprom(find_address , Caracter)
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
                     If Find_address < 65535 Then
                        'Gosub Show_phone_number
                        Gosub Show_contacts_name
                        Gosub Show_contacts_number
                        I = 1
                     Else
                        'Cls
                        Locate 1 , 1 : Lcd Space(16)
                        Locate 1 , 1 : Lcd Name_family
                        Locate 2 , 1 : Lcd Space(16)
                        Locate 2 , 1 : Lcd "not found"      ':Wait 1
                        Cursor Noblink : Cursor Off

                        I = 1
                        'Gosub Start_menu
                        'Return
                        'Goto Main
                     End If
                  End If
                  If Menu_1 = 1 Then
                     'Gosub Search_phone_number
                     Gosub Add_number
                  End If
                  If Menu_1 = 2 Then
                     Gosub Search_phone_number
                     If Find_address < 65535 Then
                        Gosub Delete

                     Else
                       'Cls
                       'Locate 1 , 1 : Lcd "not found"
                       Locate 1 , 1 : Lcd Space(16)
                       Locate 1 , 1 : Lcd Name_family
                       Locate 2 , 1 : Lcd Space(16)
                       Locate 2 , 1 : Lcd "not found"       ':Wait 1

                     End If
                  End If
               Else
                  Gosub Sound_error
               End If
            Case 10:
               Gosub Sound_menu
               Goto Main
            'Case Else:
               'Gosub Sound_error
            End Select
         End If
         If Key = 16 Then Key_bit = 1
      Loop Until Timer1 > 9000
      Stop Timer1 : Timer1 = 0
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

'*****************************
View:
   Find_address = 0
   Gosub Show_contacts_name
   Gosub Show_contacts_number
   Do
      Key = Getkbd() : Key = Lookup(key , Edit_key)
      If Key <> Key_status Then
         Key_status = Key
         Select Case Key
            Case 12:
               Gosub Sound_menu
               F1:
               Find_address = Find_address + 30 : If Find_address > 65482 Then Find_address = 0
               'Gosub Search_phone_number
               'If Find_address < 65535 Then
               If Name_family <> "" And Number <> "" Then
                  Gosub Show_contacts_name
                  Gosub Show_contacts_number
               End If
               'Else

               'End If
            Case 13:
               Gosub Sound_menu
               Find_address = Find_address - 30 : If Find_address > 65482 Then Find_address = 0
               'Gosub Search_phone_number
               'If Find_address < 65535 Then
               If Name_family <> "" And Number <> "" Then
                  Gosub Show_contacts_name
                  Gosub Show_contacts_number
               End If
               'Else

               'End If
            Case 10:
               Gosub Sound_menu
               Goto Main
            Case 14:
               Gosub Sound_menu
               Caracter = Chr(255)
               Caracter = Write_eeprom(find_address , Caracter)
              Goto F1
         End Select
      End If
   Loop
Return

'*****************************
Erase_eeprom:
   Cls : Lcd "Erase EEPROM"
   Locate 2 , 1 : Lcd "Please wait ..."
   For I1 = 0 To 500
      Caracter = Chr(255)
      Caracter = Write_eeprom(i , Caracter)
   Next I1
   Locate 2 , 1 : Lcd "Complete Erase" : Wait 1
Return

'*****************************
Delete:
   'Cls : Lcd Find_address : Wait 2
   Caracter = Chr(255)
   Caracter = Write_eeprom(find_address , Caracter)

   Cls : Lcd "Delete Number" : Wait 1
   Goto Main
Return

'*****************************
Show_contacts_name:
   Name_family = ""
   For I1 = Find_address To I2
       Caracter = Read_eeprom(i1)
       If Data_rw = 255 Then Exit For
       Caracter = Chr(data_rw)
       Name_family = Name_family + Caracter
   Next
   Locate 1 , 1 : Lcd Space(16)
   Locate 1 , 1 : Lcd Name_family
Return

'*****************************
Show_contacts_number:
   Number = "" : M = 0
   Address_block = Find_address + 17
   M = Address_block + 14
   For I1 = Address_block To M
       Caracter = Read_eeprom(i1)
       If Data_rw = 255 Then Exit For
       Caracter = Chr(data_rw)
       Number = Number + Caracter
   Next
   Locate 2 , 1 : Lcd Space(16)
   Locate 2 , 1 : Lcd Number
Return

'****************************************
Show_phone_number:
   Find_name = "" : Number = "" : M = 0
   'I2 = Find_address + 16
   'For I1 = Find_address To I2
       'Caracter = Read_eeprom(i1)
       'If Data_rw = 255 Then Exit For
       'Caracter = Chr(data_rw)
       'Name_family = Name_family + Caracter
   'Next
   Address_block = Find_address + 17
   M = Address_block + 14
   For I1 = Address_block To M
       Caracter = Read_eeprom(i1)
       If Data_rw = 255 Then Exit For
       Caracter = Chr(data_rw)
       Number = Number + Caracter
   Next
   Cls
   Locate 1 , 1 : Lcd Name_family
   Locate 2 , 1 : Lcd Number
   'Waitms 2000
Return

'****************************************
Search_phone_number:
   Cls : Lcd "Please wait ..."
   Find_name = ""                                           ': Waitms 300
   For I1 = 0 To 65535 Step 30
      Tul_name = Len(name_family) : Tul_name = Tul_name + I1 : Decr Tul_name
      For I2 = I1 To Tul_name
         Caracter = Read_eeprom(i2)
         If Data_rw = 255 Then Exit For
         Caracter = Chr(data_rw)
         Find_name = Find_name + Caracter
      Next
      'Cls : Lcd Find_name : Waitms 2000
      If Find_name = Name_family Then
         Find_address = I1
         'Cls : Lcd Find_address : Waitms 2000
         Goto End_search_phone_number
      End If
      Find_name = ""
    Next
    'Cls:lcd i2:wait 5
    If I2 > 65519 Then Find_address = 65535
    End_search_phone_number:
Return

'****************************************
Find:
Cls
Cursor Off
   Sound Portb.0 , 100 , 500
   For Address_block = Find_address To 65535 Step 30
       Tul_name = Len(name_family)
       Tul_name = Tul_name + Address_block
       Decr Tul_name
       For I = Address_block To Tul_name
         Caracter = Read_eeprom(i)
         If Data_rw = 255 Then Exit For
         Caracter = Chr(data_rw)
         Find_name = Find_name + Caracter
       Next
      If Find_name = Name_family Then
         Cls : Lcd I : Waitms 2000
         Find_name = ""
         Find_address = Address_block + 30
         M = Address_block + 16
         For I = Address_block To M
            Caracter = Read_eeprom(i)
            If Data_rw = 255 Then Exit For
            Caracter = Chr(data_rw)
            Find_namee = Find_namee + Caracter
         Next

         Address_block = Address_block + 17
         M = Address_block + 14

         For I = Address_block To M
         Caracter = Read_eeprom(i)
            If Data_rw = 255 Then Exit For
            Caracter = Chr(data_rw)
            Number = Number + Caracter

         Next

         Home : Lcd Find_namee
         Home L : Lcd Number
         Find_bit = 1
         Find_namee = ""
         Number = ""
      End If
         Find_name = ""
   Next

   If Address_block = 65536 Then
      Find_address = 0
      Home L : Lcd "not found       "
      Home : Lcd Name_family
      Cursor On
   End If
Return

'****************************************
Add_number:
I = 0
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
                              Caracter = Chr(255)
                              Caracter = Write_eeprom(find_address , Caracter)
                              Cls : Lcd "Delete Number" : Wait 1
                              Goto Main
                           End If

                           Case 11:
                              If I = 0 Then
                              If Number <> "" Then
                                 Gosub Sound_menu
                                 Gosub Search_phone_number
                                 If Find_address < 65535 Then
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
                                                Caracter = Chr(255)
                                                Caracter = Write_eeprom(find_address , Caracter)
                                                Gosub Save
                                                Gosub Search_phone_number
                                                Gosub Show_contacts_name
                                                Gosub Show_contacts_number
                                                I = 1
                                                'Wait 5
                                                'Goto Main
                                             Case 10:
                                                Gosub Sound_menu
                                                Goto Main
                                             'Case 10:
                                                'Goto Main
                                          End Select
                                       End If
                                    Loop
                                 Else
                                    Gosub Save
                                    Gosub Search_phone_number
                                    Gosub Show_contacts_name
                                    Gosub Show_contacts_number
                                    I = 1
                                    'Wait 5
                                    'Goto Main
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
                        End Select
                     End If
                  Loop
Return

'****************************************
Save:
   For Address_block = 0 To 65535 Step 30                   ' address to 2100
      Caracter = Read_eeprom(address_block)
      If Data_rw = 255 Then Exit For
   Next
   'Name_family = Name_family + Chr(255)
   Tul_name = Len(name_family)
   Tul_name = Tul_name + Address_block
   J = 0
   For I = Address_block To Tul_name
      Incr J
      Caracter = Mid(name_family , J , 1)
      Caracter = Write_eeprom(i , Caracter)
   Next
   Caracter = Chr(255)
   I = I + 1 : Caracter = Write_eeprom(i , Caracter)

   Address_block = Address_block + 17
   'Number = Number + Chr(255)
   Tul_name = Len(number)
   Tul_name = Tul_name + Address_block
   J = 0
   For I = Address_block To Tul_name
     Address_low = Low(i)
     Address_high = High(i)
     Caracter = Mid(number , J , 1)
     Caracter = Write_eeprom(i , Caracter)
     Incr J
   Next
   Caracter = Chr(255)
   I = I + 1
   Address_low = Low(i)
   Address_high = High(i)
   Caracter = Write_eeprom(i , Caracter)

  Cls
  Home : Lcd "Saving Number..."
  'Name_family = ""
  'Number = ""
  Wait 1
Return

'*****************************
Function Write_eeprom(address As Word , Caracter As String * 1 )
   Address_low = Low(address)
   Address_high = High(address)
   Data_rw = Asc(caracter)
   I2cstart
   I2cwbyte 160
   I2cwbyte Address_high
   I2cwbyte Address_low
   I2cwbyte Data_rw
   I2cstop
   Waitms 10
End Function

'*****************************
Function Read_eeprom(address As Word )as String
   Address_low = Low(address)
   Address_high = High(address)
   I2cstart
   I2cwbyte 160
   I2cwbyte Address_high
   I2cwbyte Address_low
   I2cstart
   I2cwbyte 161
   I2crbyte Data_rw , Nack
   I2cstop
   Read_eeprom = Chr(data_rw)
End Function


'*****************************
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
   End Select
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


Edit_key:
Data 15 , 11 , 0 , 10 , 13 , 6 , 5 , 4 , 14 , 9 , 8 , 7 , 12 , 3 , 2 , 1 , 16