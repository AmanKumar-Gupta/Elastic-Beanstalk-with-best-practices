const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'project-db-instance-1.cr64s466w7vw.ap-southeast-1.rds.amazonaws.com',
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
