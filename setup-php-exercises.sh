#!/bin/bash

# ===============================================================
# Exercise 6a & 6b - PHP + Apache + MySQL Setup
# ===============================================================

echo "================================================"
echo "  Exercise 6a & 6b: PHP + Apache Setup"
echo "  Three-Tier Architecture (MySQL + PHP)"
echo "================================================"
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Check PHP installation
echo -e "${BLUE}📍 Step 1: Checking PHP installation...${NC}"

if command -v php &> /dev/null; then
    echo -e "${GREEN}✓ PHP found${NC}"
    php --version | head -1
else
    echo -e "${RED}❌ PHP not found!${NC}"
    echo "Install PHP: brew install php"
    exit 1
fi

echo ""

# Step 2: Check Apache installation
echo -e "${BLUE}📍 Step 2: Checking Apache installation...${NC}"

if command -v apachectl &> /dev/null; then
    echo -e "${GREEN}✓ Apache found${NC}"
    apachectl -v | head -1
else
    echo -e "${RED}❌ Apache not found!${NC}"
    echo "Apache should be pre-installed on macOS"
    echo "Try: sudo apachectl start"
    exit 1
fi

echo ""

# Step 3: Check MySQL
echo -e "${BLUE}📍 Step 3: Checking MySQL...${NC}"

if command -v mysql &> /dev/null; then
    echo -e "${GREEN}✓ MySQL client found${NC}"
    mysql --version
else
    echo -e "${RED}❌ MySQL not found!${NC}"
    echo "Install MySQL: brew install mysql"
    exit 1
fi

# Check if MySQL server is running
if pgrep -x mysqld > /dev/null 2>&1 || pgrep -x mysql > /dev/null 2>&1; then
    echo -e "${GREEN}✓ MySQL server is running${NC}"
else
    echo -e "${YELLOW}⚠️  MySQL not running. Starting...${NC}"
    brew services start mysql
    sleep 3
fi

echo ""

# Step 4: Setup database
echo -e "${BLUE}📍 Step 4: Setting up database...${NC}"
echo "Enter MySQL root password (press Enter if no password):"
read -s DB_PASS

if [ -z "$DB_PASS" ]; then
    MYSQL_CMD="mysql -uroot"
else
    MYSQL_CMD="mysql -uroot -p$DB_PASS"
fi

# Create database and table
if $MYSQL_CMD < ex6a-php/musicdb.sql 2>/dev/null; then
    echo -e "${GREEN}✓ Database and table created/verified${NC}"
else
    echo -e "${RED}❌ Failed to create database${NC}"
    exit 1
fi

echo ""

# Step 5: Configure Apache
echo -e "${BLUE}📍 Step 5: Configuring Apache...${NC}"

# Determine Apache document root
APACHE_ROOT="/Library/WebServer/Documents"

if [ ! -d "$APACHE_ROOT" ]; then
    echo -e "${YELLOW}⚠️  Standard Apache root not found${NC}"
    echo "Creating symlinks in current directory instead..."
    APACHE_ROOT="."
fi

# Create symlinks or copy files
if [ "$APACHE_ROOT" = "/Library/WebServer/Documents" ]; then
    echo "This will copy files to Apache document root."
    echo "Requires sudo permission. Continue? [y/N]:"
    read -r CONTINUE
    
    if [[ "$CONTINUE" =~ ^[Yy]$ ]]; then
        sudo cp -r ex6a-php "$APACHE_ROOT/"
        sudo cp -r ex6b-php "$APACHE_ROOT/"
        echo -e "${GREEN}✓ Files copied to Apache root${NC}"
        URL_BASE="http://localhost"
    else
        echo "Skipping Apache copy. Using PHP built-in server instead."
        APACHE_ROOT="."
    fi
else
    URL_BASE="http://localhost:8000"
fi

echo ""

# Step 6: Start Apache or PHP server
echo -e "${BLUE}📍 Step 6: Starting web server...${NC}"

if [ "$APACHE_ROOT" = "/Library/WebServer/Documents" ]; then
    # Start Apache
    sudo apachectl start 2>/dev/null
    echo -e "${GREEN}✓ Apache started${NC}"
    
    URL_6A="$URL_BASE/ex6a-php/index.php"
    URL_6B="$URL_BASE/ex6b-php/view_instruments.php"
else
    # Use PHP built-in server
    echo "Starting PHP built-in server on port 8000..."
    echo -e "${YELLOW}Note: Keep this terminal open${NC}"
    
    URL_6A="http://localhost:8000/ex6a-php/index.php"
    URL_6B="http://localhost:8000/ex6b-php/view_instruments.php"
    
    echo ""
    echo "================================================"
    echo "           SETUP COMPLETE!"
    echo "================================================"
    echo ""
    echo -e "${GREEN}🌐 Access your applications:${NC}"
    echo ""
    echo "   Exercise 6a (Add Instrument):"
    echo "   → $URL_6A"
    echo ""
    echo "   Exercise 6b (View Instruments):"
    echo "   → $URL_6B"
    echo ""
    echo -e "${BLUE}📝 Press Ctrl+C to stop the server${NC}"
    echo "================================================"
    echo ""
    
    # Start PHP server
    cd /Users/vine/elco/College/wt/programs
    php -S localhost:8000
    exit 0
fi

echo ""

# Final Summary
echo "================================================"
echo "           SETUP COMPLETE!"
echo "================================================"
echo ""
echo -e "${GREEN}✅ Services Running:${NC}"
echo "   - MySQL: ✓"
echo "   - Apache: ✓"
echo "   - PHP: ✓"
echo ""
echo -e "${GREEN}🌐 Access your applications:${NC}"
echo ""
echo "   Exercise 6a (Add Instrument):"
echo "   → $URL_6A"
echo ""
echo "   Exercise 6b (View Instruments):"
echo "   → $URL_6B"
echo ""
echo -e "${BLUE}🛑 Stop Apache:${NC}"
echo "   sudo apachectl stop"
echo ""
echo -e "${BLUE}🛑 Stop MySQL:${NC}"
echo "   brew services stop mysql"
echo ""
echo "================================================"
