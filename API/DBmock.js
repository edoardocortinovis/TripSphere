class DBMock {
    constructor() {
        this.utenti = [
            {
                id: 1,
                nome: 'Admin',
                cognome: 'Admin',
                data: '1990-01-01',
                nazionalita: 'Italiana',
                email: 'admin@admin.it',
                password: 'admin'
            },
            {
                id: 2,
                nome: 'Edoardo',
                cognome: 'Cortinovis',
                data: '1985-05-15',
                nazionalita: 'Italiana',
                email: 'edo.corti@mail.com',
                password: 'edo'
            },
            {
                id: 3,
                nome: 'Cristiano',
                cognome: 'Ronaldo',
                data: '1985-05-15',
                nazionalita: 'Portoghese',
                email: 'cr7@mail.com',
                password: 'cr7'
            }
        ];
        this.nextId = this.utenti.length ? this.utenti[this.utenti.length - 1].id + 1 : 1;
    }

    run(query, params, callback) {
        if (query.startsWith('INSERT INTO utenti')) {
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
            if (callback) callback(null);
            return;
        }
        if (callback) callback(new Error('Query non supportata'));
    }

    get(query, params, callback) {
        if (!Array.isArray(params) || params.length < 1) {
            return callback(new Error(`Parametri insufficienti: ricevuto ${JSON.stringify(params)}`));
        }
    
        if (query.includes('FROM utenti WHERE email = ? AND password = ?')) {
            if (params.length < 2) {
                return callback(new Error('Parametri insufficienti per email e password'));
            }
            const user = this.utenti.find(u => u.email === params[0] && u.password === params[1]);
            if (user) {
                return callback(null, user); // Non rimuovere la password
            }
            return callback(null, null);
        }
    
        if (query.includes('FROM utenti WHERE email = ?')) {
            const user = this.utenti.find(u => u.email === params[0]);
            if (user) {
                return callback(null, user); // Non rimuovere la password
            }
            return callback(null, null);
        }
    
        if (query.includes('FROM utenti WHERE nazionalita = ?')) {
            // Filtra gli utenti per nazionalità
            const filteredUsers = this.utenti.filter(u => u.nazionalita === params[0]);
            return callback(null, filteredUsers);
        }
    
        return callback(new Error('Query non supportata'));
    }
    
    all(query, params, callback) {
        if (query.startsWith('SELECT * FROM utenti')) {
    
            if (params && params.length > 0) {
                // Aggiunto controllo per nazionalita
                const nazionalitaFiltrata = params[0];
                
                const filteredUsers = this.utenti.filter(u => u.nazionalita.toLowerCase() === nazionalitaFiltrata.toLowerCase());
    
                return callback(null, filteredUsers);
            }
    
            // Se non c'è filtro, restituiamo tutti gli utenti
            return callback(null, this.utenti);
        }
        return callback(new Error('Query non supportata'));
    }
    

    close(callback) {
        console.log('Mock DB chiuso');
        callback(null);
    }
}

module.exports = DBMock;
