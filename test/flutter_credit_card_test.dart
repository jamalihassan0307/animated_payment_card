import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() {
  group('CreditCardUtils Tests', () {
    test('detectCardBrand should identify Visa cards', () {
      expect(CreditCardUtils.detectCardBrand('4111111111111111'), CreditCardBrand.visa);
      expect(CreditCardUtils.detectCardBrand('4000000000000000'), CreditCardBrand.visa);
    });

    test('detectCardBrand should identify Mastercard cards', () {
      expect(CreditCardUtils.detectCardBrand('5555555555554444'), CreditCardBrand.mastercard);
      expect(CreditCardUtils.detectCardBrand('5105105105105100'), CreditCardBrand.mastercard);
    });

    test('detectCardBrand should identify American Express cards', () {
      expect(CreditCardUtils.detectCardBrand('378282246310005'), CreditCardBrand.americanExpress);
      expect(CreditCardUtils.detectCardBrand('371449635398431'), CreditCardBrand.americanExpress);
    });

    test('detectCardBrand should return unknown for invalid cards', () {
      expect(CreditCardUtils.detectCardBrand(''), CreditCardBrand.unknown);
      expect(CreditCardUtils.detectCardBrand('123'), CreditCardBrand.unknown);
    });

    test('validateCardNumber should validate using Luhn algorithm', () {
      expect(CreditCardUtils.validateCardNumber('4111111111111111'), true);
      expect(CreditCardUtils.validateCardNumber('5555555555554444'), true);
      expect(CreditCardUtils.validateCardNumber('378282246310005'), true);
      expect(CreditCardUtils.validateCardNumber('1234567890123456'), false);
      expect(CreditCardUtils.validateCardNumber(''), false);
    });

    test('validateExpiryDate should validate expiry dates', () {
      // Note: These tests may fail if run after the dates become past dates
      expect(CreditCardUtils.validateExpiryDate('12/25'), true);
      expect(CreditCardUtils.validateExpiryDate('01/30'), true);
      expect(CreditCardUtils.validateExpiryDate('13/25'), false); // Invalid month
      expect(CreditCardUtils.validateExpiryDate('12/20'), false); // Past date
      expect(CreditCardUtils.validateExpiryDate(''), false);
      expect(CreditCardUtils.validateExpiryDate('invalid'), false);
    });

    test('validateCVV should validate CVV codes', () {
      expect(CreditCardUtils.validateCVV('123', CreditCardBrand.visa), true);
      expect(CreditCardUtils.validateCVV('1234', CreditCardBrand.americanExpress), true);
      expect(CreditCardUtils.validateCVV('12', CreditCardBrand.visa), false);
      expect(CreditCardUtils.validateCVV('123', CreditCardBrand.americanExpress), false);
      expect(CreditCardUtils.validateCVV('', CreditCardBrand.visa), false);
    });

    test('formatCardNumber should format card numbers correctly', () {
      expect(
        CreditCardUtils.formatCardNumber('4111111111111111', CreditCardBrand.visa),
        '4111 1111 1111 1111',
      );
      expect(
        CreditCardUtils.formatCardNumber('378282246310005', CreditCardBrand.americanExpress),
        '3782 822463 10005',
      );
    });

    test('maskCardNumber should mask card numbers', () {
      expect(CreditCardUtils.maskCardNumber('4111111111111111'), '**** **** **** 1111');
      expect(CreditCardUtils.maskCardNumber('378282246310005'), '**** ****** *0005');
    });

    test('getCardNumberMask should return correct masks', () {
      expect(CreditCardUtils.getCardNumberMask(CreditCardBrand.visa), '#### #### #### ####');
      expect(CreditCardUtils.getCardNumberMask(CreditCardBrand.americanExpress), '#### ###### #####');
    });
  });

  group('CreditCardModel Tests', () {
    test('should create CreditCardModel with required fields', () {
      const model = CreditCardModel(
        cardNumber: '4111111111111111',
        expiryDate: '12/25',
        cardHolderName: 'John Doe',
        cvvCode: '123',
        isCvvFocused: false,
      );

      expect(model.cardNumber, '4111111111111111');
      expect(model.expiryDate, '12/25');
      expect(model.cardHolderName, 'John Doe');
      expect(model.cvvCode, '123');
      expect(model.isCvvFocused, false);
    });

    test('should create copy with updated fields', () {
      const original = CreditCardModel(
        cardNumber: '4111111111111111',
        expiryDate: '12/25',
        cardHolderName: 'John Doe',
        cvvCode: '123',
        isCvvFocused: false,
      );

      final updated = original.copyWith(
        cardNumber: '5555555555554444',
        isCvvFocused: true,
      );

      expect(updated.cardNumber, '5555555555554444');
      expect(updated.expiryDate, '12/25'); // Should remain unchanged
      expect(updated.cardHolderName, 'John Doe'); // Should remain unchanged
      expect(updated.cvvCode, '123'); // Should remain unchanged
      expect(updated.isCvvFocused, true);
    });

    test('should check equality correctly', () {
      const model1 = CreditCardModel(
        cardNumber: '4111111111111111',
        expiryDate: '12/25',
        cardHolderName: 'John Doe',
        cvvCode: '123',
        isCvvFocused: false,
      );

      const model2 = CreditCardModel(
        cardNumber: '4111111111111111',
        expiryDate: '12/25',
        cardHolderName: 'John Doe',
        cvvCode: '123',
        isCvvFocused: false,
      );

      const model3 = CreditCardModel(
        cardNumber: '5555555555554444',
        expiryDate: '12/25',
        cardHolderName: 'John Doe',
        cvvCode: '123',
        isCvvFocused: false,
      );

      expect(model1, model2);
      expect(model1 == model3, false);
    });
  });

  group('CreditCardBrand Tests', () {
    test('should return correct brand names', () {
      expect(CreditCardBrand.visa.brandName, 'Visa');
      expect(CreditCardBrand.mastercard.brandName, 'Mastercard');
      expect(CreditCardBrand.americanExpress.brandName, 'American Express');
      expect(CreditCardBrand.discover.brandName, 'Discover');
      expect(CreditCardBrand.unknown.brandName, 'Unknown');
    });

    test('should return correct asset paths', () {
      expect(CreditCardBrand.visa.assetPath, 'packages/flutter_credit_card/assets/images/visa.png');
      expect(CreditCardBrand.mastercard.assetPath, 'packages/flutter_credit_card/assets/images/mastercard.png');
      expect(CreditCardBrand.americanExpress.assetPath, 'packages/flutter_credit_card/assets/images/amex.png');
    });
  });
}
