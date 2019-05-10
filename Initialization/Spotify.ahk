; -- These files are to separate out the initial variables needed into their own locations
; -- They're all loaded in near the top of the script

; REDUNDANT due to the system volume now being retrieved every time a volume change request is handled - See Functions/Spotify.ahk:140
; maxVol := 35
; SoundGet, maxVol

minVol := 2
vol_loud := 15
vol_low := minVol
currentVolume := ""
oldVolume := ""
hiddenState := ""
oldControlList := ""
volSliderClassNN := ""
spotifyNameClassNN := ""
sliderPos := ""