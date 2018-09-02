{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${version}";
  version = "3.29.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1m81zp48ywiwwv23jk2nrcrkjllxa2bly3fpkw1nqlln8cpqvgxf";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-backgrounds"; attrPath = "gnome3.gnome-backgrounds"; };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
