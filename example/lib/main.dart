import 'package:flutter/material.dart';
import 'package:flutter_credit_card/src/credit_card_widget_vue.dart';
import 'package:flutter_credit_card/src/credit_card_form_ultimate.dart';
import 'package:flutter_credit_card/src/credit_card_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card Vue Demo',
      theme: ThemeData(fontFamily: 'Source Sans Pro', useMaterial3: false),
      home: const CreditCardVueDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreditCardVueDemo extends StatefulWidget {
  const CreditCardVueDemo({super.key});

  @override
  State<CreditCardVueDemo> createState() => _CreditCardVueDemoState();
}

class _CreditCardVueDemoState extends State<CreditCardVueDemo> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String? focusedField;
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

  void onFocusChange(String? field) {
    setState(() {
      focusedField = field;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFddeefc),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                padding: const EdgeInsets.all(50),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 570),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card list - matches Vue.js structure
                        Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          child: CreditCardWidgetVue(
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            showBackView: isCvvFocused,
                            focusedField: focusedField,
                            isCardNumberMasked: true,
                            animationDuration: const Duration(milliseconds: 800),
                          ),
                        ),

                        // Form inner - matches Vue.js structure
                        CreditCardFormUltimate(
                          formKey: formKey,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          onCreditCardModelChange: onCreditCardModelChange,
                          onFocusChange: onFocusChange,
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

                        const SizedBox(height: 20),

                        // GitHub button
                        _buildGitHubButton(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGitHubButton() {
    return ElevatedButton(
      onPressed: () {
        // Open GitHub repository
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF24292e),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 6,
        shadowColor: const Color.fromRGBO(36, 52, 70, 0.65),
      ),
      child: const Text(
        'See on GitHub',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          fontSize: 16,
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Payment Successful!',
            style: TextStyle(
              color: Color(0xFF2364d2),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Your card details have been validated successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Card: ${cardNumber.replaceAll(RegExp(r'\d(?=\d{4})'), '*')}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2364d2),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
