# launch emacs as daemon after X session starts but
# before i3 "exec" commands run from its config
/usr/local/bin/emacs --daemon
exec i3
