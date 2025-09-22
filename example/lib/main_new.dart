import 'package:flutter/material.dart';
import 'package:animated_payment_card/src/credit_card_widget_new.dart' as new_widget;
import 'package:animated_payment_card/src/credit_card_form_new.dart' as new_form;
import 'package:animated_payment_card/animated_payment_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Source Sans Pro',
      ),
      home: const CreditCardDemo(),
    );
  }
}

class CreditCardDemo extends StatefulWidget {
  const CreditCardDemo({Key? key}) : super(key: key);

  @override
  State<CreditCardDemo> createState() => _CreditCardDemoState();
}

class _CreditCardDemoState extends State<CreditCardDemo> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String focusedField = '';
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

  void onFocusChange(String fieldName) {
    setState(() {
      focusedField = fieldName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFddeefc),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 700 || constraints.maxHeight < 500;
            
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(50),
              child: isSmallScreen 
                ? Column(
                    children: [
                      _buildCardSection(),
                      const SizedBox(height: 20),
                      Expanded(child: _buildFormSection()),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildCardSection()),
                      const SizedBox(width: 50),
                      Expanded(child: _buildFormSection()),
                    ],
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardSection() {
    return Center(
      child: new_widget.CreditCardWidget(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        showBackView: isCvvFocused,
        obscureCardNumber: true,
        obscureCardCvv: true,
        isHolderNameVisible: true,
        isInputFocused: focusedField.isNotEmpty,
        onCreditCardWidgetChange: (CreditCardBrand brand) {
          debugPrint('Card brand: ${brand.brandName}');
        },
        customCardTypeIcons: <CreditCardBrand, Widget>{
          CreditCardBrand.mastercard: const Icon(
            Icons.credit_card,
            color: Colors.red,
            size: 30,
          ),
        },
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 570),
      child: new_form.CreditCardForm(
        formKey: formKey,
        obscureNumber: false,
        obscureCvv: true,
        isHolderNameVisible: true,
        isCardNumberVisible: true,
        isExpiryDateVisible: true,
        isCvvVisible: true,
        cardNumber: cardNumber,
        cvvCode: cvvCode,
        cardHolderName: cardHolderName,
        expiryDate: expiryDate,
        onCreditCardModelChange: onCreditCardModelChange,
        onFocusChange: onFocusChange,
        enableCardNumberMasking: true,
        onFormComplete: () {
          if (formKey.currentState!.validate()) {
            debugPrint('Valid card details');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Valid card details!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            debugPrint('Invalid card details');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill all fields correctly'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}