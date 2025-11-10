# Exercise 6b: Displaying Records from Database

## 🎯 Aim
To retrieve and display data stored in a MySQL database using a Servlet in a three-tier web application.

## 📁 Project Structure
```
ex6b-view-app/
├── view.html                  (HTML page with link)
├── README.md                  (This file)
└── WEB-INF/
    ├── web.xml               (Servlet configuration)
    ├── lib/
    │   └── mysql-connector-j-8.x.x.jar  (MySQL JDBC Driver)
    └── classes/
        ├── ViewInstruments.java         (Servlet - retrieves data)
        └── ViewInstruments.class        (Compiled - will be generated)
```

## 🏗️ Three-Tier Architecture

### 1. **Presentation Tier** (Client)
- `view.html` - Simple page with link to view data
- Servlet generates HTML table dynamically

### 2. **Business Logic Tier** (Application Server)
- `ViewInstruments.java` - Servlet processing
- Retrieves data from database
- Formats data as HTML table

### 3. **Data Tier** (Database Server)
- MySQL Database (`musicdb`)
- Reads from `instruments` table

## 📋 Prerequisites

**Same as Exercise 6a:**
- MySQL Server running
- Database `musicdb` with table `instruments`
- Apache Tomcat installed
- Java JDK installed

## 🚀 Quick Setup

### Option 1: Use the Setup Script

```bash
sh setup-ex6b.sh
```

### Option 2: Manual Setup

#### Step 1: Copy MySQL JDBC Driver
```bash
cp ex6a-database-app/WEB-INF/lib/mysql-connector-j-*.jar ex6b-view-app/WEB-INF/lib/
```

#### Step 2: Compile the Servlet
```bash
cd ex6b-view-app/WEB-INF/classes

# macOS/Linux
javac -cp "/opt/homebrew/opt/tomcat/libexec/lib/jakarta.servlet-api.jar:../lib/mysql-connector-j-8.0.33.jar" ViewInstruments.java

# Or if using servlet-api.jar
javac -cp "/opt/homebrew/opt/tomcat/libexec/lib/servlet-api.jar:../lib/mysql-connector-j-8.0.33.jar" ViewInstruments.java
```

#### Step 3: Deploy to Tomcat
```bash
cd ../../..
cp -r ex6b-view-app /opt/homebrew/opt/tomcat/libexec/webapps/
```

#### Step 4: Restart Tomcat
```bash
pkill -9 java
sleep 2
/opt/homebrew/opt/tomcat/libexec/bin/catalina.sh start
```

#### Step 5: Access Application
```
http://localhost:8080/ex6b-view-app/view.html
```

---

## 🧪 Testing the Application

### 1. Add Some Test Data First (using Exercise 6a):
```bash
# Open Exercise 6a in browser
open http://localhost:8080/ex6a-database-app/index.html
```

Add some instruments:
- Guitar, guitar@music.com, String
- Piano, piano@music.com, Keyboard
- Drums, drums@music.com, Percussion

### 2. View the Data (Exercise 6b):
```bash
# Open Exercise 6b in browser
open http://localhost:8080/ex6b-view-app/view.html
```

Click "Click here to View All Instruments"

### 3. Expected Output:
You should see a table like:

```
Registered Instruments

+----+--------+------------------+-------------+
| ID | Name   | Email            | Type        |
+----+--------+------------------+-------------+
|  1 | Guitar | guitar@music.com | String      |
|  2 | Piano  | piano@music.com  | Keyboard    |
|  3 | Drums  | drums@music.com  | Percussion  |
+----+--------+------------------+-------------+
```

---

## 🔍 How It Works

### Request Flow:
```
1. User opens view.html
   ↓
2. User clicks "View All Instruments" link
   ↓
3. Browser sends GET request to /ViewInstruments
   ↓
4. Servlet connects to MySQL
   ↓
5. Execute SELECT query
   ↓
6. ResultSet contains all records
   ↓
7. Loop through ResultSet
   ↓
8. Generate HTML table rows dynamically
   ↓
9. Send HTML response to browser
   ↓
10. User sees table with all instruments
```

### Key JDBC Concepts:

**1. Create Statement:**
```java
Statement stmt = con.createStatement();
```

**2. Execute Query:**
```java
ResultSet rs = stmt.executeQuery("SELECT * FROM instruments");
```

**3. Loop Through Results:**
```java
while (rs.next()) {
    int id = rs.getInt("id");
    String name = rs.getString("name");
    // ...
}
```

**4. Get Column Values:**
```java
rs.getInt("column_name")      // For INT columns
rs.getString("column_name")   // For VARCHAR columns
rs.getDate("column_name")     // For DATE columns
```

---

## 🔄 Combined Workflow (6a + 6b)

### Complete CRUD Operations:

1. **Add Data (Exercise 6a):**
   - http://localhost:8080/ex6a-database-app/index.html
   - Fill form and submit

2. **View Data (Exercise 6b):**
   - http://localhost:8080/ex6b-view-app/view.html
   - Click link to see all records

3. **Verify in Database:**
   ```bash
   mysql -uroot musicdb -e "SELECT * FROM instruments;"
   ```

---

## 📊 Database Commands

### View all records:
```sql
mysql -uroot musicdb -e "SELECT * FROM instruments;"
```

### Count records:
```sql
mysql -uroot musicdb -e "SELECT COUNT(*) FROM instruments;"
```

### Add test data:
```sql
mysql -uroot musicdb -e "INSERT INTO instruments (name, email, type) VALUES 
('Violin', 'violin@music.com', 'String'),
('Flute', 'flute@music.com', 'Wind'),
('Saxophone', 'sax@music.com', 'Wind');"
```

---

## 🔧 Troubleshooting

### "No records found" or empty table
**Check if data exists:**
```bash
mysql -uroot musicdb -e "SELECT * FROM instruments;"
```

**Add test data:**
```bash
mysql -uroot musicdb -e "INSERT INTO instruments (name, email, type) 
VALUES ('Test Guitar', 'test@test.com', 'String');"
```

### "Error: null" or connection error
**Solutions:**
- Verify MySQL is running: `brew services list | grep mysql`
- Check database exists: `mysql -uroot -e "SHOW DATABASES;" | grep musicdb`
- Verify password in servlet (should be empty string `""`)

### Table not displaying properly
**Check browser console for errors**
- Right-click → Inspect → Console tab

**View servlet logs:**
```bash
tail -f /opt/homebrew/opt/tomcat/libexec/logs/catalina.out
```

---

## 💡 Enhancements

### Add CSS Styling:
Create a `style.css` file and link it in the servlet output:

```java
out.println("<html><head>");
out.println("<style>");
out.println("table { border-collapse: collapse; width: 80%; margin: 20px auto; }");
out.println("th { background-color: #4CAF50; color: white; padding: 10px; }");
out.println("td { padding: 8px; text-align: left; }");
out.println("tr:nth-child(even) { background-color: #f2f2f2; }");
out.println("</style></head><body>");
```

### Add Search/Filter:
Modify the servlet to accept query parameters for filtering.

### Add Pagination:
Limit results per page using `LIMIT` and `OFFSET` in SQL.

---

## 🔗 Related Exercises

- **Exercise 6a:** Adding records to database
- **Exercise 6c:** Updating records (coming next)
- **Exercise 6d:** Deleting records (coming next)

---

## ✅ Success Checklist

- [ ] MySQL running
- [ ] Database `musicdb` exists with data
- [ ] MySQL JDBC driver in `WEB-INF/lib/`
- [ ] Servlet compiled successfully
- [ ] Application deployed to Tomcat
- [ ] Tomcat running
- [ ] Can access `http://localhost:8080/ex6b-view-app/view.html`
- [ ] Clicking link shows table with records
- [ ] Table displays all instruments from database

---

## 🎯 Key Differences: Statement vs PreparedStatement

| Feature | Statement (Ex 6b) | PreparedStatement (Ex 6a) |
|---------|------------------|--------------------------|
| **Usage** | Simple queries | Parameterized queries |
| **SQL Injection** | Vulnerable | Protected |
| **Performance** | Slower for repeated queries | Faster (pre-compiled) |
| **Use Case** | SELECT without parameters | INSERT/UPDATE with user input |

**Example from Exercise 6a (INSERT with PreparedStatement):**
```java
PreparedStatement ps = con.prepareStatement(
    "INSERT INTO instruments(name, email, type) VALUES(?,?,?)");
ps.setString(1, name);
```

**Example from Exercise 6b (SELECT with Statement):**
```java
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM instruments");
```
