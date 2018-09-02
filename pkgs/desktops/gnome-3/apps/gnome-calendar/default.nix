{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook, libdazzle, libgweather, geoclue2, geocode-glib
, gettext, libxml2, gnome3, gtk, evolution-data-server, libsoup
, glib, gnome-online-accounts, gsettings-desktop-schemas }:

let
  pname = "gnome-calendar";
  version = "3.29.92";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "14hqs2012bvws36fdsx97jr063bgwiqp10n2bfkawrlf3zj657ip";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxml2 wrapGAppsHook ];
  buildInputs = [
    gtk evolution-data-server libsoup glib gnome-online-accounts libdazzle libgweather geoclue2 geocode-glib
    gsettings-desktop-schemas gnome3.defaultIconTheme
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
