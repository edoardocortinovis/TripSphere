<template>
  <div class="homepage">
    <div class="container">
      <!-- Sidebar -->
      <aside class="sidebar">
        <nav>
          <ul>
            <li><a @click="goToAttractions">Gestisci Attrazioni</a></li>
            <li><a @click="showUsers">Gestisci Utenti</a></li>
            <li><a @click="confirmLogout">Logout</a></li>
          </ul>
        </nav>
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <!-- Mostra il messaggio di conferma del logout -->
        <div v-if="showLogoutConfirmation">
          <h2>Sei sicuro di voler uscire?</h2>
          <button @click="logout" class="confirm-btn">Logout</button>
        </div>

        <!-- Mostra la tabella degli utenti -->
        <div v-else-if="showUserTable">
          <h2>Gestisci Utenti</h2>
          <table class="user-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Cognome</th>
                <th>Email</th>
                <th>Nazionalità</th>
                <th>Data di Nascita</th>
                <th>Azioni</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="user in users" :key="user.id">
                <td>{{ user.id }}</td>
                <td>{{ user.nome }}</td>
                <td>{{ user.cognome }}</td>
                <td>{{ user.email }}</td>
                <td>{{ user.nazionalita }}</td>
                <td>{{ user.data }}</td>
                <td>
                  <button @click="editUser(user)" class="edit-btn">Modifica</button>
                  <button @click="deleteUser(user.id)" class="delete-btn">Elimina</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Mostra il messaggio di benvenuto -->
        <div v-else>
          <h2>Benvenuto nella dashboard</h2>
          <p>Seleziona un'opzione dalla barra laterale per iniziare.</p>
        </div>
      </main>
    </div>
  </div>
</template>

<script>
export default {
  name: "HomePage",
  data() {
    return {
      showLogoutConfirmation: false, // Stato per la conferma del logout
      showUserTable: true, // Stato iniziale: mostra subito la tabella degli utenti
      users: [], // Array per memorizzare gli utenti recuperati dal database
    };
  },
  created() {
    // Carica gli utenti non appena la pagina viene caricata
    this.fetchUsers();
  },
  methods: {
    goToAttractions() {
      this.$router.push("/gestisci-attrazioni"); // Reindirizza alla pagina di gestione attrazioni
    },
    showUsers() {
      this.showLogoutConfirmation = false;
      this.showUserTable = true; // Mostra la tabella degli utenti
      this.fetchUsers(); // Recupera gli utenti dal database
    },
    confirmLogout() {
      this.showUserTable = false;
      this.showLogoutConfirmation = true; // Mostra il messaggio di conferma
    },
    logout() {
      fetch('http://localhost:3000/logout', {
        method: 'POST',
        credentials: 'include', // Include cookie di sessione
      })
        .then(() => {
          localStorage.clear();
          this.$router.push("/accedi"); // Reindirizza alla pagina di login
        })
        .catch(error => {
          console.error('Logout failed:', error);
        });
    },
    fetchUsers() {
      fetch('http://localhost:3000/utenti', {
        method: 'GET',
        credentials: 'include', // Include i cookie di sessione
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Errore durante il recupero degli utenti');
          }
          return response.json();
        })
        .then(data => {
          console.log('Utenti recuperati:', data);
          this.users = data.utenti; // Aggiorna l'array degli utenti
        })
        .catch(error => {
          console.error('Errore:', error);
        });
    },
    editUser(user) {
      // Chiede di modificare il nome dell'utente come esempio
      const nuovoNome = prompt("Modifica il nome dell'utente:", user.nome);
      if (nuovoNome) {
        fetch(`http://localhost:3000/utenti/${user.id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ nome: nuovoNome }),
        })
          .then(response => {
            if (!response.ok) {
              throw new Error('Errore durante la modifica dell\'utente');
            }
            this.fetchUsers(); // Aggiorna la lista degli utenti
          })
          .catch(error => {
            console.error('Errore:', error);
          });
      }
    },
    deleteUser(userId) {
      if (confirm("Sei sicuro di voler eliminare questo utente?")) {
        fetch(`http://localhost:3000/utenti/${userId}`, {
          method: 'DELETE',
        })
          .then(response => {
            if (!response.ok) {
              throw new Error('Errore durante l\'eliminazione dell\'utente');
            }
            this.fetchUsers(); // Aggiorna la lista degli utenti
          })
          .catch(error => {
            console.error('Errore:', error);
          });
      }
    },
  },
};
</script>

<style scoped>
.homepage {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.container {
  display: flex;
  flex: 1;
}

.sidebar {
  width: 250px;
  background: linear-gradient(to bottom, #ff7f50, #351712);
  color: white;
  padding: 20px;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
}

.sidebar nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar nav ul li {
  margin: 15px 0;
}

.sidebar nav ul li a {
  color: white;
  text-decoration: none;
  font-size: 1em;
  cursor: pointer;
}

.sidebar nav ul li a:hover {
  text-decoration: underline;
}

.main-content {
  flex: 1;
  padding: 40px;
  background-color: #f8f9fa;
  position: relative;
}

.main-content h2 {
  margin-top: 0;
}

.confirm-btn {
  padding: 10px 20px;
  background-color: #ff7f50;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.confirm-btn:hover {
  background-color: #e65c38;
}

.user-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.user-table th,
.user-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.user-table th {
  background-color: #ff7f50;
  color: white;
}

.edit-btn,
.delete-btn {
  padding: 5px 10px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  margin-right: 5px;
}

.edit-btn {
  background-color: #007bff;
  color: white;
}

.edit-btn:hover {
  background-color: #0056b3;
}

.delete-btn {
  background-color: #dc3545;
  color: white;
}

.delete-btn:hover {
  background-color: #a71d2a;
}
</style>
