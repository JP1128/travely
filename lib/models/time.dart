class Time {
  final int hour;
  final int minutes;

  Time(this.hour, this.minutes);

  Time subtract(Time time) {
    int newHour = hour - time.hour;
    int newMinutes = minutes - time.minutes;

    if (newMinutes < 0) {
      newHour--;
      newMinutes += 60;
    }

    return Time(newHour, newMinutes);
  }

  String toStringDuration() {
    if (hour == 0) {
      return "$minutes min";
    }

    return "$hour hr $minutes min";
  }

  @override
  String toString() {
    String ampm = hour < 12 ? "AM" : "PM";
    return "${hour % 12 == 0 ? 12 : hour % 12}:$minutes $ampm";
  }
}
