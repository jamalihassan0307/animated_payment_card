import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_model.dart';
import 'utils/credit_card_utils.dart';

/// A credit card form that perfectly matches the Vue.js design
class CreditCardFormPerfect extends StatefulWidget {
  const CreditCardFormPerfect({
    super.key,
    required this.formKey,
    required this.onCreditCardModelChange,
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.cvvCode = '',
    this.obscureNumber = false,
    this.obscureCvv = true,
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.isCvvVisible = true,
    this.enableCardNumberMasking = true,
    this.cardNumberValidator,
    this.expiryDateValidator,
    this.cvvValidator,
    this.cardHolderValidator,
    this.cardNumberDecoration = const InputDecoration(),
    this.cardHolderDecoration = const InputDecoration(),
    this.expiryDateDecoration = const InputDecoration(),
    this.cvvCodeDecoration = const InputDecoration(),
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.onFormComplete,
  });

  /// Global form key for validation
  final GlobalKey<FormState> formKey;

  /// Callback when credit card model changes
  final void Function(CreditCardModel) onCreditCardModelChange;

  /// Initial card number
  final String cardNumber;

  /// Initial expiry date
  final String expiryDate;

  /// Initial card holder name
  final String cardHolderName;

  /// Initial CVV code
  final String cvvCode;

  /// Whether to obscure the card number input
  final bool obscureNumber;

  /// Whether to obscure the CVV input
  final bool obscureCvv;

  /// Whether to show the holder name field
  final bool isHolderNameVisible;

  /// Whether to show the card number field
  final bool isCardNumberVisible;

  /// Whether to show the expiry date field
  final bool isExpiryDateVisible;

  /// Whether to show the CVV field
  final bool isCvvVisible;

  /// Whether to enable card number masking
  final bool enableCardNumberMasking;

  /// Card number validator
  final String? Function(String?)? cardNumberValidator;

  /// Expiry date validator
  final String? Function(String?)? expiryDateValidator;

  /// CVV validator
  final String? Function(String?)? cvvValidator;

  /// Card holder validator
  final String? Function(String?)? cardHolderValidator;

  /// Card number field decoration
  final InputDecoration cardNumberDecoration;

  /// Card holder field decoration
  final InputDecoration cardHolderDecoration;

  /// Expiry date field decoration
  final InputDecoration expiryDateDecoration;

  /// CVV field decoration
  final InputDecoration cvvCodeDecoration;

  /// Theme color for the form
  final Color? themeColor;

  /// Text color
  final Color textColor;

  /// Cursor color
  final Color? cursorColor;

  /// Callback when form is complete
  final VoidCallback? onFormComplete;

  @override
  State<CreditCardFormPerfect> createState() => _CreditCardFormPerfectState();
}

class _CreditCardFormPerfectState extends State<CreditCardFormPerfect> {
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cardHolderNameController;
  late TextEditingController _cvvCodeController;

  late FocusNode _cardNumberFocus;
  late FocusNode _expiryDateFocus;
  late FocusNode _cardHolderNameFocus;
  late FocusNode _cvvCodeFocus;

  bool _isCvvFocused = false;
  String _selectedMonth = '';
  String _selectedYear = '';

  @override
  void initState() {
    super.initState();

    _cardNumberController = TextEditingController(text: widget.cardNumber);
    _expiryDateController = TextEditingController(text: widget.expiryDate);
    _cardHolderNameController = TextEditingController(text: widget.cardHolderName);
    _cvvCodeController = TextEditingController(text: widget.cvvCode);

    _cardNumberFocus = FocusNode();
    _expiryDateFocus = FocusNode();
    _cardHolderNameFocus = FocusNode();
    _cvvCodeFocus = FocusNode();

    _cvvCodeFocus.addListener(() {
      setState(() {
        _isCvvFocused = _cvvCodeFocus.hasFocus;
      });
      _onCreditCardModelChange();
    });

    _cardNumberController.addListener(_onCreditCardModelChange);
    _expiryDateController.addListener(_onCreditCardModelChange);
    _cardHolderNameController.addListener(_onCreditCardModelChange);
    _cvvCodeController.addListener(_onCreditCardModelChange);

    // Parse initial expiry date
    if (widget.expiryDate.isNotEmpty) {
      final parts = widget.expiryDate.split('/');
      if (parts.length == 2) {
        _selectedMonth = parts[0];
        _selectedYear = parts[1];
      }
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardHolderNameController.dispose();
    _cvvCodeController.dispose();

    _cardNumberFocus.dispose();
    _expiryDateFocus.dispose();
    _cardHolderNameFocus.dispose();
    _cvvCodeFocus.dispose();

    super.dispose();
  }

  void _onCreditCardModelChange() {
    final expiryDate = _selectedMonth.isNotEmpty && _selectedYear.isNotEmpty
        ? '$_selectedMonth/$_selectedYear'
        : '';

    widget.onCreditCardModelChange(
      CreditCardModel(
        cardNumber: _cardNumberController.text,
        expiryDate: expiryDate,
        cardHolderName: _cardHolderNameController.text,
        cvvCode: _cvvCodeController.text,
        isCvvFocused: _isCvvFocused,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: widget.themeColor ?? const Color(0xFF3d9cff),
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: widget.themeColor ?? const Color(0xFF3d9cff),
        ),
      ),
      child: Form(
        key: widget.formKey,
        child: Container(
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(90, 116, 148, 0.4),
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: Column(
            children: [
              // Card Number field
              if (widget.isCardNumberVisible) ...[
                _buildCardNumberField(),
                const SizedBox(height: 20),
              ],

              // Card Holder field
              if (widget.isHolderNameVisible) ...[
                _buildCardHolderField(),
                const SizedBox(height: 20),
              ],

              // Expiry Date and CVV row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expiry Date
                  if (widget.isExpiryDateVisible)
                    Expanded(
                      flex: 2,
                      child: _buildExpiryDateField(),
                    ),

                  if (widget.isExpiryDateVisible && widget.isCvvVisible)
                    const SizedBox(width: 35),

                  // CVV
                  if (widget.isCvvVisible)
                    Expanded(
                      flex: 1,
                      child: _buildCvvField(),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Submit button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Card Number'),
        const SizedBox(height: 5),
        TextFormField(
          controller: _cardNumberController,
          focusNode: _cardNumberFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          obscureText: widget.obscureNumber,
          style: _getInputTextStyle(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            if (widget.enableCardNumberMasking)
              CardNumberInputFormatter(),
          ],
          decoration: _getInputDecoration(
            widget.cardNumberDecoration.copyWith(
              hintText: widget.cardNumberDecoration.hintText ?? '1234 5678 9012 3456',
            ),
          ),
          validator: widget.cardNumberValidator ?? _validateCardNumber,
          onFieldSubmitted: (_) => _cardHolderNameFocus.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildCardHolderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Card Holders'),
        const SizedBox(height: 5),
        TextFormField(
          controller: _cardHolderNameController,
          focusNode: _cardHolderNameFocus,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          style: _getInputTextStyle(),
          decoration: _getInputDecoration(
            widget.cardHolderDecoration.copyWith(
              hintText: widget.cardHolderDecoration.hintText ?? 'Full Name',
            ),
          ),
          validator: widget.cardHolderValidator ?? _validateCardHolder,
          onFieldSubmitted: (_) => _expiryDateFocus.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildExpiryDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Expiration Date'),
        const SizedBox(height: 5),
        Row(
          children: [
            // Month dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedMonth.isEmpty ? null : _selectedMonth,
                style: _getInputTextStyle(),
                decoration: _getInputDecoration(const InputDecoration()).copyWith(
                  hintText: 'Month',
                ),
                items: List.generate(12, (index) {
                  final month = (index + 1).toString().padLeft(2, '0');
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value ?? '';
                  });
                  _onCreditCardModelChange();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select month';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 15),
            // Year dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedYear.isEmpty ? null : _selectedYear,
                style: _getInputTextStyle(),
                decoration: _getInputDecoration(const InputDecoration()).copyWith(
                  hintText: 'Year',
                ),
                items: List.generate(12, (index) {
                  final year = (DateTime.now().year + index).toString().substring(2);
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value ?? '';
                  });
                  _onCreditCardModelChange();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select year';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCvvField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('CVV'),
        const SizedBox(height: 5),
        TextFormField(
          controller: _cvvCodeController,
          focusNode: _cvvCodeFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          obscureText: widget.obscureCvv,
          style: _getInputTextStyle(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: _getInputDecoration(
            widget.cvvCodeDecoration.copyWith(
              hintText: widget.cvvCodeDecoration.hintText ?? '123',
            ),
          ),
          validator: widget.cvvValidator ?? _validateCvv,
          onFieldSubmitted: (_) => widget.onFormComplete?.call(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (widget.formKey.currentState?.validate() ?? false) {
            widget.onFormComplete?.call();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2364d2),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: const Color.fromRGBO(35, 100, 210, 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Source Sans Pro',
          ),
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

  InputDecoration _getInputDecoration(InputDecoration decoration) {
    return decoration.copyWith(
      filled: false,
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
        borderSide: BorderSide(color: widget.themeColor ?? const Color(0xFF3d9cff)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  TextStyle _getInputTextStyle() {
    return TextStyle(
      fontSize: 18,
      color: widget.textColor,
      fontFamily: 'Source Sans Pro',
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    }
    
    final cleanNumber = value.replaceAll(RegExp(r'\s+'), '');
    if (cleanNumber.length < 13) {
      return 'Card number is too short';
    }
    
    if (!CreditCardUtils.validateCardNumber(cleanNumber)) {
      return 'Invalid card number';
    }
    
    return null;
  }

  String? _validateCardHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card holder name';
    }
    
    if (value.length < 2) {
      return 'Name is too short';
    }
    
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    }
    
    if (value.length < 3) {
      return 'CVV is too short';
    }
    
    return null;
  }
}

/// Input formatter for card number with proper spacing
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\s+'), '');
    
    if (text.length > 19) {
      return oldValue;
    }
    
    final formatted = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }
      formatted.write(text[i]);
    }
    
    final formattedText = formatted.toString();
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}