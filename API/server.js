const express = require('express');
const sqlite3 = require('sqlite3');
const app = express();
const port = 3000;

let db = new sqlite3.Database('./database.db', (err) => {
    if (err) {
        return console.error(err.message);
    }
    console.log('Connesso al database');
});

app.use(express.json());

// Creazione della tabella utenti con i nuovi campi
db.run(`CREATE TABLE IF NOT EXISTS utenti 
( id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT,
  cognome TEXT,
  data TEXT,  -- Data di nascita
  nazionalita TEXT,
  email TEXT,
  password TEXT)`);

// Endpoint per creare un nuovo utente
app.post('/utenti', (req, res) => {
    const { nome, cognome, data, nazionalita, email, password } = req.body;
    db.run(`INSERT INTO utenti (nome, cognome, data, nazionalita, email, password) VALUES (?, ?, ?, ?, ?, ?)`, 
        [nome, cognome, data, nazionalita, email, password], 
        function(err) {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            res.json({ message: 'Nuovo utente creato', id: this.lastID });
        });
});

// Endpoint per ottenere tutti gli utenti
app.get('/utenti', (req, res) => {
    db.all('SELECT * FROM utenti', [], (err, rows) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ users: rows });
    });
});

// Endpoint per aggiornare un utente
app.put('/utenti/:id', (req, res) => {
    const { id } = req.params;
    const { nome, cognome, eta, nazionalita, email, password } = req.body;
    db.run(`UPDATE utenti SET nome = ?, cognome = ?, data = ?, nazionalita = ?, email = ?, password = ? WHERE id = ?`, 
        [nome, cognome, eta, nazionalita, email, password, id], 
        function(err) {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            if (this.changes === 0) {
                return res.status(404).json({ message: 'Utente non trovato' });
            }
            res.json({ message: 'Utente aggiornato con successo' });
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

app.listen(port, () => {
    console.log(`Server API in esecuzione su http://localhost:${port}`);
});