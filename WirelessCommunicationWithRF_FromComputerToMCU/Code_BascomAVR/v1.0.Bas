'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$prog &HFC , &HFF , &HD1 , &H00                             ' generated. Take care that the chip supports all fuse bytes.

Config Lcdpin = Pin , Rs = Pina.0 , E = Pina.2 , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portd.3 = Input
Config Portb.0 = Output : Portb.0 = 0 : Led_pin Alias Portb.0

Enable Interrupts

$baud = 9600
On Urxc Uart_receiver
Enable Urxc

Const Address_start1 = "L1"
Const Address_stop = "CD"

Const Address_start2 = "L2"

Dim Z As Byte
Dim S As String * 20 : S = ""
Dim Address As String * 3
Dim Status_lcd As Byte

Dim Text_r(20) As String * 16
Dim Text As String * 16

Dim Price(20) As Byte
Dim Max_price As Byte

Dim I As Byte
Dim K As Byte
'Dim J As Byte
Dim N As Byte
Dim N_str As String * 1

Dim E1 As Bit : E1 = 0
Dim E2 As Bit : E2 = 0
Dim E3 As Bit : E3 = 0
Dim E4 As Bit : E4 = 0

Gosub Test

Do

Loop

End

'**************************************************
Uart_receiver:
   Z = Udr
   If Z = 1 Or E1 = 1 Then
      E1 = 1
      If Z = 2 Or E2 = 1 Then
      E2 = 1
      Select Case Z
         Case 32 To 126:
            S = S + Chr(z)
         Case 13:
            Disable Urxc
            Address = Mid(s , 1 , 2)
            If Address = Address_start1 Then
               Set Led_pin
               'N_str = Mid(s , 3 , 1) : N = Val(n_str)
               Incr N
               Status_lcd = 1
               Text_r(n) = Mid(s , 4 , 16)
               'If N > 8 Then Gosub Test_r
               'Reset Led_pin
            Elseif Address = Address_start2 Then
               Set Led_pin
               'N_str = Mid(s , 3 , 1) : N = Val(n_str)
               Incr N
               Status_lcd = 2
               Text_r(n) = Mid(s , 4 , 16)
               'If N > 8 Then Gosub Test_r
               'Reset Led_pin
            Elseif Address = Address_stop Then
               Gosub Encode
            End If
            S = "" : Address = "" : E1 = 0 : E2 = 0 : E3 = 0
            Enable Urxc
      End Select
      End If
   End If
Return

'**************************************************
Encode:
Set Led_pin
   Disable Urxc

   For I = 1 To N
      For K = 1 To N
         If Text_r(i) = Text_r(k) Then Incr Price(i)
      Next K
   Next I

   K = 0 : Max_price = 1 : Text = ""
   For I = 1 To N
      If Price(i) > Max_price Then
         Text = Text_r(i)
         Max_price = Price(i)
      Else
         'Text = "Error"
      End If
   Next I

   Cursor Off
   If Status_lcd = 1 Then
      Locate 1 , 1 : Lcd Space(16)
      Locate 1 , 1 : Lcd Text
   Elseif Status_lcd = 2 Then
      Locate 2 , 1 : Lcd Space(16)
      Locate 2 , 1 : Lcd Text
   End If

   For I = 1 To 20
      Price(i) = 0 : Text_r(i) = ""
   Next I
   N = 0 : K = 0
   Waitms 500
   Reset Led_pin
   Enable Urxc
Return

'**************************************************
Lcd_display:
   Cursor Off
   If Status_lcd = 1 Then
      Locate 1 , 1 : Lcd Space(16)
      Locate 1 , 1 : Lcd Text
   Elseif Status_lcd = 2 Then
      Locate 2 , 1 : Lcd Space(16)
      Locate 2 , 1 : Lcd Text
   End If
Return

'**************************************************
Test:
   Set Led_pin
   Locate 1 , 1 : Lcd "Send Text of the"
   Locate 2 , 1 : Lcd "       PC"
   Wait 1 : Cls
   Reset Led_pin
   Cursor On : Cursor Blink
Return
