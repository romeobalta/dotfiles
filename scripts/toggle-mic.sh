#!/bin/bash

script=$(
	cat <<'EOF'
on getMicrophoneVolume()
    input volume of (get volume settings)
end getMicrophoneVolume

on disableMicrophone()
    set volume input volume 0
    if getMicrophoneVolume() is 0 then
        display notification "Volume set to 0" with title "🔇 Microphone is off"
    else
        display notification "Volume still 100" with title "❌ Failed"
    end if
end disableMicrophone

on enableMicrophone()
    set volume input volume 100
    if getMicrophoneVolume() is 100 then
        display notification "Volume set to 100" with title "🔊 Microphone is on"
    else
        display notification "Volume still 0" with title "❌ Failed"
    end if
end enableMicrophone

if getMicrophoneVolume() is greater than 0 then
    disableMicrophone()
else
    enableMicrophone()
end if
EOF
)

osascript -e "$script"
