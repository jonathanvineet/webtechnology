# Exercise 5d: URL Rewriting Using Servlets

## 🎯 Aim
To maintain session information by passing data through the URL between servlets.

## 📁 Project Structure
```
ex5d-urlrewrite-app/
├── ex5d.html              (HTML form)
├── README.md              (This file)
└── WEB-INF/
    ├── web.xml           (Servlet configuration)
    └── classes/
        ├── ex5d.java     (Servlet source code)
        └── ex5d.class    (Compiled servlet)
```

## 🚀 Quick Setup

### Step 1: Compile the Servlet

**Windows:**
```cmd
cd ex5d-urlrewrite-app\WEB-INF\classes
javac -cp "C:\tomcat\lib\servlet-api.jar" ex5d.java
```

**macOS/Linux:**
```bash
cd ex5d-urlrewrite-app/WEB-INF/classes
javac -cp "/opt/tomcat/lib/servlet-api.jar" ex5d.java
```

### Step 2: Deploy to Tomcat

**Windows:**
```cmd
xcopy ex5d-urlrewrite-app C:\tomcat\webapps\ex5d-urlrewrite-app\ /E /I
```

**macOS/Linux:**
```bash
cp -r ex5d-urlrewrite-app /opt/tomcat/webapps/
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

### Step 4: Access

Open browser: `http://localhost:8080/ex5d-urlrewrite-app/ex5d.html`

## 🧪 Testing

1. **Submit Form:**
   - Enter artist name (e.g., "Led Zeppelin")
   - Click Submit
   - See welcome message with link

2. **Click Link:**
   - Click "View [Artist]" link
   - Notice URL: `Ex5d?artist=Led+Zeppelin`
   - Artist details displayed

3. **Observe URL:**
   - Check browser address bar
   - Data is visible in URL as query parameter
   - Data persists in bookmarks/history

## 📝 How It Works

### URL Encoding (doPost):
```java
String artist = req.getParameter("artist");
String nextURL = "Ex5d?artist=" + artist;
out.println("<a href='" + nextURL + "'>View " + artist + "</a>");
```

### URL Decoding (doGet):
```java
String artist = req.getParameter("artist");
// Displays the artist from URL parameter
```

## 🔑 Key Concepts

- **Query Parameters:** Data appended to URL as `?key=value`
- **Multiple Parameters:** Separated by `&`: `?name=John&age=25`
- **URL Encoding:** Spaces become `+` or `%20`
- **No Server Storage:** Data travels with each request
- **Visible to User:** Data appears in browser address bar
- **Bookmarkable:** Can save URL with data

## 🆚 URL Rewriting vs Other Methods

| Method | Storage | Visibility | Persistence |
|--------|---------|------------|-------------|
| **URL Rewriting** | None | Visible in URL | Only in URL/links |
| Session | Server | Hidden | Until timeout |
| Cookies | Client | Hidden | Until expiry |

## ⚠️ Limitations

- **Security:** Sensitive data visible in URL
- **Length Limit:** URLs have max length (~2000 chars)
- **Manual Propagation:** Must append to every link
- **Not Persistent:** Lost when URL changes

## 💡 Use Cases

✅ **Good for:**
- Search queries
- Pagination
- Sharing specific views
- Public/non-sensitive data

❌ **Avoid for:**
- Passwords or sensitive data
- Large amounts of data
- Shopping cart information

## 🛑 Stop Tomcat

**Windows:** `C:\tomcat\bin\shutdown.bat`  
**macOS/Linux:** `/opt/tomcat/bin/shutdown.sh`

## 🔗 Related Exercises

- **ex5b:** Session Tracking (server-side storage)
- **ex5c:** Cookie Tracking (client-side storage)
- **ex5d:** URL Rewriting (stateless tracking)
