# Exercise 7: Programs using XML – Schema – XSL/XSLT

## 🎯 Aim
To create an XML file and use an XSL stylesheet to display the data in a formatted way using HTML and PHP.

## 📁 Project Structure
```
ex7-xml-xsl/
├── instruments.xml       (XML data file)
├── instruments.xsd       (XML Schema for validation)
├── style.xsl            (XSL stylesheet for transformation)
├── index.php            (PHP file to parse and display XML)
├── display.html         (Direct XML+XSL viewing)
└── README.md            (This file)
```

## 📝 Files Overview

### 1. **instruments.xml** - XML Data File
Contains musical instrument data with:
- Processing instruction linking to XSL stylesheet
- Structured data with `<instrument>` elements
- Each instrument has `<name>` and `<type>`

### 2. **style.xsl** - XSL Stylesheet
XSLT transformation that:
- Matches the root element
- Creates HTML table structure
- Loops through each instrument using `<xsl:for-each>`
- Extracts values using `<xsl:value-of>`
- Applies styling

### 3. **index.php** - PHP Parser
PHP script that:
- Loads XML using `simplexml_load_file()`
- Iterates through instruments
- Generates HTML table dynamically

### 4. **instruments.xsd** - XML Schema
Defines the structure and validates:
- Root element `<instruments>`
- Child elements `<instrument>`
- Required fields: `name` and `type`

## 🚀 How to Run

### Method 1: Direct XML+XSL (Browser-based)

Most modern browsers can render XML with XSL directly:

1. **Open in browser:**
   ```bash
   open ex7-xml-xsl/instruments.xml
   ```
   Or navigate to: `file:///path/to/ex7-xml-xsl/instruments.xml`

2. **Result:**
   - Browser applies the XSL transformation
   - Displays formatted HTML table

**Note:** Modern browsers may block XSL transformations for local files due to CORS. See workarounds below.

---

### Method 2: Using PHP

PHP requires a web server to execute.

#### Option A: Using PHP Built-in Server

1. **Start PHP server:**
   ```bash
   cd ex7-xml-xsl
   php -S localhost:8000
   ```

2. **Open in browser:**
   ```
   http://localhost:8000/index.php
   ```

#### Option B: Using Apache/XAMPP

1. **Copy folder to web root:**
   ```bash
   # macOS (XAMPP)
   cp -r ex7-xml-xsl /Applications/XAMPP/htdocs/

   # macOS (MAMP)
   cp -r ex7-xml-xsl /Applications/MAMP/htdocs/

   # Linux
   sudo cp -r ex7-xml-xsl /var/www/html/
   ```

2. **Start Apache:**
   ```bash
   # XAMPP
   sudo /Applications/XAMPP/xamppfiles/xampp start

   # MAMP - Use GUI

   # Linux
   sudo systemctl start apache2
   ```

3. **Access:**
   ```
   http://localhost/ex7-xml-xsl/index.php
   ```

---

### Method 3: Python HTTP Server (For XSL Viewing)

To avoid CORS issues with XSL transformations:

1. **Start Python server:**
   ```bash
   cd ex7-xml-xsl
   python3 -m http.server 8000
   ```

2. **Open in browser:**
   ```
   http://localhost:8000/instruments.xml
   ```

---

## 🧪 Testing

### Test XML Structure:
```bash
# View raw XML
cat ex7-xml-xsl/instruments.xml

# Validate XML syntax (if xmllint installed)
xmllint ex7-xml-xsl/instruments.xml
```

### Validate Against Schema:
```bash
# Install xmllint (if needed)
brew install libxml2

# Validate
xmllint --schema ex7-xml-xsl/instruments.xsd ex7-xml-xsl/instruments.xml --noout
```

Expected output:
```
instruments.xml validates
```

### Test XSL Transformation:
```bash
# Using xsltproc
xsltproc ex7-xml-xsl/style.xsl ex7-xml-xsl/instruments.xml > output.html
open output.html
```

---

## 📊 Expected Output

### Both methods should display:

```
Musical Instruments List

+-------------------+-------------+
| Instrument Name   | Type        |
+-------------------+-------------+
| Guitar            | String      |
| Piano             | Keyboard    |
| Flute             | Wind        |
| Drum              | Percussion  |
+-------------------+-------------+
```

- Centered table
- Light blue header background
- White table background
- Gray page background

---

## 🔍 How It Works

### XSL Transformation Process:

1. **Browser/Processor reads XML**
   ```xml
   <?xml-stylesheet type="text/xsl" href="style.xsl"?>
   ```

2. **Loads XSL stylesheet** (`style.xsl`)

3. **XSL processor executes transformation:**
   - Matches root: `<xsl:template match="/">`
   - Loops through instruments: `<xsl:for-each select="instruments/instrument">`
   - Extracts values: `<xsl:value-of select="name"/>`

4. **Generates HTML output**

5. **Browser renders HTML**

### PHP Processing:

1. **PHP loads XML:**
   ```php
   $xml = simplexml_load_file("instruments.xml");
   ```

2. **Iterates through elements:**
   ```php
   foreach ($xml->instrument as $inst) {
       echo $inst->name;
   }
   ```

3. **Generates HTML dynamically**

4. **Browser renders result**

---

## 🎨 Customization

### Add More Instruments:

Edit `instruments.xml`:
```xml
<instrument>
  <name>Violin</name>
  <type>String</type>
</instrument>
```

### Change Styling:

Edit `style.xsl`:
```xml
<body style="font-family: Arial; background-color: #your-color;">
```

### Add More Fields:

1. Update XML:
   ```xml
   <instrument>
     <name>Guitar</name>
     <type>String</type>
     <price>299.99</price>
   </instrument>
   ```

2. Update XSD schema

3. Update XSL:
   ```xml
   <td><xsl:value-of select="price"/></td>
   ```

4. Update PHP:
   ```php
   echo $inst->price;
   ```

---

## 🛠️ Advanced Features

### Add Sorting (XSL):
```xml
<xsl:for-each select="instruments/instrument">
  <xsl:sort select="name"/>
  <!-- ... -->
</xsl:for-each>
```

### Add Filtering (XSL):
```xml
<xsl:for-each select="instruments/instrument[type='String']">
  <!-- Only show String instruments -->
</xsl:for-each>
```

### Add Conditional Formatting (XSL):
```xml
<xsl:choose>
  <xsl:when test="type='String'">
    <td bgcolor="lightgreen"><xsl:value-of select="type"/></td>
  </xsl:when>
  <xsl:otherwise>
    <td><xsl:value-of select="type"/></td>
  </xsl:otherwise>
</xsl:choose>
```

---

## 🔧 Troubleshooting

### "Cross-origin request blocked" (CORS Error)

**Solution 1: Use a local server**
```bash
python3 -m http.server 8000
# or
php -S localhost:8000
```

**Solution 2: Firefox allows local XSL**
- Firefox is more permissive with local files
- Try opening XML file in Firefox

**Solution 3: Chrome with disabled security (not recommended)**
```bash
# macOS
open -a "Google Chrome" --args --allow-file-access-from-files

# Linux
google-chrome --allow-file-access-from-files
```

### PHP "Cannot load file" error

**Check file path:**
```php
$xml = simplexml_load_file("instruments.xml") or die("Error: Cannot load file");
```

**Verify file exists:**
```bash
ls -la ex7-xml-xsl/instruments.xml
```

**Use absolute path:**
```php
$xml = simplexml_load_file(__DIR__ . "/instruments.xml");
```

### XSL not applying

**Check XML has stylesheet declaration:**
```xml
<?xml-stylesheet type="text/xsl" href="style.xsl"?>
```

**Verify XSL file exists in same directory**

---

## 📚 Key XML/XSL Concepts

### XPath Expressions:
- `instruments/instrument` - Select all instrument elements
- `name` - Select name element relative to current node
- `//name` - Select all name elements anywhere
- `instrument[type='String']` - Filter by condition

### XSL Elements:
- `<xsl:template match="/">` - Root template
- `<xsl:for-each>` - Loop through elements
- `<xsl:value-of>` - Extract text value
- `<xsl:sort>` - Sort elements
- `<xsl:if>` - Conditional inclusion
- `<xsl:choose>` - Multi-way branching

### PHP SimpleXML:
- `simplexml_load_file()` - Load XML from file
- `simplexml_load_string()` - Load XML from string
- `->element` - Access child element
- `->attribute` - Access attribute

---

## ✅ Success Checklist

- [ ] XML file created with valid structure
- [ ] XSD schema created for validation
- [ ] XSL stylesheet transforms XML to HTML
- [ ] PHP file parses and displays XML
- [ ] XML validates against XSD schema
- [ ] Can view formatted output in browser
- [ ] Table displays all instruments correctly
- [ ] Styling applied (colors, fonts, alignment)

---

## 🎓 Learning Outcomes

After completing this exercise, you should understand:
- XML structure and syntax
- XML Schema (XSD) validation
- XSLT transformations
- XPath expressions
- PHP XML parsing with SimpleXML
- Separation of data (XML) and presentation (XSL)

---

## 🔗 Resources

- **XML Tutorial:** https://www.w3schools.com/xml/
- **XSL/XSLT:** https://www.w3schools.com/xml/xsl_intro.asp
- **XML Schema:** https://www.w3schools.com/xml/schema_intro.asp
- **PHP SimpleXML:** https://www.php.net/manual/en/book.simplexml.php
