double formatRating(double rating) {
  if (rating % 1 >= 0.25 && rating % 1 < 0.5) {
    return rating.floorToDouble();
  } else if (rating % 1 >= 0.5 && rating % 1 < 0.75) {
    return rating.floorToDouble() + 0.5;
  } else {
    return rating.floorToDouble();
  }
}
