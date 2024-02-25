{ lib
, stdenv
, fetchFromGitLab
, gnome
, gtk4
, pcre2
# , vte-gtk4
, desktop-file-utils
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, json-glib
, glib
, glibc
, cmake
, callPackage
, libportal-gtk4
, appstream
, fetchpatch
, nixosTests
}:

let
  libadwaita = callPackage ./libadwaita.nix { };
	vte-gtk4 = callPackage ./vte.nix { };
in
stdenv.mkDerivation rec {
  pname = "ptyxis";
  version = "46.alpha";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "ptyxis";
    rev = "973527aeab3ae0aa7b36ed0f36c71bda12bf2857";
    hash = "sha256-wcLupoZH5U1GVEC3a5b0riNp5vRngwJlU80uEyLLNKM=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    pcre2
    vte-gtk4
		json-glib
		glib
		glibc
		cmake
		libportal-gtk4
		appstream
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "ptyxis";
    };
  };

	passthru.tests.test = nixosTests.terminal-emulators.ptyxis;

  meta = with lib; {
    description = "A container oriented terminal for GNOME";
    homepage = "https://gitlab.gnome.org/chergert/ptyxis";
		changelog = "https://gitlab.gnome.org/chergert/ptyxis/-/blob/main/NEWS";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ keanuk ]);
    platforms = platforms.unix;
    mainProgram = "ptyxis";
  };
}
