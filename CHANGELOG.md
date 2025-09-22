# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-22

### Added
- Initial release of Animated Payment Card package
- New Vue.js-inspired payment card widget with advanced animations
- Multiple widget variations: Perfect, Ultimate, New, and Vue styles
- Advanced animation effects: shimmer, pulse, elastic, slide transitions
- Premium card number masking (first 4, last 4, middle stars)
- Enhanced form validation with custom validators
- Improved card brand detection and icon animations
- Focus overlay effects with smooth transitions
- Multiple background card designs
- Responsive layout optimizations

### Fixed
- SDK constraint compatibility issues for pub.dev publishing
- Deprecated `withOpacity` usage replaced with `withValues`
- Removed unused imports, fields, and variables
- Fixed overflow issues in card layouts
- Improved performance and reduced widget rebuilds
- CVV security enhancements (no preview, only stars)

### Changed
- Updated to Flutter 3.8.1+ compatibility
- Enhanced README with comprehensive examples and documentation
- Improved API documentation and code examples
- Better error handling and validation messages
- Optimized animation performance

### Documentation
- Complete rewrite of README with professional styling
- Added comprehensive usage examples for all widgets
- Detailed API reference with parameter descriptions
- Best practices guide for security and performance
- Added screenshots and demo GIFs

## [1.0.0] - 2025-09-22

### Added
- Initial release of Flutter Credit Card package
- Beautiful, animated credit card widget with flip animation
- Automatic card brand detection for major card types (Visa, Mastercard, American Express, Discover, etc.)
- Built-in validation for card numbers, expiry dates, and CVV codes
- Customizable styling and colors
- Input formatters for proper card number and expiry date formatting
- Credit card form widget with validation
- Comprehensive utility functions for card validation and formatting
- Support for custom card type icons
- Responsive design that works on all screen sizes
- CVV focus triggers card flip animation
- Card number masking for security
- Luhn algorithm validation for card numbers
- Support for American Express 4-digit CVV
- Expiry date validation (MM/YY format)
- Card holder name validation
- Comprehensive documentation and examples

### Features
- **CreditCardWidget**: Main widget displaying the credit card with animations
- **CreditCardForm**: Form widget for collecting credit card information
- **CreditCardModel**: Data model for credit card information
- **CreditCardBrand**: Enum for different card brands
- **CreditCardUtils**: Utility functions for validation and formatting
- Automatic card brand detection
- Input validation and formatting
- Customizable appearance
- Flip animation on CVV focus
- Support for multiple card brands

### Documentation
- Comprehensive README with usage examples
- API documentation for all public methods
- Example app demonstrating all features
- Contributing guidelines
- License information
