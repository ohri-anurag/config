{
  description = "My Config Repo";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      defaultPackages = with pkgs; [
        nixfmt-rfc-style
      ];
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          name = "config";
          packages = defaultPackages;
        };

      };
    };
}
