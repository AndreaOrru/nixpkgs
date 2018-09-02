{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, iconnamingutils, gtk, gdk_pixbuf, librsvg, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-${version}";
  version = "3.29.90";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0hxw02qbwx9ccliyanwqx64yrgb55w2naqc21g7abamhj1510229";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "adwaita-icon-theme"; attrPath = "gnome3.adwaita-icon-theme"; };
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor-icon-theme ];

  buildInputs = [ gdk_pixbuf librsvg ];

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];

  # remove a tree of dirs with no files within
  postInstall = '' rm -rf "$out/locale" '';

  meta = with stdenv.lib; {
    platforms = with platforms; linux ++ darwin;
    maintainers = gnome3.maintainers;
  };
}
