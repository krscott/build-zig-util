{
  stdenvNoCC,
  gawk,
}:
stdenvNoCC.mkDerivation {
  name = "build-zig-utils";
  src = ./.;

  buildInputs = [gawk];

  installPhase = ''
    mkdir -p $out/bin
    cp *.awk $out/bin
  '';
}
