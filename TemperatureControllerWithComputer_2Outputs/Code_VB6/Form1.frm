VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Thermostat"
   ClientHeight    =   3570
   ClientLeft      =   2025
   ClientTop       =   3375
   ClientWidth     =   10335
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3570
   ScaleWidth      =   10335
   Begin VB.CommandButton Command2 
      Caption         =   "Stop"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4560
      TabIndex        =   11
      Top             =   3120
      Width           =   5655
   End
   Begin VB.Frame Frame4 
      BackColor       =   &H00FFFFC0&
      Caption         =   "Communication"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1155
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   4335
      Begin VB.ComboBox Combo1 
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   11.25
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   2880
         TabIndex        =   9
         Text            =   "1"
         Top             =   480
         Width           =   975
      End
      Begin VB.Label Label7 
         BackColor       =   &H00FFFFC0&
         Caption         =   "COM Port Number"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         TabIndex        =   10
         Top             =   480
         Width           =   1815
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Top             =   3120
      Width           =   4335
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00FFFFC0&
      Caption         =   "Change Setpoint"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1635
      Left            =   120
      TabIndex        =   2
      Top             =   1440
      Width           =   4335
      Begin VB.TextBox Change_Gas_Setpoint 
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         MaxLength       =   4
         TabIndex        =   12
         Top             =   960
         Width           =   915
      End
      Begin VB.TextBox Change_Temp_setpoint 
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   2520
         MaxLength       =   3
         TabIndex        =   4
         Top             =   960
         Width           =   915
      End
      Begin VB.Label Label2 
         BackColor       =   &H00FFFFC0&
         Caption         =   "('c)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Index           =   5
         Left            =   3480
         TabIndex        =   20
         Top             =   960
         Width           =   375
      End
      Begin VB.Label Label3 
         BackColor       =   &H00FFFFC0&
         Caption         =   "Setpoint ( MIN )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Index           =   1
         Left            =   240
         TabIndex        =   19
         Top             =   480
         Width           =   1425
      End
      Begin VB.Label Label2 
         BackColor       =   &H00FFFFC0&
         Caption         =   "('c)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   1320
         TabIndex        =   5
         Top             =   960
         Width           =   375
      End
      Begin VB.Label Label3 
         BackColor       =   &H00FFFFC0&
         Caption         =   "Setpoint ( MAX )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Index           =   0
         Left            =   2520
         TabIndex        =   3
         Top             =   480
         Width           =   1545
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0FF&
      Caption         =   "Temp Monitoring"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2955
      Left            =   4560
      TabIndex        =   0
      Top             =   120
      Width           =   5655
      Begin VB.Label Display_Gas_Setpoint 
         BackColor       =   &H00C0C0FF&
         Caption         =   "150"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   48
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   900
         Left            =   120
         TabIndex        =   18
         Top             =   840
         Width           =   1680
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Setpoint ( MIN )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   210
         Index           =   4
         Left            =   240
         TabIndex        =   17
         Top             =   480
         Width           =   1455
      End
      Begin VB.Label Display_Temp_Setpoint 
         BackColor       =   &H00C0C0FF&
         Caption         =   "150"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   48
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   945
         Left            =   3960
         TabIndex        =   16
         Top             =   840
         Width           =   1560
      End
      Begin VB.Label Display_Temp 
         BackColor       =   &H00C0C0FF&
         Caption         =   "150"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   48
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1035
         Left            =   2040
         TabIndex        =   15
         Top             =   840
         Width           =   1560
      End
      Begin VB.Shape Fan_Status 
         BackColor       =   &H0000C000&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Left            =   2040
         Shape           =   3  'Circle
         Top             =   2040
         Width           =   330
      End
      Begin VB.Label Label6 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Fan Relay  Out"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Left            =   120
         TabIndex        =   14
         Top             =   2040
         Width           =   1590
      End
      Begin VB.Shape relay_out 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Left            =   2040
         Shape           =   3  'Circle
         Top             =   2400
         Width           =   330
      End
      Begin VB.Label Label5 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Heater Relay  Out"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Left            =   120
         TabIndex        =   13
         Top             =   2400
         Width           =   1590
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Setpoint ( MAX )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   4080
         TabIndex        =   6
         Top             =   480
         Width           =   1455
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Tempreture ( 'c )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   0
         Left            =   2160
         TabIndex        =   1
         Top             =   480
         Width           =   1575
      End
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   0
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      InputLen        =   1
      RThreshold      =   1
      SThreshold      =   1
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'GitHub Account: GitHub.com/AliRezaJoodi

Dim buf As Variant
Dim data(8) As Variant
Dim data_dorost(3)  As Variant
Dim counter As Variant
Dim cs As Variant
Dim sending As Boolean
Dim CPN As Byte
Dim GAS As Single
Dim Z1 As Byte
Dim z2 As Single
Dim s1 As String

'Dim s As Boolean
Private Sub Command1_Click()
    'If s = False Then
    CPN = Val(Combo1.Text)
    MSComm1.CommPort = CPN
    Change_Temp_setpoint.Enabled = True
    Change_Gas_Setpoint.Enabled = True
    MSComm1.PortOpen = True ': s = True
    Command1.Enabled = False
    Command2.Enabled = True
    Combo1.Enabled = False
    'temp_mon.Enabled = True
    'setpoint_mon.Enabled = True
    'If Val(setpoint_change.Text) > 0 And Val(setpoint_change.Text) <= 255 Then sending = True
    'End If
End Sub

Private Sub Command2_Click()
    MSComm1.PortOpen = False
    Command1.Enabled = True
    Command2.Enabled = False
    Combo1.Enabled = True
    'temp_mon.Enabled = False
    'setpoint_mon.Enabled = False
    'temp_mon.Text = ""
    'setpoint_mon.Text = ""
    Change_Temp_setpoint.Enabled = False
    Change_Gas_Setpoint.Enabled = False
    Display_Temp = ""
    Display_Temp_Setpoint = ""
    Display_Gas = ""
    Display_Gas_Setpoint = ""
    relay_out.BackColor = RGB(192, 192, 192)
    Fan_Status.BackColor = RGB(192, 192, 192)
    'Gas_Status.BackColor = RGB(192, 192, 192)
End Sub

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
    'Combo1.Text = 16
    's = False
    Display_Temp = " 0"
    Display_Temp_Setpoint = " 0"
    Display_Gas = " 0"
    Display_Gas_Setpoint = " 0"
    
    relay_out.BackColor = RGB(192, 192, 192)
    Fan_Status.BackColor = RGB(192, 192, 192)
    'Gas_Status.BackColor = RGB(192, 192, 192)
    Command2.Enabled = False
End Sub

Private Sub Label9_Click()

End Sub

Private Sub MSComm1_OnComm()

Select Case MSComm1.CommEvent
        Case comEvReceive
            buf = MSComm1.Input
            buf = Asc(buf)
            Debug.Print buf
            If buf = &HEB And counter = 0 Then
                counter = 1
                data(counter) = buf
                'cs = buf
                Exit Sub
            End If
            
            If counter <> 0 Then
                    counter = counter + 1
                    data(counter) = buf
                     If counter = 6 Then
                            'cs = cs And 255
                            'If data(6) = cs Then
                            'temp_mon.Text = data(2) 'teparature
                            Display_Temp.Caption = data(2)
                            'GAS = data(3) '/ 10
                            'Display_Gas1.txt = GAS
                            'Display_Gas.Caption = GAS
                            'setpoint_mon.Text = data(4) 'set point
                            Display_Temp_Setpoint.Caption = data(3)
                            
                            GAS = data(4) '/ 10
                            Display_Gas_Setpoint.Caption = GAS
                            
                            If data(5) = 0 Then relay_out.BackColor = RGB(192, 192, 192) Else relay_out.BackColor = RGB(255, 0, 0) 'relay out
                            If data(6) = 0 Then Fan_Status.BackColor = RGB(192, 192, 192) Else Fan_Status.BackColor = RGB(0, 225, 50) 'relay out
                            'If data(8) = 0 Then Gas_Status.BackColor = RGB(192, 192, 192) Else Gas_Status.BackColor = RGB(255, 0, 0)
                            'End If
                    counter = 0
                    
                  If sending = True Then
                        sending = False
                        F_BYTE = &HAA
                        cs = F_BYTE
                        MSComm1.Output = Chr$(F_BYTE)
                        If Change_Temp_setpoint.Text = "" Then Change_Temp_setpoint.Text = "255"
                        MSComm1.Output = Chr$(Change_Temp_setpoint.Text)
                        
                        If Change_Gas_Setpoint.Text = "" Then Change_Gas_Setpoint.Text = "255"
                        z2 = Val(Change_Gas_Setpoint.Text)
                        z2 = z2 '* 10
                        s1 = Str(z2)
                        Z1 = Val(s1)
                        MSComm1.Output = Chr$(Z1)
                        
                        'MSComm1.Output = Chr$(setpoint_change.Text)
                        'Label4.Caption = Chr$(Change_Gas_Setpoint.Text)
                        
                        cs = F_BYTE + Change_Temp_setpoint.Text
                        'cs = cs + Change_Gas_Setpoint.Text
                        cs = cs And 255
                        'MSComm1.Output = Chr$(cs)
                        Change_Temp_setpoint.Text = ""
                        Change_Gas_Setpoint.Text = ""
                 End If
                 
                     End If
                    'cs = cs + buf
            End If
End Select

End Sub

Private Sub Change_Temp_setpoint_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then sending = True
End Sub

Private Sub Change_Gas_Setpoint_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then sending = True
End Sub

