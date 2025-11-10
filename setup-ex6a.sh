#!/bin/bash

# ===============================================================
# Exercise 6a - Database Application Setup Script
# Three-Tier Architecture with MySQL
# ===============================================================

echo "================================================"
echo "  Exercise 6a: Database Application Setup"
echo "  Three-Tier Architecture (MySQL + Servlet)"
echo "================================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
APP_NAME="ex6a-database-app"
DB_NAME="musicdb"
DB_USER="root"
DB_PASS=""
MYSQL_JAR_VERSION="8.0.33"
MYSQL_JAR_URL="https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/${MYSQL_JAR_VERSION}/mysql-connector-j-${MYSQL_JAR_VERSION}.jar"

# Step 1: Check MySQL Installation
echo -e "${BLUE}📍 Step 1: Checking MySQL installation...${NC}"

if command -v mysql &> /dev/null; then
    echo -e "${GREEN}✓ MySQL client found${NC}"
    mysql --version
else
    echo -e "${RED}❌ MySQL not found!${NC}"
    echo ""
    echo "Please install MySQL first:"
    echo "  macOS:  brew install mysql"
    echo "  Ubuntu: sudo apt install mysql-server"
    echo ""
    exit 1
fi

# Check if MySQL server is running
if pgrep -x mysqld > /dev/null 2>&1 || pgrep -x mysql > /dev/null 2>&1; then
    echo -e "${GREEN}✓ MySQL server is running${NC}"
else
    echo -e "${YELLOW}⚠️  MySQL server not running. Attempting to start...${NC}"
    
    # Try to start MySQL
    if command -v brew &> /dev/null; then
        brew services start mysql
        sleep 3
    elif command -v systemctl &> /dev/null; then
        sudo systemctl start mysql
        sleep 3
    else
        echo -e "${RED}❌ Could not start MySQL automatically${NC}"
        echo "Please start MySQL manually and run this script again."
        exit 1
    fi
fi

echo ""

# Step 2: Get MySQL Password
echo -e "${BLUE}📍 Step 2: MySQL authentication...${NC}"
echo "Enter MySQL root password (press Enter if no password):"
read -s DB_PASS
echo ""

# Test connection
if [ -z "$DB_PASS" ]; then
    # No password - connect without -p flag
    if mysql -u"$DB_USER" -e "SELECT 1;" &> /dev/null; then
        echo -e "${GREEN}✓ MySQL connection successful${NC}"
    else
        echo -e "${RED}❌ MySQL connection failed!${NC}"
        echo "Please check your MySQL configuration."
        exit 1
    fi
else
    # Has password - use -p flag
    if mysql -u"$DB_USER" -p"$DB_PASS" -e "SELECT 1;" &> /dev/null; then
        echo -e "${GREEN}✓ MySQL connection successful${NC}"
    else
        echo -e "${RED}❌ MySQL connection failed!${NC}"
        echo "Please check your MySQL root password."
        exit 1
    fi
fi

echo ""

# Step 3: Create Database and Table
echo -e "${BLUE}📍 Step 3: Setting up database...${NC}"

# Set MySQL command based on password
if [ -z "$DB_PASS" ]; then
    MYSQL_CMD="mysql -u$DB_USER"
else
    MYSQL_CMD="mysql -u$DB_USER -p$DB_PASS"
fi

# Check if database exists
if $MYSQL_CMD -e "USE $DB_NAME;" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Database '$DB_NAME' already exists${NC}"
    echo "Do you want to recreate it? (This will delete all existing data) [y/N]:"
    read -r RECREATE
    
    if [[ "$RECREATE" =~ ^[Yy]$ ]]; then
        echo "Dropping existing database..."
        $MYSQL_CMD -e "DROP DATABASE $DB_NAME;"
        echo -e "${GREEN}✓ Database dropped${NC}"
    else
        echo "Keeping existing database..."
    fi
fi

# Create database
if ! $MYSQL_CMD -e "USE $DB_NAME;" 2>/dev/null; then
    echo "Creating database '$DB_NAME'..."
    $MYSQL_CMD < "$APP_NAME/musicdb.sql"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Database and table created successfully${NC}"
    else
        echo -e "${RED}❌ Failed to create database${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Database exists${NC}"
fi

# Verify table
TABLES=$($MYSQL_CMD -D"$DB_NAME" -e "SHOW TABLES;" 2>/dev/null | grep instruments)
if [ -n "$TABLES" ]; then
    echo -e "${GREEN}✓ Table 'instruments' verified${NC}"
else
    echo -e "${RED}❌ Table 'instruments' not found${NC}"
    exit 1
fi

echo ""

# Step 4: Download MySQL JDBC Driver
echo -e "${BLUE}📍 Step 4: Checking MySQL JDBC Driver...${NC}"

LIB_DIR="$APP_NAME/WEB-INF/lib"
MYSQL_JAR="$LIB_DIR/mysql-connector-j-${MYSQL_JAR_VERSION}.jar"

if [ -f "$MYSQL_JAR" ]; then
    echo -e "${GREEN}✓ MySQL JDBC driver found${NC}"
else
    echo "Downloading MySQL JDBC driver..."
    
    if command -v curl &> /dev/null; then
        curl -L -o "$MYSQL_JAR" "$MYSQL_JAR_URL"
    elif command -v wget &> /dev/null; then
        wget -O "$MYSQL_JAR" "$MYSQL_JAR_URL"
    else
        echo -e "${RED}❌ Neither curl nor wget found${NC}"
        echo "Please download manually from:"
        echo "$MYSQL_JAR_URL"
        echo "And place it in: $LIB_DIR/"
        exit 1
    fi
    
    if [ -f "$MYSQL_JAR" ]; then
        echo -e "${GREEN}✓ MySQL JDBC driver downloaded${NC}"
    else
        echo -e "${RED}❌ Failed to download JDBC driver${NC}"
        exit 1
    fi
fi

echo ""

# Step 5: Update Database Credentials in Servlet
echo -e "${BLUE}📍 Step 5: Updating database credentials...${NC}"

SERVLET_FILE="$APP_NAME/WEB-INF/classes/AddInstrument.java"

if [ -f "$SERVLET_FILE" ]; then
    # Update password in servlet (simple sed replacement)
    if [ -z "$DB_PASS" ]; then
        # No password
        sed -i.bak 's/"jdbc:mysql:\/\/localhost:3306\/musicdb", "root", "password"/"jdbc:mysql:\/\/localhost:3306\/musicdb", "root", ""/' "$SERVLET_FILE"
    else
        # Has password - keep as is or update
        echo -e "${YELLOW}⚠️  Remember to update password in AddInstrument.java if needed${NC}"
    fi
    echo -e "${GREEN}✓ Servlet file ready${NC}"
else
    echo -e "${RED}❌ Servlet file not found${NC}"
    exit 1
fi

echo ""

# Step 6: Detect Tomcat
echo -e "${BLUE}📍 Step 6: Detecting Tomcat installation...${NC}"

TOMCAT_HOME=""

# Check common Tomcat locations
TOMCAT_LOCATIONS=(
    "/opt/homebrew/opt/tomcat/libexec"
    "/usr/local/opt/tomcat/libexec"
    "/opt/homebrew/Cellar/tomcat/"*/libexec
    "/opt/tomcat"
    "/usr/local/tomcat"
    "$HOME/tomcat"
    "/Library/Tomcat"
)

for location in "${TOMCAT_LOCATIONS[@]}"; do
    if [ -d "$location" ] && [ -f "$location/lib/servlet-api.jar" ]; then
        TOMCAT_HOME="$location"
        break
    fi
done

if [ -z "$TOMCAT_HOME" ]; then
    echo -e "${RED}❌ Tomcat not found in common locations${NC}"
    echo ""
    echo "Please install Tomcat first:"
    echo "  brew install tomcat"
    echo ""
    echo "Or enter your Tomcat installation path manually:"
    read TOMCAT_HOME
    
    if [ -z "$TOMCAT_HOME" ] || [ ! -d "$TOMCAT_HOME" ]; then
        echo -e "${RED}❌ Invalid path. Exiting.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Found Tomcat at: $TOMCAT_HOME${NC}"

# Check for servlet API jar (Tomcat 10+ uses jakarta.servlet-api.jar)
SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"
if [ ! -f "$SERVLET_API" ]; then
    SERVLET_API="$TOMCAT_HOME/lib/jakarta.servlet-api.jar"
fi

if [ ! -f "$SERVLET_API" ]; then
    echo -e "${RED}❌ servlet-api.jar or jakarta.servlet-api.jar not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Using: $(basename $SERVLET_API)${NC}"

echo ""

# Step 7: Compile Servlet
echo -e "${BLUE}📍 Step 7: Compiling servlet...${NC}"

cd "$APP_NAME/WEB-INF/classes"

# Find the MySQL JAR
MYSQL_JAR_FILE=$(ls ../lib/mysql-connector-j-*.jar 2>/dev/null | head -1)

if [ -z "$MYSQL_JAR_FILE" ]; then
    echo -e "${RED}❌ MySQL JAR not found in lib directory${NC}"
    exit 1
fi

# Compile with both JARs
if javac -cp "$SERVLET_API:$MYSQL_JAR_FILE" AddInstrument.java; then
    echo -e "${GREEN}✓ Servlet compiled successfully${NC}"
else
    echo -e "${RED}❌ Compilation failed${NC}"
    exit 1
fi

cd ../../..

echo ""

# Step 8: Deploy to Tomcat
echo -e "${BLUE}📍 Step 8: Deploying to Tomcat...${NC}"

if [ -d "$TOMCAT_HOME/webapps/$APP_NAME" ]; then
    echo "Removing old deployment..."
    rm -rf "$TOMCAT_HOME/webapps/$APP_NAME"
fi

cp -r "$APP_NAME" "$TOMCAT_HOME/webapps/"
echo -e "${GREEN}✓ Application deployed${NC}"

echo ""

# Step 9: Start Tomcat
echo -e "${BLUE}📍 Step 9: Starting Tomcat...${NC}"

if pgrep -f "catalina" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Tomcat is running. Restarting...${NC}"
    "$TOMCAT_HOME/bin/shutdown.sh" > /dev/null 2>&1
    sleep 3
fi

"$TOMCAT_HOME/bin/startup.sh" > /dev/null 2>&1
echo -e "${GREEN}✓ Tomcat started${NC}"
echo "⏳ Waiting for deployment (5 seconds)..."
sleep 5

echo ""

# Step 10: Test Application
echo -e "${BLUE}📍 Step 10: Testing application...${NC}"

URL="http://localhost:8080/$APP_NAME/index.html"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL" 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✓ Application is accessible!${NC}"
else
    echo -e "${YELLOW}⚠️  Application not ready yet (HTTP $HTTP_CODE)${NC}"
fi

echo ""

# Final Summary
echo "================================================"
echo "           SETUP COMPLETE!"
echo "================================================"
echo ""
echo -e "${GREEN}✅ Database Setup:${NC}"
echo "   Database: $DB_NAME"
echo "   Table: instruments"
echo "   User: $DB_USER"
echo ""
echo -e "${GREEN}✅ Application Deployed:${NC}"
echo "   Location: $TOMCAT_HOME/webapps/$APP_NAME"
echo ""
echo -e "${GREEN}🌐 Access your application:${NC}"
echo "   $URL"
echo ""
echo -e "${BLUE}📝 Testing:${NC}"
echo "   1. Open the URL above in your browser"
echo "   2. Fill in the instrument registration form"
echo "   3. Submit and verify 'Instrument Added Successfully!'"
echo "   4. Check database:"
echo "      mysql -u$DB_USER -p$DB_PASS -D$DB_NAME -e \"SELECT * FROM instruments;\""
echo ""
echo -e "${BLUE}🛑 Stop Services:${NC}"
echo "   Tomcat:  $TOMCAT_HOME/bin/shutdown.sh"
echo "   MySQL:   brew services stop mysql  (or systemctl stop mysql)"
echo ""
echo -e "${BLUE}💡 Database Query:${NC}"
if [ -z "$DB_PASS" ]; then
    echo "   mysql -u$DB_USER -D$DB_NAME -e \"SELECT * FROM instruments;\""
else
    echo "   mysql -u$DB_USER -p -D$DB_NAME -e \"SELECT * FROM instruments;\""
fi
echo ""
echo "================================================"
