# Info

This configuration is currently only meant to be for my desktop, because everything else is going to be too much setup. I want to use it to install packages instead of apt more and more.
# Update home.nix

``` shell
home-manager switch -b backup --flake .#tassilo
```

The b- backup option is there so that files that are overwritten with home-manager get backed up.


