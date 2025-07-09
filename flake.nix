{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        # Final derivation including any overrides made to output package
        finalDrv = self.packages.${system}.build-zig-utils;
      in {
        packages = {
          build-zig-utils = pkgs.callPackage ./. {};
          default = finalDrv;

          lib = {
            applyLocalDepPatch = {
              src,
              dependency,
              path,
            }:
              pkgs.stdenvNoCC.mkDerivation {
                name = "patched-local-dep-source";
                inherit src;

                buildPhase = ''
                  ${finalDrv}/bin/patch-local-dep.awk ${dependency} ${path} ${src}/build.zig.zon > build.zig.zon
                '';

                installPhase = ''
                  mkdir $out
                  mv * $out/
                '';
              };
          };
        };

        formatter = pkgs.alejandra;
      }
    );
}
