{
  description = "Testing executing scripts on start for rr";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {

      packages.x86_64-linux.default =
        with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation {
          name = "main";
          src = self;
          dontStrip = true;
          buildPhase = "gcc -g -o main ./main.cpp";
          installPhase = "mkdir -p $out/bin; install -t $out/bin main";
        };

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [ gdb rr ];
      };
    };
}
