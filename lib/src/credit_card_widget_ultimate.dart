import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_brand.dart';
import 'credit_card_model.dart';

/// A pixel-perfect credit card widget that exactly matches the Vue.js design
class CreditCardWidgetUltimate extends StatefulWidget {
  const CreditCardWidgetUltimate({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.animationDuration = const Duration(milliseconds: 800),
    this.height,
    this.width,
    this.onCreditCardWidgetChange,
    this.obscureCardNumber = true,
    this.obscureCardCvv = true,
    this.isHolderNameVisible = true,
    this.backgroundGradientColor,
    this.glassmorphismConfig,
    this.enableFlipping = true,
    this.isChipVisible = true,
    this.customCardTypeIcons = const <CreditCardBrand, Widget>{},
    this.chipColor,
    this.focusedInputType,
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
  final double? height;

  /// Width of the credit card widget
  final double? width;

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

  /// Glassmorphism configuration
  final Glassmorphism? glassmorphismConfig;

  /// Whether to enable card flipping animation
  final bool enableFlipping;

  /// Whether to show the chip
  final bool isChipVisible;

  /// Custom card type icons
  final Map<CreditCardBrand, Widget> customCardTypeIcons;

  /// Chip color
  final Color? chipColor;

  /// Currently focused input type for highlighting
  final String? focusedInputType;

  @override
  State<CreditCardWidgetUltimate> createState() => _CreditCardWidgetUltimateState();
}

class _CreditCardWidgetUltimateState extends State<CreditCardWidgetUltimate>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _focusController;
  late AnimationController _numberController;
  
  late Animation<double> _flipAnimation;
  late Animation<double> _focusAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentBackgroundIndex = 1;
  Rect? _focusRect;

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
    
    _numberController = AnimationController(
      duration: const Duration(milliseconds: 250),
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
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _numberController,
      curve: Curves.easeInOut,
    ));

    // Random background selection
    _currentBackgroundIndex = DateTime.now().millisecond % 25 + 1;
  }

  @override
  void didUpdateWidget(CreditCardWidgetUltimate oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.showBackView != oldWidget.showBackView) {
      _toggleCardView();
    }
    
    if (widget.focusedInputType != oldWidget.focusedInputType) {
      _updateFocusAnimation();
    }
    
    if (widget.cardNumber != oldWidget.cardNumber) {
      _numberController.forward().then((_) => _numberController.reverse());
    }
  }

  void _toggleCardView() {
    if (!widget.enableFlipping) return;
    
    if (widget.showBackView) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }
  
  void _updateFocusAnimation() {
    if (widget.focusedInputType != null && widget.focusedInputType!.isNotEmpty) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _focusController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    double cardWidth;
    double cardHeight;
    
    if (screenSize.width <= 480) {
      cardWidth = widget.width ?? (screenSize.width * 0.9).clamp(280, 310);
      cardHeight = widget.height ?? 180;
    } else if (screenSize.width <= 700) {
      cardWidth = widget.width ?? 350;
      cardHeight = widget.height ?? 220;
    } else {
      cardWidth = widget.width ?? 430;
      cardHeight = widget.height ?? 270;
    }
    
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
            child: isShowingFront ? _buildFrontView(cardWidth, cardHeight) : _buildBackView(cardWidth, cardHeight),
          );
        },
      ),
    );
  }

  Widget _buildFrontView(double cardWidth, double cardHeight) {
    return Container(
      width: cardWidth,
      height: cardHeight,
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
            // Focus overlay
            _buildFocusOverlay(),
            // Card content
            _buildCardContent(cardWidth, cardHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildBackView(double cardWidth, double cardHeight) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        width: cardWidth,
        height: cardHeight,
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
              _buildBackContent(cardWidth, cardHeight),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: const Color.fromRGBO(8, 20, 47, 0.5).withOpacity(_focusAnimation.value),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(double cardWidth, double cardHeight) {
    final isSmall = cardHeight < 200;
    final padding = isSmall ? 15.0 : 25.0;
    
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with chip and brand
          _buildTopRow(isSmall),
          
          // Flexible space for card number
          Expanded(
            flex: 2,
            child: Center(
              child: _buildCardNumber(isSmall),
            ),
          ),
          
          // Bottom row with holder name and expiry
          _buildBottomRow(isSmall),
        ],
      ),
    );
  }

  Widget _buildTopRow(bool isSmall) {
    final chipSize = isSmall ? 30.0 : 40.0;
    final chipHeight = isSmall ? 25.0 : 30.0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Chip
        if (widget.isChipVisible)
          Container(
            width: chipSize,
            height: chipHeight,
            decoration: BoxDecoration(
              color: widget.chipColor ?? Colors.amber,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        // Card brand icon
        SizedBox(
          height: chipHeight,
          child: _buildCardTypeIcon(),
        ),
      ],
    );
  }

  Widget _buildCardNumber(bool isSmall) {
    final fontSize = isSmall ? 19.0 : 24.0;
    final brand = _getCardBrand();
    final displayNumber = _formatCardNumber();
    
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value * _numberController.value,
          child: AnimatedOpacity(
            opacity: 1.0 - (_numberController.value * 0.3),
            duration: const Duration(milliseconds: 100),
            child: Text(
              displayNumber,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.0,
                fontFamily: 'monospace',
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
          ),
        );
      },
    );
  }

  Widget _buildBottomRow(bool isSmall) {
    final smallFontSize = isSmall ? 10.0 : 12.0;
    final largeFontSize = isSmall ? 14.0 : 16.0;
    
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
                    fontSize: smallFontSize,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
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
                    widget.cardHolderName.isEmpty ? 'FULL NAME' : widget.cardHolderName.toUpperCase(),
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
            const SizedBox(height: 4),
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

  Widget _buildBackContent(double cardWidth, double cardHeight) {
    final isSmall = cardHeight < 200;
    final stripeHeight = isSmall ? 30.0 : 50.0;
    final stripeMargin = isSmall ? 15.0 : 30.0;
    
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Column(
        children: [
          // Magnetic stripe
          Container(
            width: double.infinity,
            height: stripeHeight,
            margin: EdgeInsets.only(top: stripeMargin),
            color: const Color.fromRGBO(0, 0, 19, 0.8),
          ),
          
          // Flexible space
          Expanded(
            child: Container(),
          ),
          
          // CVV section
          Container(
            padding: EdgeInsets.all(isSmall ? 10 : 15),
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
                        fontSize: isSmall ? 12 : 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: isSmall ? 30 : 45,
                      width: isSmall ? 80 : 120,
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
                          style: TextStyle(
                            color: const Color(0xFF1a3b5d),
                            fontSize: isSmall ? 14 : 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmall ? 15 : 30),
                    // Card brand on back
                    SizedBox(
                      height: isSmall ? 20 : 30,
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
    
    return AnimatedSwitcher(
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
      child: Image.network(
        iconPath,
        key: ValueKey(iconPath),
        height: 30,
        fit: BoxFit.contain,
        alignment: Alignment.centerRight,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      ),
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
        // Amex format: 4-6-5 with masking
        if (number.length <= 4) return _formatVisibleNumber(number);
        if (number.length <= 10) {
          final visible = number.substring(0, 4);
          final masked = '*' * (number.length - 4);
          return '$visible $masked';
        }
        // Show first 4 and last 5, mask middle
        final first4 = number.substring(0, 4);
        final last5 = number.substring(number.length - 5);
        final maskedLength = number.length - 9;
        final masked = maskedLength > 0 ? ' ${'*' * maskedLength} ' : ' ';
        return '$first4$masked$last5';
      } else {
        // Other cards: show first 4 and last 4, mask middle
        if (number.length <= 8) {
          final visible = number.substring(0, 4);
          final masked = '*' * (number.length - 4);
          return '$visible $masked';
        }
        final first4 = number.substring(0, 4);
        final last4 = number.substring(number.length - 4);
        final maskedLength = number.length - 8;
        final masked = maskedLength > 0 ? ' ${'*' * maskedLength} ' : ' ';
        return '$first4$masked$last4';
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