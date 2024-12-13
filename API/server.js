const express = require('express');
const sqlite3 = require('sqlite3');
const cors = require('cors');
const session = require('express-session');
require('dotenv').config();

const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const path = require('path');

const app = express();
const port = 3000;

app.use(
  session({
    secret: 'TripsphereEdoCorti',
    resave: false,
    saveUninitialized: true,
    cookie: {
      maxAge: 3600000, // 1 ora
      httpOnly: true, // Non accessibile da JavaScript
      secure: process.env.NODE_ENV === 'production', // Usa HTTPS in produzione
    },
  })
);


// Middleware
app.use(cors({ origin: ['http://localhost:8080'], credentials: true }));
app.use(express.json());
app.use(passport.initialize());
app.use(passport.session());

passport.use(new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: 'http://localhost:3000/auth/google/callback',
  passReqToCallback: true,
  scope: [
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email'
  ]
},
(req, token, tokenSecret, profile, done) => {
  // Log the entire profile to understand its structure
  console.log('Full Google Profile:', JSON.stringify(profile, null, 2));

  // Extract email more robustly
  const email = profile.emails && profile.emails.length > 0 
    ? profile.emails[0].value 
    : profile._json.email // Try alternative email extraction
    || `${profile.id}@googleid.com`; // Fallback email generation

  // Ensure we have a valid email
  if (!email) {
    return done(new Error('Cannot retrieve email from Google profile'));
  }

  // Destructure other user details
  const firstName = profile.name.givenName || profile.displayName.split(' ')[0];
  const lastName = profile.name.familyName || profile.displayName.split(' ').slice(1).join(' ');

  // Connessione al database SQLite
  db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, row) => {
    if (err) return done(err);

    if (!row) {
      // Se l'utente non esiste, crealo
      db.run(
        `INSERT INTO utenti (nome, cognome, email) VALUES (?, ?, ?)`,
        [firstName, lastName, email],
        function (insertErr) {
          if (insertErr) return done(insertErr);
          
          // Passa il profilo con l'email aggiunta
          const userProfile = { ...profile, email };
          return done(null, userProfile);
        }
      );
    } else {
      // Se l'utente esiste, fai login
      const userProfile = { ...profile, email };
      return done(null, userProfile);
    }
  });
  (req, accessToken, refreshToken, profile, done) => {
    try {
      console.log('Full Google Profile:', JSON.stringify(profile, null, 2));
  
      // More robust email extraction
      const email = 
        profile.emails?.[0]?.value || 
        profile._json?.email || 
        `${profile.id}@googleid.com`;
  
      if (!email) {
        return done(new Error('Cannot retrieve email from Google profile'));
      }
  
      // Extract names safely
      const firstName = profile.name?.givenName || profile.displayName?.split(' ')[0] || 'Google';
      const lastName = profile.name?.familyName || profile.displayName?.split(' ').slice(1).join(' ') || 'User';
  
      // Database operation
      db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, row) => {
        if (err) return done(err);
  
        if (!row) {
          // Create new user if not exists
          db.run(
            `INSERT INTO utenti (nome, cognome, email) VALUES (?, ?, ?)`,
            [firstName, lastName, email],
            function (insertErr) {
              if (insertErr) return done(insertErr);
              return done(null, { ...profile, email });
            }
          );
        } else {
          // User exists, proceed with login
          return done(null, { ...profile, email });
        }
      });
    } catch (error) {
      console.error('Google OAuth Error:', error);
      done(error);
    }
  };
  
  // Serialize and deserialize user for session management
  passport.serializeUser((user, done) => {
    done(null, user.email);
  });
  
  passport.deserializeUser((email, done) => {
    db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, user) => {
      done(err, user);
    });
  });
}));
//const DBMock = require('./DBmock.js');
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

app.get('/auth/google',
  passport.authenticate('google', { scope: ['https://www.googleapis.com/auth/plus.login'] })
);

// Il callback di Google dopo l'autenticazione
app.get('/auth/google/callback',
  passport.authenticate('google', { failureRedirect: '/accedi' }),
  (req, res) => {
    req.session.loggedin = true;
    req.session.userId = req.user.id; // Puoi usare req.user per ottenere i dettagli dell'utente
    // Reindirizza al frontend, includendo un token o altre informazioni utente
    res.redirect(`http://localhost:8080/home?token=${req.sessionID}`); // Puoi passare l'ID della sessione o un token JWT
  }
);


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
