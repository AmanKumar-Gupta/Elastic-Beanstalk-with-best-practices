const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  port: '3306',
  user: 'admin',
  password: 'aman1234',
  database: 'project-db'
});

connection.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err);
  } else {
    console.log('DB connected :)');
  }
});

module.exports = connection;
