import '../utils/utils.dart';

extension DurationExt on Duration {
  String get format {
    String twoDigitMinutes = Utils.twoDigits(inMinutes.remainder(60).abs());
    String twoDigitSeconds = Utils.twoDigits(inSeconds.remainder(60).abs());
    return "${Utils.twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String get twoDigitHours => Utils.twoDigits(inHours);
  String get twoDigitMinutes => Utils.twoDigits(inMinutes.remainder(60).abs());
  String get twoDigitSeconds => Utils.twoDigits(inSeconds.remainder(60).abs());
}
