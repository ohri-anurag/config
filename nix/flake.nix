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
          yazi
          elmPackages.elm
          httpie
          gh
          difftastic
          zoxide
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
          micro
          helix
          shellcheck
          vscode
          spotify
          emacs
          cmake
          libtool
        ];
      };
  };
}
