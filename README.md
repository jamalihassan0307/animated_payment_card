<div align="center">
  <kbd>
    <img src="https://github.com/jamalihassan0307/flutter_credit_card/blob/main/image/images.jpeg?raw=true" width="250" alt="Jam Ali Hassan"/>
  </kbd>
  
  <h1>💳 Flutter Credit Card 💳</h1>
  <p><i>Beautiful, animated credit card input form for Flutter</i></p>
  
  <p align="center">
    <a href="https://github.com/jamalihassan0307">
      <img src="https://img.shields.io/badge/Created_by-Jam_Ali_Hassan-blue?style=for-the-badge&logo=github&logoColor=white" alt="Created by"/>
    </a>
  </p>

  <p align="center">
    <a href="https://github.com/jamalihassan0307">
      <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"/>
    </a>
    <a href="https://www.linkedin.com/in/jamalihassan0307">
      <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
    </a>
    <a href="https://jamalihassan0307.github.io/portfolio.github.io">
      <img src="https://img.shields.io/badge/Portfolio-255E63?style=for-the-badge&logo=About.me&logoColor=white" alt="Portfolio"/>
    </a>
  </p>

  <p align="center">
    <a href="https://pub.dev/packages/flutter_credit_card">
      <img src="https://img.shields.io/pub/v/flutter_credit_card?style=for-the-badge&logo=dart&logoColor=white" alt="Pub Version"/>
    </a>
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter" alt="Platform"/>
    </a>
    <a href="https://opensource.org/licenses/MIT">
      <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="License: MIT"/>
    </a>
  </p>

  <p align="center">
    <a href="https://pub.dev/packages/flutter_credit_card">
      <img src="https://img.shields.io/pub/likes/flutter_credit_card?style=for-the-badge&logo=flutter&logoColor=white&label=Pub%20Likes" alt="Pub Likes"/>
    </a>
    <a href="https://pub.dev/packages/flutter_credit_card">
      <img src="https://img.shields.io/pub/points/flutter_credit_card?style=for-the-badge&logo=flutter&logoColor=white&label=Pub%20Points" alt="Pub Points"/>
    </a>
    <a href="https://pub.dev/packages/flutter_credit_card">
      <img src="https://img.shields.io/pub/popularity/flutter_credit_card?style=for-the-badge&logo=flutter&logoColor=white&label=Popularity" alt="Popularity"/>
    </a>
  </p>

  <p align="center">
    <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/demo.gif" width="600" alt="Demo"/>
  </p>
</div>

---

# Flutter Credit Card 💳

A Flutter package that provides a beautiful, animated credit card input form with smooth animations, card flipping effects, and comprehensive validation. Perfect for payment screens, e-commerce apps, and any application requiring credit card input with a premium user experience.

[![pub package](https://img.shields.io/pub/v/flutter_credit_card.svg)](https://pub.dev/packages/flutter_credit_card)
[![likes](https://img.shields.io/pub/likes/flutter_credit_card)](https://pub.dev/packages/flutter_credit_card/score)
[![popularity](https://img.shields.io/pub/popularity/flutter_credit_card)](https://pub.dev/packages/flutter_credit_card/score)

## Features 🛠️

### 1. Beautiful Credit Card Widgets
- `CreditCardWidget`: Premium 3D-style credit card display
- `CreditCardWidgetVue`: Vue.js-inspired animations and effects
- `CreditCardWidgetPerfect`: Optimized performance version
- `CreditCardWidgetUltimate`: Feature-rich with advanced animations
- `CreditCardForm`: Comprehensive input form with validation

### 2. Advanced Animations & Effects
- Smooth card flip animation when focusing CVV
- Shimmer and pulse effects for premium feel
- Elastic scale animations on focus
- Slide transitions for card number reveal
- Focus overlay with smooth transitions
- Card type icon animations

### 3. Smart Card Detection & Validation
- Automatic card brand detection (Visa, Mastercard, American Express, etc.)
- Real-time validation for card number, expiry date, and CVV
- Intelligent card number masking (first 4, last 4, middle stars)
- Input formatters for proper formatting
- CVV security (no preview, only stars)

### 4. Customizable Styling
- Multiple card background designs
- Customizable colors and gradients
- Adjustable card dimensions
- Custom fonts and text styles
- Responsive design for all screen sizes

### 5. Cross-Platform Support
<!-- - iOS ✓ -->
- Android ✓
- Web ✓
<!-- - Windows & macOS ✓ -->

## Getting Started 🚀

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_credit_card: ^1.0.0
```

## Usage Examples 💻

### Credit Card Widgets

#### 1. Vue.js Style Widget
<div align="center">
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/vue_card.gif" width="300" alt="Vue Style Card"/>
</div>

```dart
CreditCardWidgetVue(
  cardNumber: cardNumber,
  expiryDate: expiryDate,
  cardHolderName: cardHolderName,
  cvvCode: cvvCode,
  showBackView: isCvvFocused,
  onCreditCardWidgetChange: (CreditCardBrand brand) {
    print('Card brand: ${brand.brandName}');
  },
  cardBgColor: const Color(0xFF1B263B),
  height: 200,
  width: 350,
  animationDuration: const Duration(milliseconds: 600),
)
```

#### 2. Ultimate Widget with Advanced Features
<div align="center">
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/ultimate_card.gif" width="300" alt="Ultimate Card"/>
</div>

```dart
CreditCardWidgetUltimate(
  cardNumber: cardNumber,
  expiryDate: expiryDate,
  cardHolderName: cardHolderName,
  cvvCode: cvvCode,
  showBackView: isCvvFocused,
  onCreditCardWidgetChange: (CreditCardBrand brand) {},
  enablePulseAnimation: true,
  enableShimmerEffect: true,
  cardBgColor: Colors.blueGrey[800],
)
```

#### 3. Perfect Performance Widget
<div align="center">
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/perfect_card.gif" width="300" alt="Perfect Card"/>
</div>

```dart
CreditCardWidgetPerfect(
  cardNumber: cardNumber,
  expiryDate: expiryDate,
  cardHolderName: cardHolderName,
  cvvCode: cvvCode,
  showBackView: isCvvFocused,
  onCreditCardWidgetChange: (CreditCardBrand brand) {},
  obscureCardNumber: true,
  obscureCardCvv: true,
)
```

### Credit Card Forms

#### 1. Ultimate Form with Validation
<div align="center">
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/form_ultimate.gif" width="300" alt="Ultimate Form"/>
</div>

```dart
CreditCardFormUltimate(
  formKey: formKey,
  cardNumber: cardNumber,
  cvvCode: cvvCode,
  cardHolderName: cardHolderName,
  expiryDate: expiryDate,
  onCreditCardModelChange: onCreditCardModelChange,
  enableCardNumberMasking: true,
  cardNumberValidator: (String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) {
      return 'Card number is required';
    }
    if (cardNumber.length < 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  },
  cvvValidator: (String? cvv) {
    if (cvv == null || cvv.isEmpty) {
      return 'CVV is required';
    }
    if (cvv.length < 3) {
      return 'CVV must be at least 3 digits';
    }
    return null;
  },
)
```

#### 2. Standard Form
<div align="center">
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/form_standard.gif" width="300" alt="Standard Form"/>
</div>

```dart
CreditCardForm(
  formKey: formKey,
  cardNumber: cardNumber,
  cvvCode: cvvCode,
  cardHolderName: cardHolderName,
  expiryDate: expiryDate,
  onCreditCardModelChange: onCreditCardModelChange,
  obscureCvv: true,
  obscureNumber: false,
  cvvValidationMessage: 'Please input a valid CVV',
  dateValidationMessage: 'Please input a valid date',
  numberValidationMessage: 'Please input a valid number',
)
```

### Complete Implementation

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Credit Card Payment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Vue.js Style Credit Card Widget
            CreditCardWidgetVue(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand brand) {
                print('Card brand: ${brand.brandName}');
              },
              cardBgColor: const Color(0xFF1B263B),
              animationDuration: const Duration(milliseconds: 600),
            ),
            
            // Credit Card Form
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: CreditCardFormUltimate(
                    formKey: formKey,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              ),
            ),
            
            // Submit Button
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    print('Valid!');
                    // Process payment
                  } else {
                    print('Invalid!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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

## Card Brand Support 💳

The package automatically detects and supports:

<div align="center">
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/visa.png" width="60" alt="Visa"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/mastercard.png" width="60" alt="Mastercard"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/amex.png" width="60" alt="American Express"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/discover.png" width="60" alt="Discover"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/jcb.png" width="60" alt="JCB"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/dinersclub.png" width="60" alt="Diners Club"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/unionpay.png" width="60" alt="UnionPay"/>
  <img src="https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/main/assets/images/troy.png" width="60" alt="Troy"/>
</div>

- **Visa**: 4xxx xxxx xxxx xxxx
- **Mastercard**: 5xxx xxxx xxxx xxxx
- **American Express**: 3xxx xxxxxx xxxxx
- **Discover**: 6xxx xxxx xxxx xxxx
- **JCB**: 35xx xxxx xxxx xxxx
- **Diners Club**: 30xx xxxx xxxx xxx
- **UnionPay**: 62xx xxxx xxxx xxxx
- **Troy**: 9xxx xxxx xxxx xxxx

## API Reference 📖

### CreditCardWidgetVue

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `cardNumber` | `String` | Required | The card number to display |
| `expiryDate` | `String` | Required | The expiry date (MM/YY format) |
| `cardHolderName` | `String` | Required | The card holder name |
| `cvvCode` | `String` | Required | The CVV code |
| `showBackView` | `bool` | Required | Whether to show card back view |
| `onCreditCardWidgetChange` | `Function(CreditCardBrand)` | Required | Brand change callback |
| `height` | `double` | `200` | Card height |
| `width` | `double` | `350` | Card width |
| `cardBgColor` | `Color` | `Color(0xFF1B263B)` | Card background color |
| `obscureCardNumber` | `bool` | `true` | Whether to mask card number |
| `obscureCardCvv` | `bool` | `true` | Whether to mask CVV |
| `animationDuration` | `Duration` | `Duration(milliseconds: 500)` | Animation duration |

### CreditCardFormUltimate

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `formKey` | `GlobalKey<FormState>?` | `null` | Form validation key |
| `cardNumber` | `String` | Required | Card number value |
| `expiryDate` | `String` | Required | Expiry date value |
| `cardHolderName` | `String` | Required | Card holder name value |
| `cvvCode` | `String` | Required | CVV code value |
| `onCreditCardModelChange` | `Function(CreditCardModel)` | Required | Value change callback |
| `enableCardNumberMasking` | `bool` | `true` | Enable card number formatting |
| `cardNumberValidator` | `String? Function(String?)` | `null` | Card number validator |
| `expiryDateValidator` | `String? Function(String?)` | `null` | Expiry date validator |
| `cvvValidator` | `String? Function(String?)` | `null` | CVV validator |
| `cardHolderNameValidator` | `String? Function(String?)` | `null` | Name validator |

### CreditCardModel

```dart
class CreditCardModel {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool isCvvFocused;
  
  CreditCardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.isCvvFocused,
  });
}
```

### CreditCardBrand

```dart
enum CreditCardType {
  visa,
  mastercard,
  amex,
  discover,
  jcb,
  dinersclub,
  unionpay,
  troy,
  otherBrand,
}

class CreditCardBrand {
  final CreditCardType type;
  final String brandName;
  final String cardPattern;
  final int cvvLength;
  
  // ... implementation
}
```

## Customization 🎨

### Custom Card Themes

```dart
// Dark Theme
CreditCardWidgetVue(
  cardBgColor: const Color(0xFF1A1A1A),
  // ... other properties
)

// Blue Gradient Theme
CreditCardWidgetVue(
  cardBgColor: const Color(0xFF1E3A8A),
  // ... other properties
)

// Custom Background Image
CreditCardWidgetVue(
  backgroundImage: 'assets/images/custom_card_bg.png',
  // ... other properties
)
```

### Animation Customization

```dart
CreditCardWidgetVue(
  animationDuration: const Duration(milliseconds: 800),
  enableShimmerEffect: true,
  enablePulseAnimation: true,
  // ... other properties
)
```

### Form Styling

```dart
CreditCardFormUltimate(
  inputDecoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Colors.grey[100],
    filled: true,
  ),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  // ... other properties
)
```

## Best Practices 💡

### Security
1. Never store sensitive card data locally
2. Use HTTPS for all network communications
3. Implement proper input validation
4. Follow PCI DSS compliance guidelines
5. Use tokenization for card data storage

### Performance
1. Use `CreditCardWidgetPerfect` for performance-critical scenarios
2. Implement proper state management
3. Avoid unnecessary rebuilds
4. Use const constructors where possible
5. Optimize image assets

### User Experience
1. Provide clear validation messages
2. Use appropriate keyboard types for each field
3. Implement smooth animations
4. Test on various screen sizes
5. Consider accessibility requirements

### Validation
```dart
String? validateCardNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Card number is required';
  }
  
  // Remove spaces and check length
  String cleanNumber = value.replaceAll(' ', '');
  if (cleanNumber.length < 13 || cleanNumber.length > 19) {
    return 'Invalid card number length';
  }
  
  // Luhn algorithm validation
  if (!isValidCardNumber(cleanNumber)) {
    return 'Invalid card number';
  }
  
  return null;
}

String? validateExpiryDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Expiry date is required';
  }
  
  if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
    return 'Enter date in MM/YY format';
  }
  
  // Check if date is not in the past
  List<String> parts = value.split('/');
  int month = int.parse(parts[0]);
  int year = 2000 + int.parse(parts[1]);
  
  DateTime now = DateTime.now();
  DateTime cardDate = DateTime(year, month);
  
  if (cardDate.isBefore(DateTime(now.year, now.month))) {
    return 'Card has expired';
  }
  
  return null;
}

String? validateCVV(String? value) {
  if (value == null || value.isEmpty) {
    return 'CVV is required';
  }
  
  if (value.length < 3 || value.length > 4) {
    return 'CVV must be 3-4 digits';
  }
  
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'CVV must contain only numbers';
  }
  
  return null;
}
```

## Additional Information 📚

### Contributing
Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Testing
The package includes comprehensive tests for all components:
```bash
flutter test
```

### Examples
Check out the `/example` folder for complete implementation examples and different use cases.

### Changelog
See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and improvements.

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support ❤️

If you find this package helpful, please give it a ⭐️ on [GitHub](https://github.com/jamalihassan0307/flutter_credit_card)!

For issues, feature requests, or questions, please file an issue on the GitHub repository.

## Contact

- 👨‍💻 Developed by [Jam Ali Hassan](https://github.com/jamalihassan0307)
- 🌐 [Portfolio](https://jamalihassan0307.github.io/portfolio.github.io)
- 📧 Email: jamalihassan0307@gmail.com
- 🔗 [LinkedIn](https://www.linkedin.com/in/jamalihassan0307)
