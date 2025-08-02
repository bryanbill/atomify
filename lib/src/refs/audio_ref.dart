import 'package:atomify/atomify.dart';

class AudioRef extends Ref {
  void play() {
    if (current is Audio) {
      (current?.element as HTMLAudioElement).play();
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void pause() {
    if (current is Audio) {
      (current?.element as HTMLAudioElement).pause();
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void stop() {
    if (current is Audio) {
      final audioElement = current?.element as HTMLAudioElement;
      audioElement.pause();
      audioElement.currentTime = 0;
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void setVolume(double volume) {
    if (current is Audio) {
      (current?.element as HTMLAudioElement).volume = volume.clamp(0.0, 1.0);
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void setPlaybackRate(double rate) {
    if (current is Audio) {
      (current?.element as HTMLAudioElement).playbackRate = rate;
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void mute(bool mute) {
    if (current is Audio) {
      (current?.element as HTMLAudioElement).muted = mute;
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void forward(double seconds) {
    if (current is Audio) {
      final audioElement = current?.element as HTMLAudioElement;
      audioElement.currentTime = (audioElement.currentTime + seconds).clamp(
        0.0,
        audioElement.duration,
      );
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void rewind(double seconds) {
    if (current is Audio) {
      final audioElement = current?.element as HTMLAudioElement;
      audioElement.currentTime = (audioElement.currentTime - seconds).clamp(
        0.0,
        audioElement.duration,
      );
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  void download() {
    if (current is Audio) {
      final audioElement = current?.element as HTMLAudioElement;

      HTMLAnchorElement()
        ..href = audioElement.src
        ..target = '_blank'
        ..setAttribute('download', 'audio.mp3')
        ..click();
    } else {
      throw StateError('Current element is not an Audio instance.');
    }
  }

  @override
  void init(Box box) {
    if (box is Audio) {
      current = box;
    } else {
      throw ArgumentError('Box must be an instance of Audio.');
    }
  }

  @override
  void dispose() {
    if (current is Audio) {
      (current?.element as HTMLAudioElement).pause();
    }
    super.dispose();
  }
}
