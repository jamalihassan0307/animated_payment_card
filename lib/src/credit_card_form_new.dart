import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_model.dart';
import 'credit_card_brand.dart';
import 'utils/credit_card_utils.dart';

/// A form widget that matches the original Vue.js design
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
  final void Function(String)? onFocusChange;

  const CreditCardForm({
    Key? key,
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
    this.onFocusChange,
  }) : super(key: key);

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
  String _currentMonth = '';
  String _currentYear = '';

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

    _cardNumberFocusNode.addListener(_handleFocusChange);
    _expiryDateFocusNode.addListener(_handleFocusChange);
    _cardHolderNameFocusNode.addListener(_handleFocusChange);
    _cvvFocusNode.addListener(_handleCvvFocusChange);

    _updateCardBrand(widget.cardNumber);
    _parseExpiryDate(widget.expiryDate);
  }

  void _handleFocusChange() {
    if (_cardNumberFocusNode.hasFocus) {
      widget.onFocusChange?.call('cardNumber');
    } else if (_cardHolderNameFocusNode.hasFocus) {
      widget.onFocusChange?.call('cardName');
    } else if (_expiryDateFocusNode.hasFocus) {
      widget.onFocusChange?.call('cardDate');
    } else {
      widget.onFocusChange?.call('');
    }
  }

  void _handleCvvFocusChange() {
    setState(() {
      _isCvvFocused = _cvvFocusNode.hasFocus;
    });
    _onModelChange();
    
    if (_cvvFocusNode.hasFocus) {
      widget.onFocusChange?.call('cardCvv');
    }
  }

  void _parseExpiryDate(String expiryDate) {
    if (expiryDate.contains('/')) {
      List<String> parts = expiryDate.split('/');
      if (parts.length == 2) {
        _currentMonth = parts[0];
        _currentYear = parts[1];
      }
    }
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
        expiryDate: _currentMonth.isNotEmpty && _currentYear.isNotEmpty 
            ? '$_currentMonth/$_currentYear' 
            : '',
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

  String? _validateExpiryDate(String month, String year) {
    if (month.isEmpty || year.isEmpty) {
      return widget.expiryDateValidationMessage;
    }
    
    String expiryDate = '$month/$year';
    if (!CreditCardUtils.validateExpiryDate(expiryDate)) {
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0x665a7494),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(35, 180, 35, 35),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            // Card Number Input
            if (widget.isCardNumberVisible)
              _buildCardInput(
                label: 'Card Number',
                controller: _cardNumberController,
                focusNode: _cardNumberFocusNode,
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
              ),
            
            const SizedBox(height: 20),
            
            // Card Holder Name Input
            if (widget.isHolderNameVisible)
              _buildCardInput(
                label: 'Card Holders',
                controller: _cardHolderNameController,
                focusNode: _cardHolderNameFocusNode,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: _validateCardHolderName,
                onChanged: (_) => _onModelChange(),
              ),

            const SizedBox(height: 20),

            // Expiry Date and CVV Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expiry Date Section
                if (widget.isExpiryDateVisible)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Expiration Date'),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: _buildExpiryDropdown(
                                value: _currentMonth,
                                hint: 'Month',
                                items: List.generate(12, (index) {
                                  String month = (index + 1).toString().padLeft(2, '0');
                                  return DropdownMenuItem(
                                    value: month,
                                    child: Text(month),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    _currentMonth = value ?? '';
                                  });
                                  _onModelChange();
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildExpiryDropdown(
                                value: _currentYear,
                                hint: 'Year',
                                items: List.generate(12, (index) {
                                  int year = DateTime.now().year + index;
                                  String yearStr = year.toString().substring(2);
                                  return DropdownMenuItem(
                                    value: yearStr,
                                    child: Text(year.toString()),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    _currentYear = value ?? '';
                                  });
                                  _onModelChange();
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_validateExpiryDate(_currentMonth, _currentYear) != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _validateExpiryDate(_currentMonth, _currentYear)!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                if (widget.isExpiryDateVisible && widget.isCvvVisible)
                  const SizedBox(width: 35),

                // CVV Section
                if (widget.isCvvVisible)
                  SizedBox(
                    width: 150,
                    child: _buildCardInput(
                      label: 'CVV',
                      controller: _cvvCodeController,
                      focusNode: _cvvFocusNode,
                      keyboardType: TextInputType.number,
                      obscureText: widget.obscureCvv,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: _validateCvv,
                      onChanged: (_) => _onModelChange(),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: widget.onFormComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2364d2),
                  elevation: 0,
                  shadowColor: const Color(0x4d2364d2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1a3b5d),
      ),
    );
  }

  Widget _buildCardInput({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF1a3b5d),
            fontFamily: 'Source Sans Pro',
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFFced6e0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFFced6e0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF3d9cff)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: false,
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryDropdown({
    required String value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      hint: Text(hint),
      items: items,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF1a3b5d),
        fontFamily: 'Source Sans Pro',
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFced6e0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFced6e0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF3d9cff)),
        ),
        filled: false,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xFF1a3b5d),
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