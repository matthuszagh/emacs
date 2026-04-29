{
  description = "Customized emacs build (matching the build used in ~/src/nixos)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, emacs-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ emacs-overlay.overlay ];
        };

        emacsBase = (pkgs.emacs-unstable-pgtk.override {
          srcRepo = true;
          withCsrc = true;
          withNativeCompilation = true;
          withTreeSitter = true;
        }).overrideAttrs (_: {
          CFLAGS = "-O3 -march=native -mtune=native -momit-leaf-frame-pointer";
          NIX_ENFORCE_NO_NATIVE = false;
        });

        emacs = (pkgs.emacsPackagesFor emacsBase).emacsWithPackages (epkgs:
          (with epkgs.melpaPackages; [
            vterm
            pdf-tools
          ]) ++ (with epkgs; [
            treesit-grammars.with-all-grammars
          ]));
      in
      {
        packages = {
          default = emacs;
          inherit emacs;
        };

        apps.default = {
          type = "app";
          program = "${emacs}/bin/emacs";
        };
      });
}
