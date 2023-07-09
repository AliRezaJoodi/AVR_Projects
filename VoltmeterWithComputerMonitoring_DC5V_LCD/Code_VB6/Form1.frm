VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H00E0E0E0&
   Caption         =   "Voltmeter"
   ClientHeight    =   2040
   ClientLeft      =   2445
   ClientTop       =   2985
   ClientWidth     =   9480
   LinkTopic       =   "Form1"
   NegotiateMenus  =   0   'False
   ScaleHeight     =   2040
   ScaleWidth      =   9480
   Begin MSCommLib.MSComm MSComm1 
      Left            =   8760
      Top             =   360
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Communication"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   14.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1875
      Index           =   1
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   4335
      Begin VB.ComboBox Combo1 
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   14.25
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   435
         Left            =   2880
         TabIndex        =   8
         Text            =   "1"
         Top             =   480
         Width           =   1215
      End
      Begin VB.CommandButton Command_Start 
         Caption         =   "Connect"
         Height          =   375
         Left            =   240
         TabIndex        =   7
         Top             =   1320
         Width           =   1815
      End
      Begin VB.CommandButton Command_Stop 
         Caption         =   "Disconnect"
         Height          =   375
         Left            =   2280
         TabIndex        =   6
         Top             =   1320
         Width           =   1815
      End
      Begin VB.Label Label1 
         BackColor       =   &H00E0E0E0&
         Caption         =   "COM Port Number:"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   0
         Left            =   120
         TabIndex        =   9
         Top             =   495
         Width           =   2655
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Monitoring"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   14.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1875
      Index           =   0
      Left            =   4560
      TabIndex        =   0
      Top             =   120
      Width           =   4815
      Begin VB.Label Display_1 
         BackColor       =   &H00E0E0E0&
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   27.75
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2640
         TabIndex        =   4
         Top             =   360
         Width           =   1560
      End
      Begin VB.Label Label2 
         BackColor       =   &H00E0E0E0&
         Caption         =   "Input (V):"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   24
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   600
         Left            =   240
         TabIndex        =   3
         Top             =   360
         Width           =   2055
      End
      Begin VB.Label Label3 
         BackColor       =   &H00E0E0E0&
         Caption         =   "Input (mV):"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   24
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   240
         TabIndex        =   2
         Top             =   1080
         Width           =   2295
      End
      Begin VB.Label Display_2 
         BackColor       =   &H00E0E0E0&
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   27.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2640
         TabIndex        =   1
         Top             =   1080
         Width           =   2055
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'GitHub Account: GitHub.com/AliRezaJoodi

Dim buffer As Variant
Dim CPN As Byte
Dim input_mv As Single
Dim input_v As Single
Dim text As String

Private Sub Form_Load()
MSComm1.Settings = "9600,N,8,1"
MSComm1.RThreshold = 1
MSComm1.SThreshold = 1
MSComm1.InputLen = 1
    Combo1.Clear
    For CPN = 1 To 16
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.text = Combo1.List(0)
    Command_Stop.Enabled = False
    Display_1.Caption = "0"
    Display_2.Caption = "0"
End Sub

Private Sub Command_Start_Click()
    CPN = Val(Combo1.text)
    MSComm1.CommPort = CPN
    MSComm1.PortOpen = True
    Command_Start.Enabled = False
    Command_Stop.Enabled = True
    Combo1.Enabled = False
End Sub

Private Sub Command_Stop_Click()
    MSComm1.PortOpen = False
    Command_Start.Enabled = True
    Command_Stop.Enabled = False
    Combo1.Enabled = True
    Display_1.Caption = "0"
    Display_2.Caption = "0"
End Sub

Private Sub MSComm1_OnComm()
    Select Case MSComm1.CommEvent
        Case comEvReceive
            buffer = MSComm1.Input
            buffer = Asc(buffer)
            Debug.Print buffer
            If buf = 13 Then
                input_mv = Val(text)
                input_v = input_mv / 1000
                Display_1.Caption = input_v
                Display_2.Caption = input_mv
                text = ""
            ElseIf 33 < buffer And buffer < 126 Then
                text = text + Chr(buffer)
            End If
    End Select
End Sub



