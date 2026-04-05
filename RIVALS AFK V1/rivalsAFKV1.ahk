#NoEnv
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#MaxThreadsPerHotkey 2
SetBatchLines -1

; --- Global Variables ---
global PrivateLink := ""
global SelectedWeapon := ""
global RejoinMinutes := 20
global UseManual := 0
global UseStatus := 1

; Coordinate variables
global PX := 0, PY := 0, JX := 0, JY := 0
global W1X := 0, W1Y := 0, W2X := 0, W2Y := 0, W3X := 0, W3Y := 0, W4X := 0, W4Y := 0

; Load settings
IniRead, PrivateLink, settings.ini, Config, PSLink, % ""
IniRead, SelectedWeapon, settings.ini, Config, Weapon, % "Assault Rifle"
IniRead, RejoinMinutes, settings.ini, Config, RejoinMin, 7 
IniRead, UseManual, settings.ini, Config, UseManual, 0
IniRead, UseStatus, settings.ini, Config, UseStatus, 1

; Load Coords
IniRead, PX, settings.ini, ManualCoords, PX, 0
IniRead, PY, settings.ini, ManualCoords, PY, 0
IniRead, JX, settings.ini, ManualCoords, JX, 0
IniRead, JY, settings.ini, ManualCoords, JY, 0
IniRead, W1X, settings.ini, ManualCoords, W1X, 0
IniRead, W1Y, settings.ini, ManualCoords, W1Y, 0
IniRead, W2X, settings.ini, ManualCoords, W2X, 0
IniRead, W2Y, settings.ini, ManualCoords, W2Y, 0
IniRead, W3X, settings.ini, ManualCoords, W3X, 0
IniRead, W3Y, settings.ini, ManualCoords, W3Y, 0
IniRead, W4X, settings.ini, ManualCoords, W4X, 0
IniRead, W4Y, settings.ini, ManualCoords, W4Y, 0

; Colors
BackgroundColor := "121212", SidebarColor := "1E1E1E", TextColor := "FFFFFF"
WarningColor := "FF4444", InfoColor := "50FA7B", DonationColor := "6272A4", DiscordWarn := "FF5555"

; --- Main GUI ---
Gui, 1:Color, %BackgroundColor%
Gui, 1:Font, s9 c%TextColor%, Segoe UI

; Sidebar
Gui, 1:Add, Progress, x0 y0 w140 h480 Background%SidebarColor% c%SidebarColor% Vertical +Disabled, 100
Gui, 1:Add, Button, x10 y40 w120 h40 gShowPS, Private Server
Gui, 1:Add, Button, x10 y90 w120 h40 gShowWeapons, Weapons
Gui, 1:Add, Button, x10 y140 w120 h40 gShowSettings, Settings
Gui, 1:Add, Button, x10 y190 w120 h40 gShowDono, Donations
Gui, 1:Font, s7 Bold c%DiscordWarn%
Gui, 1:Add, Text, x5 y370 w130 h20 +Center +BackgroundTrans, WE DONT HAVE A DISCORD SERVER!

; Section: Private Server
Gui, 1:Font, s10 Bold c%TextColor%
Gui, 1:Add, Text, x160 y20 w260 h25 vTitlePS +Center, RIVALS AFK GRINDER
Gui, 1:Font, s9 Norm
Gui, 1:Add, Text, x160 y55 w260 h20 vLabelPS, Private Server Link:
Gui, 1:Add, Edit, x160 y75 w260 h25 vPrivateLinkEdit cBlack, %PrivateLink%
Gui, 1:Add, Button, x160 y110 w260 h30 gSaveLink vSaveBtn, Save Link
Gui, 1:Add, Button, x160 y160 w260 h40 gStartGrind vStartBtn, (F1) START GRIND
Gui, 1:Add, Button, x160 y210 w260 h40 gPauseGrind vPauseBtn, (F2) PAUSE / RESUME
Gui, 1:Add, Button, x160 y260 w260 h40 gStopGrind vStopBtn, (F3) STOP & RELOAD

; Section: Weapons
Gui, 1:Font, s10 Bold
Gui, 1:Add, Text, x160 y20 w260 h25 vTitleWp +Center +Hidden, PRIMARY WEAPONS
Gui, 1:Font, s8 Italic c%WarningColor%
Gui, 1:Add, Text, x160 y45 w260 h30 vWarningWp +Center +Hidden, Weapons must be on List! Using Grid will break the macro.
Gui, 1:Font, s9 Norm c%TextColor%
Gui, 1:Add, Text, x160 y75 w260 h20 vLabelWp +Hidden, Select Weapon to Use:
WeaponItems := "Distortion|Permafrost|Energy Rifle|Flamethrower|Grenade Launcher|Minigun|Paintball Gun|Assault Rifle|Bow|Burst Rifle|Crossbow|Gunblade|RPG|Shotgun|Sniper"
Gui, 1:Add, ListBox, x160 y95 w260 h150 vWeaponList +Hidden cBlack, %WeaponItems%
Gui, 1:Add, Button, x160 y255 w260 h30 gSaveWeapons vSaveWpBtn +Hidden, Save Weapon Config
Gui, 1:Font, s7 Bold c%InfoColor%
Gui, 1:Add, Text, x160 y300 w260 h40 vMaintText +Center +Hidden, IN MAINTENANCE. USE COORDINATES FOR NOW.

; Section: Settings
Gui, 1:Font, s10 Bold c%TextColor%
Gui, 1:Add, Text, x160 y10 w260 h25 vTitleSet +Center +Hidden, ADVANCED SETTINGS
Gui, 1:Font, s9 Norm
Gui, 1:Add, Picture, x410 y10 w20 h20 vInfoIcon gShowInfoHelp +Hidden, %A_ScriptDir%\UI\info.png
Gui, 1:Add, Text, x160 y40 w260 h20 vLabelRejoin +Hidden, Rejoin Every (Minutes):
Gui, 1:Add, Edit, x160 y60 w60 h25 vRejoinEdit cBlack +Hidden, %RejoinMinutes%
Gui, 1:Add, CheckBox, x160 y95 w260 h20 vUseManualBtn gToggleManual +Hidden Checked%UseManual%, Enable Manual Weapon Sequence
Gui, 1:Add, CheckBox, x160 y120 w260 h20 vUseStatusBtn gToggleStatus +Hidden Checked%UseStatus%, Enable Status Bar Window

; Coordinates
Gui, 1:Add, Text, x155 y145 w260 h20 vLabelManual +Hidden, Coords (Play, Join, W1-W4):
Gui, 1:Add, Text, x155 y170 w80 h20 vCoord1 +Hidden, P: %PX%,%PY%
Gui, 1:Add, Button, x235 y165 w35 h20 gCapPlay vCapPlayBtn +Hidden, SET
Gui, 1:Add, Text, x285 y170 w80 h20 vCoord2 +Hidden, J: %JX%,%JY%
Gui, 1:Add, Button, x365 y165 w35 h20 gCapJoin vCapJoinBtn +Hidden, SET
Gui, 1:Add, Text, x155 y195 w80 h20 vCoord3 +Hidden, W1: %W1X%,%W1Y%
Gui, 1:Add, Button, x235 y190 w35 h20 gCapW1 vCapW1Btn +Hidden, SET
Gui, 1:Add, Text, x285 y195 w80 h20 vCoord4 +Hidden, W2: %W2X%,%W2Y%
Gui, 1:Add, Button, x365 y190 w35 h20 gCapW2 vCapW2Btn +Hidden, SET
Gui, 1:Add, Text, x155 y220 w80 h20 vCoord5 +Hidden, W3: %W3X%,%W3Y%
Gui, 1:Add, Button, x235 y215 w35 h20 gCapW3 vCapW3Btn +Hidden, SET
Gui, 1:Add, Text, x285 y220 w80 h20 vCoord6 +Hidden, W4: %W4X%,%W4Y%
Gui, 1:Add, Button, x365 y215 w35 h20 gCapW4 vCapW4Btn +Hidden, SET
Gui, 1:Add, Button, x160 y255 w260 h30 gSaveSettings vSaveSetBtn +Hidden, Save Settings

; Section: Donations
Gui, 1:Font, s11 Bold c%InfoColor%
Gui, 1:Add, Text, x160 y100 w260 h25 vDonoUsTitle +Center +Hidden, Support us!
Gui, 1:Add, Picture, x240 y135 w100 h100 vDonoUsImg gOpenDonoUsLink +Hidden +BackgroundTrans, %A_ScriptDir%\UI\skab.png 

; Status Window
Gui, 2:+AlwaysOnTop -Caption +Border +ToolWindow
Gui, 2:Color, %SidebarColor%
Gui, 2:Font, s10 Bold c%TextColor%
Gui, 2:Add, Text, x10 y5 w280 h25 vStatusText, Status: IDLE

Gui, 1:Show, w450 h400, RIVALS AFK V1
return

; --- Labels & Functions ---

UpdateStatus(msg) {
    global UseStatus
    if (UseStatus) {
        GuiControl, 2:, StatusText, Status: %msg%
        Gui, 2:Show, xCenter y0 NoActivate w300 h35
    }
}

ShowPS:
    ToggleSection("PS")
return
ShowWeapons:
    ToggleSection("WP")
return
ShowSettings:
    ToggleSection("SET")
return
ShowDono:
    ToggleSection("DONO")
return

SaveWeapons:
    MsgBox, 48, Maintenance, This tab is currently in maintenance. Please use manual coordinates in the Settings tab.
return

SaveLink:
    Gui, 1:Submit, NoHide
    IniWrite, %PrivateLinkEdit%, settings.ini, Config, PSLink
    MsgBox, 64, Saved, Link Saved!, 1
return

SaveSettings:
    Gui, 1:Submit, NoHide
    IniWrite, %RejoinEdit%, settings.ini, Config, RejoinMin
    IniWrite, %PX%, settings.ini, ManualCoords, PX
    IniWrite, %PY%, settings.ini, ManualCoords, PY
    IniWrite, %JX%, settings.ini, ManualCoords, JX
    IniWrite, %JY%, settings.ini, ManualCoords, JY
    IniWrite, %W1X%, settings.ini, ManualCoords, W1X
    IniWrite, %W1Y%, settings.ini, ManualCoords, W1Y
    IniWrite, %W2X%, settings.ini, ManualCoords, W2X
    IniWrite, %W2Y%, settings.ini, ManualCoords, W2Y
    IniWrite, %W3X%, settings.ini, ManualCoords, W3X
    IniWrite, %W3Y%, settings.ini, ManualCoords, W3Y
    IniWrite, %W4X%, settings.ini, ManualCoords, W4X
    IniWrite, %W4Y%, settings.ini, ManualCoords, W4Y
    MsgBox, 64, Saved, Settings Saved!, 1
return

StartGrind:
    Gui, 1:Submit, NoHide
    UpdateStatus("STARTING...")
    SetTimer, RejoinSequence, % RejoinMinutes * 60000
    GoSub, RejoinSequence
return

PauseGrind:
    Pause, Toggle, 1
    UpdateStatus(A_IsPaused ? "PAUSED" : "RESUMED")
return

StopGrind:
    Reload
return

RejoinSequence:
    SetTimer, CombatLoopTimer, Off 
    UpdateStatus("OPENING PRIVATE LINK...")
    Run, %PrivateLinkEdit%
    Random, LoadExtra, 0, 5000
    UpdateStatus("WAITING FOR CLIENT...")
    Sleep, 45000 + LoadExtra 
    CoordMode, Mouse, Screen
    UpdateStatus("FOCUSING WINDOW...")
    MouseMove, A_ScreenWidth/2, A_ScreenHeight/2, 0
    Click
    Sleep, 800
    
    if (UseManual) {
        UpdateStatus("ACTION: PLAY")
        MouseMove, %PX%, %PY%, 2 
        Click
        UpdateStatus("SCROLLING...")
        EndTime := A_TickCount + 3000
        while (A_TickCount < EndTime) {
            Click, WheelDown
            Random, ScrollVar, 30, 60
            Sleep, %ScrollVar%
        }
        Click
        UpdateStatus("WAITING (10s)...")
        Sleep, 10000
        UpdateStatus("ACTION: JOIN")
        MouseMove, %JX%, %JY%, 2 
        Click
        Sleep, 1500
        ClickWeapon(W1X, W1Y), ClickWeapon(W2X, W2Y), ClickWeapon(W3X, W3Y), ClickWeapon(W4X, W4Y)
    } else {
        ; ImageSearch fallback
    }
    Sleep, 2000
    UpdateStatus("GRINDING...")
    SetTimer, CombatLoopTimer, 10
return

ClickWeapon(X, Y) {
    if (X > 0) {
        MouseMove, %X%, %Y%, 2 
        Click
        Sleep, 400
    }
}

CombatLoopTimer:
    Random, Jitter, -1, 1
    DllCall("mouse_event", uint, 1, int, 100 + Jitter, int, 0, uint, 0, int, 0)
    Send, {w down}{Space down}
    Click
    Random, CWait, 40, 75
    Sleep, %CWait%
    Send, {w up}{Space up}
    Random, LWait, 15, 30
    Sleep, %LWait%
return

ToggleManual:
    Gui, 1:Submit, NoHide
    IniWrite, %UseManualBtn%, settings.ini, Config, UseManual
return

ToggleStatus:
    Gui, 1:Submit, NoHide
    if (!UseStatusBtn)
        Gui, 2:Hide
    IniWrite, %UseStatusBtn%, settings.ini, Config, UseStatus
return

ShowInfoHelp:
    MsgBox, 64, Help, Use SET buttons to map screen. F1: Start, F2: Pause, F3: Reload.
return

OpenDonoUsLink:
    Run, https://www.roblox.com/users/7362711581/profile 
return

ToggleSection(S) {
    PS := "TitlePS,LabelPS,PrivateLinkEdit,SaveBtn,StartBtn,PauseBtn,StopBtn"
    WP := "TitleWp,WarningWp,LabelWp,WeaponList,SaveWpBtn,MaintText"
    SET := "TitleSet,InfoIcon,LabelRejoin,RejoinEdit,UseManualBtn,UseStatusBtn,LabelManual,Coord1,CapPlayBtn,Coord2,CapJoinBtn,Coord3,CapW1Btn,Coord4,CapW2Btn,Coord5,CapW3Btn,Coord6,CapW4Btn,SaveSetBtn"
    DONO := "DonoUsTitle,DonoUsImg"
    Loop, Parse, % PS . "," . WP . "," . SET . "," . DONO, `,
        GuiControl, 1:Hide, %A_LoopField%
    if (S = "PS")
        Loop, Parse, PS, `,
            GuiControl, 1:Show, %A_LoopField%
    else if (S = "WP")
        Loop, Parse, WP, `,
            GuiControl, 1:Show, %A_LoopField%
    else if (S = "SET")
        Loop, Parse, SET, `,
            GuiControl, 1:Show, %A_LoopField%
    else if (S = "DONO")
        Loop, Parse, DONO, `,
            GuiControl, 1:Show, %A_LoopField%
}

CapPlay:
    ToolTip, Click PLAY
    KeyWait, LButton, D
    MouseGetPos, PX, PY
    GuiControl, 1:, Coord1, P: %PX%,%PY%
    ToolTip
return
CapJoin:
    ToolTip, Click JOIN
    KeyWait, LButton, D
    MouseGetPos, JX, JY
    GuiControl, 1:, Coord2, J: %JX%,%JY%
    ToolTip
return
CapW1:
    ToolTip, Click W1
    KeyWait, LButton, D
    MouseGetPos, W1X, W1Y
    GuiControl, 1:, Coord3, W1: %W1X%,%W1Y%
    ToolTip
return
CapW2:
    ToolTip, Click W2
    KeyWait, LButton, D
    MouseGetPos, W2X, W2Y
    GuiControl, 1:, Coord4, W2: %W2X%,%W2Y%
    ToolTip
return
CapW3:
    ToolTip, Click W3
    KeyWait, LButton, D
    MouseGetPos, W3X, W3Y
    GuiControl, 1:, Coord5, W3: %W3X%,%W3Y%
    ToolTip
return
CapW4:
    ToolTip, Click W4
    KeyWait, LButton, D
    MouseGetPos, W4X, W4Y
    GuiControl, 1:, Coord6, W4: %W4X%,%W4Y%
    ToolTip
return

F1::GoSub, StartGrind
F2::GoSub, PauseGrind
F3::Reload

GuiClose:
ExitApp