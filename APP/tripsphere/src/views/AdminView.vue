<template>
  <div class="homepage">
    <div class="container">
      <!-- Sidebar -->
      <aside class="sidebar">
        <nav>
          <ul>
            <li><a @click="goToIntroduction">Introduzione</a></li>
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
                <td>{{ user.nome }}</td>
                <td>{{ user.cognome }}</td>
                <td>{{ user.email }}</td>
                <td>{{ user.nazionalita }}</td>
                <td>{{ user.data }}</td>
                <td>
                  <button @click="editUser(user)" class="edit-btn">
                    <img src="../../public/edit.png">
                  </button>
                  <button @click="showDeleteConfirmation(user.id)" class="delete-btn">
                    <img src="../../public/delete.png">
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Modale per la modifica dell'utente -->
        <div v-if="isEditing" class="modal-overlay">
          <div class="modal-content">
            <h2>Modifica Utente</h2>
            <form @submit.prevent="submitEdit">
              <label for="nome">Nome</label>
              <input type="text" v-model="editedUser.nome" id="nome" required />

              <label for="cognome">Cognome</label>
              <input type="text" v-model="editedUser.cognome" id="cognome" required />

              <label for="email">Email</label>
              <input type="email" v-model="editedUser.email" id="email" required />

              <label for="nazionalita">Nazionalità</label>
              <input type="text" v-model="editedUser.nazionalita" id="nazionalita" required />

              <label for="data">Data di Nascita</label>
              <input type="date" v-model="editedUser.data" id="data" required />

              <div class="modal-actions">
                <button type="submit" class="confirm-btn">Salva</button>
                <button type="button" @click="closeModal" class="cancel-btn">Annulla</button>
              </div>
            </form>
          </div>
        </div>

        <!-- Sezione di Introduzione (solo qui viene visualizzato il messaggio di benvenuto) -->
        <div v-if="isIntroduction">
          <h2>Benvenuto nella dashboard</h2>
          <p>Seleziona un'opzione dalla barra laterale per iniziare.</p>
        </div>

        <!-- Sezione di conferma eliminazione -->
        <div v-if="isDeleting" class="modal-overlay">
          <div class="modal-content">
            <h2>Sei sicuro di voler eliminare questo utente?</h2>
            <div class="modal-actions">
              <button @click="confirmDelete" class="confirm-btn">Elimina</button>
              <button @click="closeDeleteConfirmation" class="cancel-btn">Annulla</button>
            </div>
          </div>
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
      showLogoutConfirmation: false,
      showUserTable: false,
      isIntroduction: true,
      users: [],
      isEditing: false,
      editedUser: {},
      isDeleting: false, // Gestisce la visualizzazione della conferma di eliminazione
      userToDelete: null, // Memorizza l'utente da eliminare
    };
  },
  created() {
    this.fetchUsers();
  },
  methods: {
    // ATTRACTIONS SECTION
    goToIntroduction() {
      this.showLogoutConfirmation = false;
      this.showUserTable = false;
      this.isIntroduction = true;
    },

    // USER SECTION
    showUsers() {
      this.showLogoutConfirmation = false;
      this.isIntroduction = false;
      this.showUserTable = true;
      this.fetchUsers();
    },
    fetchUsers() {
      fetch('http://localhost:3000/utenti', {
        method: 'GET',
        credentials: 'include',
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Errore durante il recupero degli utenti');
          }
          return response.json();
        })
        .then(data => {
          this.users = data.utenti || [];
        })
        .catch(error => {
          console.error('Errore:', error);
        });
    },
    editUser(user) {
      this.isEditing = true;
      this.editedUser = { ...user };
    },
    closeModal() {
      this.isEditing = false;
      this.editedUser = {};
    },
    submitEdit() {
      fetch(`http://localhost:3000/utenti/${this.editedUser.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(this.editedUser),
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Errore durante la modifica dell\'utente');
          }
          this.fetchUsers();
          this.closeModal();
        })
        .catch(error => {
          console.error('Errore:', error);
        });
    },

    // ELIMINAZIONE UTENTE
    showDeleteConfirmation(userId) {
      this.userToDelete = userId;
      this.isDeleting = true;
    },
    closeDeleteConfirmation() {
      this.isDeleting = false;
      this.userToDelete = null;
    },
    confirmDelete() {
      if (this.userToDelete) {
        fetch(`http://localhost:3000/utenti/${this.userToDelete}`, {
          method: 'DELETE',
        })
          .then(response => {
            if (!response.ok) {
              throw new Error('Errore durante l\'eliminazione dell\'utente');
            }
            this.fetchUsers();
            this.closeDeleteConfirmation();
          })
          .catch(error => {
            console.error('Errore:', error);
          });
      }
    },

    // LOGOUT SECTION
    logout() {
      fetch('http://localhost:3000/logout', {
        method: 'POST',
        credentials: 'include',
      })
        .then(() => {
          localStorage.clear();
          this.$router.push("/accedi");
        })
        .catch(error => {
          console.error('Logout failed:', error);
        });
    },
    confirmLogout() {
      this.showUserTable = false;
      this.showLogoutConfirmation = true;
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
  padding: 3px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  margin-right: 5px;
}

.edit-btn {
  color: white;
}

.edit-btn:hover {
  background-color: #a5bad1;
}

.delete-btn {
  color: white;
}

.delete-btn:hover {
  background-color: #a5bad1;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  transition: opacity 0.3s ease;
}

.modal-content {
  background-color: #fff;
  padding: 30px;
  border-radius: 10px;
  width: 450px;
  max-width: 90%;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease-in-out;
  transform: scale(0.95);
}

.modal-content h2 {
  margin-bottom: 20px;
  font-size: 1.5em;
  color: #333;
  text-align: center;
}

.modal-content form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.modal-content label {
  font-weight: bold;
  color: #555;
  margin-bottom: 5px;
}

.modal-content input {
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 1em;
  outline: none;
}

.modal-content input:focus {
  border-color: #ff7f50;
  box-shadow: 0 0 5px rgba(255, 127, 80, 0.7);
}

.modal-actions {
  display: flex;
  justify-content: center;
  margin-top: 25px;
  gap: 15px;
}

.confirm-btn, .cancel-btn {
  padding: 12px 25px;
  font-size: 1em;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.confirm-btn {
  background-color: #ff7f50;
  color: white;
}

.confirm-btn:hover {
  background-color: #e65c38;
}

.cancel-btn {
  background-color: #6c757d;
  color: white;
}

.cancel-btn:hover {
  background-color: #5a6268;
}

.modal-content {
  transform: scale(1);
}

</style>