# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 3.0.x   | :white_check_mark: |
| < 3.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in Echo Pro, please report it responsibly:

1. **DO NOT** create a public GitHub issue
2. Email: abdelatizarzori3@gmail.com
3. Subject: `[SECURITY] Echo Pro Vulnerability Report`
4. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 7 days
- **Fix & Release**: Within 30 days (critical), 90 days (high)

## Security Best Practices for Users

### Backend
- Use strong `JWT_SECRET` (64+ random characters)
- Store `KIMI_API_KEY` in environment variables only
- Enable HTTPS in production
- Restrict CORS to your domain only
- Enable rate limiting
- Keep dependencies updated

### Flutter
- Do not hardcode API keys
- Use `flutter_secure_storage` for tokens
- Enable certificate pinning
- Validate all user inputs

## Security Features

- JWT authentication with bcrypt
- Helmet security headers
- Rate limiting (20 req/min)
- Input validation (express-validator + Joi)
- CORS configuration
- SQL injection protection (Prisma ORM)
- XSS protection

## Hall of Fame

We thank the following security researchers:

*(Empty — be the first!)*
