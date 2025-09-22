/// Model class for credit card data
class CreditCardModel {
  const CreditCardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.isCvvFocused,
  });

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool isCvvFocused;

  /// Creates a copy of this model with the given fields replaced with new values
  CreditCardModel copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    bool? isCvvFocused,
  }) {
    return CreditCardModel(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      isCvvFocused: isCvvFocused ?? this.isCvvFocused,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreditCardModel &&
        other.cardNumber == cardNumber &&
        other.expiryDate == expiryDate &&
        other.cardHolderName == cardHolderName &&
        other.cvvCode == cvvCode &&
        other.isCvvFocused == isCvvFocused;
  }

  @override
  int get hashCode {
    return cardNumber.hashCode ^
        expiryDate.hashCode ^
        cardHolderName.hashCode ^
        cvvCode.hashCode ^
        isCvvFocused.hashCode;
  }
}