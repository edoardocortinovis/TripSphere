const express = require('express');
const sqlite3 = require('sqlite3');
const cors = require('cors');

const app = express();
const port = 3000;

// Configurazione del database SQLite
let db = new sqlite3.Database('./database.db', (err) => {
    if (err) {
        return console.error(err.message);
    }
    console.log('Connesso al database');
});

// Configurazione CORS
/*const corsOptions = {
  origin: 'http://localhost:8080', // Assicurati che questo sia l'URL del tuo frontend
  optionsSuccessStatus: 200,       // Per risolvere problemi con i browser più vecchi
};*/

const corsOptions = {
    origin: function (origin, callback) {
      const allowedOrigins = ['http://65.109.225.35:8080', 'http://www.edocorti.it'];
      if (allowedOrigins.indexOf(origin) !== -1 || !origin) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    },
    optionsSuccessStatus: 200
  };
  

app.use(cors(corsOptions)); // Applica il middleware CORS con la configurazione specificata
app.use(express.json());    // Per poter gestire i JSON nel body delle richieste

// Creazione della tabella utenti
db.run(`CREATE TABLE IF NOT EXISTS utenti (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    cognome TEXT,
    data TEXT,
    nazionalita TEXT,
    email TEXT UNIQUE,
    password TEXT
)`);

// Endpoint per registrare un nuovo utente
app.post('/registra', (req, res) => {
    const { nome, cognome, data, nazionalita, email, password } = req.body;
    db.run(`INSERT INTO utenti (nome, cognome, data, nazionalita, email, password) VALUES (?, ?, ?, ?, ?, ?)`,
        [nome, cognome, data, nazionalita, email, password],
        function (err) {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            res.json({ message: 'Nuovo utente creato', id: this.lastID });
        });
});

// Endpoint per effettuare il accesso
app.post('/accedi', (req, res) => {
    const { email, password } = req.body;
    db.get(`SELECT * FROM utenti WHERE email = ? AND password = ?`, [email, password], (err, row) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (row) {
            res.json({ message: 'Login riuscito', user: row });
        } else {
            res.status(401).json({ message: 'Credenziali errate' });
        }
    });
});


// Chiusura del database in modo sicuro
process.on('SIGINT', () => {
    db.close((err) => {
        if (err) {
            console.error(err.message);
        }
        console.log('Chiusura database');
        process.exit(0);
    });
});

// Avvio del server
app.listen(port, () => {
    console.log(`Server API in esecuzione su http://65.109.225.35:${port}`);
});