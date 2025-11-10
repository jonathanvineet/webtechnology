#!/bin/bash

# ===============================================================
# Exercise 7 - XML/XSL/PHP Setup and Run Script
# ===============================================================

echo "================================================"
echo "  Exercise 7: XML/XSL/PHP Demo"
echo "================================================"
echo ""

cd ex7-xml-xsl

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "❌ PHP not found!"
    echo ""
    echo "Install PHP:"
    echo "  macOS: brew install php"
    echo "  Ubuntu: sudo apt install php"
    echo ""
    exit 1
fi

echo "✓ PHP found: $(php -v | head -1)"
echo ""

# Validate XML (if xmllint available)
if command -v xmllint &> /dev/null; then
    echo "📋 Validating XML..."
    if xmllint instruments.xml --noout 2>/dev/null; then
        echo "✓ XML is well-formed"
    else
        echo "⚠️  XML validation warning (but may still work)"
    fi
    
    # Validate against schema
    if xmllint --schema instruments.xsd instruments.xml --noout 2>/dev/null; then
        echo "✓ XML validates against XSD schema"
    fi
    echo ""
else
    echo "ℹ️  xmllint not found (optional for validation)"
    echo "   Install: brew install libxml2"
    echo ""
fi

# Start PHP server
echo "🚀 Starting PHP built-in server..."
echo ""
echo "================================================"
echo "  Server Running!"
echo "================================================"
echo ""
echo "📌 Access points:"
echo ""
echo "   Main Demo Page:"
echo "   → http://localhost:8000/display.html"
echo ""
echo "   PHP Version:"
echo "   → http://localhost:8000/index.php"
echo ""
echo "   XML (with XSL):"
echo "   → http://localhost:8000/instruments.xml"
echo ""
echo "================================================"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start PHP server
php -S localhost:8000
