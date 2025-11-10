# Exercise 5b: Session Tracking Using Servlets

## 🎯 Aim
To maintain user information across multiple pages using HttpSession in Servlets.

## 📁 Project Structure
```
ex5b-session-app/
├── ex5b.html              (HTML form)
├── README.md              (This file)
└── WEB-INF/
    ├── web.xml           (Servlet configuration)
    └── classes/
        ├── ex5b.java     (Servlet source code)
        └── ex5b.class    (Compiled servlet - will be generated)
```

## 🚀 Quick Setup (OS-Independent)

### Step 1: Compile the Servlet

Navigate to the classes directory:
```bash
cd ex5b-session-app/WEB-INF/classes
```

**Windows:**
```cmd
javac -cp "C:\tomcat\lib\servlet-api.jar" ex5b.java
```

**macOS/Linux:**
```bash
javac -cp "/opt/tomcat/lib/servlet-api.jar" ex5b.java
```

### Step 2: Deploy to Tomcat

**Windows:**
```cmd
xcopy ex5b-session-app C:\tomcat\webapps\ex5b-session-app\ /E /I
```

**macOS/Linux:**
```bash
cp -r ex5b-session-app /opt/tomcat/webapps/
```

### Step 3: Start Tomcat

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

### Step 4: Access the Application

Open your browser:
```
http://localhost:8080/ex5b-session-app/ex5b.html
```

## 🧪 Testing Session Tracking

1. **Start a Session:**
   - Open `http://localhost:8080/ex5b-session-app/ex5b.html`
   - Enter musician name (e.g., "John Doe")
   - Enter instrument (e.g., "Guitar")
   - Click "Start Session"
   - You'll see a welcome message with your data

2. **View Session Data:**
   - Click the "View Session Info" link on the welcome page
   - OR directly visit: `http://localhost:8080/ex5b-session-app/Ex5b`
   - The servlet will retrieve and display session data

3. **Test Session Persistence:**
   - Open a new tab and visit `http://localhost:8080/ex5b-session-app/Ex5b`
   - Session data should still be available (same browser)

4. **Test No Session:**
   - Close all browser tabs/windows
   - Clear cookies or open in incognito mode
   - Visit `http://localhost:8080/ex5b-session-app/Ex5b`
   - Should show "No active session found!"

## 📝 How It Works

### 1. HTML Form (`ex5b.html`)
- Collects musician name and instrument
- Submits data via POST to servlet `/Ex5b`

### 2. Servlet POST Method (`doPost`)
- Receives form data
- Creates/retrieves session using `req.getSession()`
- Stores data in session: `session.setAttribute("key", value)`
- Displays welcome message with link to view session

### 3. Servlet GET Method (`doGet`)
- Retrieves existing session: `req.getSession(false)`
- Gets session attributes: `session.getAttribute("key")`
- Displays stored data or "no session" message

### 4. Session Management
- **Session Creation:** `req.getSession()` creates new or returns existing
- **Session Check:** `req.getSession(false)` returns null if no session exists
- **Store Data:** `session.setAttribute("name", value)`
- **Retrieve Data:** `session.getAttribute("name")`

## 🔍 Key Concepts

### HttpSession Features:
- **Automatic Cookie Management:** Session ID stored in browser cookie
- **Server-Side Storage:** Data stored on server, not client
- **Cross-Request Persistence:** Data available across multiple requests
- **Timeout:** Session expires after inactivity (default ~30 minutes)

### Methods Used:
- `req.getSession()` - Get or create session
- `req.getSession(false)` - Get session, don't create if absent
- `session.setAttribute(key, value)` - Store data
- `session.getAttribute(key)` - Retrieve data
- `session.invalidate()` - Destroy session (not used in this example)

## 🛑 Stop Tomcat

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

## 🔧 Troubleshooting

**Session not persisting:**
- Check browser cookies are enabled
- Verify session timeout in `web.xml` or Tomcat config
- Ensure same browser is used for testing

**ClassNotFoundException:**
- Verify `ex5b.class` exists in `WEB-INF/classes/`
- Check servlet class name matches in `web.xml`

**404 Error:**
- Verify URL pattern: `/Ex5b` (case-sensitive)
- Check app is deployed: `<tomcat>/webapps/ex5b-session-app/`

## 📚 Additional Resources

For detailed setup instructions, see the main setup guide:
- `EX5A_SETUP_GUIDE.md` (in parent directory)

## ✅ Expected Output

**After submitting form:**
```
Welcome John Doe!
Your instrument: Guitar
[View Session Info link]
```

**After clicking "View Session Info":**
```
Session Data
Musician: John Doe
Instrument: Guitar
```
