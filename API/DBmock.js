class DBMock {
    constructor() {
        // Inizializza il "database" come un array in memoria
        this.utenti = [
            {
                id: 1,
                nome: 'Admin',
                cognome: 'User',
                data: '1990-01-01',
                nazionalita: 'Italiana',
                email: 'admin@admin.it',
                password: 'admin'
            },
            {
                id: 2,
                nome: 'John',
                cognome: 'Doe',
                data: '1985-05-15',
                nazionalita: 'Statunitense',
                email: 'john.doe@example.com',
                password: 'password123'
            }
        ];
        this.nextId = this.utenti.length ? this.utenti[this.utenti.length - 1].id + 1 : 1;
    }

    // Simula il comportamento di `db.run` per eseguire le query
    run(query, params, callback) {
        if (query.startsWith('INSERT INTO utenti')) {
            // Simula l'inserimento di un nuovo utente
            const newUser = {
                id: this.nextId++,
                nome: params[0],
                cognome: params[1],
                data: params[2],
                nazionalita: params[3],
                email: params[4],
                password: params[5]
            };
            this.utenti.push(newUser);
            // Callback senza errore
            if (callback) callback(null); 
            return;
        }
        if (callback) callback(new Error('Query non supportata'));
    }
    

    // Simula il comportamento di `db.get` per ottenere un singolo utente
    get(query, params, callback) {
        if (query.startsWith('SELECT * FROM utenti WHERE email = ? AND password = ?')) {
            const user = this.utenti.find(u => u.email === params[0] && u.password === params[1]);
            if (user) {
                // Nascondi la password prima di restituire i dati
                const { password, ...userWithoutPassword } = user;
                return callback(null, userWithoutPassword);
            }
            return callback(null, null); // Utente non trovato
        }
        return callback(new Error('Query non supportata'));
    }

    // Simula il comportamento di `db.all` per ottenere tutti gli utenti o filtrati
    all(query, params, callback) {
        if (query.startsWith('SELECT * FROM utenti')) {
            if (params.length > 0) {
                // Filtro per nazionalità
                const filteredUsers = this.utenti.filter(u => u.nazionalita === params[0]);
                return callback(null, filteredUsers);
            }
            return callback(null, this.utenti); // Ritorna tutti gli utenti
        }
        return callback(new Error('Query non supportata'));
    }

    // Simula la chiusura del "database"
    close(callback) {
        console.log('Mock DB chiuso');
        callback(null);
    }
}

module.exports = DBMock;
