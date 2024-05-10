VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H80000004&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Transmit text with wireless communication"
   ClientHeight    =   1290
   ClientLeft      =   3195
   ClientTop       =   3825
   ClientWidth     =   4170
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   12
      Charset         =   178
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1290
   ScaleWidth      =   4170
   Begin VB.TextBox Text2 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   405
      Left            =   120
      MaxLength       =   16
      TabIndex        =   3
      Top             =   840
      Width           =   3975
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   25
      Left            =   1920
      Top             =   0
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   3240
      TabIndex        =   2
      Text            =   "1"
      Top             =   0
      Width           =   855
   End
   Begin VB.TextBox Text1 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   405
      Left            =   120
      MaxLength       =   16
      TabIndex        =   0
      Top             =   360
      Width           =   3975
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   2280
      Top             =   0
      _ExtentX        =   794
      _ExtentY        =   794
      _Version        =   393216
      DTREnable       =   -1  'True
      InputLen        =   1024
   End
   Begin VB.Label Label1 
      BackColor       =   &H80000004&
      Caption         =   "COM Port Number"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   11.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   200
      Left            =   0
      TabIndex        =   1
      Top             =   30
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'GitHub Account: GitHub.com/AliRezaJoodi

Dim CPN As Byte
Dim i As Byte
Dim status_lcd As Byte
Dim Highest_value_of_The_Send As Byte
Dim e As Byte

Private Sub Form_Load()
    MSComm1.Settings = "9600,N,8,1"
    MSComm1.RThreshold = 1
    MSComm1.SThreshold = 1
    MSComm1.InputLen = 1

    Combo1.Clear
    For CPN = 1 To 16
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.Text = Combo1.List(0)
    i = 1
    status_lcd = 0
    e = 0
    Highest_value_of_The_Send = 10 + 48
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
        MSComm1.PortOpen = True
        status_lcd = 1: i = 48: e = 1
        Text1.Enabled = False
        Text2.Enabled = False
        Combo1.Enabled = False
        Timer1.Enabled = True
    End If
End Sub

Private Sub Text2_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
        MSComm1.PortOpen = True
        status_lcd = 2: i = 48: e = 1
        Text1.Enabled = False
        Text2.Enabled = False
        Combo1.Enabled = False
        Timer1.Enabled = True
    End If
End Sub

Private Sub Timer1_Timer()
If e = 1 Then
    i = i + 1
    If status_lcd = 1 Then MSComm1.Output = Chr(1) + Chr(2) + "L1" + Chr(i) + Text1.Text + Chr(13)
    If status_lcd = 2 Then MSComm1.Output = Chr(1) + Chr(2) + "L2" + Chr(i) + Text2.Text + Chr(13)
    If i >= 57 Then
        e = 2: i = 48
    End If
ElseIf e = 2 Then
    i = i + 1
    MSComm1.Output = Chr(1) + Chr(2) + "CD" + Chr(13)
    If i >= 57 Then
        e = 3: i = 48
    End If
ElseIf e = 3 Then
    MSComm1.PortOpen = False
    Timer1.Enabled = False
    If status_lcd = 1 Then
        Text2.Enabled = True
        Text1.Enabled = True
    End If
    If status_lcd = 2 Then
        Text1.Enabled = True
        Text2.Enabled = True
    End If
    Combo1.Enabled = True
    status_lcd = 0: i = 48: e = 0
End If

End Sub
