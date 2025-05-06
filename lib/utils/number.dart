double formatRating(double rating) {
  if (rating % 1 >= 0.25 && rating % 1 < 0.5) {
    return rating.floorToDouble(); // Chuyển 3.25 thành 3.0
  } else if (rating % 1 >= 0.5 && rating % 1 < 0.75) {
    return rating.floorToDouble() + 0.5; // Giữ 3.5, nhưng 3.75 sẽ thành 3.5
  } else {
    return rating.floorToDouble(); // Giữ nguyên các giá trị nguyên như 4.0
  }
}
