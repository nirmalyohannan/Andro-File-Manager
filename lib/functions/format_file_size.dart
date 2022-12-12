double formatFileSizeGB(int size) {
  double sizeDouble = size.toDouble();

  double sizeGB = sizeDouble / (1024 * 1024 * 1024);
  return double.parse(sizeGB.toStringAsFixed(2));
}
