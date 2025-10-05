#!/bin/bash
echo "Starting Moodle setup..."

# Wait a few seconds for DB service readiness
sleep 5

# Create Moodle auto-install script inside the container
cat <<'EOF' > init_moodle.sh
#!/bin/bash
set -e

cd /var/www/html

# Check if Moodle is already installed
if [ -f /var/www/moodledata/install_complete.flag ]; then
  echo "Moodle already installed. Starting Apache..."
  apache2-foreground
  exit 0
fi

echo "Running Moodle CLI installation..."

php admin/cli/install.php \
  --chmod=2777 \
  --lang=en \
  --wwwroot=http://localhost:8080 \
  --dataroot=/var/www/moodledata \
  --dbtype=mariadb \
  --dbhost=${MOODLE_DB_HOST} \
  --dbname=${MOODLE_DB_NAME} \
  --dbuser=${MOODLE_DB_USER} \
  --dbpass=${MOODLE_DB_PASS} \
  --fullname="Moodle Dev Site" \
  --shortname="MoodleDev" \
  --adminuser=admin \
  --adminpass=Admin@12345 \
  --adminemail=admin@example.com \
  --agree-license

touch /var/www/moodledata/install_complete.flag

chown -R www-data:www-data /var/www/html /var/www/moodledata

echo "✅ Moodle installation complete! Starting Apache..."
apache2-foreground
EOF

chmod +x init_moodle.sh
mv init_moodle.sh /init_moodle.sh

echo "Building and starting Docker containers..."
docker compose up -d --build

echo "Moodle will auto-install shortly..."
echo "----------------------------------------------------"
echo "🌐 Moodle: http://localhost:8080"
echo "🗄️ phpMyAdmin: http://localhost:8081"
echo "👤 Admin Login: admin / Admin@12345"
echo "----------------------------------------------------"
