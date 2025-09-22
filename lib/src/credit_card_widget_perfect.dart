import 'package:flutter/material.dart';
import 'credit_card_brand.dart';
import 'credit_card_model.dart';

/// A credit card widget that perfectly matches the Vue.js design
class CreditCardWidgetPerfect extends StatefulWidget {
  const CreditCardWidgetPerfect({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.animationDuration = const Duration(milliseconds: 500),
    this.height = 220,
    this.width = 350,
    this.textStyle,
    this.cardNumberStyle,
    this.onCreditCardWidgetChange,
    this.obscureCardNumber = true,
    this.obscureCardCvv = true,
    this.isHolderNameVisible = true,
    this.backgroundGradientColor,
    this.backgroundImage,
    this.glassmorphismConfig,
    this.enableFlipping = true,
    this.cvvValidationMessage,
    this.dateValidationMessage,
    this.numberValidationMessage,
    this.isChipVisible = true,
    this.isSwipeGestureEnabled = true,
    this.customCardTypeIcons = const <CreditCardBrand, Widget>{},
    this.chipColor,
    this.floatingConfig,
  });

  /// Card number to display
  final String cardNumber;

  /// Expiry date to display (MM/YY format)
  final String expiryDate;

  /// Card holder name to display
  final String cardHolderName;

  /// CVV code to display
  final String cvvCode;

  /// Whether to show the back view of the card
  final bool showBackView;

  /// Animation duration for card flip
  final Duration animationDuration;

  /// Height of the credit card widget
  final double height;

  /// Width of the credit card widget
  final double width;

  /// Text style for card details
  final TextStyle? textStyle;

  /// Text style for card number
  final TextStyle? cardNumberStyle;

  /// Callback for card brand changes
  final void Function(CreditCardBrand)? onCreditCardWidgetChange;

  /// Whether to obscure the card number
  final bool obscureCardNumber;

  /// Whether to obscure the CVV
  final bool obscureCardCvv;

  /// Whether to show the holder name
  final bool isHolderNameVisible;

  /// Background gradient colors
  final Gradient? backgroundGradientColor;

  /// Background image URL
  final String? backgroundImage;

  /// Glassmorphism configuration
  final Glassmorphism? glassmorphismConfig;

  /// Whether to enable card flipping animation
  final bool enableFlipping;

  /// CVV validation message
  final String? cvvValidationMessage;

  /// Date validation message
  final String? dateValidationMessage;

  /// Number validation message
  final String? numberValidationMessage;

  /// Whether to show the chip
  final bool isChipVisible;

  /// Whether to enable swipe gestures
  final bool isSwipeGestureEnabled;

  /// Custom card type icons
  final Map<CreditCardBrand, Widget> customCardTypeIcons;

  /// Chip color
  final Color? chipColor;

  /// Floating configuration
  final FloatingConfig? floatingConfig;

  @override
  State<CreditCardWidgetPerfect> createState() => _CreditCardWidgetPerfectState();
}

class _CreditCardWidgetPerfectState extends State<CreditCardWidgetPerfect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  
  int _currentBackgroundIndex = 1;

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
      curve: Curves.easeInOut,
    ));

    // Random background selection
    _currentBackgroundIndex = DateTime.now().millisecond % 25 + 1;
  }

  @override
  void didUpdateWidget(CreditCardWidgetPerfect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBackView != oldWidget.showBackView) {
      _toggleCardView();
    }
  }

  void _toggleCardView() {
    if (!widget.enableFlipping) return;
    
    if (widget.showBackView) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = widget.width.clamp(280.0, screenWidth * 0.9);
    final cardHeight = widget.height;
    
    return SizedBox(
      height: cardHeight,
      width: cardWidth,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14159),
            child: isShowingFront ? _buildFrontView() : _buildBackView(),
          );
        },
      ),
    );
  }

  Widget _buildFrontView() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(14, 42, 90, 0.55),
            offset: Offset(0, 20),
            blurRadius: 60,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background image
            _buildBackgroundImage(),
            // Card content
            _buildCardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackView() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(14, 42, 90, 0.55),
              offset: Offset(0, 20),
              blurRadius: 60,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Background image
              _buildBackgroundImage(),
              // Back content
              _buildBackContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1c1d27),
        ),
        child: Stack(
          children: [
            if (widget.backgroundImage != null)
              Image.network(
                widget.backgroundImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF1c1d27),
                ),
              )
            else
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

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with chip and brand
          _buildTopRow(),
          
          const SizedBox(height: 20),
          
          // Card number
          _buildCardNumber(),
          
          const Spacer(),
          
          // Bottom row with holder name and expiry
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Chip
        if (widget.isChipVisible)
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              color: widget.chipColor ?? Colors.amber,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        // Card brand icon
        SizedBox(
          height: 30,
          child: _buildCardTypeIcon(),
        ),
      ],
    );
  }

  Widget _buildCardNumber() {
    final brand = _getCardBrand();
    final displayNumber = _formatCardNumber();
    
    return Text(
      displayNumber,
      style: widget.cardNumberStyle ?? const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.0,
        fontFamily: 'monospace',
        height: 1.4,
        shadows: [
          Shadow(
            offset: Offset(7, 6),
            blurRadius: 10,
            color: Color.fromRGBO(14, 42, 90, 0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Card holder name
        if (widget.isHolderNameVisible)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Holder',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.cardHolderName.isEmpty ? 'FULL NAME' : widget.cardHolderName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        
        const SizedBox(width: 20),
        
        // Expiry date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Expires',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                letterSpacing: 0.3,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.expiryDate.isEmpty ? 'MM/YY' : widget.expiryDate,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                height: 1.4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackContent() {
    return Column(
      children: [
        // Magnetic stripe
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.only(top: 30),
          color: const Color.fromRGBO(0, 0, 19, 0.8),
        ),
        
        const Spacer(),
        
        // CVV section
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    width: 120,
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.obscureCardCvv 
                            ? '*' * widget.cvvCode.length
                            : widget.cvvCode,
                        style: const TextStyle(
                          color: Color(0xFF1a3b5d),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Card brand on back
                  SizedBox(
                    height: 30,
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
    );
  }

  Widget _buildCardTypeIcon() {
    final brand = _getCardBrand();
    
    if (widget.customCardTypeIcons.containsKey(brand)) {
      return widget.customCardTypeIcons[brand]!;
    }
    
    String iconPath;
    switch (brand) {
      case CreditCardBrand.visa:
        iconPath = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/visa.png';
        break;
      case CreditCardBrand.mastercard:
        iconPath = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/mastercard.png';
        break;
      case CreditCardBrand.americanExpress:
        iconPath = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/amex.png';
        break;
      case CreditCardBrand.discover:
        iconPath = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/discover.png';
        break;
      default:
        iconPath = 'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/visa.png';
    }
    
    return Image.network(
      iconPath,
      height: 30,
      fit: BoxFit.contain,
      alignment: Alignment.centerRight,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );
  }

  CreditCardBrand _getCardBrand() {
    final number = widget.cardNumber.replaceAll(RegExp(r'\s+'), '');
    
    if (number.startsWith('4')) {
      return CreditCardBrand.visa;
    } else if (number.startsWith(RegExp(r'5[1-5]'))) {
      return CreditCardBrand.mastercard;
    } else if (number.startsWith(RegExp(r'3[47]'))) {
      return CreditCardBrand.americanExpress;
    } else if (number.startsWith('6011')) {
      return CreditCardBrand.discover;
    }
    
    return CreditCardBrand.visa;
  }

  String _formatCardNumber() {
    final number = widget.cardNumber.replaceAll(RegExp(r'\s+'), '');
    final brand = _getCardBrand();
    
    if (widget.obscureCardNumber && number.length > 4) {
      if (brand == CreditCardBrand.americanExpress) {
        // Amex format: 4-6-5
        final first4 = number.substring(0, 4);
        final last5 = number.length >= 15 ? number.substring(10) : '';
        final middle = '*' * (number.length - first4.length - last5.length);
        
        if (number.length <= 4) return number;
        if (number.length <= 10) return '$first4 $middle';
        return '$first4 $middle $last5';
      } else {
        // Other cards format: 4-4-4-4
        final first4 = number.substring(0, 4);
        final last4 = number.length >= 8 ? number.substring(number.length - 4) : '';
        final middleLength = number.length - first4.length - last4.length;
        final middle = '*' * middleLength;
        
        if (number.length <= 4) return _formatVisibleNumber(number);
        if (number.length <= 8) return '$first4 $middle';
        return '$first4 $middle $last4';
      }
    } else {
      return _formatVisibleNumber(number);
    }
  }

  String _formatVisibleNumber(String number) {
    final brand = _getCardBrand();
    
    if (brand == CreditCardBrand.americanExpress) {
      // Amex format: 4-6-5
      if (number.length <= 4) return number;
      if (number.length <= 10) return '${number.substring(0, 4)} ${number.substring(4)}';
      return '${number.substring(0, 4)} ${number.substring(4, 10)} ${number.substring(10)}';
    } else {
      // Other cards format: 4-4-4-4
      final formatted = StringBuffer();
      for (int i = 0; i < number.length; i++) {
        if (i > 0 && i % 4 == 0) {
          formatted.write(' ');
        }
        formatted.write(number[i]);
      }
      return formatted.toString();
    }
  }
}

/// Configuration for glassmorphism effect
class Glassmorphism {
  final double blurX;
  final double blurY;
  final Gradient gradient;

  const Glassmorphism({
    this.blurX = 8.0,
    this.blurY = 16.0,
    required this.gradient,
  });
}

/// Configuration for floating animation
class FloatingConfig {
  final bool isFloating;
  final Duration duration;
  final double offset;

  const FloatingConfig({
    this.isFloating = false,
    this.duration = const Duration(seconds: 2),
    this.offset = 8.0,
  });
}