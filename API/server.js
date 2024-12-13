const express = require('express');
const sqlite3 = require('sqlite3');
const cors = require('cors');
const session = require('express-session');

const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const path = require('path');

const app = express();
const port = 3000;

// Configurazione express-session
app.use(
  session({
    secret: 'TripsphereEdoCorti',
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 3600000 }, // 1 ora
  })
);

// Middleware
app.use(cors({ origin: ['http://localhost:8080'], credentials: true }));
app.use(express.json());


const DBMock = require('./DBmock.js'); // Supponiamo che DBMock.js esista nella stessa cartella
//const db = new DBMock(); // Creiamo un'istanza del mock

const db = new sqlite3.Database('./database.db', (err) => {
  if (err) return console.error('Errore connessione DB:', err.message);
  console.log('Connesso al database SQLite');
});

// Creazione della tabella utenti se non esiste
db.run(`
  CREATE TABLE IF NOT EXISTS utenti (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    cognome TEXT,
    data TEXT,
    nazionalita TEXT,
    email TEXT UNIQUE,
    password TEXT
  )
`);

// Configurazione Swagger
const swaggerOptions = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'API TripSphere',
      version: '1.0.0',
      description: 'Documentazione API per TripSphere',
    },
    servers: [{ url: `http://localhost:${port}` }],
  },
  apis: ['./server.js'], // Percorso del file con annotazioni Swagger
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));


app.use(express.static(path.join(__dirname, 'public')));
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});


/**
 * @swagger
 * /registra:
 *   post:
 *     summary: Registra un nuovo utente
 *     description: Endpoint per registrare un nuovo utente nel sistema.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nome:
 *                 type: string
 *               cognome:
 *                 type: string
 *               data:
 *                 type: string
 *               nazionalita:
 *                 type: string
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Utente registrato con successo.
 *       500:
 *         description: Errore durante la registrazione.
 */
app.post('/registra', (req, res) => {
  const { nome, cognome, data, nazionalita, email, password } = req.body;
  db.run(
    `INSERT INTO utenti (nome, cognome, data, nazionalita, email, password) VALUES (?, ?, ?, ?, ?, ?)`,
    [nome, cognome, data, nazionalita, email, password],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Utente registrato con successo', id: this.lastID });
    }
  );
});

/**
 * @swagger
 * /accedi:
 *   post:
 *     summary: Effettua il login
 *     description: Endpoint per autenticare un utente tramite email e password.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Login riuscito.
 *       401:
 *         description: Credenziali errate.
 */
app.post('/accedi', (req, res) => {
  const { email, password } = req.body;

  if (email === 'admin@admin.it' && password === 'admin') {
    req.session.loggedin = true;
    req.session.isAdmin = true;
    return res.json({
      success: true,
      isAdmin: true,
      email: 'admin@admin.it',
      password: 'admin'
    });
  }

  db.get(`SELECT * FROM utenti WHERE email = ? AND password = ?`, [email, password], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (row) {
      req.session.loggedin = true;
      req.session.userId = row.id;
      req.session.isAdmin = false;
      return res.json({
        success: true,
        isAdmin: false,
        email: row.email,
        password: row.password
      });
    } else {
      res.status(401).json({ message: 'Credenziali errate' });
    }
  });
});


/**
 * @swagger
 * /logout:
 *   post:
 *     summary: Effettua il logout
 *     description: Disconnette l'utente corrente dalla sessione.
 *     responses:
 *       200:
 *         description: Logout effettuato con successo.
 *       400:
 *         description: Nessuna sessione attiva.
 */
app.post('/logout', (req, res) => {
  if (req.session) {
    req.session.destroy((err) => {
      if (err) return res.status(500).json({ message: 'Errore durante il logout' });
      res.clearCookie('connect.sid');
      res.json({ message: 'Logout effettuato con successo.' });
    });
  } else {
    res.status(400).json({ message: 'Nessuna sessione attiva.' });
  }
});

app.get('/account', (req, res) => {
  if (req.session.loggedin) {
    const userId = req.session.userId; // L'id dell'utente che è loggato
    // Recupera i dati dell'utente dal database
    db.get(`SELECT * FROM utenti WHERE id = ?`, [userId], (err, row) => {
      if (err) return res.status(500).json({ error: err.message });

      if (row) {
        res.json({
          name: row.name,
          email: row.email,
          favorites: row.favorites, // Preferiti (ipotizzando che siano memorizzati)
        });
      } else {
        res.status(404).json({ message: 'Utente non trovato' });
      }
    });
  } else {
    res.status(401).json({ message: 'Non autenticato' });
  }
});







app.get('/utenti', (req, res) => {
  db.all(`SELECT * FROM utenti`, [], (err, rows) => {
      if (err) {
          return res.status(500).json({ error: err.message });
      }
      res.json({ utenti: rows });
  });
});
app.get('/utenti/filtrati', (req, res) => {
  const { nazionalita } = req.query;
  if (!nazionalita) {
      return res.status(400).json({ error: 'Nazionalità non specificata' });
  }
  db.all(`SELECT * FROM utenti WHERE nazionalita = ?`, [nazionalita], (err, rows) => {
      if (err) {
          return res.status(500).json({ error: err.message });
      }
      res.json({ utenti: rows });
  });
});



// Avvio del server
app.listen(port, () => {
  console.log(`Server API in esecuzione su http://localhost:${port}`);
});

// Chiusura sicura del database
process.on('SIGINT', () => {
  db.close((err) => {
    if (err) console.error('Errore durante la chiusura del database:', err.message);
    console.log('Database chiuso');
    process.exit(0);
  });
});
