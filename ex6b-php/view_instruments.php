<?php
// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "musicdb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to get all instruments
$sql = "SELECT * FROM instruments";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html>
<head>
  <title>View Instruments</title>
  <style>
    body { 
      font-family: Arial; 
      text-align: center; 
      padding: 20px; 
      background: #f5f5f5;
    }
    h2 { color: #333; }
    table { 
      border-collapse: collapse; 
      width: 80%; 
      margin: 20px auto; 
      background: white;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    th { 
      background-color: #4CAF50; 
      color: white; 
      padding: 12px; 
      text-align: left;
    }
    td { 
      padding: 10px; 
      text-align: left; 
      border-bottom: 1px solid #ddd;
    }
    tr:hover { background-color: #f5f5f5; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    .no-data { 
      padding: 20px; 
      color: #999; 
      font-style: italic;
    }
    .links {
      margin: 20px;
    }
    .links a {
      display: inline-block;
      margin: 5px;
      padding: 10px 20px;
      background: #2196F3;
      color: white;
      text-decoration: none;
      border-radius: 4px;
    }
    .links a:hover { background: #0b7dda; }
    .count {
      color: #666;
      font-size: 14px;
      margin: 10px 0;
    }
  </style>
</head>
<body>
  <h2>📋 Registered Musical Instruments</h2>
  
<?php
if ($result->num_rows > 0) {
    echo "<p class='count'>Total Records: <strong>" . $result->num_rows . "</strong></p>";
    echo "<table>";
    echo "<tr><th>ID</th><th>Instrument Name</th><th>Email</th><th>Type</th></tr>";
    
    // Output data of each row
    while($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $row["id"] . "</td>";
        echo "<td>" . htmlspecialchars($row["name"]) . "</td>";
        echo "<td>" . htmlspecialchars($row["email"]) . "</td>";
        echo "<td>" . htmlspecialchars($row["type"]) . "</td>";
        echo "</tr>";
    }
    
    echo "</table>";
} else {
    echo "<p class='no-data'>No instruments registered yet.</p>";
}

$conn->close();
?>

  <div class="links">
    <a href="index.html">← Back</a>
    <a href="../ex6a-php/index.html">Add New Instrument</a>
    <a href="view_instruments.php">🔄 Refresh</a>
  </div>
</body>
</html>
