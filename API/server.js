const express = require('express');
const sqlite3 = require('sqlite3');
const cors = require('cors');
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const session = require('express-session');

const app = express();
const port = 3000; // Porta su cui il server sarà in esecuzione

// Configurazione express-session
app.use(
  session({
    secret: 'TripsphereEdoCorti', // Segreto per la sessione
    resave: false,      // Non salva la sessione se non modificata
    saveUninitialized: true, // Salva nuove sessioni anche se vuote
    cookie: { maxAge: 3600000 }, // Durata della sessione (1 ora)
  })
);

app.use(express.static('public'));

// Configurazione Swagger
const swaggerOptions = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'API TripSphere',
      version: '1.0.0',
      description: 'Documentazione API per TripSphere',
    },
    servers: [
      {
        url: `http://localhost:${port}`, // URL del server
      },
    ],
  },
  apis: ['./server.js'], // Percorso del file con le annotazioni Swagger
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

const corsOptions = {
  origin: function (origin, callback) {
    const allowedOrigins = ['http://localhost:8080', 'http://www.edocorti.it'];
    if (allowedOrigins.indexOf(origin) !== -1 || !origin) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(express.json()); 

// Configurazione del database SQLite
let db = new sqlite3.Database('./database.db', (err) => {
  if (err) {
    return console.error(err.message);
  }
  console.log('Connesso al database');
});

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
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.json({ message: 'Nuovo utente creato', id: this.lastID });
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

  db.get(`SELECT * FROM utenti WHERE email = ? AND password = ?`, [email, password], (err, row) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (row) {
      // Salva le informazioni nella sessione
      req.session.loggedin = true;
      req.session.userId = row.id;
      req.session.userName = row.nome;

      res.json({ message: 'Login riuscito' });
    } else {
      res.status(401).json({ message: 'Credenziali errate' });
    }
  });
});

app.post('/logout', (req, res) => {
  if (req.session) {
    req.session.loggedin = false; // Aggiorna lo stato di login
    req.session.save((err) => { // Salva la sessione prima di distruggerla
      if (err) {
        return res.status(500).json({ message: 'Errore durante il salvataggio della sessione' });
      }
      req.session.destroy((err) => {
        if (err) {
          return res.status(500).json({ message: 'Errore durante il logout' });
        }
        res.clearCookie('connect.sid'); // Rimuove il cookie di sessione
        res.json({ message: 'Logout effettuato con successo.' });
      });
    });
  } else {
    res.status(400).json({ message: 'Nessuna sessione attiva.' });
  }
});

app.get('/home', (req, res) => {
  if (req.session.loggedin) {
    res.json({ message: `Benvenuto, ${req.session.userName}` });
  } else {
    res.status(401).json({ message: 'Utente non autenticato' });
  }
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
