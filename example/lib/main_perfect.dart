import 'package:flutter/material.dart';
import 'package:animated_payment_card/src/credit_card_widget_perfect.dart';
import 'package:animated_payment_card/src/credit_card_form_perfect.dart';
import 'package:animated_payment_card/src/credit_card_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card Perfect Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Source Sans Pro',
      ),
      home: const CreditCardPerfectDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreditCardPerfectDemo extends StatefulWidget {
  const CreditCardPerfectDemo({super.key});

  @override
  State<CreditCardPerfectDemo> createState() => _CreditCardPerfectDemoState();
}

class _CreditCardPerfectDemoState extends State<CreditCardPerfectDemo> {
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
      backgroundColor: const Color(0xFFddeefc),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout that adapts to screen size
            if (constraints.maxWidth > 700) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 570),
        margin: const EdgeInsets.all(50),
        child: Column(
          children: [
            // Credit card widget
            Container(
              margin: const EdgeInsets.only(bottom: -130),
              child: CreditCardWidgetPerfect(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                height: 270,
                width: 430,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                animationDuration: const Duration(milliseconds: 800),
              ),
            ),
            
            // Credit card form
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 130),
                  child: CreditCardFormPerfect(
                    formKey: formKey,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    onCreditCardModelChange: onCreditCardModelChange,
                    obscureNumber: false,
                    obscureCvv: true,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    isCvvVisible: true,
                    enableCardNumberMasking: true,
                    onFormComplete: () {
                      if (formKey.currentState!.validate()) {
                        _showSuccessDialog();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Credit card widget
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: -120),
          child: CreditCardWidgetPerfect(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            height: 220,
            width: 310,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            animationDuration: const Duration(milliseconds: 800),
          ),
        ),
        
        // Credit card form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              margin: const EdgeInsets.only(top: 120),
              child: CreditCardFormPerfect(
                formKey: formKey,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                onCreditCardModelChange: onCreditCardModelChange,
                obscureNumber: false,
                obscureCvv: true,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                isCvvVisible: true,
                enableCardNumberMasking: true,
                onFormComplete: () {
                  if (formKey.currentState!.validate()) {
                    _showSuccessDialog();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: const Text('Card details are valid and ready to be processed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}