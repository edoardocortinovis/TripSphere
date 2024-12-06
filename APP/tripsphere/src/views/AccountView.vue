<template>
  <div class="profile-container">
    <div class="sidebar">
      <ul>
        <li>
          <a href="#" @click="setSelectedSection('dati')" :class="{ active: selectedSection === 'dati' }">Dati</a>
        </li>
        <li>
          <a href="#" @click="setSelectedSection('preferiti')"
            :class="{ active: selectedSection === 'preferiti' }">Preferiti</a>
        </li>
        <li>
          <a href="#" @click="setSelectedSection('Esci')" :class="{ active: selectedSection === 'Esci' }">Esci</a>
        </li>
      </ul>

    </div>

    <div class="main-content">
      <!-- Sezione Dati -->
      <div v-if="selectedSection === 'dati'" class="section">
        <h3>Informazioni Account</h3>
        <form @submit.prevent="updateProfile">
          <label for="full-name">Nome completo:</label>
          <input type="text" id="full-name" v-model="user.name" required />

          <label for="email">Email:</label>
          <input type="email" id="email" v-model="user.email" required />

          <button type="submit">Salva modifiche</button>
        </form>
      </div>

      <!-- Sezione Preferiti -->
      <div v-if="selectedSection === 'preferiti'" class="section">
        <h3>I miei Preferiti</h3>
        <ul>
          <li v-for="favorite in favorites" :key="favorite.id">{{ favorite.name }}</li>
        </ul>
      </div>

      <div v-if="selectedSection === 'Esci'" class="section">
        <h3>Sicuro di Voler Uscire</h3>
        <ul>
          <button @click="Logout">Esci</button>
        </ul>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      selectedSection: 'dati',  // Sezione selezionata inizialmente
      user: {
        name: 'Mario Rossi',
        email: 'mario.rossi@example.com',
      },
      favorites: [
        { id: 1, name: 'Roma' },
        { id: 2, name: 'Milano' },
        { id: 3, name: 'Parigi' },
      ],
    };
  },
  methods: {
    setSelectedSection(section) {
      this.selectedSection = section;
    },
    updateProfile() {
      console.log("Profilo aggiornato:", this.user);
    },
  Logout() {
    fetch('http://localhost:3000/logout', {
      method: 'POST',
      credentials: 'include', // Necessario per includere i cookie
    })
      .then((response) => {
        if (response.ok) {
          console.log('Logout effettuato');
          this.$router.push('/accedi'); // Reindirizza alla pagina di login
        } else {
          console.error('Errore durante il logout');
        }
      })
      .catch((error) => console.error('Errore di rete:', error));
  },


  },
};
</script>


<style scoped>
.profile-container {
  display: flex;
  height: 100vh;
  background-color: #f4f4f9;
  font-family: 'Roboto', sans-serif;
}

.sidebar {
  width: 260px;
  background-color: #333;
  color: #fff;
  padding: 30px 20px;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
  border-radius: 10px 0 0 10px;
}

.sidebar ul {
  list-style-type: none;
  padding: 0;
}

.sidebar ul li {
  margin: 20px 0;
}

.sidebar ul li a {
  text-decoration: none;
  color: #fff;
  font-size: 18px;
  font-weight: 500;
  transition: color 0.3s;
}

.sidebar ul li a.active,
.sidebar ul li a:hover {
  color: #ffd700;
}

.main-content {
  flex: 1;
  padding: 40px;
  background-color: #fff;
  border-radius: 10px;
  margin-left: 20px;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.section {
  margin-top: 20px;
}

.section h3 {
  font-size: 22px;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
}

.section label {
  font-size: 14px;
  color: #555;
  margin: 8px 0 5px;
}

.section input {
  width: 100%;
  padding: 12px;
  margin-bottom: 20px;
  border: 2px solid #ddd;
  border-radius: 6px;
  background-color: #f9f9f9;
  font-size: 16px;
  transition: border-color 0.3s;
}

.section input:focus {
  border-color: #4CAF50;
  outline: none;
  background-color: #fff;
}

.section button {
  padding: 12px 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.section button:hover {
  background-color: #45a049;
}

ul {
  padding-left: 20px;
}

li {
  margin: 10px 0;
  font-size: 16px;
  color: #333;
}
</style>