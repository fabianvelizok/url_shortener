# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-13

First production release deployed to Heroku with custom domain.

### Added
- Referrer tracking on every click (stored in `views.referrer`)
- Unique visitor counting per link (`unique_views_count` via distinct IP)
- Top referrers donut chart on link show page
- Paginated recent clicks table (time, referrer, user agent)
- Gmail SMTP configuration for Devise password reset emails
- `HOST` environment variable for production domain configuration
- Default URL options for Turbo Stream broadcasts
- Environment variables documentation in README

### Fixed
- Turbo Stream broadcasts showing `example.org` instead of correct host
- Redis SSL handshake failure on Heroku (self-signed certificate)

### Dependencies
- turbo-rails 2.0.20, tailwindcss-rails 4.4.0, puma 7.1.0
- chartkick 5.2.1, pg 1.6.2, jbuilder 2.14.1, importmap-rails 2.2.2
- selenium-webdriver 4.38.0, actions/upload-artifact v5

## [0.2.0] - 2025-08-14

### Added
- Dark mode with system-preference-aware theme switching
- Architecture diagram and improved README structure

## [0.1.0] - 2025-08-13

### Added
- URL shortening with Base62-encoded short codes (`/v/:code`)
- Click tracking with daily view graphs (Chartkick + Groupdate)
- Metadata extraction in background (title, description, OG image)
- Real-time UI updates via Turbo Streams
- Clipboard copy for short URLs
- Link CRUD (create, show, edit, delete)
- Pagination with Pagy
- User authentication with Devise
- Styled Devise views
- Integration and model tests with SimpleCov coverage
- Local CI check script
- Redis for Action Cable in production
- Sucker Punch for background jobs

[1.0.0]: https://github.com/fabianvelizok/url_shortener/compare/v0.2.0...v1.0.0
[0.2.0]: https://github.com/fabianvelizok/url_shortener/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/fabianvelizok/url_shortener/releases/tag/v0.1.0
