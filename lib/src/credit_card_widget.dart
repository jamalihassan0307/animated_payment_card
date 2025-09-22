import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'credit_card_brand.dart';
import 'utils/credit_card_utils.dart';

/// A beautiful, animated credit card widget with flip animation
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

  const CreditCardWidget({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.height = 200,
    this.width = 350,
    this.animationDuration = const Duration(milliseconds: 600),
    this.labelCardHolder = 'Card Holder',
    this.labelExpiry = 'Expires',
    this.cardBgColor = const Color(0xFF1B263B),
    this.backgroundGradientColor,
    this.backgroundNetworkImage,
    this.cardType,
    this.obscureCardNumber = true,
    this.obscureCardCvv = true,
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.onCreditCardWidgetChange,
    this.customCardTypeIcons = const {},
    this.frontCardBorder,
    this.backCardBorder,
  }) : super(key: key);

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  CreditCardBrand _cardBrand = CreditCardBrand.unknown;

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

    _updateCardBrand();
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * math.pi),
            child: isShowingFront
                ? _buildFrontCard()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBackCard(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: widget.frontCardBorder,
        gradient: widget.backgroundGradientColor ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.cardBgColor,
                // ignore: deprecated_member_use
                widget.cardBgColor.withOpacity(0.8),
              ],
            ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            if (widget.backgroundNetworkImage != null)
              Positioned.fill(
                child: Image.network(
                  widget.backgroundNetworkImage!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'CHIP',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      _buildCardTypeIcon(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (widget.isCardNumberVisible)
                    _buildCardNumber(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: widget.backCardBorder,
        gradient: widget.backgroundGradientColor ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.cardBgColor,
                widget.cardBgColor.withValues(alpha: 0.8),
              ],
            ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              height: 40,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'CVV',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.obscureCardCvv
                              ? '*' * widget.cvvCode.length
                              : widget.cvvCode,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  _buildCardTypeIcon(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumber() {
    String cardNumber = widget.cardNumber;
    if (widget.obscureCardNumber && cardNumber.isNotEmpty) {
      String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
      if (cleanNumber.length > 4) {
        String lastFour = cleanNumber.substring(cleanNumber.length - 4);
        cardNumber = '**** **** **** $lastFour';
      }
    } else {
      cardNumber = CreditCardUtils.formatCardNumber(cardNumber, _cardBrand);
    }

    return Text(
      cardNumber.isEmpty ? '**** **** **** ****' : cardNumber,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildCardHolderName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelCardHolder,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.cardHolderName.isEmpty ? 'FULL NAME' : widget.cardHolderName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildExpiryDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.labelExpiry,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.expiryDate.isEmpty ? 'MM/YY' : widget.expiryDate,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCardTypeIcon() {
    if (widget.customCardTypeIcons.containsKey(_cardBrand)) {
      return widget.customCardTypeIcons[_cardBrand]!;
    }

    if (_cardBrand == CreditCardBrand.unknown) {
      return const SizedBox.shrink();
    }

    return const Icon(
      Icons.credit_card,
      color: Colors.white,
      size: 30,
    );
  }
}