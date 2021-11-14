class Trip {
  final String title;
  final int currentCompanions;
  final int maximumCompanions;
  final int costOverall;
  int get oneUserCost => (costOverall / (currentCompanions + 1)).round();
  final DateTime departureTime;

  const Trip(this.title, this.currentCompanions, this.maximumCompanions,
      this.costOverall, this.departureTime);

  // Trip simpleTrip = Trip('asf', 1, 2);
}
