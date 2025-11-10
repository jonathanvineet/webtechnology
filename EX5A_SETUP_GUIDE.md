# Exercise 5a: Servlet Setup Guide (OS-Independent)

This guide works for **Windows**, **macOS**, and **Linux** without requiring Homebrew or any package manager.

---

## 📋 Prerequisites

1. **Java JDK** installed (Java 8 or higher)
2. **Apache Tomcat** downloaded and extracted

---

## 🔽 Step 1: Download and Setup Tomcat (If Not Already Installed)

### Download Tomcat:
1. Visit: https://tomcat.apache.org/download-11.cgi
2. Download the appropriate version:
   - **Windows**: Download `.zip` file (e.g., `apache-tomcat-11.x.x-windows-x64.zip`)
   - **macOS/Linux**: Download `.tar.gz` file (e.g., `apache-tomcat-11.x.x.tar.gz`)

### Extract Tomcat:

**Windows:**
```cmd
# Extract to C:\tomcat (or any location you prefer)
# Right-click the zip file → Extract All → Choose destination
```

**macOS/Linux:**
```bash
# Extract to your home directory or /opt
tar -xzf apache-tomcat-11.x.x.tar.gz
# Move to a convenient location (optional)
sudo mv apache-tomcat-11.x.x /opt/tomcat
```

### Set Execute Permissions (macOS/Linux only):
```bash
chmod +x /opt/tomcat/bin/*.sh
```

---

## 📁 Project Structure

```
ex5a-tomcat-app/
├── ex5a.html
└── WEB-INF/
    ├── web.xml
    └── classes/
        └── ex5a.java
```

---

## 🛠️ Step 2: Compile the Servlet

### Navigate to the classes directory:

**Windows:**
```cmd
cd ex5a-tomcat-app\WEB-INF\classes
```

**macOS/Linux:**
```bash
cd ex5a-tomcat-app/WEB-INF/classes
```

### Compile the servlet:

**Windows (adjust Tomcat path as needed):**
```cmd
javac -cp "C:\tomcat\lib\servlet-api.jar" ex5a.java
```

**macOS/Linux:**
```bash
javac -cp "/opt/tomcat/lib/servlet-api.jar" ex5a.java
```

**Alternative - If Tomcat is in a different location:**
```bash
# Find your Tomcat installation first
# Replace /path/to/tomcat with your actual Tomcat directory
javac -cp "/path/to/tomcat/lib/servlet-api.jar" ex5a.java
```

### Verify compilation:
Check that `ex5a.class` file is created in the same directory.

**Windows:**
```cmd
dir
```

**macOS/Linux:**
```bash
ls -la
```

---

## 🚀 Step 3: Deploy to Tomcat

### Copy the application to Tomcat's webapps directory:

**Windows:**
```cmd
# From the programs directory
xcopy ex5a-tomcat-app C:\tomcat\webapps\ex5a-tomcat-app\ /E /I
```

**macOS/Linux:**
```bash
# From the programs directory
cp -r ex5a-tomcat-app /opt/tomcat/webapps/
```

---

## ▶️ Step 4: Start Tomcat

### Windows:
```cmd
# Navigate to Tomcat bin directory
cd C:\tomcat\bin

# Start Tomcat
startup.bat
```

A command window will open showing Tomcat logs.

### macOS/Linux:
```bash
# Navigate to Tomcat bin directory
cd /opt/tomcat/bin

# Start Tomcat
./startup.sh
```

### Check if Tomcat is running:
**Windows:**
```cmd
curl http://localhost:8080
```

**macOS/Linux:**
```bash
curl -I http://localhost:8080
```

You should see an HTTP 200 response or the Tomcat welcome page.

---

## 🌐 Step 5: Access the Application

Open your web browser and navigate to:
```
http://localhost:8080/ex5a-tomcat-app/ex5a.html
```

---

## 🧪 Step 6: Test the Application

1. Enter a musician name (e.g., "John Doe")
2. Enter an instrument (e.g., "Guitar")
3. Click the **Submit** button
4. You should see a response page displaying your input

---

## 🛑 Stopping Tomcat

### Windows:
```cmd
cd C:\tomcat\bin
shutdown.bat
```

### macOS/Linux:
```bash
cd /opt/tomcat/bin
./shutdown.sh
```

---

## 🔍 Troubleshooting

### Issue: "Port 8080 already in use"

**Find what's using port 8080:**

**Windows:**
```cmd
netstat -ano | findstr :8080
```

**macOS/Linux:**
```bash
lsof -i :8080
```

**Solution:** Either stop the conflicting process or change Tomcat's port in `conf/server.xml`.

### Issue: "Cannot find servlet-api.jar"

**Verify the path exists:**

**Windows:**
```cmd
dir C:\tomcat\lib\servlet-api.jar
```

**macOS/Linux:**
```bash
ls -la /opt/tomcat/lib/servlet-api.jar
```

**Solution:** Update the compile command with the correct path to your Tomcat installation.

### Issue: "404 Not Found"

**Check if app is deployed:**

**Windows:**
```cmd
dir C:\tomcat\webapps\ex5a-tomcat-app
```

**macOS/Linux:**
```bash
ls -la /opt/tomcat/webapps/ex5a-tomcat-app
```

**Solution:** Make sure the app folder is correctly copied to webapps and Tomcat has been restarted.

### Issue: "500 Internal Server Error"

**Check Tomcat logs:**

**Windows:**
```cmd
type C:\tomcat\logs\catalina.out
```

**macOS/Linux:**
```bash
tail -f /opt/tomcat/logs/catalina.out
```

**Solution:** Look for Java exceptions or ClassNotFoundException in the logs.

---

## 📝 Quick Reference

### Common Paths:

| OS | Default Tomcat Location | Servlet API Path |
|---|---|---|
| Windows | `C:\tomcat` | `C:\tomcat\lib\servlet-api.jar` |
| macOS | `/opt/tomcat` | `/opt/tomcat/lib/servlet-api.jar` |
| Linux | `/opt/tomcat` or `/usr/local/tomcat` | `/opt/tomcat/lib/servlet-api.jar` |

### Important Files:
- **Application URL:** `http://localhost:8080/ex5a-tomcat-app/ex5a.html`
- **Tomcat Logs:** `<TOMCAT_HOME>/logs/catalina.out`
- **Tomcat Config:** `<TOMCAT_HOME>/conf/server.xml`
- **Webapps Directory:** `<TOMCAT_HOME>/webapps/`

---

## ✅ Summary

1. Download and extract Tomcat
2. Compile servlet with `javac -cp <tomcat>/lib/servlet-api.jar ex5a.java`
3. Copy `ex5a-tomcat-app` folder to `<tomcat>/webapps/`
4. Start Tomcat with `startup.bat` (Windows) or `./startup.sh` (macOS/Linux)
5. Access at `http://localhost:8080/ex5a-tomcat-app/ex5a.html`

---

**Note:** Replace `C:\tomcat` or `/opt/tomcat` with your actual Tomcat installation path throughout this guide.
