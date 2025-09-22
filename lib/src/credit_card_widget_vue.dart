import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_brand.dart';

/// A credit card widget that perfectly matches the Vue.js implementation
class CreditCardWidgetVue extends StatefulWidget {
  const CreditCardWidgetVue({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.focusedField,
    this.isCardNumberMasked = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.onCreditCardWidgetChange,
  });

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool showBackView;
  final String? focusedField;
  final bool isCardNumberMasked;
  final Duration animationDuration;
  final void Function(CreditCardBrand)? onCreditCardWidgetChange;

  @override
  State<CreditCardWidgetVue> createState() => _CreditCardWidgetVueState();
}

class _CreditCardWidgetVueState extends State<CreditCardWidgetVue>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _focusController;
  late Animation<double> _flipAnimation;
  late Animation<double> _focusAnimation;

  int _currentBackgroundIndex = 1;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _focusController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _currentBackgroundIndex = DateTime.now().millisecond % 25 + 1;
  }

  @override
  void didUpdateWidget(CreditCardWidgetVue oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showBackView != oldWidget.showBackView) {
      if (widget.showBackView) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }

    if (widget.focusedField != oldWidget.focusedField) {
      if (widget.focusedField != null && widget.focusedField!.isNotEmpty) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing like Vue.js
    double cardWidth;
    double cardHeight;
    
    if (screenWidth <= 360) {
      cardWidth = screenWidth * 0.9;
      cardHeight = 180;
    } else if (screenWidth <= 480) {
      cardWidth = 310;
      cardHeight = 220;
    } else {
      cardWidth = 430;
      cardHeight = 270;
    }

    return Container(
      width: cardWidth,
      height: cardHeight,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14159),
            child: isShowingFront
                ? _buildFrontView(cardWidth, cardHeight)
                : _buildBackView(cardWidth, cardHeight),
          );
        },
      ),
    );
  }

  Widget _buildFrontView(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(14, 42, 90, 0.55),
            offset: Offset(0, 20),
            blurRadius: 60,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background
            _buildBackground(),
            // Focus overlay
            _buildFocusOverlay(),
            // Card content
            _buildCardContent(width, height),
          ],
        ),
      ),
    );
  }

  Widget _buildBackView(double width, double height) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(14, 42, 90, 0.55),
              offset: Offset(0, 20),
              blurRadius: 60,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Background
              _buildBackground(),
              // Back content
              _buildBackContent(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1c1d27),
        ),
        child: Stack(
          children: [
            // Background image
            Image.network(
              'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/$_currentBackgroundIndex.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF1c1d27),
              ),
            ),
            // Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(6, 2, 29, 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusOverlay() {
    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        if (_focusAnimation.value == 0.0) return const SizedBox();

        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.65 * _focusAnimation.value),
                width: 2,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: const Color.fromRGBO(8, 20, 47, 0.5)
                    .withOpacity(_focusAnimation.value),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(double width, double height) {
    final isSmall = height < 200;
    final padding = isSmall ? 20.0 : 25.0;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with chip and card type
          _buildTopRow(isSmall),

          // Card number section
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: _buildCardNumber(isSmall),
            ),
          ),

          // Bottom content
          _buildBottomContent(isSmall),
        ],
      ),
    );
  }

  Widget _buildTopRow(bool isSmall) {
    final chipWidth = isSmall ? 40.0 : 60.0;
    final chipHeight = isSmall ? 25.0 : 30.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Chip
        Container(
          width: chipWidth,
          height: chipHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Image.network(
            'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/chip.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.amber,
            ),
          ),
        ),

        // Card type icon
        SizedBox(
          height: isSmall ? 30 : 45,
          width: isSmall ? 60 : 100,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: _buildCardTypeIcon(),
          ),
        ),
      ],
    );
  }

  Widget _buildCardNumber(bool isSmall) {
    final fontSize = isSmall ? 19.0 : 27.0;
    final letterSpacing = isSmall ? 1.5 : 2.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        _formatCardNumber(),
        key: ValueKey(widget.cardNumber),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          letterSpacing: letterSpacing,
          fontFamily: 'Source Code Pro',
          height: 1.4,
          shadows: const [
            Shadow(
              offset: Offset(7, 6),
              blurRadius: 10,
              color: Color.fromRGBO(14, 42, 90, 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContent(bool isSmall) {
    final smallFontSize = isSmall ? 10.0 : 13.0;
    final largeFontSize = isSmall ? 14.0 : 18.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Card holder info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Card Holder',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: smallFontSize,
                  letterSpacing: 0.3,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  widget.cardHolderName.isEmpty
                      ? 'FULL NAME'
                      : widget.cardHolderName.toUpperCase(),
                  key: ValueKey(widget.cardHolderName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Expiry date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Expires',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: smallFontSize,
                letterSpacing: 0.3,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Text(
                widget.expiryDate.isEmpty ? 'MM/YY' : widget.expiryDate,
                key: ValueKey(widget.expiryDate),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: largeFontSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackContent(double width, double height) {
    final isSmall = height < 200;
    final stripeHeight = isSmall ? 40.0 : 50.0;
    final topMargin = isSmall ? 20.0 : 30.0;

    return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          // Magnetic stripe
          Container(
            width: double.infinity,
            height: stripeHeight,
            margin: EdgeInsets.only(top: topMargin),
            color: const Color.fromRGBO(0, 0, 19, 0.8),
          ),

          const Spacer(),

          // CVV section
          Container(
            padding: EdgeInsets.all(isSmall ? 10.0 : 15.0),
            child: Row(
              children: [
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CVV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 12.0 : 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: isSmall ? 35.0 : 45.0,
                      width: isSmall ? 80.0 : 120.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(32, 56, 117, 0.35),
                            offset: Offset(0, 10),
                            blurRadius: 20,
                            spreadRadius: -7,
                          ),
                        ],
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '*' * widget.cvvCode.length,
                        style: TextStyle(
                          color: const Color(0xFF1a3b5d),
                          fontSize: isSmall ? 14.0 : 18.0,
                        ),
                      ),
                    ),
                    SizedBox(height: isSmall ? 15.0 : 30.0),
                    // Card type on back
                    SizedBox(
                      height: isSmall ? 20.0 : 30.0,
                      child: Opacity(
                        opacity: 0.7,
                        child: _buildCardTypeIcon(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTypeIcon() {
    final cardType = _getCardType();
    String iconUrl;

    switch (cardType) {
      case CreditCardBrand.visa:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/visa.png';
        break;
      case CreditCardBrand.mastercard:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/mastercard.png';
        break;
      case CreditCardBrand.americanExpress:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/amex.png';
        break;
      case CreditCardBrand.discover:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/discover.png';
        break;
      case CreditCardBrand.jcb:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/jcb.png';
        break;
      case CreditCardBrand.unionPay:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/unionpay.png';
        break;
      case CreditCardBrand.dinersClub:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/dinersclub.png';
        break;
      default:
        iconUrl = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/visa.png';
    }

    return Image.network(
      iconUrl,
      key: ValueKey(iconUrl),
      fit: BoxFit.contain,
      alignment: Alignment.centerRight,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );
  }

  CreditCardBrand _getCardType() {
    final number = widget.cardNumber.replaceAll(RegExp(r'\s+'), '');

    if (number.startsWith('4')) {
      return CreditCardBrand.visa;
    } else if (number.startsWith(RegExp(r'5[1-5]')) || number.startsWith(RegExp(r'2[2-7]'))) {
      return CreditCardBrand.mastercard;
    } else if (number.startsWith(RegExp(r'3[47]'))) {
      return CreditCardBrand.americanExpress;
    } else if (number.startsWith('6011') || number.startsWith(RegExp(r'64[4-9]')) || number.startsWith('65')) {
      return CreditCardBrand.discover;
    } else if (number.startsWith('35')) {
      return CreditCardBrand.jcb;
    } else if (number.startsWith('62')) {
      return CreditCardBrand.unionPay;
    } else if (number.startsWith(RegExp(r'30[0-5]')) || number.startsWith('36') || number.startsWith('38')) {
      return CreditCardBrand.dinersClub;
    }

    return CreditCardBrand.visa; // default
  }

  String _formatCardNumber() {
    final number = widget.cardNumber.replaceAll(RegExp(r'\s+'), '');
    final cardType = _getCardType();

    String placeholder;
    if (cardType == CreditCardBrand.americanExpress) {
      placeholder = '#### ###### #####';
    } else if (cardType == CreditCardBrand.dinersClub) {
      placeholder = '#### ###### ####';
    } else {
      placeholder = '#### #### #### ####';
    }

    final result = StringBuffer();
    int numberIndex = 0;

    for (int i = 0; i < placeholder.length; i++) {
      final char = placeholder[i];
      
      if (char == '#') {
        if (numberIndex < number.length) {
          // Show the actual number
          final shouldMask = widget.isCardNumberMasked && 
                           numberIndex > 4 && 
                           numberIndex < number.length - 4;
          
          result.write(shouldMask ? '*' : number[numberIndex]);
          numberIndex++;
        } else {
          // Show placeholder
          result.write(char);
        }
      } else {
        // Space or other characters
        result.write(char);
      }
    }

    return result.toString();
  }
}