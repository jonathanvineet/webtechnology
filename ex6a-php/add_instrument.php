<?php
// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "musicdb";

// Get form data
$name = $_POST['name'];
$email = $_POST['email'];
$type = $_POST['type'];

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Insert query
$sql = "INSERT INTO instruments (name, email, type) VALUES ('$name', '$email', '$type')";

?>
<!DOCTYPE html>
<html>
<head>
  <title>Registration Result</title>
  <style>
    body { 
      font-family: Arial; 
      text-align: center; 
      padding: 20px; 
      background: #f0f0f0;
    }
    .message {
      display: inline-block;
      padding: 30px;
      margin: 50px auto;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .success { color: #4CAF50; }
    .error { color: #f44336; }
    a {
      display: inline-block;
      margin: 10px;
      padding: 10px 20px;
      background: #2196F3;
      color: white;
      text-decoration: none;
      border-radius: 4px;
    }
    a:hover { background: #0b7dda; }
  </style>
</head>
<body>
  <div class="message">
<?php
// Execute query
if ($conn->query($sql) === TRUE) {
    echo "<h2 class='success'>✓ Instrument Added Successfully!</h2>";
    echo "<p><strong>Name:</strong> " . htmlspecialchars($name) . "</p>";
    echo "<p><strong>Email:</strong> " . htmlspecialchars($email) . "</p>";
    echo "<p><strong>Type:</strong> " . htmlspecialchars($type) . "</p>";
} else {
    echo "<h2 class='error'>✗ Error: " . $conn->error . "</h2>";
}

$conn->close();
?>
    <br>
    <a href="index.html">Add Another</a>
    <a href="../ex6b-php/view_instruments.php">View All</a>
  </div>
</body>
</html>
