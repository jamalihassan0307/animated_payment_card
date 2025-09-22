/// Enum for different credit card brands
enum CreditCardBrand {
  visa,
  mastercard,
  americanExpress,
  discover,
  dinersClub,
  jcb,
  unionPay,
  maestro,
  elo,
  mir,
  hiper,
  hipercard,
  unknown
}

/// Extension for credit card brand utilities
extension CreditCardBrandExtension on CreditCardBrand {
  /// Returns the brand name as a string
  String get brandName {
    switch (this) {
      case CreditCardBrand.visa:
        return 'Visa';
      case CreditCardBrand.mastercard:
        return 'Mastercard';
      case CreditCardBrand.americanExpress:
        return 'American Express';
      case CreditCardBrand.discover:
        return 'Discover';
      case CreditCardBrand.dinersClub:
        return 'Diners Club';
      case CreditCardBrand.jcb:
        return 'JCB';
      case CreditCardBrand.unionPay:
        return 'UnionPay';
      case CreditCardBrand.maestro:
        return 'Maestro';
      case CreditCardBrand.elo:
        return 'Elo';
      case CreditCardBrand.mir:
        return 'Mir';
      case CreditCardBrand.hiper:
        return 'Hiper';
      case CreditCardBrand.hipercard:
        return 'Hipercard';
      case CreditCardBrand.unknown:
        return 'Unknown';
    }
  }

  /// Returns the asset path for the brand logo
  String get assetPath {
    switch (this) {
      case CreditCardBrand.visa:
        return 'packages/flutter_credit_card/assets/images/visa.png';
      case CreditCardBrand.mastercard:
        return 'packages/flutter_credit_card/assets/images/mastercard.png';
      case CreditCardBrand.americanExpress:
        return 'packages/flutter_credit_card/assets/images/amex.png';
      case CreditCardBrand.discover:
        return 'packages/flutter_credit_card/assets/images/discover.png';
      case CreditCardBrand.dinersClub:
        return 'packages/flutter_credit_card/assets/images/diners_club.png';
      case CreditCardBrand.jcb:
        return 'packages/flutter_credit_card/assets/images/jcb.png';
      case CreditCardBrand.unionPay:
        return 'packages/flutter_credit_card/assets/images/unionpay.png';
      case CreditCardBrand.maestro:
        return 'packages/flutter_credit_card/assets/images/maestro.png';
      case CreditCardBrand.elo:
        return 'packages/flutter_credit_card/assets/images/elo.png';
      case CreditCardBrand.mir:
        return 'packages/flutter_credit_card/assets/images/mir.png';
      case CreditCardBrand.hiper:
        return 'packages/flutter_credit_card/assets/images/hiper.png';
      case CreditCardBrand.hipercard:
        return 'packages/flutter_credit_card/assets/images/hipercard.png';
      case CreditCardBrand.unknown:
        return 'packages/flutter_credit_card/assets/images/unknown.png';
    }
  }
}