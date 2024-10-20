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

// Middleware
app.use(cors()); // Abilita CORS
app.use(express.json()); // Per poter gestire i JSON nel body delle richieste

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
app.post('/utenti', (req, res) => {
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

// Endpoint per effettuare il login
app.post('/login', (req, res) => {
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
    console.log(`Server API in esecuzione su http://localhost:${port}`);
});