import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_model.dart';
import 'credit_card_brand.dart';
import 'utils/credit_card_utils.dart';

/// A form widget for collecting credit card information
class CreditCardForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final bool obscureNumber;
  final bool obscureCvv;
  final bool isHolderNameVisible;
  final bool isCardNumberVisible;
  final bool isExpiryDateVisible;
  final bool isCvvVisible;
  final bool enableCardNumberMasking;
  final String numberValidationMessage;
  final String expiryDateValidationMessage;
  final String cvvValidationMessage;
  final String cardHolderValidationMessage;
  final InputDecoration? cardNumberDecoration;
  final InputDecoration? expiryDateDecoration;
  final InputDecoration? cvvCodeDecoration;
  final InputDecoration? cardHolderDecoration;
  final TextStyle? textStyle;
  final void Function()? onFormComplete;

  const CreditCardForm({
    super.key,
    this.formKey,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.onCreditCardModelChange,
    this.obscureNumber = false,
    this.obscureCvv = false,
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.isCvvVisible = true,
    this.enableCardNumberMasking = true,
    this.numberValidationMessage = 'Please enter a valid card number',
    this.expiryDateValidationMessage = 'Please enter a valid expiry date',
    this.cvvValidationMessage = 'Please enter a valid CVV',
    this.cardHolderValidationMessage = 'Please enter the card holder name',
    this.cardNumberDecoration,
    this.expiryDateDecoration,
    this.cvvCodeDecoration,
    this.cardHolderDecoration,
    this.textStyle,
    this.onFormComplete,
  });

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cardHolderNameController;
  late TextEditingController _cvvCodeController;

  late FocusNode _cardNumberFocusNode;
  late FocusNode _expiryDateFocusNode;
  late FocusNode _cardHolderNameFocusNode;
  late FocusNode _cvvFocusNode;

  bool _isCvvFocused = false;
  CreditCardBrand _cardBrand = CreditCardBrand.unknown;

  @override
  void initState() {
    super.initState();

    _cardNumberController = TextEditingController(text: widget.cardNumber);
    _expiryDateController = TextEditingController(text: widget.expiryDate);
    _cardHolderNameController = TextEditingController(text: widget.cardHolderName);
    _cvvCodeController = TextEditingController(text: widget.cvvCode);

    _cardNumberFocusNode = FocusNode();
    _expiryDateFocusNode = FocusNode();
    _cardHolderNameFocusNode = FocusNode();
    _cvvFocusNode = FocusNode();

    _cvvFocusNode.addListener(() {
      setState(() {
        _isCvvFocused = _cvvFocusNode.hasFocus;
      });
      _onModelChange();
    });

    _updateCardBrand(widget.cardNumber);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardHolderNameController.dispose();
    _cvvCodeController.dispose();

    _cardNumberFocusNode.dispose();
    _expiryDateFocusNode.dispose();
    _cardHolderNameFocusNode.dispose();
    _cvvFocusNode.dispose();

    super.dispose();
  }

  void _updateCardBrand(String cardNumber) {
    final newBrand = CreditCardUtils.detectCardBrand(cardNumber);
    if (newBrand != _cardBrand) {
      setState(() {
        _cardBrand = newBrand;
      });
    }
  }

  void _onModelChange() {
    widget.onCreditCardModelChange(
      CreditCardModel(
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryDateController.text,
        cardHolderName: _cardHolderNameController.text,
        cvvCode: _cvvCodeController.text,
        isCvvFocused: _isCvvFocused,
      ),
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return widget.numberValidationMessage;
    }
    if (!CreditCardUtils.validateCardNumber(value)) {
      return widget.numberValidationMessage;
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return widget.expiryDateValidationMessage;
    }
    if (!CreditCardUtils.validateExpiryDate(value)) {
      return widget.expiryDateValidationMessage;
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return widget.cvvValidationMessage;
    }
    if (!CreditCardUtils.validateCVV(value, _cardBrand)) {
      return widget.cvvValidationMessage;
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return widget.cardHolderValidationMessage;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          if (widget.isCardNumberVisible)
            TextFormField(
              controller: _cardNumberController,
              focusNode: _cardNumberFocusNode,
              obscureText: widget.obscureNumber,
              decoration: widget.cardNumberDecoration ??
                  const InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
              style: widget.textStyle,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                if (widget.enableCardNumberMasking)
                  _CardNumberInputFormatter(),
              ],
              validator: _validateCardNumber,
              onChanged: (value) {
                _updateCardBrand(value);
                _onModelChange();
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_expiryDateFocusNode);
              },
            ),
          if (widget.isCardNumberVisible) const SizedBox(height: 16),
          if (widget.isHolderNameVisible)
            TextFormField(
              controller: _cardHolderNameController,
              focusNode: _cardHolderNameFocusNode,
              decoration: widget.cardHolderDecoration ??
                  const InputDecoration(
                    labelText: 'Card Holder Name',
                    hintText: 'Full Name',
                  ),
              style: widget.textStyle,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              validator: _validateCardHolderName,
              onChanged: (_) => _onModelChange(),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_expiryDateFocusNode);
              },
            ),
          if (widget.isHolderNameVisible) const SizedBox(height: 16),
          Row(
            children: [
              if (widget.isExpiryDateVisible)
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _expiryDateController,
                    focusNode: _expiryDateFocusNode,
                    decoration: widget.expiryDateDecoration ??
                        const InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                        ),
                    style: widget.textStyle,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      _ExpiryDateInputFormatter(),
                    ],
                    validator: _validateExpiryDate,
                    onChanged: (_) => _onModelChange(),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_cvvFocusNode);
                    },
                  ),
                ),
              if (widget.isExpiryDateVisible && widget.isCvvVisible)
                const SizedBox(width: 16),
              if (widget.isCvvVisible)
                Expanded(
                  child: TextFormField(
                    controller: _cvvCodeController,
                    focusNode: _cvvFocusNode,
                    obscureText: widget.obscureCvv,
                    decoration: widget.cvvCodeDecoration ??
                        const InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                    style: widget.textStyle,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        _cardBrand == CreditCardBrand.americanExpress ? 4 : 3,
                      ),
                    ],
                    validator: _validateCvv,
                    onChanged: (_) => _onModelChange(),
                    onFieldSubmitted: (_) {
                      widget.onFormComplete?.call();
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Input formatter for card number with spaces
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i != 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(newText[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Input formatter for expiry date (MM/YY)
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(newText[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}