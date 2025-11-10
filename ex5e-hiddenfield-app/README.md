# Exercise 5e: Hidden Form Field Tracking Using Servlets

## 🎯 Aim
To pass user data between multiple requests using Hidden Form Fields instead of sessions or cookies.

## 📁 Project Structure
```
ex5e-hiddenfield-app/
├── ex5e.html              (HTML form)
├── README.md              (This file)
└── WEB-INF/
    ├── web.xml           (Servlet configuration)
    └── classes/
        ├── ex5e.java     (Servlet source code)
        └── ex5e.class    (Compiled servlet - will be generated)
```

## 🚀 Quick Setup (OS-Independent)

### Step 1: Compile the Servlet

Navigate to the classes directory:
```bash
cd ex5e-hiddenfield-app/WEB-INF/classes
```

**Windows:**
```cmd
javac -cp "C:\tomcat\lib\servlet-api.jar" ex5e.java
```

**macOS/Linux:**
```bash
javac -cp "/opt/tomcat/lib/servlet-api.jar" ex5e.java
```

### Step 2: Deploy to Tomcat

**Windows:**
```cmd
xcopy ex5e-hiddenfield-app C:\tomcat\webapps\ex5e-hiddenfield-app\ /E /I
```

**macOS/Linux:**
```bash
cp -r ex5e-hiddenfield-app /opt/tomcat/webapps/
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
http://localhost:8080/ex5e-hiddenfield-app/ex5e.html
```

## 🧪 Testing Hidden Form Fields

1. **Enter Song Details:**
   - Open `http://localhost:8080/ex5e-hiddenfield-app/ex5e.html`
   - Enter song name (e.g., "Bohemian Rhapsody")
   - Enter artist name (e.g., "Queen")
   - Click "Submit"

2. **Confirm Details (Hidden Fields Created):**
   - You'll see a confirmation page showing your data
   - The form contains hidden fields (not visible in browser)
   - Click "View Final Details"

3. **View Final Details:**
   - Data is retrieved from hidden form fields
   - Shows final song and artist information
   - Note: Data was passed through forms, not sessions/cookies

4. **Inspect Hidden Fields:**
   - Right-click on confirmation page → "View Page Source"
   - Look for: `<input type='hidden' name='song' value='...'>`
   - This is how data is passed between requests

## 📝 How It Works

### 1. HTML Form (`ex5e.html`)
- Initial form to collect song and artist name
- Submits data via POST to servlet `/Ex5e`

### 2. Servlet POST Method (`doPost`)
- Receives form data from initial submission
- Displays confirmation page with a new form
- Creates **hidden form fields** containing the data:
  ```html
  <input type='hidden' name='song' value='...'>
  <input type='hidden' name='artist' value='...'>
  ```
- Hidden fields are not visible to user but sent with form

### 3. Servlet GET Method (`doGet`)
- Receives data from hidden form fields
- Retrieves parameters same way as normal form fields
- Displays final details

### 4. Data Flow
```
Step 1: User fills ex5e.html
   ↓ (POST with song & artist)
Step 2: doPost() receives data
   ↓ (Creates form with hidden fields)
Step 3: User clicks "View Final Details"
   ↓ (GET with hidden field values)
Step 4: doGet() receives and displays data
```

## 🔍 Key Concepts

### Hidden Form Fields:
- **Client-Side Storage:** Data stored in HTML form (client browser)
- **Invisible to User:** Not displayed but present in HTML source
- **Form Submission Required:** Data passed only when form is submitted
- **No Server Storage:** Unlike sessions, data not stored on server
- **URL-Independent:** Unlike URL rewriting, data not in address bar

### Comparison with Other Methods:

| Method | Storage | Visibility | Persistence |
|--------|---------|------------|-------------|
| **Hidden Fields** | Client (HTML) | Hidden in source | Per form submit |
| **Cookies** | Client (file) | Not visible | Configurable lifetime |
| **Sessions** | Server (memory) | Not visible | Until timeout/logout |
| **URL Rewriting** | Client (URL) | Visible in address bar | Per request |

### Methods Used:
- `req.getParameter("name")` - Get form field value (visible or hidden)
- `out.println("<input type='hidden' name='...' value='...'>")` - Create hidden field

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

**Hidden fields not working:**
- Check HTML source to verify hidden fields are present
- Ensure form method matches servlet method (GET/POST)
- Verify field names match in both forms

**Data showing as "null":**
- Check form is being submitted (button clicked)
- Verify parameter names are spelled correctly
- Ensure values are properly encoded in hidden fields

**404 Error:**
- Verify URL pattern: `/Ex5e` (case-sensitive)
- Check app is deployed: `<tomcat>/webapps/ex5e-hiddenfield-app/`

## 📚 Use Cases

Hidden form fields are useful for:
- Multi-step forms (wizards)
- Passing data without cookies/sessions
- Maintaining state in stateless applications
- CSRF protection tokens
- Passing previous page data

## ✅ Expected Output

**After initial submission (POST):**
```
Confirm Song Details
Song: Bohemian Rhapsody
Artist: Queen
[View Final Details button]
```

**After clicking button (GET):**
```
Final Song Details
Song: Bohemian Rhapsody
Artist: Queen
(Data passed using Hidden Form Fields)
```

## 💡 Advantages & Disadvantages

**Advantages:**
- Simple to implement
- No server-side storage required
- Works even if cookies disabled
- Data not visible in URL

**Disadvantages:**
- Requires form submission for each step
- Data visible in page source
- Not suitable for sensitive data
- Limited to form-based navigation
