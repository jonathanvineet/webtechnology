#!/bin/bash

# =======================================================
# Quick Manual Setup for Exercise 6a (Without Tomcat)
# Use this if you don't have Tomcat installed
# =======================================================

echo "============================================"
echo "  Exercise 6a: Manual Setup Guide"
echo "============================================"
echo ""

# Step 1: Install Tomcat
echo "Step 1: Install Apache Tomcat"
echo "------------------------------"
echo "Run this command:"
echo "  brew install tomcat"
echo ""
echo "Press Enter after installing Tomcat..."
read

# Step 2: Start Tomcat
echo ""
echo "Step 2: Start Tomcat"
echo "--------------------"
echo "Run this command:"
echo "  brew services start tomcat"
echo ""
echo "Press Enter after starting Tomcat..."
read

# Step 3: Find Tomcat location
echo ""
echo "Step 3: Locating Tomcat..."
echo "--------------------------"

TOMCAT_HOME=""
if [ -d "/opt/homebrew/opt/tomcat/libexec" ]; then
    TOMCAT_HOME="/opt/homebrew/opt/tomcat/libexec"
elif [ -d "/usr/local/opt/tomcat/libexec" ]; then
    TOMCAT_HOME="/usr/local/opt/tomcat/libexec"
fi

if [ -n "$TOMCAT_HOME" ]; then
    echo "✓ Found Tomcat at: $TOMCAT_HOME"
else
    echo "⚠️  Could not auto-detect Tomcat"
    echo "Please run: brew --prefix tomcat"
    exit 1
fi

echo ""

# Step 4: Compile servlet
echo "Step 4: Compile the Servlet"
echo "---------------------------"

cd ex6a-database-app/WEB-INF/classes

MYSQL_JAR=$(ls ../lib/mysql-connector-j-*.jar 2>/dev/null | head -1)

if [ -z "$MYSQL_JAR" ]; then
    echo "⚠️  MySQL JDBC driver not found!"
    echo "Run the main setup script first: sh setup-ex6a.sh"
    exit 1
fi

SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"

echo "Compiling AddInstrument.java..."
javac -cp "$SERVLET_API:$MYSQL_JAR" AddInstrument.java

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
    exit 1
fi

cd ../../..

echo ""

# Step 5: Deploy
echo "Step 5: Deploy to Tomcat"
echo "------------------------"

if [ -d "$TOMCAT_HOME/webapps/ex6a-database-app" ]; then
    rm -rf "$TOMCAT_HOME/webapps/ex6a-database-app"
fi

cp -r ex6a-database-app "$TOMCAT_HOME/webapps/"

echo "✓ Application deployed to: $TOMCAT_HOME/webapps/ex6a-database-app"
echo ""

# Step 6: Restart Tomcat
echo "Step 6: Restart Tomcat"
echo "----------------------"
echo "Run these commands:"
echo "  brew services restart tomcat"
echo ""
echo "Press Enter after restarting..."
read

# Step 7: Test
echo ""
echo "Step 7: Test Application"
echo "------------------------"

sleep 3

URL="http://localhost:8080/ex6a-database-app/index.html"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL" 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✓ Application is running!"
else
    echo "⚠️  Application not responding (HTTP $HTTP_CODE)"
    echo "Wait a few seconds and try accessing manually"
fi

echo ""
echo "============================================"
echo "           SETUP COMPLETE!"
echo "============================================"
echo ""
echo "🌐 Access your application:"
echo "   $URL"
echo ""
echo "📝 Test database connection:"
echo "   1. Fill the form and submit"
echo "   2. Check: mysql -uroot musicdb -e 'SELECT * FROM instruments;'"
echo ""
echo "============================================"
