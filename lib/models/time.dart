const dayToMinutes = 1440;
const hourToMinutes = 60;

class Time {
  final int day;
  final int hour;
  final int minutes;

  Time(this.day, this.hour, this.minutes);

  Minutes toMinutes() {
    return Minutes((day * dayToMinutes) + (hour * hourToMinutes) + minutes);
  }

  String toDurationString() {
    return [
      if (day > 0) "$day day${day > 1 ? "s" : ""}",
      if (hour > 0) "$hour hr${hour > 1 ? "s" : ""}",
      if (minutes > 0) "$minutes min${minutes > 1 ? "s" : ""}",
    ].join(" ");
  }

  String toTimeString() {
    var ampm = this.hour < 12 ? "AM" : "PM";
    var hour = this.hour % 12;
    if (hour == 0) hour = 12;
    return "$hour:${minutes.toString().padLeft(2, '0')} $ampm";
  }
}

class Minutes {
  final int minutes;

  Minutes(this.minutes);

  Time toTime() {
    var minutes = this.minutes;

    var day = minutes ~/ dayToMinutes;
    minutes %= dayToMinutes;

    var hour = minutes ~/ hourToMinutes;
    minutes %= hourToMinutes;

    return Time(day, hour, minutes);
  }

  static int fromDay(int day) {
    return day * dayToMinutes;
  }
}
