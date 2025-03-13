{
  description = "My tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      claude-code = pkgs.buildNpmPackage {
        pname = "claude-code";
        version = "0.0.1";
        src = ./claude-code;
        npmDepsHash = "sha256-1eTO6LPIzmSAISRz27BlsnlJQsoyTiOKmyjq5YjqhYA=";
        dontNpmBuild = true;
        postInstall = ''
	  mkdir -p "$out/bin"
          ln -s "$out/lib/node_modules/claude-code/node_modules/@anthropic-ai/claude-code/cli.js" "$out/bin/claude"
        '';
      };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "My Packages";
        paths = with pkgs; [
          # CLI Tool for rendering markdown
          glow
          # NodeJS
          nodePackages.nodejs
          # For generating flakes for node packages
          node2nix
          # Setup for claude code
          claude-code
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
