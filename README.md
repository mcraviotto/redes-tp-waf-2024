# Nginx Reverse Proxy with ModSecurity

This project sets up an Nginx reverse proxy with ModSecurity to secure two web applications, Juice Shop and DVWA, running in Docker containers.

## Requirements
- Docker
- Docker Compose


## Setup
Step 1:

```bash
docker compose up
```

This will start:
- juice-shop webapp
  - on localhost:3000
- Damn Vulnerable WebApp
  - on localhost:4280
- nginx reverse proxy
  - with modsecurity, an open source WAF engine
  - redirecting localhost:80/ requests to the DVWA, through our WAF
  - redirecting localhost:8080/ requests to the juice-shop webapp, through our WAF

Step 2: Verify the Setup
After starting the services, you should have:

    - Juice Shop accessible at http://localhost:3000
    - DVWA accessible at http://localhost:4280
    - Nginx reverse proxy for Juice Shop at http://localhost:80
    - Nginx reverse proxy for DVWA at http://localhost:8080

This means, the direct (vulnerable) port endpoint of both webapps are 3000 and 4280 respectively, while the 80 and 8080 ports go through our WAF, making them no longer so vulnerable.

## Project Structure
```
.
├── Dockerfile
├── README.md
├── docker-compose.yml
├── error.html
├── juice-shop
│   └── Dockerfile
├── modsecurity.conf
├── nginx.conf
└── rules
    ├── blocks.conf
    └── detections.conf
```

## Files
- Dockerfile: Builds the custom Nginx image with ModSecurity.
- docker-compose.yml: Defines the services and configurations for Docker Compose.
- nginx.conf: Nginx configuration file.
- modsecurity.conf: ModSecurity configuration file.
- rules/blocks.conf: Custom rules for blocking traffic.
- rules/detections.conf: Custom rules for detecting suspicious activities.

