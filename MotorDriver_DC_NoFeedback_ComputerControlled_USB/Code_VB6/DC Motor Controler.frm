VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00E0E0E0&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "DC Motor Controler"
   ClientHeight    =   3600
   ClientLeft      =   1755
   ClientTop       =   3150
   ClientWidth     =   9480
   FillStyle       =   0  'Solid
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   9480
   Begin VB.Frame Frame_Monitoring 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Monitoring"
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000040&
      Height          =   1935
      Index           =   0
      Left            =   4800
      TabIndex        =   5
      Top             =   1560
      Width           =   4575
      Begin VB.Image Image_Stop 
         Enabled         =   0   'False
         Height          =   1350
         Left            =   2880
         Picture         =   "DC Motor Controler.frx":0000
         Top             =   360
         Visible         =   0   'False
         Width           =   1320
      End
      Begin VB.Image Image_clockwise 
         Height          =   1350
         Left            =   2880
         Picture         =   "DC Motor Controler.frx":0FD3
         Top             =   360
         Visible         =   0   'False
         Width           =   1320
      End
      Begin VB.Image Image_Anti_clockwise 
         Height          =   1350
         Left            =   2880
         Picture         =   "DC Motor Controler.frx":16AB
         Top             =   360
         Visible         =   0   'False
         Width           =   1320
      End
      Begin VB.Label Label_PWM 
         BackColor       =   &H00E0E0E0&
         Caption         =   "255"
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   36
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   480
         TabIndex        =   8
         Top             =   720
         Width           =   1335
      End
   End
   Begin VB.Frame Frame_Controler 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Controler"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000040&
      Height          =   1935
      Index           =   2
      Left            =   120
      TabIndex        =   3
      Top             =   1560
      Width           =   4575
      Begin VB.CommandButton Command_Stop 
         BackColor       =   &H00E0E0E0&
         Height          =   735
         Left            =   1680
         Picture         =   "DC Motor Controler.frx":2474
         Style           =   1  'Graphical
         TabIndex        =   11
         Top             =   960
         Width           =   855
      End
      Begin VB.HScrollBar HScroll1 
         Height          =   375
         Left            =   120
         Max             =   255
         TabIndex        =   9
         Top             =   480
         Width           =   4215
      End
      Begin VB.CommandButton Command_Anti_clockwise 
         BackColor       =   &H00E0E0E0&
         Height          =   800
         Left            =   120
         Picture         =   "DC Motor Controler.frx":294E
         Style           =   1  'Graphical
         TabIndex        =   7
         Top             =   960
         Width           =   800
      End
      Begin VB.CommandButton Command_Clockwise 
         BackColor       =   &H00E0E0E0&
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   800
         Index           =   2
         Left            =   3480
         Picture         =   "DC Motor Controler.frx":2DFB
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   960
         Width           =   800
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00E0E0E0&
      Caption         =   "COM Port Setting"
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000040&
      Height          =   1335
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   9255
      Begin MSCommLib.MSComm MSComm1 
         Left            =   6120
         Top             =   240
         _ExtentX        =   1005
         _ExtentY        =   1005
         _Version        =   393216
         DTREnable       =   -1  'True
      End
      Begin VB.CommandButton Command_Close 
         Caption         =   "Close"
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   4800
         TabIndex        =   10
         Top             =   840
         Width           =   4335
      End
      Begin VB.CommandButton Command_Open 
         BackColor       =   &H8000000B&
         Caption         =   "Open"
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   840
         Width           =   4335
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
         Left            =   8280
         TabIndex        =   1
         Text            =   "1"
         Top             =   360
         Width           =   855
      End
      Begin VB.Label LABLE_CPN 
         BackColor       =   &H00E0E0E0&
         Caption         =   "COM Port Number"
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00000040&
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   480
         Width           =   2295
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'GitHub Account: GitHub.com/AliRezaJoodi

Dim K As Byte
Dim Controler_PWM As Byte
Dim CPN As Byte
Dim buf As Variant
Dim data(3) As Byte
Dim counter As Byte

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

    Command_Open.Enabled = True
    Command_Close.Enabled = False

    Image_Anti_clockwise.Height = 1350
    Image_Anti_clockwise.Width = 9585
    Image_Anti_clockwise.Top = 360
    Image_Anti_clockwise.Left = 2880
    Image_Anti_clockwise.Visible = False

    Image_clockwise.Height = 1350
    Image_clockwise.Width = 9585
    Image_clockwise.Top = 360
    Image_clockwise.Left = 2880
    Image_clockwise.Visible = False

    Image_Stop.Height = 1350
    Image_Stop.Width = 9585
    Image_Stop.Top = 360
    Image_Stop.Left = 2880
    Image_Stop.Visible = False

    Call Config_Frame_Controler(False)
    Call Config_Frame_Monitoring(False)

    K = Val(HScroll1.Value)
    Label_PWM.Caption = K
End Sub

Private Sub Command_Open_Click()
    CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
    MSComm1.PortOpen = True
    Command_Close.Enabled = True
    Command_Open.Enabled = False
    Combo1.Enabled = False
    Call Config_Frame_Controler(True)
    Call Config_Frame_Monitoring(True)
    MSComm1.Output = Chr$(&HF2)
End Sub

Private Sub Command_Stop_Click()
    'MSComm1.Output = Chr$(&HF1)
    'MSComm1.Output = Chr$(0)
    'MSComm1.Output = Chr$(Controler_PWM)
    Call Sending(0)
    'Call Display_direction(0)
    MSComm1.Output = Chr$(&HF2)
End Sub

Private Sub Command_Anti_clockwise_Click()
    'MSComm1.Output = Chr$(&HF1)
    'MSComm1.Output = Chr$(1)
    'MSComm1.Output = Chr$(Controler_PWM)
    Call Sending(1)
    'Call Display_direction(1)
    MSComm1.Output = Chr$(&HF2)
End Sub

Private Sub Command_Clockwise_Click(Index As Integer)
    'MSComm1.Output = Chr$(&HF1)
    'MSComm1.Output = Chr$(2)
    'MSComm1.Output = Chr$(Controler_PWM)
    Call Sending(2)
    'Call Display_direction(2)
    MSComm1.Output = Chr$(&HF2)
End Sub

Private Sub Command_Close_Click()
    MSComm1.PortOpen = False
    Command_Close.Enabled = False
    Command_Open.Enabled = True
    Combo1.Enabled = True
    Call Config_Frame_Controler(False)
    Call Config_Frame_Monitoring(False)
    'Call Display_PWM(0)
    'MSComm1.PortOpen = False
End Sub

Private Sub HScroll1_Change()
    K = Val(HScroll1.Value)
    Label_PWM.Caption = K
    Controler_PWM = Label_PWM.Caption
    MSComm1.Output = Chr$(&HF1)
    MSComm1.Output = Chr$(3)
    MSComm1.Output = Chr$(Controler_PWM)
End Sub

Private Sub Config_Frame_Monitoring(state As Variant)
    Label_PWM.Enabled = state
    Image_Anti_clockwise.Enabled = state
    Image_clockwise.Enabled = state
    Image_Anti_clockwise.Visible = False
    Image_clockwise.Visible = False
    Image_Stop.Visible = state
End Sub

Private Sub Config_Frame_Controler(state As Variant)
    Frame_Controler(2).Enabled = state
    Frame_Monitoring(0).Enabled = state
    HScroll1.Enabled = state
    Command_Anti_clockwise.Enabled = state
    Command_Stop.Enabled = state
    Command_Clockwise(2).Enabled = state
End Sub

Private Sub MSComm1_OnComm()
    Select Case MSComm1.CommEvent
        Case comEvReceive
            buf = MSComm1.Input
            buf = Asc(buf)
            Debug.Print buf
            If buf = &HF1 And counter = 0 Then
                counter = 1
                data(counter) = buf
                Exit Sub
            End If
            If counter <> 0 Then
                counter = counter + 1
                data(counter) = buf
                If counter = 3 Then
                    Call Display_direction(data(2))
                    Call Display_PWM(data(3))
                    counter = 0
                End If
            End If
    End Select
End Sub

Private Sub Display_PWM(Index As Byte)
    Label_PWM.Caption = Index
    HScroll1.Value = Index
End Sub

Private Sub Display_direction(Index As Byte)
    If Index = 0 Or Index = 1 Or Index = 2 Then
        Image_Anti_clockwise.Visible = False
        Image_clockwise.Visible = False
        Image_Stop.Visible = False
    End If
    If Index = 0 Then Image_Stop.Visible = True
    If Index = 1 Then Image_Anti_clockwise.Visible = True
    If Index = 2 Then Image_clockwise.Visible = True
End Sub

Private Sub Sending(Index As Byte)
    MSComm1.Output = Chr$(&HF1)
    MSComm1.Output = Chr$(Index)
    MSComm1.Output = Chr$(Controler_PWM)
End Sub
