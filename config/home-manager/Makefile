.PHONY: switch build check
switch:
	home-manager switch -b backup --flake .#tassilo

build:
	home-manager build --flake .#tassilo

check:
	nix flake check
