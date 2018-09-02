{ stdenv, gettext, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, meson, ninja, gtk, glib, wrapGAppsHook, libnotify
, itstool, gnome3, libxml2
, libcanberra-gtk3, libxslt, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  name = "gnome-disk-utility-${version}";
  version = "3.29.92";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0a37k0bcw44maf2j38q3c7cm9j1scyk2k073by0kqxh916yk94kb";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-disk-utility"; attrPath = "gnome3.gnome-disk-utility"; };
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt docbook_xsl
    wrapGAppsHook libxml2
  ];
  buildInputs = [
    gtk glib libsecret libpwquality libnotify libdvdread libcanberra-gtk3
    udisks2 gnome3.defaultIconTheme
    gnome3.gnome-settings-daemon gnome3.gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
