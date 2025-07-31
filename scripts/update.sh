if command -v yay &>/dev/null; then kitty -T update yay -Syu --devel; else kitty -T update paru -Syu --devel; fi && notify-send 'The system has been updated'
