# Flutter Credit Card

A beautiful, animated credit card input form for Flutter with validation and card flipping animation.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Flutter](https://img.shields.io/badge/flutter->=1.17.0-blue.svg)

## Features

- 🎨 Beautiful credit card UI with animations
- 💳 Card flip animation when focusing CVV field
- 🔍 Automatic card brand detection (Visa, Mastercard, American Express, etc.)
- ✅ Built-in validation for card number, expiry date, and CVV
- 🎯 Customizable styling and colors
- 📱 Responsive design
- 🔧 Input formatters for proper card number and expiry date formatting
- 🌐 Support for multiple card brands

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_credit_card: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCardPage extends StatefulWidget {
  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Credit Card')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand brand) {
                print('Card brand: ${brand.brandName}');
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  formKey: formKey,
                  cardNumber: cardNumber,
                  cvvCode: cvvCode,
                  cardHolderName: cardHolderName,
                  expiryDate: expiryDate,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## API Reference

### CreditCardWidget

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `cardNumber` | `String` | Required | The card number to display |
| `expiryDate` | `String` | Required | The expiry date to display |
| `cardHolderName` | `String` | Required | The card holder name to display |
| `cvvCode` | `String` | Required | The CVV code to display |
| `showBackView` | `bool` | Required | Whether to show the back of the card |
| `height` | `double` | `200` | Height of the credit card |
| `width` | `double` | `350` | Width of the credit card |
| `cardBgColor` | `Color` | `Color(0xFF1B263B)` | Background color of the card |
| `obscureCardNumber` | `bool` | `true` | Whether to obscure the card number |
| `obscureCardCvv` | `bool` | `true` | Whether to obscure the CVV |

### CreditCardForm

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `formKey` | `GlobalKey<FormState>?` | `null` | Form key for validation |
| `cardNumber` | `String` | Required | Initial card number value |
| `expiryDate` | `String` | Required | Initial expiry date value |
| `cardHolderName` | `String` | Required | Initial card holder name value |
| `cvvCode` | `String` | Required | Initial CVV code value |
| `onCreditCardModelChange` | `Function(CreditCardModel)` | Required | Callback when form values change |
| `enableCardNumberMasking` | `bool` | `true` | Whether to format card number with spaces |

## Contributing

Contributions are welcome! Please read the contributing guidelines before submitting PRs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you like this package, please give it a ⭐ on [GitHub](https://github.com/jamalihassan0307/flutter_credit_card)!
