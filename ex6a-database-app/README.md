# Exercise 6a: Adding Records to Database (Three-Tier Application)

## 🎯 Aim
To create a simple web form that allows users to add data into a MySQL database using Java Servlets (three-tier structure).

## 📁 Project Structure
```
ex6a-database-app/
├── index.html                 (HTML form - Presentation Tier)
├── musicdb.sql               (Database script)
├── README.md                 (This file)
└── WEB-INF/
    ├── web.xml              (Servlet configuration)
    ├── lib/
    │   └── mysql-connector-j-8.x.x.jar  (MySQL JDBC Driver - place here)
    └── classes/
        ├── AddInstrument.java           (Servlet - Business Logic Tier)
        └── AddInstrument.class          (Compiled - will be generated)
```

## 🏗️ Three-Tier Architecture

### 1. **Presentation Tier** (Client)
- `index.html` - Web form interface
- Collects user input for instrument registration

### 2. **Business Logic Tier** (Application Server)
- `AddInstrument.java` - Servlet processing
- Validates and processes data
- Communicates with database

### 3. **Data Tier** (Database Server)
- MySQL Database (`musicdb`)
- Stores instrument records

## 📋 Prerequisites

### 1. MySQL Database
- MySQL Server installed and running
- Default port: 3306

### 2. MySQL JDBC Driver
- Download `mysql-connector-j-8.x.x.jar`
- From: https://dev.mysql.com/downloads/connector/j/

### 3. Apache Tomcat
- Tomcat installed (see `EX5A_SETUP_GUIDE.md`)

### 4. Java JDK
- Java 8 or higher

---

## 🚀 Setup Instructions

### Step 1: Install and Start MySQL

**macOS (using Homebrew):**
```bash
# Install MySQL
brew install mysql

# Start MySQL service
brew services start mysql

# Secure installation (optional but recommended)
mysql_secure_installation
```

**macOS (Manual Download):**
1. Download from: https://dev.mysql.com/downloads/mysql/
2. Install the DMG package
3. Start MySQL from System Preferences

**Linux:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql

# CentOS/RHEL
sudo yum install mysql-server
sudo systemctl start mysqld
```

**Windows:**
1. Download MySQL Installer from: https://dev.mysql.com/downloads/installer/
2. Run installer and follow wizard
3. Start MySQL service from Services

---

### Step 2: Create Database and Table

**Connect to MySQL:**
```bash
# Default (no password)
mysql -u root

# With password
mysql -u root -p
```

**Run the SQL script:**
```sql
CREATE DATABASE musicdb;
USE musicdb;

CREATE TABLE instruments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(100),
  type VARCHAR(50)
);
```

**Verify table creation:**
```sql
SHOW TABLES;
DESCRIBE instruments;
```

**Exit MySQL:**
```sql
EXIT;
```

**Alternative - Run SQL file directly:**
```bash
mysql -u root -p < musicdb.sql
```

---

### Step 3: Download MySQL JDBC Driver

**Option 1 - Direct Download:**
1. Visit: https://dev.mysql.com/downloads/connector/j/
2. Select "Platform Independent"
3. Download the ZIP/TAR file
4. Extract and find `mysql-connector-j-8.x.x.jar`
5. Copy to `ex6a-database-app/WEB-INF/lib/`

**Option 2 - Using wget/curl (macOS/Linux):**
```bash
cd ex6a-database-app/WEB-INF/lib/

# Download (replace version if needed)
wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar

# Or using curl
curl -O https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar
```

**Verify the JAR file:**
```bash
ls -lh WEB-INF/lib/
```

---

### Step 4: Update Database Credentials

Edit `AddInstrument.java` and update the connection string:

```java
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/musicdb", 
    "root",      // Your MySQL username
    "password"   // Your MySQL password (or "" if no password)
);
```

**Common MySQL credentials:**
- **Default username:** `root`
- **Default password:** (empty string `""`) or set during installation

---

### Step 5: Compile the Servlet

Navigate to classes directory:
```bash
cd ex6a-database-app/WEB-INF/classes
```

**Compile with both servlet-api.jar and MySQL driver:**

**Windows:**
```cmd
javac -cp "C:\tomcat\lib\servlet-api.jar;..\lib\mysql-connector-j-8.0.33.jar" AddInstrument.java
```

**macOS/Linux:**
```bash
javac -cp "/opt/tomcat/lib/servlet-api.jar:../lib/mysql-connector-j-8.0.33.jar" AddInstrument.java
```

**Note:** Use `;` on Windows and `:` on macOS/Linux for classpath separator.

---

### Step 6: Deploy to Tomcat

**Windows:**
```cmd
xcopy ex6a-database-app C:\tomcat\webapps\ex6a-database-app\ /E /I
```

**macOS/Linux:**
```bash
cp -r ex6a-database-app /opt/tomcat/webapps/
```

---

### Step 7: Start Tomcat

**Windows:**
```cmd
cd C:\tomcat\bin
startup.bat
```

**macOS/Linux:**
```bash
cd /opt/tomcat/bin
./startup.sh
```

---

### Step 8: Access the Application

Open your browser:
```
http://localhost:8080/ex6a-database-app/index.html
```

---

## 🧪 Testing the Application

### 1. Add a Record:
- Open the form in your browser
- Fill in the details:
  - **Instrument Name:** Guitar
  - **Email:** guitar@music.com
  - **Type:** String
- Click "Register"
- Should see: "Instrument Added Successfully!"

### 2. Verify in Database:
```bash
mysql -u root -p
```

```sql
USE musicdb;
SELECT * FROM instruments;
```

Expected output:
```
+----+--------+------------------+--------+
| id | name   | email            | type   |
+----+--------+------------------+--------+
|  1 | Guitar | guitar@music.com | String |
+----+--------+------------------+--------+
```

### 3. Add More Records:
Test with different instrument types:
- **Piano** (Keyboard)
- **Flute** (Wind)
- **Drums** (Percussion)

---

## 🔍 How It Works

### Request Flow:
```
1. User fills form in index.html
   ↓
2. Browser sends POST to /AddInstrument
   ↓
3. Servlet receives parameters
   ↓
4. Servlet connects to MySQL
   ↓
5. PreparedStatement inserts data
   ↓
6. Database stores record
   ↓
7. Servlet sends success/error response
   ↓
8. User sees confirmation
```

### Key JDBC Concepts:

**1. Load Driver:**
```java
Class.forName("com.mysql.cj.jdbc.Driver");
```

**2. Establish Connection:**
```java
Connection con = DriverManager.getConnection(url, user, password);
```

**3. Create PreparedStatement:**
```java
PreparedStatement ps = con.prepareStatement(
    "INSERT INTO instruments(name, email, type) VALUES(?,?,?)"
);
```

**4. Set Parameters:**
```java
ps.setString(1, name);   // First ?
ps.setString(2, email);  // Second ?
ps.setString(3, type);   // Third ?
```

**5. Execute Query:**
```java
ps.executeUpdate();  // For INSERT, UPDATE, DELETE
```

**6. Close Connection:**
```java
con.close();
```

---

## 🔧 Troubleshooting

### Error: "ClassNotFoundException: com.mysql.cj.jdbc.Driver"
**Solution:**
- Verify MySQL JAR is in `WEB-INF/lib/`
- Restart Tomcat after adding JAR

### Error: "Access denied for user 'root'@'localhost'"
**Solution:**
- Check MySQL username and password in servlet
- Reset MySQL root password if needed:
  ```bash
  mysql -u root
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
  FLUSH PRIVILEGES;
  ```

### Error: "Unknown database 'musicdb'"
**Solution:**
- Create database using SQL script
- Verify: `mysql -u root -p -e "SHOW DATABASES;"`

### Error: "Communications link failure"
**Solution:**
- Check MySQL is running:
  ```bash
  # macOS
  brew services list | grep mysql
  
  # Linux
  sudo systemctl status mysql
  ```
- Verify port 3306 is open
- Check firewall settings

### Error: "Table 'instruments' doesn't exist"
**Solution:**
- Run the CREATE TABLE statement
- Verify: `mysql -u root -p -e "USE musicdb; SHOW TABLES;"`

### Data Not Inserting (No Error)
**Solution:**
- Check Tomcat logs: `tail -f /opt/tomcat/logs/catalina.out`
- Verify servlet mapping in web.xml
- Check form action matches servlet URL pattern

---

## 📊 Database Commands Reference

### View all records:
```sql
SELECT * FROM instruments;
```

### View specific type:
```sql
SELECT * FROM instruments WHERE type = 'String';
```

### Count records:
```sql
SELECT COUNT(*) FROM instruments;
```

### Delete a record:
```sql
DELETE FROM instruments WHERE id = 1;
```

### Clear all records:
```sql
TRUNCATE TABLE instruments;
```

### Drop database:
```sql
DROP DATABASE musicdb;
```

---

## 🛑 Stop Services

### Stop Tomcat:
**Windows:**
```cmd
cd C:\tomcat\bin
shutdown.bat
```

**macOS/Linux:**
```bash
cd /opt/tomcat/bin
./shutdown.sh
```

### Stop MySQL:
**macOS:**
```bash
brew services stop mysql
```

**Linux:**
```bash
sudo systemctl stop mysql
```

**Windows:**
- Stop MySQL service from Services panel

---

## 💡 Security Best Practices

### 1. Don't Hardcode Credentials
Instead of hardcoding in servlet, use:
- Environment variables
- Configuration files
- JNDI DataSource

### 2. Use Prepared Statements
- Already implemented ✓
- Prevents SQL injection

### 3. Validate Input
- Add server-side validation
- Sanitize user input

### 4. Use Connection Pooling
For production, use connection pooling (e.g., HikariCP, Apache DBCP)

---

## ✅ Success Checklist

- [ ] MySQL installed and running
- [ ] Database `musicdb` created
- [ ] Table `instruments` created
- [ ] MySQL JDBC driver in `WEB-INF/lib/`
- [ ] Servlet credentials updated
- [ ] Servlet compiled successfully
- [ ] Application deployed to Tomcat
- [ ] Tomcat started
- [ ] Form accessible at `http://localhost:8080/ex6a-database-app/`
- [ ] Record inserted successfully
- [ ] Data visible in MySQL database

---

## 📚 Next Steps

After mastering this exercise, try:
- **Exercise 6b:** Retrieving records from database
- **Exercise 6c:** Updating records
- **Exercise 6d:** Deleting records
- Build a complete CRUD application

---

## 🔗 Useful Links

- MySQL Connector/J: https://dev.mysql.com/downloads/connector/j/
- MySQL Documentation: https://dev.mysql.com/doc/
- JDBC Tutorial: https://docs.oracle.com/javase/tutorial/jdbc/
- Tomcat Setup Guide: See `EX5A_SETUP_GUIDE.md`
