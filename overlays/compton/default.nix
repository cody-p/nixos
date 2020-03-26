{ stdenv, lib, fetchFromGitHub, pkgconfig, uthash, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper, meson, ninja
, xorgproto, libxcb ,xcbutilrenderutil, xcbutilimage, pixman, libev
, dbus, libconfig, libdrm, libGL, pcre, libX11
, libXinerama, libXext, xwininfo, libxdg_basedir }:
stdenv.mkDerivation rec {
  pname = "compton";
  version = "0.1";

  src = fetchFromGitHub {
    owner  = "tryone144";
    repo   = "compton";
    rev    = "241bbc50285e58cbc6a25d45066689eeea913880";
    sha256 = "148s7rkgh5aafzqdvag12fz9nm3fxw2kqwa8vimgq5af0c6ndqh2";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig
    uthash
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
  ];

  buildInputs = [
    dbus libX11 libXext
    xorgproto
    libXinerama libdrm pcre libxml2 libxslt libconfig libGL
    libxcb xcbutilrenderutil xcbutilimage
    pixman libev
    libxdg_basedir
  ];

  NIX_CFLAGS_COMPILE = [ "-fno-strict-aliasing" ];

  mesonFlags = [
    "-Dbuild_docs=true"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/compton-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '';

  meta = with lib; {
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    license = licenses.mit;
    homepage = "https://github.com/tryone144/compton";
    maintainers = with maintainers; [ ertes enzime twey ];
    platforms = platforms.linux;
  };
}
