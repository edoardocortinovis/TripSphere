// app.js

const express = require('express');
const sqlite3 = require('sqlite3');
const app = express();
const port = 3000;

let db = new sqlite3.Database('./database.db', (err) => {
    if (err) {
        return console.error(err.message);
    }
    console.log('connesso al database');
});

app.use(express.json());

db.run(`CREATE TABLE IF NOT EXISTS utenti 
( id INTEGER PRIMARY KEY AUTOINCREMENT,
     nome TEXT,
      cognome TEXT,
       data TEXT,
        email TEXT,
         password TEXT,
          favourite_dish TEXT,
           username TEXT  
           )`);


app.post('/utenti', (req, res) => {
    const { nome, cognome, data, email, password, favourite_dish, username } = req.body;
    db.run(`INSERT INTO utenti (nome,cognome,data,email,password,favourite_dish,username) VALUES (?,?,?,?,?,?,?)`, [ nome, cognome, data, email, password, favourite_dish, username], function(err){
        if(err) {
            return res.status(500).json({error: err.message} );
        }
        res.json({message: ' Nuovo utente creato', id: this.lastID});
    });
});

app.get('/utenti', (req,res)=> {
    db.all('SELECT * FROM utenti', [], (err,rows) => {
        if (err) {
            return res.status(500).json({error : err.message});
        }
        res.json({users: rows});
    });
});

app.put('/utenti/:id', (req,res) => {
    const {id} = req.params;
    const {nome,email,città, titolo_studio} = req.body;
    db.run(
        `UPDATE utenti SET nome = ?, cognome= ?, data = ?,email = ?, password = ?, favourite_dish = ?, username = ? WHERE ID= ?`, [nome,cognome,data,email,password,favourite_dish,username,id],
        function(err){
            if (err) {
                return res.status(500).json({error : err.message});
            }
            if ( this.changes === 0) {
                return res.status(404).json({message: 'utente non trovato'});

            }
            res.json({ message: 'utente aggiornato con successo'});
        }

    );
});


process.on('SIGINT',()=> {
    db.close((err) => {
        if(err) {
            console.error(err.message);
        }
        console.log('chiusura database');
        process.exit(0);
    });
});

app.listen(port,() => {
    console.log(`Server API in esecuzione su http://localhost.${port}`);
});