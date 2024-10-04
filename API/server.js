const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs'); // Modulo per leggere il file

// Creiamo l'applicazione Express
const app = express();

// Middleware per parsare il body delle richieste in formato JSON
app.use(bodyParser.json());

// Endpoint di login
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    console.log(`Richiesta di login per l'utente ${username}`);
    console.log(`Password: ${password}`);

    // Legge il file utenti.json
    fs.readFile('utenti.json', 'utf8', (err, data) => {
        if (err) {
            res.status(500).json({ message: 'Errore nella lettura del file utenti.json' });
            return;
        }

        try {
            const utenti = JSON.parse(data);

            // Cerca l'utente nel file utenti.json
            const user = utenti.find(u => u.user === username && u.pwd === password);

            if (user) {
                // Se l'utente viene trovato, restituisci i suoi dati
                res.status(200).json({
                    "status": "OK",
                    "user": user.user,
                    "ruolo": user.ruolo
                });
            } else {
                // Se le credenziali non corrispondono, restituisci un errore 401
                res.status(401).json({ message: 'Credenziali non valide' });
            }
        } catch (err) {
            res.status(500).json({ message: 'Errore nel parsing del file utenti.json' });
        }
    });
});

// Endpoint per ottenere la lista degli utenti
app.get('/utenti', (req, res) => {
    fs.readFile('utenti.json', 'utf8', (err, data) => {
        if (err) {
            res.status(500).json({ message: 'Errore nella lettura del file utenti.json' });
            return;
        }

        try {
            const utenti = JSON.parse(data);
            res.status(200).json(utenti);
        } catch (err) {
            res.status(500).json({ message: 'Errore nel parsing del file utenti.json' });
        }
    });
});

// Endpoint per aggiungere un nuovo utente
app.post('/utenti', (req, res) => {
    const { user, pwd, ruolo } = req.body;

    if (!user || !pwd || !ruolo) {
        return res.status(400).json({ message: 'Dati mancanti: username, password o ruolo' });
    }

    // Legge il file utenti.json
    fs.readFile('utenti.json', 'utf8', (err, data) => {
        if (err) {
            return res.status(500).json({ message: 'Errore nella lettura del file utenti.json' });
        }

        try {
            const utenti = JSON.parse(data);

            // Verifica se l'utente esiste già
            const userExists = utenti.find(u => u.user === user);
            if (userExists) {
                return res.status(400).json({ message: 'Utente già esistente' });
            }

            // Aggiungi il nuovo utente
            const nuovoUtente = { user, pwd, ruolo };
            utenti.push(nuovoUtente);

            // Salva il file aggiornato
            fs.writeFile('utenti.json', JSON.stringify(utenti, null, 2), (err) => {
                if (err) {
                    return res.status(500).json({ message: 'Errore nel salvataggio del file utenti.json' });
                }

                res.status(201).json({ message: 'Utente aggiunto con successo', nuovoUtente });
            });
        } catch (err) {
            return res.status(500).json({ message: 'Errore nel parsing del file utenti.json' });
        }
    });
});

//DELETE
// Endpoint per eliminare un utente
app.delete('/delete', (req, res) => {
    const { username } = req.body;

    if (!username) {
        return res.status(400).json({ message: 'Username non fornito' });
    }

    // Legge il file utenti.json
    fs.readFile('utenti.json', 'utf8', (err, data) => {
        if (err) {
            return res.status(500).json({ message: 'Errore nella lettura del file utenti.json' });
        }

        try {
            let utenti = JSON.parse(data);

            // Cerca l'utente nel file
            const userIndex = utenti.findIndex(u => u.user === username);
            if (userIndex === -1) {
                return res.status(404).json({ message: 'Utente non trovato' });
            }

            // Rimuove l'utente dall'array
            utenti.splice(userIndex, 1);

            // Salva il file aggiornato
            fs.writeFile('utenti.json', JSON.stringify(utenti, null, 2), (err) => {
                if (err) {
                    return res.status(500).json({ message: 'Errore nel salvataggio del file utenti.json' });
                }

                res.status(200).json({ message: `Utente ${username} eliminato con successo` });
            });
        } catch (err) {
            return res.status(500).json({ message: 'Errore nel parsing del file utenti.json' });
        }
    });
});


// Avviare il server sulla porta 3000
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server in esecuzione sulla porta ${PORT}`);
});
