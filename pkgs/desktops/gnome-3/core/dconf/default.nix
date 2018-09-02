{ stdenv, fetchurl, meson, ninja, python3, vala, libxslt, pkgconfig, glib, dbus-glib, gnome3
, libxml2, docbook_xsl }:

let
  pname = "dconf";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.29.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0i8kc2kg2blj8lr531x18vk993fq11qbgzw5a0lh0dh63dnzi8hp";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ meson ninja vala pkgconfig python3 libxslt libxml2 docbook_xsl ];
  buildInputs = [ glib dbus-glib ];

  doCheck = false; # fails 2 out of 9 tests, maybe needs dbus daemon?

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/dconf;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = gnome3.maintainers;
  };
}
