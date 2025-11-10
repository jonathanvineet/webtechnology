# Exercise 5c: Cookie Tracking Using Servlets

## 🎯 Aim
To store and retrieve user information using Cookies in Java Servlets.

## 📁 Project Structure
```
ex5c-cookie-app/
├── ex5c.html              (HTML form)
├── README.md              (This file)
└── WEB-INF/
    ├── web.xml           (Servlet configuration)
    └── classes/
        ├── ex5c.java     (Servlet source code)
        └── ex5c.class    (Compiled servlet - will be generated)
```

## 🚀 Quick Setup (OS-Independent)

### Step 1: Compile the Servlet

Navigate to the classes directory:
```bash
cd ex5c-cookie-app/WEB-INF/classes
```

**Windows:**
```cmd
javac -cp "C:\tomcat\lib\servlet-api.jar" ex5c.java
```

**macOS/Linux:**
```bash
javac -cp "/opt/tomcat/lib/servlet-api.jar" ex5c.java
```

### Step 2: Deploy to Tomcat

**Windows:**
```cmd
xcopy ex5c-cookie-app C:\tomcat\webapps\ex5c-cookie-app\ /E /I
```

**macOS/Linux:**
```bash
cp -r ex5c-cookie-app /opt/tomcat/webapps/
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
http://localhost:8080/ex5c-cookie-app/ex5c.html
```

## 🧪 Testing Cookie Tracking

### Test 1: Save a Cookie
1. Open `http://localhost:8080/ex5c-cookie-app/ex5c.html`
2. Enter an artist name (e.g., "The Beatles")
3. Click "Save Cookie"
4. You'll see: "Cookie saved! Your favorite artist: **The Beatles**"

### Test 2: View Saved Cookie
1. Click the "View Cookie" link
2. OR visit: `http://localhost:8080/ex5c-cookie-app/Ex5c`
3. The servlet will retrieve and display: "Favorite Artist: **The Beatles**"

### Test 3: Cookie Persistence
1. Close the browser tab
2. Open a new tab and visit: `http://localhost:8080/ex5c-cookie-app/Ex5c`
3. The cookie data should still be available (browser session cookie)

### Test 4: No Cookie Scenario
1. Clear browser cookies or use incognito mode
2. Visit: `http://localhost:8080/ex5c-cookie-app/Ex5c`
3. Should display: "Favorite Artist: **Not Found**"

### Test 5: Update Cookie
1. Go back to: `http://localhost:8080/ex5c-cookie-app/ex5c.html`
2. Enter a different artist name (e.g., "Led Zeppelin")
3. Submit - this will overwrite the previous cookie value

## 📝 How It Works

### 1. HTML Form (`ex5c.html`)
- Input field for artist name
- Submits data via POST to servlet `/Ex5c`
- Link to view saved cookie data

### 2. Servlet POST Method (`doPost`)
- Receives artist name from form
- Creates cookie: `new Cookie("favArtist", artist)`
- Adds cookie to response: `res.addCookie(cookie)`
- Displays confirmation message

### 3. Servlet GET Method (`doGet`)
- Retrieves all cookies: `req.getCookies()`
- Searches for cookie named "favArtist"
- Extracts value: `cookie.getValue()`
- Displays the stored artist name

## 🔍 Key Concepts

### Cookie Characteristics:
- **Client-Side Storage:** Stored in browser, not on server
- **Automatic Transmission:** Browser sends cookies with each request
- **Size Limit:** ~4KB per cookie
- **Persistence:** Can be session-based or have expiration time

### Cookie vs Session:
| Feature | Cookie | Session |
|---------|--------|---------|
| Storage | Client (browser) | Server |
| Size | ~4KB limit | No limit |
| Security | Less secure | More secure |
| Expiration | Can be set | Server timeout |

### Important Cookie Methods:
```java
// Create cookie
Cookie c = new Cookie("name", "value");

// Set expiration (seconds)
c.setMaxAge(3600); // 1 hour

// Add to response
res.addCookie(c);

// Retrieve cookies
Cookie[] cookies = req.getCookies();

// Get cookie name and value
String name = c.getName();
String value = c.getValue();
```

## 🔧 Advanced Features (Optional Enhancements)

### Set Cookie Expiration:
```java
// In doPost method, after creating cookie:
cookie.setMaxAge(60 * 60 * 24); // 24 hours in seconds
```

### Set Cookie Path:
```java
cookie.setPath("/"); // Available for entire domain
```

### Delete Cookie:
```java
cookie.setMaxAge(0); // Expire immediately
res.addCookie(cookie);
```

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

## 🐛 Troubleshooting

**Cookie not saving:**
- Check browser cookie settings (ensure cookies are enabled)
- Verify `res.addCookie()` is called before sending response
- Check browser developer tools → Application → Cookies

**"Not Found" always displayed:**
- Verify cookie name matches exactly: "favArtist"
- Check if cookies are blocked by browser
- Test in different browser or incognito mode

**Cookie value shows encoded characters:**
- Avoid spaces and special characters in cookie values
- Use URL encoding if needed: `URLEncoder.encode(value, "UTF-8")`

## 📚 Additional Resources

For detailed Tomcat setup, see:
- `EX5A_SETUP_GUIDE.md` (in parent directory)

Related exercises:
- `ex5a-tomcat-app/` - Basic servlet form handling
- `ex5b-session-app/` - Session tracking (server-side storage)

## ✅ Expected Output

**After saving cookie:**
```
Cookie saved!
Your favorite artist: The Beatles
[View Cookie link]
```

**After viewing cookie:**
```
Saved Cookie Data
Favorite Artist: The Beatles
```

**If no cookie exists:**
```
Saved Cookie Data
Favorite Artist: Not Found
```

## 🎓 Learning Points

1. **Cookies store data on client side** - visible to users
2. **Sessions store data on server side** - more secure
3. **Cookies survive browser close** (if MaxAge is set)
4. **Sessions expire after timeout** or browser close
5. **Use cookies for preferences**, sessions for sensitive data
