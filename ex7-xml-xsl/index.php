<?php
$xml = simplexml_load_file("instruments.xml") or die("Error: Cannot load file");
?>
<!DOCTYPE html>
<html>
<head>
  <title>XML Data Display (PHP)</title>
</head>
<body style="text-align:center; font-family:Arial;">
  <h2>Instruments from XML (PHP Output)</h2>
  <table border="1" align="center" cellpadding="8">
    <tr bgcolor="#add8e6">
      <th>Instrument</th>
      <th>Type</th>
    </tr>
    <?php
      foreach ($xml->instrument as $inst) {
        echo "<tr><td>" . $inst->name . "</td><td>" . $inst->type . "</td></tr>";
      }
    ?>
  </table>
</body>
</html>
