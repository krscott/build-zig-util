{
  stdenvNoCC,
  gawk,
}:
stdenvNoCC.mkDerivation {
  name = "patch-local-dep";
  src = ./.;

  buildInputs = [gawk];

  installPhase = ''
    mkdir -p $out/bin
    cp *.awk $out/bin
  '';
}
