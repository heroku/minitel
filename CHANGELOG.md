# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

-

## [1.0.0]

### Added

- `Minitel::HTTP::Error` exception hierarchy. See: lib/minitel/errors.rb

### Changed

- Replace MultiJson with stdlib JSON
- Bump webmock dependency to ~> 3.26
- Update CI workflow and test configuration
- Require Ruby >= 3.2

### Removed

- **Breaking Change:** Replace `Excon` with stdlib `Net::HTTP` - Gem-specific errors are raised rather than Excon-specific errors. See: lib/minitel/errors.rb


## [0.6.0] - 2025-05-01

### Changed

- Allow use of newer versions of excon

## [0.5.0] - 2021-08-06

### Changed

- Also send JSON content type
- Move to GitHub Actions

## [0.4.0]

## [0.3.0] - 2014-10-21

### Added

- Client#add_followup for adding followup to a previous notification

## [0.2.0] - 2014-10-10

### Added

- Client#notify_user for sending notifications to a single user

## [0.1.1] - 2014-10-08

### Added

- User-Agent header

## [0.1.0] - 2014-10-08

### Changed

- Bump minimum version of Excon to redact passwords on errors

## [0.0.1] - 2014-10-04

### Added

- Initial release

[Unreleased]: https://github.com/heroku/minitel/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/heroku/minitel/compare/v0.6.0...v1.0.0
[0.6.0]: https://github.com/heroku/minitel/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/heroku/minitel/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/heroku/minitel/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/heroku/minitel/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/heroku/minitel/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/heroku/minitel/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/heroku/minitel/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/heroku/minitel/releases/tag/v0.0.1
