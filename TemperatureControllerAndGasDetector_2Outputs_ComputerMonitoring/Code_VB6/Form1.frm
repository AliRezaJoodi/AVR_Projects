VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Temperature Controller And Gas Detector"
   ClientHeight    =   4575
   ClientLeft      =   60
   ClientTop       =   225
   ClientWidth     =   9510
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4575
   ScaleWidth      =   9510
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame5 
      BackColor       =   &H00C0C0FF&
      Caption         =   "Gas Monitoring"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1575
      Left            =   5040
      TabIndex        =   17
      Top             =   2400
      Width           =   4335
      Begin VB.Label Display_Gas_Setpoint 
         BackColor       =   &H00C0C0FF&
         Caption         =   "3.9"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   2800
         TabIndex        =   28
         Top             =   760
         Width           =   600
      End
      Begin VB.Label Display_Gas 
         BackColor       =   &H00C0C0FF&
         Caption         =   "3.9"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   2800
         TabIndex        =   27
         Top             =   300
         Width           =   600
      End
      Begin VB.Shape Gas_Status 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Left            =   2800
         Shape           =   3  'Circle
         Top             =   1220
         Width           =   330
      End
      Begin VB.Label Label8 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Gas Alarm  Out"
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
         Left            =   240
         TabIndex        =   22
         Top             =   1220
         Width           =   1590
      End
      Begin VB.Label Label2 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Volt"
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
         Index           =   4
         Left            =   3700
         TabIndex        =   21
         Top             =   760
         Width           =   495
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "GAS Setpoint"
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
         TabIndex        =   20
         Top             =   760
         Width           =   1455
      End
      Begin VB.Label Label2 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Volt"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Index           =   3
         Left            =   3700
         TabIndex        =   19
         Top             =   300
         Width           =   615
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "GAS"
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
         Index           =   3
         Left            =   240
         TabIndex        =   18
         Top             =   300
         Width           =   735
      End
   End
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
      Left            =   5040
      TabIndex        =   13
      Top             =   4080
      Width           =   4335
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
      Height          =   1275
      Left            =   120
      TabIndex        =   10
      Top             =   120
      Width           =   4815
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
         Left            =   3240
         TabIndex        =   11
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
         TabIndex        =   12
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
      TabIndex        =   9
      Top             =   4080
      Width           =   4815
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
      Height          =   2475
      Left            =   120
      TabIndex        =   3
      Top             =   1560
      Width           =   4815
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
         Left            =   3240
         MaxLength       =   4
         TabIndex        =   15
         Top             =   1550
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
         Left            =   3240
         MaxLength       =   3
         TabIndex        =   5
         Top             =   550
         Width           =   915
      End
      Begin VB.Label Label2 
         BackColor       =   &H00FFFFC0&
         Caption         =   "Volt"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Index           =   5
         Left            =   4320
         TabIndex        =   16
         Top             =   1600
         Width           =   375
      End
      Begin VB.Label Label4 
         BackColor       =   &H00FFFFC0&
         Caption         =   "Gas Setpoint ( 0 to 5Volt )"
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
         Left            =   240
         TabIndex        =   14
         Top             =   1600
         Width           =   2500
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
         Left            =   4320
         TabIndex        =   6
         Top             =   600
         Width           =   375
      End
      Begin VB.Label Label3 
         BackColor       =   &H00FFFFC0&
         Caption         =   " Temp Setpoint ( 0 to150 'c )"
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
         Left            =   240
         TabIndex        =   4
         Top             =   600
         Width           =   2500
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
      Height          =   2115
      Left            =   5040
      TabIndex        =   0
      Top             =   120
      Width           =   4335
      Begin VB.Label Display_Temp_Setpoint 
         BackColor       =   &H00C0C0FF&
         Caption         =   "33"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   2800
         TabIndex        =   26
         Top             =   720
         Width           =   600
      End
      Begin VB.Label Display_Temp 
         BackColor       =   &H00C0C0FF&
         Caption         =   "33"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   2800
         TabIndex        =   25
         Top             =   300
         Width           =   600
      End
      Begin VB.Shape Fan_Status 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Left            =   2800
         Shape           =   3  'Circle
         Top             =   1680
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
         Left            =   240
         TabIndex        =   24
         Top             =   1680
         Width           =   1590
      End
      Begin VB.Shape relay_out 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Left            =   2800
         Shape           =   3  'Circle
         Top             =   1220
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
         Left            =   240
         TabIndex        =   23
         Top             =   1220
         Width           =   1590
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Setpoint"
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
         Index           =   1
         Left            =   240
         TabIndex        =   8
         Top             =   760
         Width           =   1365
      End
      Begin VB.Label Label2 
         BackColor       =   &H00C0C0FF&
         Caption         =   "'c"
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
         Index           =   2
         Left            =   3700
         TabIndex        =   7
         Top             =   800
         Width           =   375
      End
      Begin VB.Label Label2 
         BackColor       =   &H00C0C0FF&
         Caption         =   "'c"
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
         Index           =   0
         Left            =   3700
         TabIndex        =   2
         Top             =   300
         Width           =   375
      End
      Begin VB.Label Label1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "Tempreture"
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
         Index           =   0
         Left            =   240
         TabIndex        =   1
         Top             =   300
         Width           =   1455
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
    Gas_Status.BackColor = RGB(192, 192, 192)
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
    Gas_Status.BackColor = RGB(192, 192, 192)
    Command2.Enabled = False
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
                     If counter = 8 Then
                            'cs = cs And 255
                            'If data(6) = cs Then
                            'temp_mon.Text = data(2) 'teparature
                            Display_Temp.Caption = data(2)
                            GAS = data(3) / 10
                            'Display_Gas1.txt = GAS
                            Display_Gas.Caption = GAS
                            'setpoint_mon.Text = data(4) 'set point
                            Display_Temp_Setpoint.Caption = data(4)
                            
                            GAS = data(5) / 10
                            Display_Gas_Setpoint.Caption = GAS
                            
                            If data(6) = 0 Then relay_out.BackColor = RGB(192, 192, 192) Else relay_out.BackColor = RGB(255, 0, 0) 'relay out
                            If data(7) = 0 Then Fan_Status.BackColor = RGB(192, 192, 192) Else Fan_Status.BackColor = RGB(255, 0, 0) 'relay out
                            If data(8) = 0 Then Gas_Status.BackColor = RGB(192, 192, 192) Else Gas_Status.BackColor = RGB(255, 0, 0)
                            'End If
                    counter = 0
                    
                  If sending = True Then
                        sending = False
                        F_BYTE = &HAA
                        cs = F_BYTE
                        MSComm1.Output = Chr$(F_BYTE)
                        If Change_Temp_setpoint.Text = "" Then Change_Temp_setpoint.Text = "255"
                        MSComm1.Output = Chr$(Change_Temp_setpoint.Text)
                        
                        If Change_Gas_Setpoint.Text = "" Then Change_Gas_Setpoint.Text = "10"
                        z2 = Val(Change_Gas_Setpoint.Text)
                        z2 = z2 * 10
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

