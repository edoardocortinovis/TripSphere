const express = require('express');
const sqlite3 = require('sqlite3');
const cors = require('cors');
const session = require('express-session');
const cookieParser = require('cookie-parser');
require('dotenv').config();

const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const path = require('path');
const { Console } = require('console');

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

//AJAX
app.use(express.static(path.join(__dirname, 'public')));
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Middleware
app.use(cors({ origin: ['http://localhost:8080'], credentials: true }));
app.use(cookieParser());
app.use(express.json());
app.use(passport.initialize());
app.use(passport.session());

//const DBMock = require('./DBmock.js');
//const db = new DBMock(); // Creiamo un'istanza del mock

const db = new sqlite3.Database('./database.db', (err) => {
  if (err) return console.error('Errore connessione DB:', err.message);
  console.log('Connesso al database SQLite');
});

//Messaggio per rilevazione del cookie
app.use((req, res, next) => {
  console.log("Cookie della sessione:", req.cookies);
  next();
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

//#region Goggle Auth
passport.use(new GoogleStrategy({
  
  callbackURL: 'http://localhost:3000/auth/google/callback',
  passReqToCallback: true,
  scope: [
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.password'
  ]
},
  (req, accessToken, refreshToken, profile, done) => {
    try {
      // Log completo del profilo di Google
      console.log('Full Google Profile:', JSON.stringify(profile, null, 2));

      // Estrarre l'email dal profilo
      const email =
        profile.emails?.[0]?.value ||
        profile._json?.email ||
        `${profile.id}@googleid.com`;

      // Se non c'è un'email, restituire un errore
      if (!email) {
        return done(new Error('Cannot retrieve email from Google profile'));
      }

      // Estrazione del nome e cognome in modo sicuro
      const firstName = profile.name?.givenName || profile.displayName?.split(' ')[0] || 'Google';
      const lastName = profile.name?.familyName || profile.displayName?.split(' ').slice(1).join(' ') || 'User';

      // Verifica se l'utente esiste nel database
      db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, row) => {
        if (err) return done(err);

        // Se l'utente non esiste, lo creiamo
        if (!row) {
          db.run(
            `INSERT INTO utenti (nome, cognome, email) VALUES (?, ?, ?)`,
            [firstName, lastName, email],
            function (insertErr) {
              if (insertErr) return done(insertErr);

              // Passiamo il profilo dell'utente creato
              const userProfile = { ...profile, email };
              return done(null, userProfile);
            }
          );
        } else {
          // Se l'utente esiste, facciamo login
          const userProfile = { ...profile, email };
          return done(null, userProfile);
        }
      });
    } catch (error) {
      console.error('Google OAuth Error:', error);
      return done(error);
    }
  }));

// Serialize user for session management
passport.serializeUser((user, done) => {
  done(null, user.email);
});

// Deserialize user from session
passport.deserializeUser((email, done) => {
  db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, user) => {
    if (err) return done(err);
    done(null, user);
  });
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
    console.log("COSO RIUSCITO");
    res.redirect(`http://localhost:8080/home?token=${req.sessionID}`); // Puoi passare l'ID della sessione o un token JWT
  }
);
//#endregion

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
  console.log('Tentativo di login con email:', email);

  // Admin login check
  if (email === 'admin@admin.it' && password === 'admin') {
    req.session.loggedin = true;
    req.session.isAdmin = true;
    req.session.email = email;

    req.session.save((err) => {
      if (err) {
        console.error('Errore nel salvare la sessione admin:', err);
        return res.status(500).json({
          success: false,
          message: 'Errore nel salvataggio della sessione'
        });
      }

      console.log('Accesso come admin riuscito');
      return res.json({
        success: true,
        isAdmin: true,
        email: 'admin@admin.it',
        message: 'Login admin effettuato con successo'
      });
    });
    return;
  }

  // Regular user login
  db.get(`SELECT * FROM utenti WHERE email = ?`, [email], (err, row) => {
    if (err) {
      console.error('Errore database:', err);
      return res.status(500).json({
        success: false,
        message: 'Errore interno del server'
      });
    }

    // If no user found, create a new account
    if (!row) {
      // Validate input before creating account
      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email e password sono obbligatorie'
        });
      }

      // Generate a default name if not provided
      const defaultName = email.split('@')[0];

      db.run(
        `INSERT INTO utenti (nome, email, password) VALUES (?, ?, ?)`,
        [defaultName, email, password],
        function (insertErr) {
          if (insertErr) {
            console.error('Errore durante la creazione dell\'utente:', insertErr);
            return res.status(500).json({
              success: false,
              message: 'Impossibile creare l\'account'
            });
          }

          // Create session for new user
          req.session.loggedin = true;
          req.session.userId = this.lastID;
          req.session.email = email;

          // Explicitly save the session
          req.session.save((saveErr) => {
            if (saveErr) {
              console.error('Errore nel salvare la sessione:', saveErr);
              return res.status(500).json({
                success: false,
                message: 'Errore nel salvataggio della sessione'
              });
            }

            return res.json({
              success: true,
              isAdmin: false,
              email: email,
              userId: this.lastID,
              message: 'Nuovo account creato e login effettuato'
            });
          });
        }
      );
    } else {
      // Existing user login
      if (row.password !== password) {
        return res.status(401).json({
          success: false,
          message: 'Password errata'
        });
      }

      // Create session for existing user
      req.session.loggedin = true;
      req.session.userId = row.id;
      req.session.email = email;

      // Explicitly save the session
      req.session.save((saveErr) => {
        if (saveErr) {
          console.error('Errore nel salvare la sessione:', saveErr);
          return res.status(500).json({
            success: false,
            message: 'Errore nel salvataggio della sessione'
          });
        }

        return res.json({
          success: true,
          isAdmin: false,
          email: row.email,
          userId: row.id,
          nome: row.nome,
          message: 'Login effettuato con successo'
        });
      });
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

//#region Admin section
//GESTIONE PAGINA ADMIN
app.get('/users', (req, res) => {
  const query = "SELECT * FROM utenti"; // Tabella "utenti"
  db.all(query, [], (err, rows) => {
    if (err) {
      console.error("Errore durante il recupero degli utenti:", err.message);
      return res.status(500).json({ error: "Errore durante il recupero degli utenti" });
    }
    res.json(rows); // Invia i risultati come JSON
  });
});

app.put('/utenti/:id', (req, res) => {
  const userId = req.params.id;
  // Controlla se l'utente esiste
  db.get('SELECT * FROM utenti WHERE id = ?', [userId], (err, row) => {
    if (err || !row) {
      return res.status(404).json({ error: 'Utente non trovato' });
    }
    // Aggiorna i dati dell'utente
    db.run(
      `UPDATE utenti SET nome = ?, cognome = ?, email = ?, nazionalita = ?, data = ? WHERE id = ?`,
      [req.body.nome, req.body.cognome, req.body.email, req.body.nazionalita, req.body.data, userId],
      function (err) {
        if (err) {
          return res.status(500).json({ error: 'Errore durante l\'aggiornamento dell\'utente' });
        }
        res.json({ message: 'Utente aggiornato con successo' });
      }
    );
  });
});

app.delete('/utenti/:id', (req, res) => {
  const { id } = req.params;

  db.run(`DELETE FROM utenti WHERE id = ?`, [id], function (err) {
    if (err) {
      return res.status(500).send({ error: 'Errore durante l\'eliminazione dell\'utente' });
    }
    res.send({ success: true });
  });
});
//#endregion

//GESTIONE UTENTI AJAX
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
