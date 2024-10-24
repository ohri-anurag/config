{
  description = "My tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
in
  {
    packages.${system}.default =
      pkgs.buildEnv {
        name = "My Packages";
        paths = with pkgs; [
          lf
          expect
          meld
          xclip
          zellij
          nodePackages.nodejs
          yazi
          elmPackages.elm
          httpie
          gh
          difftastic
          haskellPackages.hasktags
          ouch
          pistol
          fzf
          fd
          bat
          ripgrep
          direnv
          jq
          vim
          neovim
          stylua
          micro
          helix
          shellcheck
          taskwarrior3
          emacs
          cmake
          libtool
        ];
      };
  };
}
