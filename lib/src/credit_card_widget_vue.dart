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
  late AnimationController _numberController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  
  late Animation<double> _flipAnimation;
  late Animation<double> _focusAnimation;
  late Animation<double> _numberFadeAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<Offset> _slideDownAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<Color?> _glowAnimation;

  int _currentBackgroundIndex = 1;
  String _previousCardNumber = '';

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _focusController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _numberController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Enhanced animations
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutCubic,
    ));

    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.elasticOut,
    ));

    _numberFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _numberController,
      curve: Curves.easeOutBack,
    ));

    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _slideDownAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white.withOpacity(0.3),
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _currentBackgroundIndex = DateTime.now().millisecond % 25 + 1;
    _previousCardNumber = widget.cardNumber;

    // Start continuous animations
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
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
        _slideController.forward();
      } else {
        _focusController.reverse();
        _slideController.reverse();
      }
    }

    // Animate when card number changes
    if (widget.cardNumber != oldWidget.cardNumber) {
      _numberController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _numberController.reverse();
        });
      });
      _previousCardNumber = oldWidget.cardNumber;
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _focusController.dispose();
    _numberController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
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
              'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/$_currentBackgroundIndex.jpeg',
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
      animation: Listenable.merge([_focusAnimation, _shimmerController]),
      builder: (context, child) {
        if (_focusAnimation.value == 0.0) return const SizedBox();

        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.8 * _focusAnimation.value),
                width: 2 + (_focusAnimation.value * 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3 * _focusAnimation.value),
                  offset: const Offset(0, 0),
                  blurRadius: 20 * _focusAnimation.value,
                  spreadRadius: 5 * _focusAnimation.value,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(8, 20, 47, 0.4).withOpacity(_focusAnimation.value),
                    Color.fromRGBO(16, 40, 94, 0.3).withOpacity(_focusAnimation.value),
                    Color.fromRGBO(8, 20, 47, 0.4).withOpacity(_focusAnimation.value),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated border shimmer
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(
                              begin: Alignment(_shimmerAnimation.value - 1, -1),
                              end: Alignment(_shimmerAnimation.value, 1),
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.1 * _focusAnimation.value),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
            'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/chip.png',
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
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                )),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              );
            },
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.focusedField == 'cardNumber' 
                      ? _pulseAnimation.value * 0.95 + 0.05
                      : 1.0,
                  child: _buildCardTypeIcon(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardNumber(bool isSmall) {
    final fontSize = isSmall ? 19.0 : 27.0;
    final letterSpacing = isSmall ? 1.5 : 2.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_numberController, _slideController, _shimmerController]),
      builder: (context, child) {
        return Transform.translate(
          offset: _slideUpAnimation.value * (_slideController.value),
          child: Transform.scale(
            scale: 1.0 + (_numberFadeAnimation.value * 0.08),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  if (widget.focusedField == 'cardNumber')
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3 * _slideController.value),
                      offset: const Offset(0, 0),
                      blurRadius: 20 * _slideController.value,
                      spreadRadius: 2 * _slideController.value,
                    ),
                ],
              ),
              child: Stack(
                children: [
                  // Shimmer effect
                  if (widget.focusedField == 'cardNumber')
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment(_shimmerAnimation.value - 1, 0),
                                end: Alignment(_shimmerAnimation.value, 0),
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  // Card number text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.elasticOut,
                        )),
                        child: FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.elasticOut,
                              ),
                            ),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      _formatCardNumber(),
                      key: ValueKey('${_formatCardNumber()}_${widget.focusedField}'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: letterSpacing,
                        fontFamily: 'Source Code Pro',
                        height: 1.4,
                        shadows: [
                          Shadow(
                            offset: const Offset(7, 6),
                            blurRadius: 10 + (_numberFadeAnimation.value * 8),
                            color: Color.fromRGBO(14, 42, 90, 0.8 + (_numberFadeAnimation.value * 0.2)),
                          ),
                          if (widget.focusedField == 'cardNumber')
                            Shadow(
                              offset: const Offset(0, 0),
                              blurRadius: 15 * _slideController.value,
                              color: Colors.white.withOpacity(0.5 * _slideController.value),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomContent(bool isSmall) {
    final smallFontSize = isSmall ? 10.0 : 13.0;
    final largeFontSize = isSmall ? 14.0 : 18.0;

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideDownAnimation.value * _slideController.value,
          child: Row(
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
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-0.3, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.elasticOut,
                          )),
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
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: smallFontSize,
                      letterSpacing: 0.3,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.elasticOut,
                        )),
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
          ),
        );
      },
    );
  }

  Widget _buildBackContent(double width, double height) {
    final isSmall = height < 200;
    final stripeHeight = isSmall ? 30.0 : 40.0;
    final topMargin = isSmall ? 15.0 : 25.0;
    final bottomPadding = isSmall ? 8.0 : 12.0;

    return SizedBox(
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

          // CVV section - use Expanded to fill remaining space
          Expanded(
            child: Container(
              padding: EdgeInsets.all(bottomPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
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
                              fontSize: isSmall ? 10.0 : 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: widget.focusedField == 'cardCvv' 
                                    ? _pulseAnimation.value 
                                    : 1.0,
                                child: Container(
                                  height: isSmall ? 25.0 : 30.0,
                                  width: isSmall ? 60.0 : 80.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.focusedField == 'cardCvv' 
                                            ? const Color.fromRGBO(32, 56, 117, 0.5)
                                            : const Color.fromRGBO(32, 56, 117, 0.25),
                                        offset: const Offset(0, 5),
                                        blurRadius: widget.focusedField == 'cardCvv' ? 15 : 10,
                                        spreadRadius: -3,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    widget.cvvCode.isEmpty 
                                        ? '' 
                                        : '*' * widget.cvvCode.length.clamp(0, 4),
                                    style: TextStyle(
                                      color: const Color(0xFF1a3b5d),
                                      fontSize: isSmall ? 12.0 : 14.0,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isSmall ? 8.0 : 12.0),
                          // Card type on back
                          SizedBox(
                            height: isSmall ? 15.0 : 20.0,
                            child: Opacity(
                              opacity: 0.7,
                              child: _buildCardTypeIcon(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/visa.png';
        break;
      case CreditCardBrand.mastercard:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/mastercard.png';
        break;
      case CreditCardBrand.americanExpress:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/amex.png';
        break;
      case CreditCardBrand.discover:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/discover.png';
        break;
      case CreditCardBrand.jcb:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/jcb.png';
        break;
      case CreditCardBrand.unionPay:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/unionpay.png';
        break;
      case CreditCardBrand.dinersClub:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/dinersclub.png';
        break;
      default:
        iconUrl = 'https://raw.githubusercontent.com/jamalihassan0307/flutter_credit_card/blob/main/assets/images/visa.png';
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
    final cleanNumber = widget.cardNumber.replaceAll(RegExp(r'\s+'), '');
    final cardType = _getCardType();

    // Limit to 16 digits for standard cards, 15 for Amex
    final maxLength = cardType == CreditCardBrand.americanExpress ? 15 : 16;
    final limitedNumber = cleanNumber.length > maxLength 
        ? cleanNumber.substring(0, maxLength) 
        : cleanNumber;

    String placeholder;
    if (cardType == CreditCardBrand.americanExpress) {
      placeholder = '#### ###### #####';
    } else if (cardType == CreditCardBrand.dinersClub) {
      placeholder = '#### ###### ####';
    } else {
      placeholder = '#### #### #### ####';
    }

    // If number is too short, just show what's typed with placeholder
    if (limitedNumber.length <= 4) {
      return _buildWithPlaceholder(limitedNumber, placeholder);
    }

    // For masking: show first 4, mask middle, show last 4
    if (widget.isCardNumberMasked && limitedNumber.length > 8) {
      return _buildMaskedNumber(limitedNumber, cardType);
    }

    // Show full number formatted
    return _buildFormattedNumber(limitedNumber, cardType);
  }

  String _buildWithPlaceholder(String number, String placeholder) {
    final result = StringBuffer();
    int numberIndex = 0;

    for (int i = 0; i < placeholder.length; i++) {
      final char = placeholder[i];
      if (char == '#') {
        if (numberIndex < number.length) {
          result.write(number[numberIndex]);
          numberIndex++;
        } else {
          result.write('#');
        }
      } else {
        result.write(char);
      }
    }
    return result.toString();
  }

  String _buildMaskedNumber(String number, CreditCardBrand cardType) {
    if (cardType == CreditCardBrand.americanExpress) {
      // Amex: 4-6-5 format
      final first4 = number.substring(0, 4);
      final last5 = number.length >= 5 ? number.substring(number.length - 5) : '';
      final middleStars = '*' * (number.length - 9).clamp(0, 6);
      
      if (number.length <= 4) return first4;
      if (number.length <= 10) return '$first4 $middleStars';
      return '$first4 $middleStars $last5';
    } else {
      // Standard: 4-4-4-4 format
      final first4 = number.substring(0, 4);
      final last4 = number.length >= 4 ? number.substring(number.length - 4) : '';
      final middleStars = '*' * (number.length - 8).clamp(0, 8);
      
      if (number.length <= 4) return first4;
      if (number.length <= 8) return '$first4 $middleStars';
      
      // Format: 1234 **** 5678
      return '$first4 $middleStars $last4';
    }
  }

  String _buildFormattedNumber(String number, CreditCardBrand cardType) {
    if (cardType == CreditCardBrand.americanExpress) {
      // Amex format: 4-6-5
      if (number.length <= 4) return number;
      if (number.length <= 10) return '${number.substring(0, 4)} ${number.substring(4)}';
      return '${number.substring(0, 4)} ${number.substring(4, 10)} ${number.substring(10)}';
    } else {
      // Standard format: 4-4-4-4
      final result = StringBuffer();
      for (int i = 0; i < number.length; i++) {
        if (i > 0 && i % 4 == 0) {
          result.write(' ');
        }
        result.write(number[i]);
      }
      return result.toString();
    }
  }
}