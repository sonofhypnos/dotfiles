# launch emacs as daemon after X session starts but
# before i3 "exec" commands run from its config
exec i3
/usr/local/bin/emacs --daemon
