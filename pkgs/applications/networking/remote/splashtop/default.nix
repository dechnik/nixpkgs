{ stdenv, makeWrapper, autoPatchelfHook, lib, fetchurl, dpkg, xorg, keyutils, libpulseaudio, zlib, libcap, xdotool, libuuid, qt5 }:
stdenv.mkDerivation rec {
  pname = "splashtop-business";
  version = "3.6.0.0";
  src = fetchurl {
    url = "https://download.splashtop.com/linuxclient/splashtop-business_Ubuntu_v${version}_amd64.tar.gz";
    hash = "sha256-pKAWrDQJMX3Bznd9RBje3TazPvml0jLfGDjg55dQgco=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  sourceRoot = ".";
  unpackCmd = "tar zxf $src && dpkg-deb -x splashtop-business_Ubuntu_amd64.deb .";

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D opt/splashtop-business/splashtop-business $out/bin/splashtop-business
    # cp -R usr/share opt/splashtop-business/lib $out/
    cp -R usr/share $out/
    substituteInPlace $out/share/applications/splashtop-business.desktop \
      --replace-warn /usr/bin $out/bin \
      --replace-warn Icon=/usr/share/pixmaps/logo_about_biz.png Icon=$out/share/pixmaps/logo_about_biz.png
    wrapProgram "$out/bin/splashtop-business" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
    runHook postInstall
  '';
  buildInputs = [
    xorg.xcbutil
    xorg.libxcb
    xorg.xcbutilkeysyms
    keyutils.lib
    libuuid.lib
    zlib
    libcap.lib
    xdotool
    libpulseaudio
    qt5.qtbase
    qt5.qtwayland
    stdenv.cc.cc.lib
  ];
  # installPhase = ''
  #   runHook preInstall

  #   mkdir -p $out/bin
  #   cp -R usr/share opt $out/
  #   # fix the path in the desktop file
  #   substituteInPlace $out/share/applications/splashtop-business.desktop \
  #     --replace-warn /usr/bin $out/bin \
  #     --replace-warn Icon=/usr/share/pixmaps/logo_about_biz.png Icon=$out/share/pixmaps/logo_about_biz.png
  #   # symlink the binary to bin/
  #   ln -s $out/opt/splashtop-business/splashtop-business $out/bin/splashtop-business
  #   ln -s $out/opt/splashtop-business/lib $out/lib

  #   runHook postInstall
  # '';
  # preFixup = let
  #   # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
  #   libPath = lib.makeLibraryPath [
  #     xorg.xcbutil
  #     xorg.libxcb
  #     xorg.xcbutilkeysyms
  #     keyutils.lib
  #     libuuid.lib
  #     zlib
  #     libcap.lib
  #     xdotool
  #     libpulseaudio
  #     qt5.qtbase
  #     stdenv.cc.cc.lib
  #   ];
  # in ''
  #   patchelf \
  #     --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
  #     --set-rpath "${libPath}:$out/lib/msquic:$out/lib/fips" \
  #     $out/opt/splashtop-business/splashtop-business
  # '';
}
