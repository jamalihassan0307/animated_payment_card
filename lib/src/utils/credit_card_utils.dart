import '../credit_card_brand.dart';

/// Utility class for credit card operations
class CreditCardUtils {
  /// Detects the credit card brand from the card number
  static CreditCardBrand detectCardBrand(String cardNumber) {
    if (cardNumber.isEmpty) return CreditCardBrand.unknown;

    // Remove any spaces or non-digit characters
    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Visa: starts with 4
    if (RegExp(r'^4').hasMatch(cleanNumber)) {
      return CreditCardBrand.visa;
    }

    // Mastercard: starts with 5[1-5] or 2[2-7]
    if (RegExp(r'^5[1-5]').hasMatch(cleanNumber) ||
        RegExp(r'^2[2-7]').hasMatch(cleanNumber)) {
      return CreditCardBrand.mastercard;
    }

    // American Express: starts with 34 or 37
    if (RegExp(r'^3[47]').hasMatch(cleanNumber)) {
      return CreditCardBrand.americanExpress;
    }

    // Discover: starts with 6011, 622126-622925, 644-649, or 65
    if (RegExp(r'^6011|^64[4-9]|^65').hasMatch(cleanNumber) ||
        RegExp(r'^622(12[6-9]|1[3-9]\d|[2-8]\d{2}|9[01]\d|92[0-5])')
            .hasMatch(cleanNumber)) {
      return CreditCardBrand.discover;
    }

    // Diners Club: starts with 300-305, 36, or 38
    if (RegExp(r'^30[0-5]|^36|^38').hasMatch(cleanNumber)) {
      return CreditCardBrand.dinersClub;
    }

    // JCB: starts with 35 or 2131|1800
    if (RegExp(r'^35|^2131|^1800').hasMatch(cleanNumber)) {
      return CreditCardBrand.jcb;
    }

    // UnionPay: starts with 62
    if (RegExp(r'^62').hasMatch(cleanNumber)) {
      return CreditCardBrand.unionPay;
    }

    // Maestro: starts with 50, 56-69
    if (RegExp(r'^50|^5[6-9]|^6').hasMatch(cleanNumber)) {
      return CreditCardBrand.maestro;
    }

    return CreditCardBrand.unknown;
  }

  /// Formats card number with spaces
  static String formatCardNumber(String cardNumber, CreditCardBrand brand) {
    if (cardNumber.isEmpty) return '';

    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (brand == CreditCardBrand.americanExpress) {
      // American Express format: #### ###### #####
      return cleanNumber
          .replaceAllMapped(RegExp(r'(\d{4})(\d{6})(\d{5})'), (match) {
        return '${match.group(1)} ${match.group(2)} ${match.group(3)}';
      }).replaceAllMapped(RegExp(r'(\d{4})(\d{6})(\d{1,4})'), (match) {
        return '${match.group(1)} ${match.group(2)} ${match.group(3)}';
      }).replaceAllMapped(RegExp(r'(\d{4})(\d{1,6})'), (match) {
        return '${match.group(1)} ${match.group(2)}';
      });
    } else {
      // Standard format: #### #### #### ####
      return cleanNumber
          .replaceAllMapped(RegExp(r'(\d{4})(\d{4})(\d{4})(\d{4})'), (match) {
        return '${match.group(1)} ${match.group(2)} ${match.group(3)} ${match.group(4)}';
      }).replaceAllMapped(RegExp(r'(\d{4})(\d{4})(\d{4})(\d{1,4})'), (match) {
        return '${match.group(1)} ${match.group(2)} ${match.group(3)} ${match.group(4)}';
      }).replaceAllMapped(RegExp(r'(\d{4})(\d{4})(\d{1,4})'), (match) {
        return '${match.group(1)} ${match.group(2)} ${match.group(3)}';
      }).replaceAllMapped(RegExp(r'(\d{4})(\d{1,4})'), (match) {
        return '${match.group(1)} ${match.group(2)}';
      });
    }
  }

  /// Gets the card number mask based on brand
  static String getCardNumberMask(CreditCardBrand brand) {
    switch (brand) {
      case CreditCardBrand.americanExpress:
        return '#### ###### #####';
      default:
        return '#### #### #### ####';
    }
  }

  /// Validates card number using Luhn algorithm
  static bool validateCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return false;

    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }

    int sum = 0;
    bool alternate = false;

    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Validates expiry date
  static bool validateExpiryDate(String expiryDate) {
    if (expiryDate.isEmpty) return false;

    List<String> parts = expiryDate.split('/');
    if (parts.length != 2) return false;

    int? month = int.tryParse(parts[0]);
    int? year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;

    if (month < 1 || month > 12) return false;

    // Assume year is in YY format, convert to full year
    if (year < 100) {
      year += 2000;
    }

    DateTime now = DateTime.now();
    DateTime expiry = DateTime(year, month);

    return expiry.isAfter(DateTime(now.year, now.month));
  }

  /// Validates CVV
  static bool validateCVV(String cvv, CreditCardBrand brand) {
    if (cvv.isEmpty) return false;

    String cleanCvv = cvv.replaceAll(RegExp(r'\D'), '');

    if (brand == CreditCardBrand.americanExpress) {
      return cleanCvv.length == 4;
    } else {
      return cleanCvv.length == 3;
    }
  }

  /// Masks card number for display (shows only last 4 digits)
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return '';

    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    
    if (cleanNumber.length < 4) return cleanNumber;

    String lastFour = cleanNumber.substring(cleanNumber.length - 4);
    String masked = '*' * (cleanNumber.length - 4) + lastFour;

    return formatCardNumber(masked, detectCardBrand(cardNumber));
  }
}