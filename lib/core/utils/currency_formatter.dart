extension CurrencyFormatter on num {
  /// Formats the number rounded to the nearest whole integer without decimals.
  /// Example: `3000.0` -> `'3000'`, `3000.6` -> `'3001'`
  String toWholePrice() => round().toString();

  /// Formats the number rounded to the nearest whole integer prefixed with currency symbol.
  /// Example: `3000.0.toCurrency('EGP')` -> `'EGP 3000'`
  String toCurrency(String currencySymbol) => '$currencySymbol ${round()}';
}
