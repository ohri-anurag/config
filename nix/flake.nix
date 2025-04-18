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
          gum # CLI Tool for making awesome bash scripts

          nodePackages.nodejs # NodeJS

          node2nix # For generating flakes for node packages

          claude-code # Setup for claude code

          xclip # Clipboard manager

          yazi # Terminal based file manager

          elmPackages.elm

          httpie # CLI HTTP client

          gh # GitHub CLI

          difftastic # Syntactic CLI diff tool

          haskellPackages.hasktags # Generate CTAGS for Haskell

          ouch # Zipping/Unzipping CLI tool

          fzf # Fuzzy finder

          fd # Faster find

          bat # Cat with wings

          ripgrep # Faster grep

          direnv # Environment switcher

          jq # CLI JSON processor

          neovim # Neovim

          stylua # Lua formatter

          keepassxc # Password manager

          pavucontrol # PulseAudio volume control

          cmus # Music player

          nicotine-plus # Client for Soulseek
        ];
      };
    };
}
