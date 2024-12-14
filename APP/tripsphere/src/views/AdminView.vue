<template>
  <div class="homepage">
    <div class="container">
      <!-- Sidebar -->
      <aside class="sidebar">
        <nav>
          <ul>
            <li><a @click="goToAttractions">Gestisci Attrazioni</a></li>
            <li><a @click="goToUsers">Gestisci Utenti</a></li>
            <li><a @click="confirmLogout">Logout</a></li>
          </ul>
        </nav>
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <!-- Mostra il messaggio di conferma del logout invece del benvenuto -->
        <div v-if="showLogoutConfirmation">
          <h2>Sei sicuro di voler uscire?</h2>
          <button @click="logout" class="confirm-btn">Logout</button>
        </div>
        <!-- Se il logout non è confermato, mostra il benvenuto -->
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
    };
  },
  methods: {
    goToAttractions() {
      this.$router.push("/gestisci-attrazioni"); // Reindirizza alla pagina di gestione attrazioni
    },
    goToUsers() {
      this.$router.push("/gestisci-utenti"); // Reindirizza alla pagina di gestione utenti
    },
    confirmLogout() {
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
  background: linear-gradient(to bottom, #ff7f50, #351712); /* Gradiente arancione */
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
  font-size: 1.0em;
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

/* Stile per il bottone di logout */
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

</style>
