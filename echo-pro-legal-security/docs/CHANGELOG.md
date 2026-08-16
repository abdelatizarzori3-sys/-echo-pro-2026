# Changelog

All notable changes to Echo Pro will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-08-14

### Added
- Clean Architecture with BLoC pattern
- JWT authentication (login/register)
- Real-time chat with WebSocket
- Kimi AI integration (Moonshot API)
- Prisma ORM with PostgreSQL
- Rate limiting and input validation
- Helmet security headers
- Winston logging with daily rotation
- Docker multi-stage build
- Docker Compose (PostgreSQL + Redis + Backend + Nginx)
- Railway deployment ready
- CI/CD with GitHub Actions
- Sentry error tracking
- Flutter dark/light theme
- Session-based chat history
- Cron jobs for cleanup

### Security
- bcrypt password hashing
- JWT token authentication
- CORS configuration
- Rate limiting (20 req/min)
- Input sanitization
- SQL injection protection

## [2.0.0] - 2026-07-01

### Added
- Initial backend with Express.js
- Basic authentication
- Chat functionality
- WebSocket support

## [1.0.0] - 2026-06-01

### Added
- Initial Flutter app
- Basic UI
- API integration

---

## Release Notes Template

```
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements
```
