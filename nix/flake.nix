{
  description = "My tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixgl.url = "github:guibou/nixgl";
  };

  outputs = { self, nixpkgs}:
  # outputs = { self, nixpkgs, nixgl }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    # nixglPackages = nixgl.packages.${system};
in
  {
    packages.${system}.default =
      pkgs.buildEnv {
        name = "My Packages";
        paths = with pkgs; [
          lf
          yazi
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
          micro
          vscode
          joplin-desktop
          postman
          spotify
          emacs
          # nixglPackages.nixGLNvidia
        ];
      };
  };
}
