#!/bin/bash

# ============================================
# Exercise 5b - Session Tracking Setup Script
# ============================================

echo "🚀 Setting up Exercise 5b - Session Tracking..."
echo ""

# Step 1: Detect Tomcat installation
echo "📍 Step 1: Detecting Tomcat installation..."

# Check common Tomcat locations (including Homebrew)
if [ -d "/opt/homebrew/opt/tomcat/libexec" ]; then
    TOMCAT_HOME="/opt/homebrew/opt/tomcat/libexec"
    echo "✓ Found Tomcat at: $TOMCAT_HOME (Homebrew)"
elif [ -d "/usr/local/opt/tomcat/libexec" ]; then
    TOMCAT_HOME="/usr/local/opt/tomcat/libexec"
    echo "✓ Found Tomcat at: $TOMCAT_HOME (Homebrew)"
elif [ -d "/opt/homebrew/Cellar/tomcat" ]; then
    # Find the latest version
    TOMCAT_HOME=$(find /opt/homebrew/Cellar/tomcat -maxdepth 2 -name "libexec" -type d | head -n 1)
    echo "✓ Found Tomcat at: $TOMCAT_HOME (Homebrew Cellar)"
elif [ -d "/opt/tomcat" ]; then
    TOMCAT_HOME="/opt/tomcat"
    echo "✓ Found Tomcat at: $TOMCAT_HOME"
elif [ -d "/usr/local/tomcat" ]; then
    TOMCAT_HOME="/usr/local/tomcat"
    echo "✓ Found Tomcat at: $TOMCAT_HOME"
elif [ -d "$HOME/tomcat" ]; then
    TOMCAT_HOME="$HOME/tomcat"
    echo "✓ Found Tomcat at: $TOMCAT_HOME"
else
    echo "❌ Tomcat not found in common locations."
    echo "Please enter your Tomcat installation path:"
    read TOMCAT_HOME
    
    if [ ! -d "$TOMCAT_HOME" ]; then
        echo "❌ Invalid path. Exiting."
        exit 1
    fi
fi

SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"

# Check for Jakarta servlet API (Tomcat 10+)
if [ ! -f "$SERVLET_API" ]; then
    SERVLET_API="$TOMCAT_HOME/lib/jakarta.servlet-api.jar"
fi

if [ ! -f "$SERVLET_API" ]; then
    echo "❌ servlet-api.jar or jakarta.servlet-api.jar not found in: $TOMCAT_HOME/lib/"
    exit 1
fi

echo "✓ Using servlet API: $(basename $SERVLET_API)"

echo ""

# Step 2: Compile the servlet
echo "⚙️  Step 2: Compiling servlet..."
cd ex5b-session-app/WEB-INF/classes

if javac -cp "$SERVLET_API" ex5b.java; then
    echo "✓ Compilation successful!"
else
    echo "❌ Compilation failed!"
    exit 1
fi

cd ../../..
echo ""

# Step 3: Deploy to Tomcat
echo "📦 Step 3: Deploying to Tomcat..."

if [ -d "$TOMCAT_HOME/webapps/ex5b-session-app" ]; then
    echo "⚠️  Removing old deployment..."
    rm -rf "$TOMCAT_HOME/webapps/ex5b-session-app"
fi

cp -r ex5b-session-app "$TOMCAT_HOME/webapps/"
echo "✓ Deployed to: $TOMCAT_HOME/webapps/ex5b-session-app"
echo ""

# Step 4: Check Tomcat status
echo "🔍 Step 4: Checking Tomcat status..."

if pgrep -f "catalina" > /dev/null; then
    echo "✓ Tomcat is running"
    echo "⚠️  Waiting 3 seconds for deployment..."
    sleep 3
else
    echo "⚠️  Tomcat is not running"
    echo "Starting Tomcat..."
    
    if [ -f "$TOMCAT_HOME/bin/startup.sh" ]; then
        chmod +x "$TOMCAT_HOME/bin/startup.sh"
        "$TOMCAT_HOME/bin/startup.sh"
        echo "✓ Tomcat started"
        echo "⏳ Waiting 5 seconds for startup..."
        sleep 5
    else
        echo "❌ Cannot find startup.sh at: $TOMCAT_HOME/bin/startup.sh"
        exit 1
    fi
fi

echo ""

# Step 5: Test connectivity
echo "🌐 Step 5: Testing application..."

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ex5b-session-app/ex5b.html | grep -q "200"; then
    echo "✓ Application is accessible!"
else
    echo "⚠️  Application might not be ready yet. Please wait a moment."
fi

echo ""
echo "=" 
echo "✅ Setup Complete!"
echo "="
echo ""
echo "🌐 Access your application at:"
echo "   http://localhost:8080/ex5b-session-app/ex5b.html"
echo ""
echo "📝 To test session tracking:"
echo "   1. Fill in the form and submit"
echo "   2. Click 'View Session Info' link"
echo "   3. Or visit: http://localhost:8080/ex5b-session-app/Ex5b"
echo ""
echo "🛑 To stop Tomcat:"
echo "   $TOMCAT_HOME/bin/shutdown.sh"
echo ""
