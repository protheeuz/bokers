const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 3000;

// Konfigurasi koneksi ke MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'detection_db',
});

// Membuat koneksi ke MySQL
db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + db.threadId);
});

// Contoh endpoint untuk mendapatkan data dari database
app.get('/detections', (req, res) => {
  db.query('SELECT * FROM detections', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Menjalankan server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
