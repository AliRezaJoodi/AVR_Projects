'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 4000000


Config Lcdpin = Pin , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7 , E = Pina.2 , Rs = Pina.0
Config Lcd = 16 * 2
Cursor Off
Cls

Deflcdchar 0 , 32 , 4 , 12 , 31 , 12 , 4 , 32 , 32

Config Kbd = Portb , Debounce = 50 , Delay = 250

Config Pind.6 = Input : Portd.6 = 1 : Default Alias Pind.6
Config Portd.5 = Output : Portd.5 = 0 : Speaker Alias Pind.5
Config Portc.3 = Output : Portc.3 = 0 : Relay Alias Portc.3

'Gosub Test

Dim A As Byte
Dim K As Byte
Dim Result As Byte , Num As String * 1
Dim Pass(8) As String * 1 , Pass1(8) As String * 1 , Pass2(8) As String * 1
Dim Pass_eeprom(8) As Eram String * 1 , Rcv(8) As String * 1

Declare Sub Check
Declare Sub Change

Sound Speaker , 120 , 400

If Default = 0 Then
   Waitms 30
   If Default = 0 Then
      Gosub Memoey_erased
   End If
End If

'Gosub Test

Main_1:
Gosub Load_password_of_the_eeprom

Gosub Start_menu



Get_pass_:
   Do
      K = Getkbd()
      If K = 0 Or K = 1 Or K = 2 Or K = 4 Or K = 5 Or K = 6 Or K = 7 Or K = 8 Or K = 9 Or K = 10 Or K = 12 Then
         Num = Lookupstr(k , Decode)
         'Num = K
         Select Case Num
            Case "F1" :
               Gosub Start_menu
               Goto Main_1
               Sound Speaker , 120 , 400
            Case Else:
               Sound Speaker , 120 , 400
               Incr A
               Locate 2 , A : Lcd "*"
               Rcv(a) = Num
               If A = 8 Then
                  Call Check
                  If Result <> 8 Then
                     Sound Speaker , 120 , 650
                     Cls : Home : Lcd "Error!" : Cursor Noblink : Waitms 500
                     Gosub Start_menu
                     Goto Main_1
                  Else
                     Result = 0
                     'Goto Main
                     Gosub Run_menu_dispaly
                     Goto Menu
                  End If
               End If
               Waitms 300
         End Select
      End If
   Loop
Return


'******************************* Main Menu *************************************
Menu:
K = Getkbd() : K = Lookup(k , Key_convert)
If K > 15 Then Goto Menu
If K = 3 Or K = 11 Or K = 15 Then Goto Menu
Sound Speaker , 120 , 400
If K = 12 Then
   Toggle Relay
End If
If K = 13 Then
   Gosub Start_menu
   Goto Main_1
End If
If K = 14 Then Call Change
Waitms 300
Goto Menu
End

'************************** Password Checker Subroutine ************************
Sub Check
   Result = 0
   For A = 1 To 8
      If Rcv(a) = Pass(a) Then Incr Result
   Next A
End Sub
'********************** End Of Password Checker Subroutine *********************

'************************* Change Password Subrounite **************************
Sub Change
Clear1:
A = 0
Cls : Home : Lcd "New Pass?   F1=" ; Chr(0)
Lowerline : Lcd "         F2=Exit"
Sound Speaker , 120 , 600
Home L : Cursor Blink
First:
K = Getkbd() : K = Lookup(k , Key_convert)
If K > 15 Then Goto First
If K = 14 Or K = 3 Or K = 11 Or K = 15 Then Goto First
If K = 12 Then Goto Clear1                                  '<-
If K = 13 Then Goto Main_1                                  'Exit
Sound Speaker , 120 , 400
Incr A
Num = Lookupstr(k , Decode)
Pass1(a) = Num
Locate 2 , A : Lcd "*"
Waitms 300
If A = 8 Then Goto Check1
Goto First
Check1:
Sound Speaker , 120 , 600
A = 0
Cls : Home : Lcd "Confirm     F1=" ; Chr(0)
Lowerline : Lcd "         F2=Exit"
Home L
Last:
K = Getkbd() : K = Lookup(k , Key_convert)
If K > 15 Then Goto Last
If K = 14 Or K = 3 Or K = 11 Or K = 15 Then Goto Last
If K = 13 Then Goto Main_1
If K = 12 Then Goto Check1
Sound Speaker , 120 , 400
Incr A
Num = Lookupstr(k , Decode)
Pass2(a) = Num
Locate 2 , A : Lcd "*"
Waitms 300
If A = 8 Then Goto Check2
Goto Last
Check2:
Cursor Noblink
Result = 0
For A = 1 To 8
   If Pass1(a) = Pass2(a) Then Incr Result
Next A
If Result = 8 Then
   For A = 1 To 8
      Pass(a) = Pass1(a)
      Pass_eeprom(a) = Pass1(a)
      Waitms 20
   Next A
   Cls : Home : Lcd "Pass Changed!"
   Sound Speaker , 120 , 700
   Sound Speaker , 120 , 650
   Sound Speaker , 120 , 600
   Wait 1 : Gosub Start_menu : Goto Main_1
Else
   Sound Speaker , 120 , 650
   Cls : Home : Lcd "Error!" : Waitms 500 : Goto Clear1
End If
End Sub


Memoey_erased:
   For A = 1 To 8
      Pass_eeprom(a) = "1" : Waitms 20
   Next A
   Cursor Off : Cls
   Home : Lcd "Memoey Erased!"
   Lowerline : Lcd "Pass=11111111"
   Sound Speaker , 120 , 600
   Wait 2
Return

Load_password_of_the_eeprom:
   For A = 1 To 8
      Pass(a) = Pass_eeprom(a) : Waitms 20
   Next A
Return

Start_menu:
   Cls : Home : Lcd "Password?   F1=" ; Chr(0)
   Home L : Cursor Blink
   Sound Speaker , 120 , 600
   A = 0
   Wait 1
Return

Run_menu_dispaly:
   Cls : Home : Cursor Noblink : Lcd "F1=Rly   F2=Exit"
   Lowerline : Lcd "F3=Change Pass"
   Sound Speaker , 120 , 700
   Sound Speaker , 120 , 650
   Sound Speaker , 120 , 600
Return

Test:
Do
   K = Getkbd()                                             ': K = Lookup(k , Key_convert)
   If K < 16 Then
      Cls : Lcd K
   End If
Loop
Return

Key_convert_:
Data 3 , 2 , 1 , 0 , 7 , 6 , 5 , 4 , 11 , 10 , 9 , 8 , 15 , 14 , 13 , 12 , 16

Key_convert:
Data 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14 , 15 , 16

'************************** Keypad Decode Data Table ***************************
Decode:
Data "1" , "4" , "7" , "*"
Data "2" , "5" , "8" , "0"
Data "3" , "6" , "9" , "#"
Data "F1" , "F2" , "F3" , "F4"
'************************** End Of KeypadDecode ********************************

Decode_:
Data "*" , "7" , "4" , "1" , "0" , "8" , "5" , "2" , "#" , "9" , "6" , "3" , "F4" , "F3" , "F2" , "F1",