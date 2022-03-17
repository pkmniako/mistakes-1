import processing.sound.*;

SoundFile music_menu = null, music_infinite = null, music_easy = null, music_medium = null, music_hard = null, music_fucked = null;



void init_music() {
  music_fucked = new SoundFile(this, "data/music_fucked.wav");
  music_menu = new SoundFile(this, "data/music_menu.wav");
  music_infinite = new SoundFile(this, "data/music_infinite.wav");
  music_easy = new SoundFile(this, "data/music_easy.wav");
  music_medium = new SoundFile(this, "data/music_normal.wav");
  music_hard = new SoundFile(this, "data/music_hard.wav");
}

void stop_music() {
  music_fucked.stop();
  music_menu.stop();
  music_infinite.stop();
  music_medium.stop();
  music_easy.stop();
  music_hard.stop();
}
