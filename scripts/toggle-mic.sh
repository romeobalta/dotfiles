#!/bin/bash

script=$(
	cat <<'EOF'
on getMicrophoneVolume()
    input volume of (get volume settings)
end getMicrophoneVolume

on disableMicrophone()
    set volume input volume 0
    display notification "Volume set to 0" with title "❌ Microphone is off"
end disableMicrophone

on enableMicrophone()
    set volume input volume 100
    display notification "Volume set to 100" with title "✅ Microphone is on"
end enableMicrophone

if getMicrophoneVolume() is greater than 0 then
    disableMicrophone()
else
    enableMicrophone()
end if
EOF
)

osascript -e "$script"
