# Exercise 6a - Quick Setup (macOS with Homebrew)

## 🚀 Quick Start (5 Steps)

### 1. Install Tomcat
```bash
brew install tomcat
```

### 2. Start Tomcat
```bash
brew services start tomcat
```

### 3. Run Setup Script
```bash
sh setup-ex6a.sh
```
**When prompted for MySQL password:** Just press **Enter** (no password)

**When prompted for Tomcat path:** The script should auto-detect it now, but if not, use:
```
/opt/homebrew/opt/tomcat/libexec
```

### 4. Access Application
Open browser:
```
http://localhost:8080/ex6a-database-app/index.html
```

### 5. Test
- Fill in instrument details
- Click "Register"
- Check database:
```bash
mysql -uroot musicdb -e "SELECT * FROM instruments;"
```

---

## 📍 Common Tomcat Locations (Homebrew)

- **M1/M2/M3 Mac:** `/opt/homebrew/opt/tomcat/libexec`
- **Intel Mac:** `/usr/local/opt/tomcat/libexec`

---

## 🔍 Verify Tomcat Installation

```bash
brew --prefix tomcat
```

This shows where Tomcat is installed. Add `/libexec` to get the path.

---

## 🛠️ Manual Compilation (If Script Fails)

### 1. Navigate to classes directory:
```bash
cd ex6a-database-app/WEB-INF/classes
```

### 2. Compile:
```bash
javac -cp "/opt/homebrew/opt/tomcat/libexec/lib/servlet-api.jar:../lib/mysql-connector-j-8.0.33.jar" AddInstrument.java
```

### 3. Deploy:
```bash
cd ../../..
cp -r ex6a-database-app /opt/homebrew/opt/tomcat/libexec/webapps/
```

### 4. Restart Tomcat:
```bash
brew services restart tomcat
```

---

## 📊 Useful Commands

### Check if Tomcat is running:
```bash
brew services list | grep tomcat
```

### Check if MySQL is running:
```bash
brew services list | grep mysql
```

### View Tomcat logs:
```bash
tail -f /opt/homebrew/opt/tomcat/libexec/logs/catalina.out
```

### Test Tomcat:
```bash
curl http://localhost:8080
```

### Connect to MySQL:
```bash
mysql -uroot
```

### View database tables:
```sql
USE musicdb;
SHOW TABLES;
SELECT * FROM instruments;
```

---

## 🐛 Troubleshooting

### "Tomcat not found"
```bash
# Install Tomcat
brew install tomcat

# Find installation path
brew --prefix tomcat
```

### "Port 8080 already in use"
```bash
# Find what's using port 8080
lsof -i :8080

# Kill the process or change Tomcat port
```

### "MySQL connection failed"
```bash
# Start MySQL
brew services start mysql

# Test connection
mysql -uroot
```

### "servlet-api.jar not found"
```bash
# Verify Tomcat installation
ls -la /opt/homebrew/opt/tomcat/libexec/lib/servlet-api.jar
```

---

## ✅ Complete Setup Checklist

- [ ] MySQL installed: `brew install mysql`
- [ ] MySQL running: `brew services start mysql`
- [ ] Database created: `mysql -uroot < ex6a-database-app/musicdb.sql`
- [ ] Tomcat installed: `brew install tomcat`
- [ ] Tomcat running: `brew services start tomcat`
- [ ] MySQL JDBC driver downloaded (auto by script)
- [ ] Servlet compiled
- [ ] Application deployed
- [ ] Can access: http://localhost:8080/ex6a-database-app/index.html

---

## 🎯 Expected Results

**After form submission:**
```
Instrument Added Successfully!
```

**Database check:**
```bash
mysql -uroot musicdb -e "SELECT * FROM instruments;"
```

**Output:**
```
+----+--------+------------------+--------+
| id | name   | email            | type   |
+----+--------+------------------+--------+
|  1 | Guitar | guitar@music.com | String |
+----+--------+------------------+--------+
```
