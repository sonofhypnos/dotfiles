#!/usr/sbin/fish
# I got this from here: https://www.reddit.com/r/emacs/comments/gsv5np/care_to_share_configs_for_how_you_use_orgroam/ 
# I am to lazy to figure out how to do this in bash/zsh for now 
set class (xprop -id (xdotool getactivewindow) WM_CLASS|awk '{print $4}' | sed 's#"##g')
if [ $class = Emacs ]
emacsclient -n "$argv" &
else
emacsclient -cn "$argv" &
sleep 0.1
emf e delete-other-windows
end
