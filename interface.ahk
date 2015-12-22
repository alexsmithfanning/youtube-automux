#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; Only allow one instance of the application to run.
#Persistent ; Not really needed because of SingleInstance, but I'm keeping it here to be safe.
#NoTrayIcon ; Removes the tray icon from the tray area. We don't need it.
FFMPEG = %A_ScriptDir%\ffmpeg.exe

GUI Muxer: New,, YouTube Video Muxer
GUI Muxer: Color, White
GUI Muxer: Add, GroupBox, w500 h75, Step One
GUI Muxer: Add, Text, -Wrap x20 y30 vAudioFileExplanationText, Please choose the audio file.
GUI Muxer: Add, Button, -Default -Wrap x425 y25 gBrowseForAudioFile vAudioFileBrowseButton h25 w75, Browse...
GUI Muxer: Add, GroupBox, w500 h75 x10 vStepTwoGroupBox, Step Two
GUI Muxer: Add, Text, -Wrap x20 y110 Disabled vVideoFileExplanationText, Please choose the video file.
GUI Muxer: Add, Button, -Wrap x425 y105 h25 w75 Disabled vVideoFileBrowseButton gBrowseForVideoFile, Browse...
GUI Muxer: Add, GroupBox, w500 h75 x10 vStepThree, Step Three
GUI Muxer: Add, Text, -Wrap x20 y190 Disabled vFinalVideoDestinationEditBox, Please choose the output file.
GUI Muxer: Add, Button, -Wrap x425 y185 h25 w75 Disabled vFinalVideoDestinationBrowseButton gBrowseForFinalVideoFile, Browse...
GUI Muxer: Add, GroupBox, w500 h75 x10, Final Step
GUI Muxer: Add, Button, -Wrap x425 y265 h25 w75 gConvertSelectedFiles vFinalStepCombineButton Disabled, Combine
GUI Muxer: Add, Text, -Wrap x20 y270 Disabled w300 vFinalStepExplanationText, Press Combine to mux the video.
Gui, Add, Progress, vFinalStepProgressBar Hidden x20 w480 y295 h15 hwndMARQ4 -0x00000001 +0x00000008, 50
DllCall("User32.dll\SendMessage", "Ptr", MARQ4, "Int", 0x00000400 + 10, "Ptr", 1, "Ptr", 10)
GUI Muxer: Font, Italic
GUI Muxer: Add, Text, -Wrap x20 y55 r1 w480 cGray vAudioFilePathText, %PATHTOAUDIOFILE%
GUI Muxer: Add, Text, -Wrap x20 y135 r1 w480 cGray vVideoFilePathText, %PATHTOVIDEOFILE%
GUI Muxer: Add, Text, -Wrap x20 y215 r1 w480 cGray vDestinationFilePathText, %FINALDESTINATIONVIDEOFILE%
GUI Muxer: Show
Return

BrowseForAudioFile:
FileSelectFile, PATHTOAUDIOFILE,,, Choose the Audio File, Audio Files (*.mp3; *.m4a; *.flac; *.ogg; *.oga; *.opus)
GUIControl, Text, AudioFilePathText, %PATHTOAUDIOFILE%
If PATHTOAUDIOFILE = 
{
	UserHasChosenAudioFile = False
}
Else
{
	UserHasChosenAudioFile = True
}
If UserHasChosenAudioFile = True
{
	GUIControl, Enable, VideoFileExplanationText
	GUIControl, Enable, VideoFileBrowseButton
}
Return

BrowseForVideoFile:
FileSelectFile, PATHTOVIDEOFILE,,, Choose the Video File, Video Files (*.mp4; *.ogv; *.mkv; *.webm; *.m4v; *.asf; *.ogg)
GUIControl, Text, VideoFilePathText, %PATHTOVIDEOFILE%
If PATHTOVIDEOFILE =
{
	UserHasChosenVideoFile = False
}
Else
{
	UserHasChosenVideoFile = True
}
If UserHasChosenVideoFile = True
{
	GUIControl, Enable, FinalVideoDestinationEditBox
	GUIControl, Enable, FinalVideoDestinationBrowseButton
}
Return

BrowseForFinalVideoFile:
FileSelectFile, FINALDESTINATIONVIDEOFILE, S16,, Choose the Output File, MPEG-4 Part 14 (*.mp4)
GUIControl, Text, DestinationFilePathText, %FINALDESTINATIONVIDEOFILE%
If FINALDESTINATIONVIDEOFILE =
{
	UserHasChosenDestinationFile = False
}
Else
{
	UserHasChosenDestinationFile = True
}
If UserHasChosenDestinationFile = True
{
	GUIControl, Enable, FinalStepCombineButton
	GUIControl, Enable, FinalStepExplanationText
}
Return

ConvertSelectedFiles:
If HasAlreadyRun = True
{
	ExitApp
}
GUIControl, Disable, VideoFileExplanationText
GUIControl, Disable, VideoFileBrowseButton
GUIControl, Disable, FinalVideoDestinationEditBox
GUIControl, Disable, FinalVideoDestinationBrowseButton
GUIControl, Disable, AudioFileExplanationText
GUIControl, Disable, AudioFileBrowseButton
GUIControl, Disable, FinalStepCombineButton
GUIControl, Show, FinalStepProgressBar
GUIControl, Text, FinalStepExplanationText, Please wait, muxing files...
RunWait, %FFMPEG% -i "%PATHTOAUDIOFILE%" -i "%PATHTOVIDEOFILE%" -acodec copy -vcodec copy -y "%FINALDESTINATIONVIDEOFILE%",, Hide
HasAlreadyRun = True
GUIControl,, FinalStepCombineButton, Close
GUIControl, Enable, FinalStepCombineButton
GUIControl, Text, FinalStepExplanationText, Process finished. You can close this window.
GUIControl, Hide, FinalStepProgressBar
Return
