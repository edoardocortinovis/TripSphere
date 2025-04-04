// jwt-routes.js completo con accesso diretto al database
const express = require('express');
const jwt = require('jsonwebtoken');
const sqlite3 = require('sqlite3').verbose();
const router = express.Router();

// Chiave segreta per firmare i token JWT
const JWT_SECRET = process.env.JWT_SECRET || 'tripsphere-jwt-secret-key';
const JWT_EXPIRATION = process.env.JWT_EXPIRATION || '24h';

// Crea una connessione al database
const db = new sqlite3.Database('./database.db', (err) => {
  if (err) console.error('Errore connessione DB:', err.message);
  console.log('JWT Routes: Connesso al database SQLite');
});

// Middleware per il parsing del corpo JSON
router.use(express.json());
router.use(express.urlencoded({ extended: true }));

// Middleware CORS per le rotte JWT
router.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:8080');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.header('Access-Control-Allow-Credentials', 'true');
  
  // Gestisci le richieste OPTIONS (preflight)
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  
  next();
});

// Funzione per generare un token JWT
const generateToken = (user) => {
  const payload = {
    id: user.id,
    email: user.email,
    isAdmin: user.isAdmin || false
  };

  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRATION });
};

// Middleware per verificare il token JWT
const verifyToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ message: 'Token non fornito' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.jwtUser = decoded; // Usiamo jwtUser per non interferire con req.session
    next();
  } catch (err) {
    return res.status(403).json({ message: 'Token non valido o scaduto' });
  }
};

// Rotta per la registrazione JWT
router.post('/jwt/register', (req, res) => {
  console.log('Richiesta di registrazione ricevuta:', req.body);
  
  // Verifica che req.body non sia undefined
  if (!req.body) {
    return res.status(400).json({
      success: false,
      message: 'Corpo della richiesta mancante'
    });
  }
  
  const { nome, cognome, data, nazionalita, email, password } = req.body;
  
  // Verifica che i campi obbligatori siano presenti
  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Email e password sono obbligatorie'
    });
  }
  
  // Utilizziamo il database direttamente
  db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, row) => {
    if (err) {
      console.error('Errore database:', err);
      return res.status(500).json({
        success: false,
        message: 'Errore interno del server'
      });
    }

    if (row) {
      return res.status(400).json({
        success: false,
        message: 'Email già registrata'
      });
    }

    // Inserisci il nuovo utente nel database
    db.run(
      `INSERT INTO utenti (nome, cognome, data, nazionalita, email, password) VALUES (?, ?, ?, ?, ?, ?)`,
      [nome || '', cognome || '', data || new Date().toISOString().split('T')[0], nazionalita || '', email, password],
      function (insertErr) {
        if (insertErr) {
          console.error('Errore inserimento:', insertErr);
          return res.status(500).json({
            success: false,
            message: 'Errore durante la registrazione'
          });
        }

        // Genera un token JWT per il nuovo utente
        const token = generateToken({
          id: this.lastID,
          email: email,
          isAdmin: false
        });

        // Restituisci il token e i dati dell'utente
        res.json({
          success: true,
          message: 'Registrazione completata con successo',
          id: this.lastID,
          token: token
        });
      }
    );
  });
});

// Rotta per il login JWT
router.post('/jwt/login', (req, res) => {
  console.log('Richiesta di login ricevuta:', req.body);
  
  // Verifica che req.body non sia undefined
  if (!req.body) {
    return res.status(400).json({
      success: false,
      message: 'Corpo della richiesta mancante'
    });
  }
  
  const { email, password } = req.body;
  
  // Verifica che i campi obbligatori siano presenti
  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Email e password sono obbligatorie'
    });
  }
  
  // Utilizziamo il database direttamente
  db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, row) => {
    if (err) {
      console.error('Errore database:', err);
      return res.status(500).json({
        success: false,
        message: 'Errore interno del server'
      });
    }

    if (!row) {
      return res.status(401).json({
        success: false,
        message: 'Utente non trovato'
      });
    }

    // Verifica la password
    if (row.password !== password) {
      return res.status(401).json({
        success: false,
        message: 'Password errata'
      });
    }

    // Genera un token JWT
    const token = generateToken({
      id: row.id,
      email: row.email,
      isAdmin: email === 'admin@admin.it'
    });

    // Restituisci il token e i dati dell'utente
    res.json({
      success: true,
      message: 'Login JWT effettuato con successo',
      token: token,
      userId: row.id,
      email: row.email,
      nome: row.nome,
      isAdmin: email === 'admin@admin.it'
    });
    
  });
});

// Rotta per ottenere i dati del profilo utente con JWT
router.get('/jwt/profile', verifyToken, (req, res) => {
  const userId = req.jwtUser.id;
  
  // Utilizziamo il database direttamente
  db.get(`SELECT * FROM utenti WHERE id = ?`, [userId], (err, row) => {
    if (err) {
      console.error('Errore database:', err);
      return res.status(500).json({ error: err.message });
    }

    if (!row) {
      return res.status(404).json({ message: 'Utente non trovato' });
    }

    // Restituisci i dati dell'utente
    res.json({
      id: row.id,
      nome: row.nome,
      cognome: row.cognome,
      email: row.email,
      nazionalita: row.nazionalita,
      data: row.data
    });
  });
});

// Gestione della chiusura del database quando l'applicazione termina
process.on('SIGINT', () => {
  db.close((err) => {
    if (err) console.error('Errore durante la chiusura del database JWT:', err.message);
    console.log('Database JWT chiuso');
    process.exit(0);
  });
});

module.exports = {
  jwtRoutes: router,
  verifyToken: verifyToken
};
