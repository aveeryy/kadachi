# Configuration for local-only services
''
  error_page 403 https://rcia.dev;
  allow 10.0.0.0/24;
  allow 10.10.0.0/24;
  deny all;
''
