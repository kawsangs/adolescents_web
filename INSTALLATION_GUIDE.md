# Youth Health Web App - Production Installation Guide

This comprehensive guide provides step-by-step instructions for setting up and deploying the Youth Health Web Application (adolescents_web) in a production environment.

## Table of Contents

- [System Overview](#system-overview)
- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Third-Party Service Integrations](#third-party-service-integrations)
- [Production Deployment](#production-deployment)
- [Post-Deployment Verification](#post-deployment-verification)
- [Troubleshooting](#troubleshooting)
- [Maintenance and Operations](#maintenance-and-operations)

---

## System Overview

The Youth Health Web Application is a Ruby on Rails application that serves as both a web interface and a backend API for the mobile application. The system includes:

- **Web Application**: Rails 7.0.8 application
- **Database**: PostgreSQL 14.4
- **Background Jobs**: Sidekiq with Redis
- **File Storage**: AWS S3 (production)
- **Authentication**: Devise with OAuth (Google, Facebook)
- **API**: Doorkeeper OAuth2 provider
- **Error Tracking**: Sentry
- **Push Notifications**: Firebase Cloud Messaging

---

## Prerequisites

### Required Software

Before beginning the installation, ensure the following software is installed on your production server:

1. **Docker** (version 20.10 or higher)
   - Installation guide: https://docs.docker.com/get-docker/
   
2. **Docker Compose** (version 1.29 or higher)
   - Installation guide: https://docs.docker.com/compose/install/

3. **Git** (version 2.30 or higher)
   ```bash
   sudo apt-get update
   sudo apt-get install git
   ```

### Server Requirements

- **Operating System**: Ubuntu 20.04 LTS or higher (recommended)
- **RAM**: Minimum 4GB (8GB+ recommended)
- **CPU**: 2+ cores
- **Storage**: 20GB+ available disk space
- **Network**: Static IP address and domain name configured

### Access Requirements

You will need access credentials for the following services:

- **GitHub Repository**: Access to clone the repository
- **AWS Account**: For S3 file storage
- **Google Cloud Console**: For Google OAuth authentication
- **Facebook Developers**: For Facebook OAuth authentication (optional)
- **Firebase Console**: For push notifications
- **Sentry.io**: For error tracking
- **SMTP Server**: For sending emails
- **Database**: PostgreSQL credentials (if using external database)

---

## Environment Setup

### 1. Clone the Repository

```bash
# Navigate to your application directory
cd /var/www

# Clone the repository
git clone https://github.com/kawsangs/adolescents_web.git
cd adolescents_web

# Checkout the desired branch (e.g., main, production)
git checkout main
```

### 2. Set Up Environment Variables

Create the production environment file:

```bash
cp app.env.example app.env
```

Edit `app.env` with production values (see [Configuration](#configuration) section below).

### 3. Verify Ruby Version

The application requires Ruby 3.1.2. The Docker container will handle this, but verify the `.ruby-version` file:

```bash
cat .ruby-version
# Should output: 3.1.2
```

---

## Configuration

### Environment Variables

Edit the `app.env` file with your production configuration:

#### Database Configuration

```bash
# PostgreSQL Database Configuration
DB_HOST=db                          # Use 'db' for Docker Compose, or your database host
DB_USER=postgres                    # Database username
DB_PWD=your_secure_password         # Database password (set a strong password!)
RAILS_MAX_THREADS=5                 # Connection pool size

# Production database URL (alternative to above)
DATABASE_URL=postgresql://user:password@host:5432/database_name
```

#### Application Settings

```bash
# Application Version
APP_VERSION=production              # Or your version/tag

# Application Name (in Khmer)
APP_NAME=សុខភាពយុវជន

# Maximum records for download
MAX_DOWNLOAD_VISIT_RECORD=1000
```

#### Redis Configuration (for Sidekiq)

```bash
# Redis URL for background jobs
REDIS_URL=redis://redis:6379        # Use 'redis' for Docker Compose, or your Redis host
```

#### Email Configuration

```bash
# Devise Mailer
MAILER_SENDER=noreply@yourdomain.com

# SMTP Settings
SETTINGS__SMTP__ADDRESS=smtp.gmail.com          # Your SMTP server
SETTINGS__SMTP__DOMAIN=yourdomain.com
SETTINGS__SMTP__USER_NAME=your-email@gmail.com
SETTINGS__SMTP__PASSWORD=your-app-password
SETTINGS__SMTP__PORT=587
SETTINGS__SMTP__HOST=yourdomain.com
SETTINGS__SMTP__DEFAULT_FROM=notifications@yourdomain.com
```

#### Security Settings

```bash
# Generate with: bundle exec rails secret
RAILS_MASTER_KEY=your_master_key_here

# ReCAPTCHA (https://www.google.com/recaptcha/admin/create)
RECAPTCHA_SITE_KEY=your_recaptcha_site_key
RECAPTCHA_SECRET_KEY=your_recaptcha_secret_key
```

#### CORS Configuration

```bash
# Allowed origins (comma-separated)
CORS_ALLOW_ORIGINS=yourdomain.com,app.yourdomain.com
```

#### Rate Limiting (Rack Attack)

```bash
# Whitelist IPs (semicolon-separated)
SAFELIST_IPS=127.0.0.1;your.trusted.ip

# Blacklist IPs (semicolon-separated)
BLOCKLIST_IPS=

# Throttle settings
THROTTLE_PERIOD_IN_SECOND=60
THROTTLE_REQUEST_LIMIT=100
```

---

## Third-Party Service Integrations

### 1. Google OAuth (Sign in with Google)

**Steps:**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable **Google+ API**
4. Go to **Credentials** → **Create Credentials** → **OAuth 2.0 Client ID**
5. Configure consent screen
6. Add authorized redirect URIs:
   - Production: `https://yourdomain.com/auth/google_oauth2/callback`
7. Copy **Client ID** and **Client Secret**

Add to `app.env`:
```bash
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

### 2. Facebook OAuth (Sign in with Facebook)

**Steps:**

1. Go to [Facebook Developers](https://developers.facebook.com)
2. Create a new app or select an existing one
3. Add **Facebook Login** product
4. Configure **Valid OAuth Redirect URIs**:
   - Production: `https://yourdomain.com/auth/facebook/callback`
5. Copy **App ID** and **App Secret**

Add to `app.env`:
```bash
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
FACEBOOK_LOGIN_ENABLED=true          # Set to true to enable
```

### 3. AWS S3 (File Storage)

**Steps:**

1. Log in to [AWS Console](https://console.aws.amazon.com/)
2. Create an S3 bucket for your application
3. Configure bucket permissions (allow your application to read/write)
4. Create an IAM user with S3 access
5. Generate access keys for the IAM user

Add to `app.env`:
```bash
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1                 # Your bucket region
AWS_NAME_OF_BUCKET=your-bucket-name
```

**S3 Bucket Policy Example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::YOUR_ACCOUNT_ID:user/YOUR_IAM_USER"
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```

### 4. Firebase (Push Notifications)

**Steps:**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Go to **Project Settings** → **General**
4. Copy **Project ID**
5. Go to **Project Settings** → **Service Accounts**
6. Click **Generate New Private Key** and download the JSON file
7. Upload the JSON file to your server at `/var/www/adolescents_web/firebase_service_account_key.json`

Add to `app.env`:
```bash
FIREBASE_PROJECT_ID=your_firebase_project_id
GOOGLE_APPLICATION_CREDENTIALS_PATH=firebase_service_account_key.json
```

**Security Note:** Ensure the JSON file is not committed to version control!

```bash
# Add to .gitignore if not already present
echo "firebase_service_account_key.json" >> .gitignore
```

### 5. Sentry (Error Tracking)

**Steps:**

1. Sign up at [Sentry.io](https://sentry.io/)
2. Create a new project (Ruby on Rails)
3. Copy the **DSN** URL

Add to `app.env`:
```bash
SENTRY_DSN=https://your_sentry_dsn@sentry.io/project_id
```

### 6. Grafana Dashboard (Optional)

If you're using Grafana for analytics:

```bash
GF_DASHBOARD_URL=https://grafana.yourdomain.com/login/generic_oauth
GF_DASHBOARD_ADMIN_USERNAME=admin
GF_DASHBOARD_ADMIN_PASSWORD=secure_password
GF_DASHBOARD_BASE_URL=https://grafana.yourdomain.com
```

### 7. Telegram Integration (Optional)

For Telegram bot integration:

**Steps:**

1. Create a Telegram bot via [@BotFather](https://t.me/botfather)
2. Set up a public URL for webhook (using ngrok for development, or your domain for production)
3. Configure allowed IP ranges for Telegram webhooks

Add to `app.env`:
```bash
TELEGRAM_CALLBACK_URL=https://yourdomain.com/api/integration/telegram
ALLOWED_HOSTS=149.154.160.0/22,149.154.164.0/22,91.108.4.0/22,91.108.56.0/22,91.108.8.0/22,95.161.64.0/20
```

### 8. Mobile App Download Link

```bash
DOWNLOAD_MOBILE_APP_LINK=https://your-mobile-app-link.com
```

### 9. User Guide Video Links

```bash
USER_GUIDE_VIDEO_LINK_FOR_PRIMARY_ADMIN=https://your-video-link.com
USER_GUIDE_VIDEO_LINK_FOR_ADMIN=https://your-video-link.com
USER_GUIDE_VIDEO_LINK_FOR_STAFF_LINK=https://your-video-link.com
```

### 10. Privacy Policy Contact Information

```bash
CONTACT_EMAIL=support@yourdomain.com
CONTACT_PHONE=+855-12-345-678
```

---

## Database Setup

### Option 1: Using Docker Compose (Recommended for single-server setup)

The provided `docker-compose.yml` includes a PostgreSQL container.

```bash
# Start the database container
docker-compose up -d db

# Wait for PostgreSQL to be ready (about 10 seconds)
sleep 10
```

### Option 2: Using External PostgreSQL Database

If using an external PostgreSQL server:

1. Create the production database:
   ```sql
   CREATE DATABASE app_production;
   CREATE USER app_user WITH PASSWORD 'secure_password';
   GRANT ALL PRIVILEGES ON DATABASE app_production TO app_user;
   ```

2. Update `app.env` with the external database credentials:
   ```bash
   DB_HOST=your-db-server.com
   DB_USER=app_user
   DB_PWD=secure_password
   ```

### Running Database Migrations

After database setup, run migrations:

```bash
# Using Docker
docker-compose run --rm web bundle exec rake db:migrate RAILS_ENV=production

# Or if building the production Docker image
docker build -t adolescents_web:production .
docker run --rm --env-file app.env adolescents_web:production bundle exec rake db:migrate RAILS_ENV=production
```

### Load Sample Data (Optional - Development/Staging Only)

**WARNING:** Do NOT run this in production with existing data!

```bash
# Load sample data (development/staging only)
docker-compose run --rm web bundle exec rake sample:load RAILS_ENV=development
```

### Database Backup (Important!)

Set up regular database backups:

```bash
# Create a backup script
cat > /var/www/adolescents_web/backup-db.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/var/backups/adolescents_web"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

docker exec adolescents_web_db_1 pg_dump -U postgres app_production > $BACKUP_DIR/db_backup_$DATE.sql
gzip $BACKUP_DIR/db_backup_$DATE.sql

# Keep only last 7 days of backups
find $BACKUP_DIR -name "db_backup_*.sql.gz" -mtime +7 -delete
EOF

chmod +x /var/www/adolescents_web/backup-db.sh

# Add to crontab (daily backup at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /var/www/adolescents_web/backup-db.sh") | crontab -
```

---

## Production Deployment

### Building the Production Docker Image

The production `Dockerfile` is optimized for deployment:

```bash
# Build the production image
docker build -t adolescents_web:production -f Dockerfile .

# Tag with version (recommended)
docker tag adolescents_web:production adolescents_web:1.0.0
```

### Deployment with Docker Compose

For a simple deployment, you can modify `docker-compose.yml` for production:

1. Create a `docker-compose.prod.yml` file:

```yaml
version: "3.9"

volumes:
  db:
  redis:

services:
  db:
    image: postgres:14.4
    volumes:
      - db:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=${DB_PWD}
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_DB=app_production
    restart: unless-stopped

  redis:
    image: redis:7.0.11
    volumes:
      - redis:/data
    restart: unless-stopped

  web:
    build:
      context: .
      dockerfile: Dockerfile
    image: adolescents_web:production
    command: puma -e production -b tcp://0.0.0.0:80
    ports:
      - "80:80"
    depends_on:
      - db
      - redis
    env_file: app.env
    environment:
      - RAILS_ENV=production
      - RACK_ENV=production
      - RAILS_LOG_TO_STDOUT=true
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PWD}@db:5432/app_production
    restart: unless-stopped
    volumes:
      - ./storage:/app/storage
      - ./log:/app/log
      - ./firebase_service_account_key.json:/app/firebase_service_account_key.json

  sidekiq:
    build:
      context: .
      dockerfile: Dockerfile
    image: adolescents_web:production
    command: bundle exec sidekiq -C config/sidekiq.yml -e production
    depends_on:
      - db
      - redis
    env_file: app.env
    environment:
      - RAILS_ENV=production
      - RACK_ENV=production
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PWD}@db:5432/app_production
    restart: unless-stopped
    volumes:
      - ./storage:/app/storage
      - ./log:/app/log
      - ./firebase_service_account_key.json:/app/firebase_service_account_key.json
```

2. Deploy the application:

```bash
# Create necessary directories
mkdir -p storage log

# Build and start services
docker-compose -f docker-compose.prod.yml up -d --build

# Run database migrations
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:migrate RAILS_ENV=production

# Create admin user (if needed)
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rails console -e production
# In the console:
# User.create!(email: 'admin@example.com', password: 'secure_password', password_confirmation: 'secure_password')
```

### Deployment with Reverse Proxy (Nginx)

For production, it's recommended to use Nginx as a reverse proxy:

1. Install Nginx:
```bash
sudo apt-get update
sudo apt-get install nginx
```

2. Create Nginx configuration:

```bash
sudo nano /etc/nginx/sites-available/adolescents_web
```

Add the following configuration:

```nginx
upstream adolescents_web {
    server localhost:3000;
}

server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    # SSL certificates (use Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Client max body size (for file uploads)
    client_max_body_size 100M;

    # Logging
    access_log /var/log/nginx/adolescents_web_access.log;
    error_log /var/log/nginx/adolescents_web_error.log;

    # Root and public files
    root /var/www/adolescents_web/public;

    # Try static files first, then proxy to app
    location / {
        try_files $uri @app;
    }

    location @app {
        proxy_pass http://adolescents_web;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
    }

    # Static assets caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Health check endpoint
    location /health {
        proxy_pass http://adolescents_web;
        access_log off;
    }
}
```

3. Enable the site and restart Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/adolescents_web /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

4. Set up SSL with Let's Encrypt:

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

### Updating the Application

To update the application with new code:

```bash
# Navigate to application directory
cd /var/www/adolescents_web

# Pull latest changes
git pull origin main

# Rebuild and restart services
docker-compose -f docker-compose.prod.yml up -d --build

# Run migrations (if any)
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:migrate RAILS_ENV=production

# Restart services
docker-compose -f docker-compose.prod.yml restart
```

---

## Post-Deployment Verification

After deployment, verify that the application is running correctly:

### 1. Check Service Status

```bash
# Check Docker containers
docker-compose -f docker-compose.prod.yml ps

# All services should show "Up" status
```

Expected output:
```
Name                          State    Ports
----------------------------------------------------------------
adolescents_web_web_1         Up       0.0.0.0:80->80/tcp
adolescents_web_sidekiq_1     Up
adolescents_web_db_1          Up       5432/tcp
adolescents_web_redis_1       Up       6379/tcp
```

### 2. Check Application Logs

```bash
# View web application logs
docker-compose -f docker-compose.prod.yml logs -f web

# View Sidekiq logs
docker-compose -f docker-compose.prod.yml logs -f sidekiq

# View all logs
docker-compose -f docker-compose.prod.yml logs -f
```

Look for any error messages or warnings.

### 3. Test Database Connection

```bash
# Open Rails console
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rails console -e production

# In the console, test database connection:
# ActiveRecord::Base.connection.execute("SELECT 1")
# User.count
```

### 4. Test Web Interface

1. Open a web browser and navigate to your domain: `https://yourdomain.com`
2. Verify the homepage loads correctly
3. Test user registration/login
4. Test Google/Facebook OAuth (if enabled)

### 5. Test API Endpoints

```bash
# Test health endpoint
curl https://yourdomain.com/health

# Test API (replace with actual endpoint)
curl -X GET https://yourdomain.com/api/v1/health \
  -H "Content-Type: application/json"
```

### 6. Verify Background Jobs (Sidekiq)

```bash
# Check Sidekiq is processing jobs
docker-compose -f docker-compose.prod.yml exec web bundle exec rails console -e production

# In console:
# Sidekiq::Queue.new.size  # Should return 0 or number of pending jobs
```

### 7. Test File Uploads

1. Log in to the application
2. Upload a test file (image, document, etc.)
3. Verify the file is stored in AWS S3
4. Verify the file can be downloaded

### 8. Test Email Delivery

```bash
# Send a test email from Rails console
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rails console -e production

# In console:
# ActionMailer::Base.mail(from: ENV['MAILER_SENDER'], to: 'test@example.com', subject: 'Test', body: 'Test email').deliver_now
```

### 9. Test Push Notifications

Trigger a test push notification through the application interface and verify it's received on a mobile device.

### 10. Verify Sentry Integration

1. Log in to Sentry.io
2. Trigger a test error in the application
3. Verify the error appears in Sentry

### 11. Monitor Resource Usage

```bash
# Check Docker container resource usage
docker stats

# Check disk usage
df -h

# Check memory usage
free -h
```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Application won't start - Port already in use

**Symptoms:** Error message: "Address already in use - bind(2)"

**Solution:**
```bash
# Find process using port 80
sudo lsof -i :80

# Kill the process (replace PID with actual process ID)
sudo kill -9 PID

# Or change the port in docker-compose.prod.yml
# ports:
#   - "8080:80"  # Use port 8080 instead
```

#### Issue 2: Database connection errors

**Symptoms:** Error: "could not connect to server: Connection refused"

**Solution:**
```bash
# Check if database container is running
docker-compose -f docker-compose.prod.yml ps db

# View database logs
docker-compose -f docker-compose.prod.yml logs db

# Restart database
docker-compose -f docker-compose.prod.yml restart db

# Check database credentials in app.env
cat app.env | grep DB_
```

#### Issue 3: Assets not loading (404 errors for CSS/JS)

**Symptoms:** Web page loads but CSS/JS files return 404

**Solution:**
```bash
# Precompile assets
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake assets:precompile RAILS_ENV=production

# Restart web service
docker-compose -f docker-compose.prod.yml restart web
```

#### Issue 4: OAuth login not working

**Symptoms:** "redirect_uri_mismatch" error

**Solution:**
1. Check redirect URIs in Google/Facebook console match your domain exactly
2. Ensure HTTPS is used in production
3. Verify `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` in `app.env`

#### Issue 5: File uploads failing

**Symptoms:** Error uploading files, or files not appearing in S3

**Solution:**
```bash
# Verify AWS credentials
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rails console -e production
# In console:
# ENV['AWS_ACCESS_KEY_ID']
# ENV['AWS_SECRET_ACCESS_KEY']
# ENV['AWS_REGION']
# ENV['AWS_NAME_OF_BUCKET']

# Test S3 connection
# CarrierWave.configure { |c| puts c.fog_credentials }
```

Check AWS IAM user permissions and S3 bucket policy.

#### Issue 6: Sidekiq not processing jobs

**Symptoms:** Background jobs stuck in queue

**Solution:**
```bash
# Check Sidekiq logs
docker-compose -f docker-compose.prod.yml logs sidekiq

# Check Redis connection
docker-compose -f docker-compose.prod.yml exec redis redis-cli ping
# Should return: PONG

# Verify REDIS_URL in app.env
cat app.env | grep REDIS_URL

# Restart Sidekiq
docker-compose -f docker-compose.prod.yml restart sidekiq
```

#### Issue 7: High memory usage

**Symptoms:** Server running out of memory, containers being killed

**Solution:**
```bash
# Check container memory usage
docker stats

# Reduce Sidekiq concurrency in config/sidekiq.yml
# production:
#   :concurrency: 10  # Reduce from 20

# Restart services
docker-compose -f docker-compose.prod.yml restart
```

#### Issue 8: Email delivery failing

**Symptoms:** Emails not being sent

**Solution:**
```bash
# Check SMTP settings in app.env
cat app.env | grep SMTP

# Test SMTP connection
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rails console -e production
# In console:
# ActionMailer::Base.delivery_method
# ActionMailer::Base.smtp_settings

# For Gmail, ensure "Less secure app access" is enabled or use an App Password
```

#### Issue 9: Database migrations failing

**Symptoms:** Error running `rake db:migrate`

**Solution:**
```bash
# Check current migration status
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:migrate:status RAILS_ENV=production

# Try running migrations one by one
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:migrate:up VERSION=20220808035840 RAILS_ENV=production

# If migration is corrupted, rollback and re-run
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:rollback STEP=1 RAILS_ENV=production
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:migrate RAILS_ENV=production
```

#### Issue 10: SSL certificate errors

**Symptoms:** "Your connection is not private" browser warning

**Solution:**
```bash
# Renew Let's Encrypt certificate
sudo certbot renew

# If renewal fails, force renewal
sudo certbot renew --force-renewal

# Check certificate expiration
sudo certbot certificates

# Restart Nginx
sudo systemctl restart nginx
```

### Getting Help

If you encounter issues not covered here:

1. **Check application logs:**
   ```bash
   docker-compose -f docker-compose.prod.yml logs -f
   ```

2. **Check Rails logs:**
   ```bash
   tail -f log/production.log
   ```

3. **Check Nginx logs:**
   ```bash
   sudo tail -f /var/log/nginx/adolescents_web_error.log
   ```

4. **Enable verbose logging** (temporarily):
   Edit `config/environments/production.rb`:
   ```ruby
   config.log_level = :debug
   ```
   Restart the application.

5. **Contact the development team** with:
   - Error messages
   - Relevant log excerpts
   - Steps to reproduce the issue
   - Environment details (server specs, Docker version, etc.)

---

## Maintenance and Operations

### Regular Maintenance Tasks

#### Daily
- Monitor application logs for errors
- Check Sentry for new errors
- Monitor server resource usage (CPU, memory, disk)

#### Weekly
- Review and clear old log files
  ```bash
  # Rotate logs
  docker-compose -f docker-compose.prod.yml exec web bundle exec rake log:clear RAILS_ENV=production
  ```
- Check database size and performance
- Review Sidekiq queue status

#### Monthly
- Update dependencies (security patches)
  ```bash
  # Update Gemfile.lock
  docker-compose -f docker-compose.prod.yml run --rm web bundle update
  
  # Rebuild and restart
  docker-compose -f docker-compose.prod.yml up -d --build
  ```
- Review and optimize database queries
- Clean up old data (if applicable)

### Monitoring

Set up monitoring for:
- Application uptime
- Response times
- Error rates
- Database performance
- Disk space
- Memory usage
- Background job queue length

Recommended tools:
- **New Relic** or **DataDog** for APM
- **Prometheus + Grafana** for metrics
- **Uptime Robot** or **Pingdom** for uptime monitoring
- **Sentry** for error tracking (already configured)

### Scaling

If your application needs to handle more traffic:

#### Vertical Scaling (Increase server resources)
- Upgrade server CPU/RAM
- Increase database instance size

#### Horizontal Scaling (Add more servers)
- Set up a load balancer (e.g., AWS ELB, Nginx)
- Deploy multiple instances of the web application
- Use a managed database service (e.g., AWS RDS)
- Use a managed Redis service (e.g., AWS ElastiCache)
- Use a CDN for static assets (e.g., CloudFlare)

### Security Best Practices

1. **Keep software updated:**
   - Regularly update Ruby, Rails, and all gems
   - Update Docker images
   - Update server OS packages

2. **Use strong passwords:**
   - Database passwords
   - Admin user passwords
   - API keys

3. **Restrict access:**
   - Use firewall rules to limit access to server
   - Use VPN for SSH access
   - Implement IP whitelisting where appropriate

4. **Enable HTTPS:**
   - Always use SSL/TLS in production
   - Force SSL in Rails: `config.force_ssl = true`

5. **Regular backups:**
   - Database backups (automated)
   - File storage backups (S3 versioning)
   - Configuration backups

6. **Monitor security:**
   - Set up Sentry for error tracking
   - Monitor authentication logs
   - Use rack-attack to prevent abuse

### Backup and Disaster Recovery

#### Full System Backup

```bash
#!/bin/bash
# backup-all.sh

BACKUP_DIR="/var/backups/adolescents_web/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

# Database backup
docker exec adolescents_web_db_1 pg_dump -U postgres app_production > $BACKUP_DIR/database.sql

# Application files
tar -czf $BACKUP_DIR/application.tar.gz /var/www/adolescents_web \
  --exclude=/var/www/adolescents_web/log \
  --exclude=/var/www/adolescents_web/tmp

# Environment configuration
cp /var/www/adolescents_web/app.env $BACKUP_DIR/

# Compress
cd $BACKUP_DIR/..
tar -czf adolescents_web_backup_$(date +%Y%m%d_%H%M%S).tar.gz $(basename $BACKUP_DIR)
rm -rf $BACKUP_DIR

# Upload to S3 (optional)
# aws s3 cp adolescents_web_backup_$(date +%Y%m%d_%H%M%S).tar.gz s3://your-backup-bucket/

echo "Backup completed: adolescents_web_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
```

#### Disaster Recovery Steps

If you need to restore from backup:

1. Set up a new server following the [Environment Setup](#environment-setup) section
2. Restore the application files from backup
3. Restore the database:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d db
   docker cp database.sql adolescents_web_db_1:/tmp/
   docker exec adolescents_web_db_1 psql -U postgres app_production < /tmp/database.sql
   ```
4. Restore environment configuration
5. Start all services
6. Verify the application is working correctly

---

## Appendix

### Useful Commands Reference

#### Docker Commands
```bash
# View running containers
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f [service_name]

# Restart a service
docker-compose -f docker-compose.prod.yml restart [service_name]

# Stop all services
docker-compose -f docker-compose.prod.yml down

# Start all services
docker-compose -f docker-compose.prod.yml up -d

# Execute command in container
docker-compose -f docker-compose.prod.yml exec web [command]

# Run one-off command
docker-compose -f docker-compose.prod.yml run --rm web [command]

# Remove unused images
docker image prune -a

# View container resource usage
docker stats
```

#### Rails Commands
```bash
# Open Rails console
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rails console -e production

# Run database migrations
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:migrate RAILS_ENV=production

# Check routes
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake routes RAILS_ENV=production

# Clear cache
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake cache:clear RAILS_ENV=production

# View database schema
docker-compose -f docker-compose.prod.yml run --rm web bundle exec rake db:schema:dump RAILS_ENV=production
```

#### Database Commands
```bash
# Connect to database
docker-compose -f docker-compose.prod.yml exec db psql -U postgres app_production

# Backup database
docker exec adolescents_web_db_1 pg_dump -U postgres app_production > backup.sql

# Restore database
docker exec -i adolescents_web_db_1 psql -U postgres app_production < backup.sql

# Check database size
docker-compose -f docker-compose.prod.yml exec db psql -U postgres -c "SELECT pg_size_pretty(pg_database_size('app_production'));"
```

### Environment Variables Reference

A complete list of all environment variables used in the application can be found in `app.env.example`.

### Support and Contact

For technical support or questions regarding this installation:

- **Development Team**: [Contact information]
- **Documentation**: [Link to additional documentation]
- **Issue Tracker**: https://github.com/kawsangs/adolescents_web/issues

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Maintainer:** Development Team
