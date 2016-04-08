#!/bin/bash
# A desktop and Text To Speech (TTS) notification of scheduled reminders
#
# Version: 0.0.1
#
# Note: This is currently only useful for one system. The one it was written on. I promise by the paper that this
#       software is written on that the next version will be more useful.
#
# ISC License (ISC)
# Copyright (c) 2016, Travis Fettig <tfettig@gmail.com>
#
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby
# granted, provided that the above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
# AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

#### Defaults ########################################################################

# Defaults for the desktop reminders (/usr/bin/notify-send is for ubuntu/mint desktops)
desktop_notifier="/usr/bin/notify-send"
desktop_message="Your scheduled reminder"

# Default sound wave
wav_player="/usr/bin/aplay"
sound_wav="/usr/share/sounds/linuxmint-gdm.wav"

# Defaults for text to speech
tts_pico2wave=('/usr/bin/pico2wave' "$wav_player")
tts_espeak=('/usr/bin/espeak' '-v en-us+f5 -s 150')
tts_message=$desktop_message

#### Parameters ######################################################################

# Override some the defaults
if [ -n "$1" ]; then
  desktop_message="$1"
  tts_message="$1"
fi

#### Script logic ####################################################################

# Send a notice to the desktop
if [ -e $desktop_notifier ]; then
    # @todo change this export to something that will not effect the entire session.
    export DISPLAY=:0
    $desktop_notifier "$desktop_message"
fi

# Check if a sound player and sound wave exists on this system.
if [ -e $wav_player -a -e $sound_wav ]; then
    $wav_player $sound_wav -q
fi

# Check for a Text to Speak program on the computer
if [ -e ${tts_pico2wave[0]} -a -e ${tts_pico2wave[1]} ]; then
    reminder_wav="/tmp/reminder$RANDOM.wav"

    ${tts_pico2wave[0]} -w=$reminder_wav "$tts_message"
    ${tts_pico2wave[1]} $reminder_wav -q
    rm $reminder_wav
elif [ -e ${tts_espeak=[0]} ]; then
    ${tts_espeak[0]} ${tts_espeak[1]} "$tts_message"
fi
