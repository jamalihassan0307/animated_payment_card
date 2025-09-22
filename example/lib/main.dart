import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CreditCardDemo(),
    );
  }
}

class CreditCardDemo extends StatefulWidget {
  const CreditCardDemo({super.key});

  @override
  State<CreditCardDemo> createState() => _CreditCardDemoState();
}

class _CreditCardDemoState extends State<CreditCardDemo> {
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
      appBar: AppBar(
        title: const Text('Credit Card Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              onCreditCardWidgetChange: (CreditCardBrand brand) {
                print('Card brand: ${brand.brandName}');
              },
              customCardTypeIcons: <CreditCardBrand, Widget>{
                CreditCardBrand.mastercard: const Icon(
                  Icons.credit_card,
                  color: Colors.red,
                  size: 30,
                ),
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
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
                      enableCardNumberMasking: true,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: const Color(0xff1b447b),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              child: const Text(
                                'Validate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'halter',
                                  fontSize: 14,
                                  package: 'flutter_credit_card',
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                print('Valid card details');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Valid card details!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                print('Invalid card details');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields correctly'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
