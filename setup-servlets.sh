#!/bin/bash

# ============================================
# Setup Script for Servlet Exercises 5a-5d
# ============================================

echo "🚀 Servlet Exercises Setup Script"
echo "=================================="
echo ""
echo "Available exercises:"
echo "  5a - Basic Servlet (Form handling)"
echo "  5b - Session Tracking"
echo "  5c - Cookie Tracking"
echo "  5d - URL Rewriting"
echo ""

# Function to detect Tomcat
detect_tomcat() {
    if [ -d "/opt/tomcat" ]; then
        echo "/opt/tomcat"
    elif [ -d "/usr/local/tomcat" ]; then
        echo "/usr/local/tomcat"
    elif [ -d "$HOME/tomcat" ]; then
        echo "$HOME/tomcat"
    elif [ -d "/Library/Tomcat" ]; then
        echo "/Library/Tomcat"
    else
        echo ""
    fi
}

# Detect Tomcat
TOMCAT_HOME=$(detect_tomcat)

if [ -z "$TOMCAT_HOME" ]; then
    echo "❌ Tomcat not found in common locations."
    echo "Please enter your Tomcat installation path:"
    read TOMCAT_HOME
    
    if [ ! -d "$TOMCAT_HOME" ]; then
        echo "❌ Invalid path. Exiting."
        exit 1
    fi
fi

echo "✓ Using Tomcat at: $TOMCAT_HOME"
SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"

if [ ! -f "$SERVLET_API" ]; then
    echo "❌ servlet-api.jar not found at: $SERVLET_API"
    exit 1
fi

echo ""
echo "Which exercise do you want to setup? (5a/5b/5c/5d/all)"
read EXERCISE

setup_exercise() {
    local ex=$1
    local app_name=$2
    
    echo ""
    echo "📦 Setting up Exercise $ex - $app_name"
    echo "----------------------------------------"
    
    # Compile
    echo "⚙️  Compiling servlet..."
    cd "$app_name/WEB-INF/classes"
    
    if javac -cp "$SERVLET_API" ex${ex}.java; then
        echo "✓ Compilation successful!"
    else
        echo "❌ Compilation failed!"
        cd ../../..
        return 1
    fi
    
    cd ../../..
    
    # Deploy
    echo "📦 Deploying to Tomcat..."
    
    if [ -d "$TOMCAT_HOME/webapps/$app_name" ]; then
        rm -rf "$TOMCAT_HOME/webapps/$app_name"
    fi
    
    cp -r "$app_name" "$TOMCAT_HOME/webapps/"
    echo "✓ Deployed: $TOMCAT_HOME/webapps/$app_name"
    
    return 0
}

# Setup based on choice
case $EXERCISE in
    5a)
        setup_exercise "5a" "ex5a-tomcat-app"
        URL="http://localhost:8080/ex5a-tomcat-app/ex5a.html"
        ;;
    5b)
        setup_exercise "5b" "ex5b-session-app"
        URL="http://localhost:8080/ex5b-session-app/ex5b.html"
        ;;
    5c)
        setup_exercise "5c" "ex5c-cookie-app"
        URL="http://localhost:8080/ex5c-cookie-app/ex5c.html"
        ;;
    5d)
        setup_exercise "5d" "ex5d-urlrewrite-app"
        URL="http://localhost:8080/ex5d-urlrewrite-app/ex5d.html"
        ;;
    all)
        setup_exercise "5a" "ex5a-tomcat-app"
        setup_exercise "5b" "ex5b-session-app"
        setup_exercise "5c" "ex5c-cookie-app"
        setup_exercise "5d" "ex5d-urlrewrite-app"
        echo ""
        echo "✅ All exercises setup complete!"
        echo ""
        echo "URLs:"
        echo "  5a: http://localhost:8080/ex5a-tomcat-app/ex5a.html"
        echo "  5b: http://localhost:8080/ex5b-session-app/ex5b.html"
        echo "  5c: http://localhost:8080/ex5c-cookie-app/ex5c.html"
        echo "  5d: http://localhost:8080/ex5d-urlrewrite-app/ex5d.html"
        URL=""
        ;;
    *)
        echo "❌ Invalid choice. Please enter 5a, 5b, 5c, 5d, or all"
        exit 1
        ;;
esac

# Check/Start Tomcat
echo ""
echo "🔍 Checking Tomcat status..."

if pgrep -f "catalina" > /dev/null; then
    echo "✓ Tomcat is running"
    echo "⏳ Waiting 3 seconds for deployment..."
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
        echo "❌ Cannot find startup.sh"
        exit 1
    fi
fi

# Final message
echo ""
echo "=" 
echo "✅ Setup Complete!"
echo "="
echo ""

if [ -n "$URL" ]; then
    echo "🌐 Access your application:"
    echo "   $URL"
    echo ""
fi

echo "🛑 To stop Tomcat:"
echo "   $TOMCAT_HOME/bin/shutdown.sh"
echo ""
echo "📚 Check README.md in each exercise folder for details"
echo ""
