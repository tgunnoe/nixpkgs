{ stdenv, fetchFromBitbucket, p7zip, cmake
, SDL2, bzip2, zlib, libjpeg
, libsndfile, mpg123
, SDL2_net, SDL2_mixer }:

stdenv.mkDerivation rec {
  pname = "lzwolf";
  majorVersion = "2.8";
  version = "${majorVersion}.1";

  src = fetchFromBitbucket {
    owner = "linuxwolf6";
    repo = "lzwolf";
    rev = "c22f7d78468feddba2e42a0f386f0cdb70c748be";
    sha256 = "0lzm4r26alr2sjp73058si2mh4qhq5mafmjkjylxj590nvnlxqz4";
  };
  nativeBuildInputs = [ p7zip cmake ];
  buildInputs = [
    SDL2 bzip2 zlib libjpeg SDL2_mixer SDL2_net libsndfile mpg123
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGPL=ON"
  ];

  enableParallelBuilding = true;

  #NIX_CFLAGS_LINK = [ "-lopenal" "-lfluidsynth" ];

  # preConfigure = ''
  #   sed -i \
  #     -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
  #     -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
  #     src/sound/music_fluidsynth_mididevice.cpp
  # '';

  installPhase = ''
    install -Dm755 lzwolf "$out/lib/lzwolf/lzwolf"
    for i in *.pk3; do
      install -Dm644 "$i" "$out/lib/lzwolf/$i"
    done
    mkdir -p $out/bin
    ln -s $out/lib/lzwolf/lzwolf $out/bin/lzwolf
  '';

  meta = with stdenv.lib; {
    homepage = "http://lzwolf.org/";
    description = "Enhanced port of the official Wolf3D source code";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };
}
