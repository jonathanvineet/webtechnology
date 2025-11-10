# Exercise 6a & 6b - PHP Version with Apache

## 🎯 Changes from Java Servlets to PHP

### Technology Stack:
- ✅ **Language:** Java Servlets → PHP
- ✅ **Server:** Apache Tomcat → Apache HTTP Server
- ✅ **Database:** MySQL (same)
- ✅ **Architecture:** Three-Tier (same)

---

## 📁 Project Structure

### Exercise 6a (Add Records):
```
ex6a-php/
├── index.php          (Landing page)
├── index.html         (Registration form)
├── add_instrument.php (Process form & insert to DB)
└── musicdb.sql        (Database script)
```

### Exercise 6b (View Records):
```
ex6b-php/
├── index.html            (Landing page)
└── view_instruments.php  (Retrieve & display data)
```

---

## 🚀 Quick Setup

### Option 1: Automated Setup Script
```bash
chmod +x setup-php-exercises.sh
sh setup-php-exercises.sh
```

### Option 2: Manual Setup

#### 1. Install Requirements (if not installed):
```bash
# PHP (if needed)
brew install php

# MySQL (if not installed)
brew install mysql
brew services start mysql

# Apache is pre-installed on macOS
```

#### 2. Create Database:
```bash
mysql -uroot < ex6a-php/musicdb.sql
```

#### 3. Start PHP Built-in Server (easiest):
```bash
cd /Users/vine/elco/College/wt/programs
php -S localhost:8000
```

#### 4. Access Applications:
- **Ex 6a:** http://localhost:8000/ex6a-php/index.php
- **Ex 6b:** http://localhost:8000/ex6b-php/view_instruments.php

---

## 🌐 Using Apache HTTP Server (Alternative)

### 1. Copy to Apache Document Root:
```bash
sudo cp -r ex6a-php /Library/WebServer/Documents/
sudo cp -r ex6b-php /Library/WebServer/Documents/
```

### 2. Start Apache:
```bash
sudo apachectl start
```

### 3. Access Applications:
- **Ex 6a:** http://localhost/ex6a-php/index.php
- **Ex 6b:** http://localhost/ex6b-php/view_instruments.php

### 4. Stop Apache:
```bash
sudo apachectl stop
```

---

## 🧪 Testing

### 1. Add Instruments (Exercise 6a):
```
http://localhost:8000/ex6a-php/index.php
```
- Click "Add New Instrument"
- Fill form: Guitar, guitar@music.com, String
- Submit
- See success message

### 2. View Instruments (Exercise 6b):
```
http://localhost:8000/ex6b-php/view_instruments.php
```
- See table with all registered instruments
- Data is pulled from MySQL database

### 3. Verify in Database:
```bash
mysql -uroot musicdb -e "SELECT * FROM instruments;"
```

---

## 🔍 Code Comparison

### Java Servlet vs PHP:

**Java (Exercise 6a):**
```java
String name = req.getParameter("name");
PreparedStatement ps = con.prepareStatement(
    "INSERT INTO instruments(name, email, type) VALUES(?,?,?)");
ps.setString(1, name);
ps.executeUpdate();
```

**PHP (Exercise 6a):**
```php
$name = $_POST['name'];
$stmt = $conn->prepare("INSERT INTO instruments (name, email, type) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $email, $type);
$stmt->execute();
```

---

## 📊 Key Differences

| Aspect | Java Servlets | PHP |
|--------|--------------|-----|
| **File Extension** | `.java` → `.class` | `.php` |
| **Compilation** | Required | Not required |
| **Server** | Tomcat | Apache / PHP built-in |
| **Deployment** | WAR/Copy to webapps | Copy to document root |
| **Configuration** | web.xml | None needed |
| **Database Driver** | JDBC JAR file | MySQLi (built-in) |
| **Form Data** | `req.getParameter()` | `$_POST[]` |
| **Output** | `out.println()` | `echo` |

---

## 🛠️ Troubleshooting

### "Connection failed" error:
```bash
# Check MySQL is running
brew services list | grep mysql

# Start MySQL
brew services start mysql
```

### "Call to undefined function mysqli_connect":
```bash
# Check PHP MySQL extension
php -m | grep mysqli

# If not installed, enable in php.ini:
# extension=mysqli
```

### Port 8000 already in use:
```bash
# Use different port
php -S localhost:8080

# Or find and kill process using port 8000
lsof -ti:8000 | xargs kill -9
```

### Apache not starting:
```bash
# Check status
sudo apachectl status

# View error log
tail -f /var/log/apache2/error_log
```

---

## ✅ Advantages of PHP Version

1. **Simpler Deployment** - No compilation needed
2. **Built-in Server** - No need for Tomcat
3. **Faster Development** - Edit and refresh
4. **Less Code** - More concise syntax
5. **Native MySQL Support** - MySQLi built-in

---

## 📝 Files Created

### Exercise 6a:
- `index.php` - Landing page
- `index.html` - Registration form
- `add_instrument.php` - Insert logic
- `musicdb.sql` - Database script

### Exercise 6b:
- `index.html` - Landing page with link
- `view_instruments.php` - Display all records

### Setup:
- `setup-php-exercises.sh` - Automated setup script
- `README_PHP.md` - This documentation

---

## 🔗 Quick Commands

**Start PHP Server:**
```bash
php -S localhost:8000
```

**Start Apache:**
```bash
sudo apachectl start
```

**Stop Apache:**
```bash
sudo apachectl stop
```

**Check MySQL:**
```bash
mysql -uroot musicdb -e "SELECT * FROM instruments;"
```

**Add Test Data:**
```bash
mysql -uroot musicdb -e "INSERT INTO instruments (name, email, type) VALUES 
('Piano', 'piano@music.com', 'Keyboard'),
('Drums', 'drums@music.com', 'Percussion');"
```

---

## 🎯 Both Versions Work!

You now have **both** Java Servlet and PHP versions:

**Java + Tomcat:**
- `ex6a-database-app/` - Java Servlet version
- `ex6b-view-app/` - Java Servlet version

**PHP + Apache:**
- `ex6a-php/` - PHP version
- `ex6b-php/` - PHP version

Choose whichever you prefer! 🚀
