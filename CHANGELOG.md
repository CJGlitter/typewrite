# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-02-02

### Added
- Keyboard interrupt support to skip typewriter animation
  - `interrupt: true` or `interrupt: :enter` - Skip with Enter key
  - `interrupt: :any` - Skip with any key press
  - `interrupt: ["q", "x", " "]` - Skip with specific keys
- When interrupted, remaining text prints immediately
- Non-blocking keyboard input detection using `io/console`

### Changed
- Updated README with interrupt mode documentation and examples
- Adjusted RuboCop metrics configuration for interrupt logic
- **Note:** Undocumented keyword argument syntax (e.g., `type_rate: 0.05`) is no longer supported due to Ruby 3.0+ keyword argument separation. All documented positional argument usage remains fully compatible.

### Technical
- Added `write_interruptible` and `key_matches?` private methods
- Uses `IO.select` for non-blocking input polling (Ruby 3.0+ compatible)
- 100% backwards compatible for all documented usage patterns

## [1.1.0] - 2025-01-XX

### Changed
- Modernized codebase to idiomatic Ruby gem standards
- Added RuboCop linting to development workflow

### Added
- RSpec testing infrastructure
- GitHub Actions CI workflow
- Comprehensive test coverage for timing and output behavior

## [1.0.0] - Earlier

### Added
- Initial typewriter effect implementation
- Basic timing controls (type_rate, punc_rate)
- Line break control

[1.2.0]: https://github.com/CJGlitter/typewrite/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/CJGlitter/typewrite/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/CJGlitter/typewrite/releases/tag/v1.0.0
