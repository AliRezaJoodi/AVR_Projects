VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H80000000&
   Caption         =   "Relay Controler"
   ClientHeight    =   5385
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4980
   LinkTopic       =   "Form1"
   ScaleHeight     =   5385
   ScaleWidth      =   4980
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame2 
      BackColor       =   &H80000000&
      Caption         =   "Relay Controler"
      Height          =   3375
      Left            =   120
      TabIndex        =   5
      Top             =   1800
      Width           =   4815
      Begin VB.CommandButton Command_Relay 
         Caption         =   "Turn off all Relays"
         Height          =   375
         Index           =   9
         Left            =   2640
         TabIndex        =   15
         Top             =   2760
         Width           =   2055
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "Turn on all Relays"
         Height          =   375
         Index           =   8
         Left            =   120
         TabIndex        =   14
         Top             =   2760
         Width           =   2175
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 1"
         Height          =   375
         Index           =   0
         Left            =   120
         TabIndex        =   13
         Top             =   360
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 2"
         Height          =   375
         Index           =   1
         Left            =   120
         TabIndex        =   12
         Top             =   960
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 3"
         Height          =   375
         Index           =   2
         Left            =   120
         TabIndex        =   11
         Top             =   1560
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 4"
         Height          =   375
         Index           =   3
         Left            =   120
         TabIndex        =   10
         Top             =   2160
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 5"
         Height          =   375
         Index           =   4
         Left            =   3120
         TabIndex        =   9
         Top             =   360
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 6"
         Height          =   375
         Index           =   5
         Left            =   3120
         TabIndex        =   8
         Top             =   960
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 7"
         Height          =   375
         Index           =   6
         Left            =   3120
         TabIndex        =   7
         Top             =   1560
         Width           =   1575
      End
      Begin VB.CommandButton Command_Relay 
         Caption         =   "RELAY 8"
         Height          =   375
         Index           =   7
         Left            =   3120
         TabIndex        =   6
         Top             =   2160
         Width           =   1575
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   7
         Left            =   2640
         Shape           =   3  'Circle
         Top             =   2200
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   6
         Left            =   2640
         Shape           =   3  'Circle
         Top             =   1605
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   5
         Left            =   2640
         Shape           =   3  'Circle
         Top             =   1000
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   4
         Left            =   2640
         Shape           =   3  'Circle
         Top             =   400
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   3
         Left            =   1800
         Shape           =   3  'Circle
         Top             =   2200
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   2
         Left            =   1800
         Shape           =   3  'Circle
         Top             =   1600
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   1
         Left            =   1800
         Shape           =   3  'Circle
         Top             =   1000
         Width           =   330
      End
      Begin VB.Shape Display_Relay 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   285
         Index           =   0
         Left            =   1800
         Shape           =   3  'Circle
         Top             =   400
         Width           =   330
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H80000000&
      Caption         =   "Communication"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4815
      Begin MSCommLib.MSComm MSComm1 
         Left            =   2040
         Top             =   360
         _ExtentX        =   1005
         _ExtentY        =   1005
         _Version        =   393216
         DTREnable       =   -1  'True
      End
      Begin VB.CommandButton Command_Stop 
         Caption         =   "STOP"
         Height          =   375
         Left            =   2520
         TabIndex        =   4
         Top             =   1080
         Width           =   2175
      End
      Begin VB.CommandButton Command_Start 
         Caption         =   "START"
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   1080
         Width           =   2175
      End
      Begin VB.ComboBox Combo1 
         Height          =   315
         Left            =   2760
         TabIndex        =   1
         Text            =   "1"
         Top             =   240
         Width           =   1575
      End
      Begin VB.Label Label1 
         BackColor       =   &H80000000&
         Caption         =   "COM Port Number"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   360
         Width           =   1695
      End
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
Dim buf As Variant
Dim counter As Variant
Dim Status_relay As Byte

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
    
    Command_Stop.Enabled = False
    For i = 0 To 9
        Command_Relay(i).Enabled = False
    Next i
    
    For i = 0 To 7
        Display_Relay(i).BackColor = RGB(150, 150, 150)
    Next i
End Sub

Private Sub Command_Start_Click()
    Command_Start.Enabled = False
    Command_Stop.Enabled = True
    Combo1.Enabled = False
    CPN = Val(Combo1.Text)
    MSComm1.CommPort = CPN
    MSComm1.PortOpen = True
    For i = 0 To 9
        Command_Relay(i).Enabled = True
    Next i
End Sub

Private Sub Command_Stop_Click()
    Command_Stop.Enabled = False
    Command_Start.Enabled = True
    MSComm1.PortOpen = False
    Combo1.Enabled = True
    For i = 0 To 9
        Command_Relay(i).Enabled = False
    Next i
    For i = 0 To 7
        Display_Relay(i).BackColor = RGB(150, 150, 150)
    Next i
End Sub

Private Sub Command_Relay_Click(Index As Integer)
    MSComm1.Output = Chr(97 + Index) + Chr(13)
End Sub

Private Sub MSComm1_OnComm()
    Select Case MSComm1.CommEvent
        Case comEvReceive
            buf = MSComm1.Input
            buf = Asc(buf)
            If buf = &HEB And counter = 0 Then
                counter = 1
                Exit Sub
            End If
            If counter = 1 Then
                Status_relay = buf
                For i = 0 To 7
                    If (Status_relay And (2 ^ i)) >= 1 Then
                        Display_Relay(i).BackColor = RGB(250, 0, 0)
                    Else
                        Display_Relay(i).BackColor = RGB(150, 150, 150)
                    End If
                Next i
                counter = 0
            End If
    End Select
End Sub
