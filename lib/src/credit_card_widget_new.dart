import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'credit_card_brand.dart';
import 'utils/credit_card_utils.dart';

/// A beautiful, animated credit card widget with flip animation
/// Accurately recreates the original Vue.js design
class CreditCardWidget extends StatefulWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool showBackView;
  final double height;
  final double width;
  final Duration animationDuration;
  final String labelCardHolder;
  final String labelExpiry;
  final Color cardBgColor;
  final Gradient? backgroundGradientColor;
  final String? backgroundNetworkImage;
  final CreditCardBrand? cardType;
  final bool obscureCardNumber;
  final bool obscureCardCvv;
  final bool isHolderNameVisible;
  final bool isCardNumberVisible;
  final bool isExpiryDateVisible;
  final void Function(CreditCardBrand)? onCreditCardWidgetChange;
  final Map<CreditCardBrand, Widget> customCardTypeIcons;
  final Border? frontCardBorder;
  final Border? backCardBorder;
  final Widget? focusedField;
  final bool isInputFocused;

  const CreditCardWidget({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.height = 270,
    this.width = 430,
    this.animationDuration = const Duration(milliseconds: 800),
    this.labelCardHolder = 'Card Holder',
    this.labelExpiry = 'Expires',
    this.cardBgColor = const Color(0xFF1c1d27),
    this.backgroundGradientColor,
    this.backgroundNetworkImage,
    this.cardType,
    this.obscureCardNumber = false,
    this.obscureCardCvv = true,
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.onCreditCardWidgetChange,
    this.customCardTypeIcons = const {},
    this.frontCardBorder,
    this.backCardBorder,
    this.focusedField,
    this.isInputFocused = false,
  }) : super(key: key);

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  CreditCardBrand _cardBrand = CreditCardBrand.unknown;
  String _backgroundImage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Cubic(0.71, 0.03, 0.56, 0.85),
    ));

    _updateCardBrand();
    _setRandomBackground();
  }

  @override
  void didUpdateWidget(CreditCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.cardNumber != widget.cardNumber) {
      _updateCardBrand();
    }

    if (widget.showBackView != oldWidget.showBackView) {
      if (widget.showBackView) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _updateCardBrand() {
    final newBrand = widget.cardType ?? CreditCardUtils.detectCardBrand(widget.cardNumber);
    if (newBrand != _cardBrand) {
      setState(() {
        _cardBrand = newBrand;
      });
      widget.onCreditCardWidgetChange?.call(_cardBrand);
    }
  }

  void _setRandomBackground() {
    // Generate random background number (1-25) like in original
    final random = math.Random().nextInt(25) + 1;
    _backgroundImage = 'https://raw.githubusercontent.com/jamalihassan0307/animated_payment_card/blob/main/assets/images/$random.jpeg';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: const EdgeInsets.only(bottom: -130),
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * math.pi),
            child: Container(
              width: widget.width,
              height: widget.height,
              child: isShowingFront
                  ? _buildFrontCard()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _buildBackCard(),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0e2a5a).withOpacity(0.55),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Container(
                color: widget.cardBgColor,
                child: widget.backgroundNetworkImage != null || _backgroundImage.isNotEmpty
                    ? Image.network(
                        widget.backgroundNetworkImage ?? _backgroundImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: widget.cardBgColor);
                        },
                      )
                    : null,
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      const Color(0x7306021d),
                    ],
                  ),
                ),
              ),
            ),
            // Focus Effect
            if (widget.isInputFocused && widget.focusedField != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.65),
                      width: 2,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: const Color(0x80081a2f),
                    ),
                  ),
                ),
              ),
            // Card Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section with chip and card type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chip
                        Image.network(
                          'https://raw.githubusercontent.com/jamalihassan0307/animated_payment_card/blob/main/assets/images/chip.png',
                          width: 60,
                          height: 45,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'CHIP',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // Card Type
                        _buildCardTypeIcon(),
                      ],
                    ),
                    // Card Number
                    Container(
                      width: double.infinity,
                      child: _buildCardNumber(),
                    ),
                    // Bottom section with name and expiry
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.isHolderNameVisible)
                          Expanded(child: _buildCardHolderName()),
                        if (widget.isExpiryDateVisible)
                          _buildExpiryDate(),
                      ],
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

  Widget _buildBackCard() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0e2a5a).withOpacity(0.55),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: Container(
                  color: widget.cardBgColor,
                  child: widget.backgroundNetworkImage != null || _backgroundImage.isNotEmpty
                      ? Image.network(
                          widget.backgroundNetworkImage ?? _backgroundImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: widget.cardBgColor);
                          },
                        )
                      : null,
                ),
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      const Color(0x7306021d),
                    ],
                  ),
                ),
              ),
            ),
            // Black stripe
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                color: const Color(0xCC000013),
              ),
            ),
            // CVV Section
            Positioned(
              bottom: 15,
              right: 15,
              child: _buildCvvSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumber() {
    String displayNumber = widget.cardNumber;
    if (displayNumber.isEmpty) {
      displayNumber = _cardBrand == CreditCardBrand.americanExpress 
          ? '#### ###### #####'
          : '#### #### #### ####';
    }

    // Format number based on card type
    String formattedNumber = '';
    String cleanNumber = displayNumber.replaceAll(RegExp(r'\D'), '');
    
    if (_cardBrand == CreditCardBrand.americanExpress) {
      // Amex format: #### ###### #####
      List<String> mask = ['#', '#', '#', '#', ' ', '#', '#', '#', '#', '#', '#', ' ', '#', '#', '#', '#', '#'];
      for (int i = 0; i < mask.length; i++) {
        if (mask[i] == ' ') {
          formattedNumber += ' ';
        } else {
          if (cleanNumber.length > (formattedNumber.replaceAll(' ', '').length)) {
            String digit = cleanNumber[formattedNumber.replaceAll(' ', '').length];
            // Mask digits 5-10 for Amex
            int digitIndex = formattedNumber.replaceAll(' ', '').length;
            if (widget.obscureCardNumber && digitIndex > 4 && digitIndex < 10) {
              formattedNumber += '*';
            } else {
              formattedNumber += digit;
            }
          } else {
            formattedNumber += '#';
          }
        }
      }
    } else {
      // Standard format: #### #### #### ####
      List<String> mask = ['#', '#', '#', '#', ' ', '#', '#', '#', '#', ' ', '#', '#', '#', '#', ' ', '#', '#', '#', '#'];
      for (int i = 0; i < mask.length; i++) {
        if (mask[i] == ' ') {
          formattedNumber += ' ';
        } else {
          if (cleanNumber.length > (formattedNumber.replaceAll(' ', '').length)) {
            String digit = cleanNumber[formattedNumber.replaceAll(' ', '').length];
            // Mask digits 5-12 for standard cards
            int digitIndex = formattedNumber.replaceAll(' ', '').length;
            if (widget.obscureCardNumber && digitIndex > 4 && digitIndex < 12) {
              formattedNumber += '*';
            } else {
              formattedNumber += digit;
            }
          } else {
            formattedNumber += '#';
          }
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        formattedNumber,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontFamily: 'Source Code Pro',
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          shadows: [
            Shadow(
              color: Color(0xCC0e2a5a),
              offset: Offset(7, 6),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHolderName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.labelCardHolder,
            style: const TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              shadows: [
                Shadow(
                  color: Color(0xCC0e2a5a),
                  offset: Offset(7, 6),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              widget.cardHolderName.isEmpty 
                  ? 'Full Name' 
                  : widget.cardHolderName.toUpperCase(),
              key: ValueKey(widget.cardHolderName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Color(0xCC0e2a5a),
                    offset: Offset(7, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryDate() {
    String month = '';
    String year = '';
    
    if (widget.expiryDate.contains('/')) {
      List<String> parts = widget.expiryDate.split('/');
      if (parts.length == 2) {
        month = parts[0];
        year = parts[1];
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.labelExpiry,
            style: const TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              shadows: [
                Shadow(
                  color: Color(0xCC0e2a5a),
                  offset: Offset(7, 6),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  month.isEmpty ? 'MM' : month,
                  key: ValueKey(month),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Color(0xCC0e2a5a),
                        offset: Offset(7, 6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                '/',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Color(0xCC0e2a5a),
                      offset: Offset(7, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  year.isEmpty ? 'YY' : year,
                  key: ValueKey(year),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Color(0xCC0e2a5a),
                        offset: Offset(7, 6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCvvSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'CVV',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0x59203875),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.obscureCardCvv
                    ? '*' * widget.cvvCode.length
                    : widget.cvvCode,
                style: const TextStyle(
                  color: Color(0xFF1a3b5d),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildCardTypeIcon(),
      ],
    );
  }

  Widget _buildCardTypeIcon() {
    if (widget.customCardTypeIcons.containsKey(_cardBrand)) {
      return widget.customCardTypeIcons[_cardBrand]!;
    }

    if (_cardBrand == CreditCardBrand.unknown) {
      return const SizedBox(width: 100, height: 45);
    }

    String cardTypeImage = '';
    switch (_cardBrand) {
      case CreditCardBrand.visa:
        cardTypeImage = 'visa';
        break;
      case CreditCardBrand.mastercard:
        cardTypeImage = 'mastercard';
        break;
      case CreditCardBrand.americanExpress:
        cardTypeImage = 'amex';
        break;
      case CreditCardBrand.discover:
        cardTypeImage = 'discover';
        break;
      default:
        cardTypeImage = 'visa';
    }

    return Container(
      height: 45,
      width: 100,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Image.network(
          'https://raw.githubusercontent.com/jamalihassan0307/animated_payment_card/blob/main/assets/images/$cardTypeImage.png',
          key: ValueKey(_cardBrand),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 30,
            );
          },
        ),
      ),
    );
  }
}