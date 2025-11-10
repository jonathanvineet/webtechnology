<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
  <title>Musical Instruments</title>
</head>
<body style="font-family: Arial; text-align: center; background-color: #f2f2f2;">
  <h2>Musical Instruments List</h2>
  <table border="1" align="center" cellpadding="8" style="background:white;">
    <tr bgcolor="#add8e6">
      <th>Instrument Name</th>
      <th>Type</th>
    </tr>
    <xsl:for-each select="instruments/instrument">
      <tr>
        <td><xsl:value-of select="name"/></td>
        <td><xsl:value-of select="type"/></td>
      </tr>
    </xsl:for-each>
  </table>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
