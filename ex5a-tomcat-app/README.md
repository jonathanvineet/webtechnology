# Exercise 5a: Invoking a Servlet from HTML Form

## 📁 Project Structure
```
ex5a-servlet/
├── ex5a.html              (HTML form)
└── WEB-INF/
    ├── web.xml           (Servlet configuration)
    └── classes/
        ├── ex5a.java     (Servlet source code)
        └── ex5a.class    (Compiled servlet - will be generated)
```

## 🚀 Setup Instructions

### Prerequisites
- Apache Tomcat (version 9.x or 10.x)
- JDK (Java Development Kit)
- servlet-api.jar (comes with Tomcat)

### Step 1: Compile the Servlet

Navigate to the WEB-INF/classes directory:
```bash
cd WEB-INF/classes
```

Compile with servlet-api.jar (replace path with your Tomcat installation):
```bash
javac -cp "/path/to/tomcat/lib/servlet-api.jar" ex5a.java
```

**For macOS/Linux (if Tomcat is in /usr/local/tomcat):**
```bash
javac -cp "/usr/local/tomcat/lib/servlet-api.jar" ex5a.java
```

**For Windows:**
```bash
javac -cp "C:\Program Files\Apache Tomcat\lib\servlet-api.jar" ex5a.java
```

### Step 2: Deploy to Tomcat

1. Copy the entire `ex5a-servlet` folder to Tomcat's `webapps` directory:
   ```bash
   cp -r ex5a-servlet /path/to/tomcat/webapps/
   ```

2. Start Tomcat:
   ```bash
   # macOS/Linux
   /path/to/tomcat/bin/startup.sh
   
   # Windows
   C:\path\to\tomcat\bin\startup.bat
   ```

### Step 3: Access the Application

Open your browser and go to:
```
http://localhost:8080/ex5a-servlet/ex5a.html
```

## 🧪 Testing

1. Enter a musician name (e.g., "John Doe")
2. Enter an instrument (e.g., "Guitar")
3. Click Submit
4. The servlet will display the submitted information

## 📝 How It Works

1. **HTML Form** (`ex5a.html`):
   - Contains input fields for musician name and instrument
   - Form action points to servlet URL pattern `/Ex5a`
   - Uses POST method

2. **Servlet** (`ex5a.java`):
   - Extends `HttpServlet`
   - Implements `doPost()` method to handle form submission
   - Retrieves form parameters using `req.getParameter()`
   - Generates HTML response with submitted data

3. **Configuration** (`web.xml`):
   - Maps servlet class to URL pattern
   - Defines servlet name and class

## 🔧 Troubleshooting

**Error: "Cannot find servlet-api"**
- Make sure servlet-api.jar path is correct in compile command

**Error: "404 Not Found"**
- Check Tomcat is running
- Verify folder is in webapps directory
- Check URL spelling

**Error: "500 Internal Server Error"**
- Check servlet compiled successfully (ex5a.class exists)
- Verify web.xml configuration is correct
