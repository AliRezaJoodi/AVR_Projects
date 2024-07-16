VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H00C0E0FF&
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Temperature Monitoring"
   ClientHeight    =   3465
   ClientLeft      =   60
   ClientTop       =   225
   ClientWidth     =   8925
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3465
   ScaleWidth      =   8925
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
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
      TabIndex        =   18
      Top             =   3000
      Width           =   4335
   End
   Begin VB.Frame Frame4 
      BackColor       =   &H00FFFFC0&
      Caption         =   "Communication"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1275
      Left            =   120
      TabIndex        =   15
      Top             =   120
      Width           =   4335
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
         Left            =   2880
         TabIndex        =   16
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
         TabIndex        =   17
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
      TabIndex        =   14
      Top             =   3000
      Width           =   4335
   End
   Begin VB.Frame Frame3 
      BackColor       =   &H00C0FFFF&
      Caption         =   "Output"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1275
      Left            =   4560
      TabIndex        =   8
      Top             =   1560
      Width           =   4335
      Begin VB.Shape relay_out 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Left            =   2880
         Shape           =   3  'Circle
         Top             =   480
         Width           =   330
      End
      Begin VB.Label Label5 
         BackColor       =   &H00C0FFFF&
         Caption         =   "Relay Out"
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
         Left            =   765
         TabIndex        =   9
         Top             =   480
         Width           =   1230
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00FFFFC0&
      Caption         =   "Control "
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1275
      Left            =   120
      TabIndex        =   4
      Top             =   1560
      Width           =   4335
      Begin VB.TextBox setpoint_change 
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
         Left            =   2880
         MaxLength       =   3
         TabIndex        =   6
         Top             =   480
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
         Index           =   1
         Left            =   3840
         TabIndex        =   10
         Top             =   480
         Width           =   375
      End
      Begin VB.Label Label4 
         BackColor       =   &H00FFFFC0&
         Caption         =   "(0...150 'c)"
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
         Left            =   1800
         TabIndex        =   7
         Top             =   480
         Width           =   975
      End
      Begin VB.Label Label3 
         BackColor       =   &H00FFFFC0&
         Caption         =   "Change Setpoint"
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
         Left            =   225
         TabIndex        =   5
         Top             =   480
         Width           =   1860
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0FF&
      Caption         =   "Monitoring"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1275
      Left            =   4560
      TabIndex        =   0
      Top             =   120
      Width           =   4335
      Begin VB.TextBox setpoint_mon 
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
         Locked          =   -1  'True
         TabIndex        =   11
         Top             =   765
         Width           =   915
      End
      Begin VB.TextBox temp_mon 
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
         Locked          =   -1  'True
         TabIndex        =   2
         Top             =   270
         Width           =   915
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
         Height          =   330
         Index           =   1
         Left            =   675
         TabIndex        =   13
         Top             =   810
         Width           =   1005
      End
      Begin VB.Label Label2 
         BackColor       =   &H00C0C0FF&
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
         Index           =   2
         Left            =   3600
         TabIndex        =   12
         Top             =   840
         Width           =   375
      End
      Begin VB.Label Label2 
         BackColor       =   &H00C0C0FF&
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
         Index           =   0
         Left            =   3600
         TabIndex        =   3
         Top             =   360
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
         Height          =   330
         Index           =   0
         Left            =   675
         TabIndex        =   1
         Top             =   315
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
'Github Account: Github.com/AliRezaJoodi

Dim buf As Variant
Dim data(5) As Variant
Dim data_dorost(3)  As Variant
Dim counter As Variant
Dim cs As Variant
Dim sending As Boolean
Dim CPN As Byte

Private Sub Command1_Click()
    'If s = False Then
    CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
    MSComm1.PortOpen = True ': s = True
    Command1.Enabled = False
    Command2.Enabled = True
    Combo1.Enabled = False
    temp_mon.Enabled = True
    setpoint_mon.Enabled = True
    'If Val(setpoint_change.Text) > 0 And Val(setpoint_change.Text) <= 255 Then sending = True
    'End If
End Sub

Private Sub Command2_Click()
    MSComm1.PortOpen = False
    Command1.Enabled = True
    Command2.Enabled = False
    Combo1.Enabled = True
    temp_mon.Enabled = False
    setpoint_mon.Enabled = False
    temp_mon.Text = ""
    setpoint_mon.Text = ""
    relay_out.BackColor = RGB(192, 192, 192)
End Sub

Private Sub Form_Load()
MSComm1.Settings = "9600,N,8,1"
MSComm1.RThreshold = 1
MSComm1.SThreshold = 1
MSComm1.InputLen = 1
    Combo1.Clear
    For CPN = 1 To 254
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.Text = Combo1.List(0)
    
    's = False
    relay_out.BackColor = RGB(192, 192, 192)
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
                cs = buf
                Exit Sub
            End If
            
            If counter <> 0 Then
                    counter = counter + 1
                    data(counter) = buf
                     If counter = 5 Then
                            cs = cs And 255
                            If data(5) = cs Then
                            temp_mon.Text = data(2) 'teparature
                            setpoint_mon.Text = data(3) 'set point
                            If data(4) = 0 Then relay_out.BackColor = RGB(192, 192, 192) Else relay_out.BackColor = RGB(255, 0, 0) 'relay out
                            End If
                    counter = 0
                    
                  If sending = True Then
                        sending = False
                        F_BYTE = &HAA
                        cs = F_BYTE
                        MSComm1.Output = Chr$(F_BYTE)
                        MSComm1.Output = Chr$(setpoint_change.Text)
                        cs = F_BYTE + setpoint_change.Text
                        cs = cs And 255
                        MSComm1.Output = Chr$(cs)
                 End If
                 
                     End If
                    cs = cs + buf
            End If
End Select

End Sub

Private Sub setpoint_change_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then sending = True
End Sub

