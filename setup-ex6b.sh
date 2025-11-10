#!/bin/bash

# ===============================================================
# Exercise 6b - View Database Records Setup Script
# ===============================================================

echo "================================================"
echo "  Exercise 6b: View Records Setup"
echo "================================================"
echo ""

APP_NAME="ex6b-view-app"
TOMCAT_HOME="/opt/homebrew/opt/tomcat/libexec"

# Check if Tomcat exists
if [ ! -d "$TOMCAT_HOME" ]; then
    echo "❌ Tomcat not found at: $TOMCAT_HOME"
    echo "Please install Tomcat: brew install tomcat"
    exit 1
fi

echo "✓ Found Tomcat"

# Copy MySQL JDBC driver from ex6a
echo "📦 Copying MySQL JDBC driver..."
if [ -f ex6a-database-app/WEB-INF/lib/mysql-connector-j-*.jar ]; then
    cp ex6a-database-app/WEB-INF/lib/mysql-connector-j-*.jar $APP_NAME/WEB-INF/lib/
    echo "✓ MySQL JDBC driver copied"
else
    echo "❌ MySQL JDBC driver not found in ex6a-database-app"
    echo "Please run Exercise 6a setup first: sh setup-ex6a.sh"
    exit 1
fi

# Compile servlet
echo "⚙️  Compiling servlet..."
cd $APP_NAME/WEB-INF/classes

SERVLET_API="$TOMCAT_HOME/lib/jakarta.servlet-api.jar"
if [ ! -f "$SERVLET_API" ]; then
    SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"
fi

MYSQL_JAR=$(ls ../lib/mysql-connector-j-*.jar | head -1)

if javac -cp "$SERVLET_API:$MYSQL_JAR" ViewInstruments.java; then
    echo "✓ Servlet compiled successfully"
else
    echo "❌ Compilation failed"
    exit 1
fi

cd ../../..

# Deploy to Tomcat
echo "🚀 Deploying to Tomcat..."
if [ -d "$TOMCAT_HOME/webapps/$APP_NAME" ]; then
    rm -rf "$TOMCAT_HOME/webapps/$APP_NAME"
fi

cp -r $APP_NAME "$TOMCAT_HOME/webapps/"
echo "✓ Application deployed"

# Restart Tomcat
echo "🔄 Restarting Tomcat..."
pkill -9 java 2>/dev/null
sleep 2
$TOMCAT_HOME/bin/catalina.sh start
echo "✓ Tomcat started"

sleep 5

echo ""
echo "================================================"
echo "           SETUP COMPLETE!"
echo "================================================"
echo ""
echo "🌐 Access your application:"
echo "   http://localhost:8080/ex6b-view-app/view.html"
echo ""
echo "📝 Testing:"
echo "   1. Open the URL above"
echo "   2. Click 'View All Instruments'"
echo "   3. See table with all records"
echo ""
echo "💡 Add test data using Exercise 6a:"
echo "   http://localhost:8080/ex6a-database-app/index.html"
echo ""
echo "================================================"
