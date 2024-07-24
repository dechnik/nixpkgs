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

  sourceRoot = ".";
  unpackCmd = "tar zxf $src && dpkg-deb -x splashtop-business_Ubuntu_amd64.deb .";

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D opt/splashtop-business/splashtop-business $out/bin/splashtop-business
    cp -R usr/share $out/
    substituteInPlace $out/share/applications/splashtop-business.desktop \
      --replace-warn /usr/bin $out/bin \
      --replace-warn Icon=/usr/share/pixmaps/logo_about_biz.png Icon=$out/share/pixmaps/logo_about_biz.png
    wrapProgram "$out/bin/splashtop-business" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --prefix QT_PLUGIN_PATH : ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}:${qt5.qtwayland.bin}/${qt5.qtbase.qtPluginPrefix}
    runHook postInstall
  '';
}
