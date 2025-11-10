#!/bin/bash

# ===============================================================
# Servlet Exercises Setup Script (Ex5a - Ex5e)
# OS-Independent approach for macOS/Linux
# ===============================================================

echo "=========================================="
echo "   SERVLET EXERCISES SETUP (5a-5e)"
echo "=========================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Detect Tomcat installation
echo "📍 Step 1: Detecting Tomcat installation..."

TOMCAT_HOME=""

if [ -d "/opt/tomcat" ]; then
    TOMCAT_HOME="/opt/tomcat"
elif [ -d "/usr/local/tomcat" ]; then
    TOMCAT_HOME="/usr/local/tomcat"
elif [ -d "$HOME/tomcat" ]; then
    TOMCAT_HOME="$HOME/tomcat"
elif [ -d "/Library/Tomcat" ]; then
    TOMCAT_HOME="/Library/Tomcat"
fi

if [ -z "$TOMCAT_HOME" ]; then
    echo -e "${RED}❌ Tomcat not found in common locations.${NC}"
    echo ""
    echo "Common locations checked:"
    echo "  - /opt/tomcat"
    echo "  - /usr/local/tomcat"
    echo "  - $HOME/tomcat"
    echo "  - /Library/Tomcat"
    echo ""
    echo "Please enter your Tomcat installation path (or press Enter to exit):"
    read TOMCAT_HOME
    
    if [ -z "$TOMCAT_HOME" ] || [ ! -d "$TOMCAT_HOME" ]; then
        echo -e "${RED}❌ Invalid path or cancelled. Exiting.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Found Tomcat at: $TOMCAT_HOME${NC}"

SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"

if [ ! -f "$SERVLET_API" ]; then
    echo -e "${RED}❌ servlet-api.jar not found at: $SERVLET_API${NC}"
    exit 1
fi

echo ""

# List of exercises
EXERCISES=("ex5a-tomcat-app" "ex5b-session-app" "ex5c-cookie-app" "ex5d-urlrewrite-app" "ex5e-hiddenfield-app")
NAMES=("5a: Form Servlet" "5b: Session Tracking" "5c: Cookie Tracking" "5d: URL Rewriting" "5e: Hidden Fields")

# Step 2: Compile all servlets
echo "⚙️  Step 2: Compiling servlets..."
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0

for i in "${!EXERCISES[@]}"; do
    EXERCISE="${EXERCISES[$i]}"
    NAME="${NAMES[$i]}"
    
    if [ ! -d "$EXERCISE" ]; then
        echo -e "${YELLOW}⚠️  Skipping $NAME - directory not found${NC}"
        continue
    fi
    
    echo "Compiling $NAME..."
    
    # Extract servlet name (ex5a, ex5b, etc.)
    SERVLET_NAME=$(echo "$EXERCISE" | cut -d'-' -f1)
    JAVA_FILE="$EXERCISE/WEB-INF/classes/${SERVLET_NAME}.java"
    
    if [ ! -f "$JAVA_FILE" ]; then
        echo -e "${YELLOW}⚠️  Skipping - ${SERVLET_NAME}.java not found${NC}"
        continue
    fi
    
    # Compile
    if javac -cp "$SERVLET_API" "$JAVA_FILE" 2>/dev/null; then
        echo -e "${GREEN}✓ Compiled $NAME${NC}"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}✗ Failed to compile $NAME${NC}"
        ((FAIL_COUNT++))
    fi
done

echo ""
echo "Compilation Summary: ${GREEN}$SUCCESS_COUNT succeeded${NC}, ${RED}$FAIL_COUNT failed${NC}"
echo ""

if [ $SUCCESS_COUNT -eq 0 ]; then
    echo -e "${RED}❌ No servlets compiled successfully. Exiting.${NC}"
    exit 1
fi

# Step 3: Deploy to Tomcat
echo "📦 Step 3: Deploying to Tomcat..."
echo ""

DEPLOY_COUNT=0

for i in "${!EXERCISES[@]}"; do
    EXERCISE="${EXERCISES[$i]}"
    NAME="${NAMES[$i]}"
    
    if [ ! -d "$EXERCISE" ]; then
        continue
    fi
    
    # Check if .class file exists (compiled successfully)
    SERVLET_NAME=$(echo "$EXERCISE" | cut -d'-' -f1)
    CLASS_FILE="$EXERCISE/WEB-INF/classes/${SERVLET_NAME}.class"
    
    if [ ! -f "$CLASS_FILE" ]; then
        echo -e "${YELLOW}⚠️  Skipping $NAME - not compiled${NC}"
        continue
    fi
    
    echo "Deploying $NAME..."
    
    # Remove old deployment
    if [ -d "$TOMCAT_HOME/webapps/$EXERCISE" ]; then
        rm -rf "$TOMCAT_HOME/webapps/$EXERCISE"
    fi
    
    # Copy to webapps
    if cp -r "$EXERCISE" "$TOMCAT_HOME/webapps/"; then
        echo -e "${GREEN}✓ Deployed $NAME${NC}"
        ((DEPLOY_COUNT++))
    else
        echo -e "${RED}✗ Failed to deploy $NAME${NC}"
    fi
done

echo ""
echo -e "${GREEN}Deployed $DEPLOY_COUNT applications${NC}"
echo ""

# Step 4: Start/Restart Tomcat
echo "🔍 Step 4: Managing Tomcat..."

TOMCAT_RUNNING=0
if pgrep -f "catalina" > /dev/null 2>&1; then
    TOMCAT_RUNNING=1
fi

if [ $TOMCAT_RUNNING -eq 1 ]; then
    echo -e "${YELLOW}⚠️  Tomcat is running. Restarting for new deployments...${NC}"
    
    if [ -f "$TOMCAT_HOME/bin/shutdown.sh" ]; then
        chmod +x "$TOMCAT_HOME/bin/shutdown.sh"
        "$TOMCAT_HOME/bin/shutdown.sh" > /dev/null 2>&1
        sleep 3
    fi
fi

echo "Starting Tomcat..."

if [ -f "$TOMCAT_HOME/bin/startup.sh" ]; then
    chmod +x "$TOMCAT_HOME/bin/startup.sh"
    "$TOMCAT_HOME/bin/startup.sh" > /dev/null 2>&1
    echo -e "${GREEN}✓ Tomcat started${NC}"
    echo "⏳ Waiting for applications to deploy (5 seconds)..."
    sleep 5
else
    echo -e "${RED}❌ Cannot find startup.sh at: $TOMCAT_HOME/bin/startup.sh${NC}"
    exit 1
fi

echo ""

# Step 5: Test applications
echo "🌐 Step 5: Testing applications..."
echo ""

TEST_PASSED=0
TEST_FAILED=0

for i in "${!EXERCISES[@]}"; do
    EXERCISE="${EXERCISES[$i]}"
    NAME="${NAMES[$i]}"
    
    if [ ! -d "$TOMCAT_HOME/webapps/$EXERCISE" ]; then
        continue
    fi
    
    SERVLET_NAME=$(echo "$EXERCISE" | cut -d'-' -f1)
    URL="http://localhost:8080/$EXERCISE/${SERVLET_NAME}.html"
    
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL" 2>/dev/null)
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo -e "${GREEN}✓ $NAME is accessible${NC}"
        ((TEST_PASSED++))
    else
        echo -e "${RED}✗ $NAME not accessible (HTTP $HTTP_CODE)${NC}"
        ((TEST_FAILED++))
    fi
done

echo ""

# Final Summary
echo "=========================================="
echo "           SETUP COMPLETE!"
echo "=========================================="
echo ""
echo -e "📊 Summary:"
echo -e "   Compiled: ${GREEN}$SUCCESS_COUNT${NC}"
echo -e "   Deployed: ${GREEN}$DEPLOY_COUNT${NC}"
echo -e "   Working:  ${GREEN}$TEST_PASSED${NC}"
echo ""

if [ $TEST_PASSED -gt 0 ]; then
    echo -e "${GREEN}🌐 Access your applications:${NC}"
    echo ""
    
    for i in "${!EXERCISES[@]}"; do
        EXERCISE="${EXERCISES[$i]}"
        NAME="${NAMES[$i]}"
        
        if [ -d "$TOMCAT_HOME/webapps/$EXERCISE" ]; then
            SERVLET_NAME=$(echo "$EXERCISE" | cut -d'-' -f1)
            echo "   $NAME:"
            echo "   → http://localhost:8080/$EXERCISE/${SERVLET_NAME}.html"
            echo ""
        fi
    done
fi

echo "📝 Additional Commands:"
echo ""
echo "   View Tomcat logs:"
echo "   → tail -f $TOMCAT_HOME/logs/catalina.out"
echo ""
echo "   Stop Tomcat:"
echo "   → $TOMCAT_HOME/bin/shutdown.sh"
echo ""
echo "   Restart Tomcat:"
echo "   → $TOMCAT_HOME/bin/shutdown.sh && $TOMCAT_HOME/bin/startup.sh"
echo ""
echo "=========================================="
