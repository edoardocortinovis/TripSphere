<template>
  <div class="homepage">
    <header>
      <div class="logo">
        <h1>TripSphere</h1>
      </div>
      <div class="account-area">
        <div class="language-selector">
          <select v-model="selectedLanguage" @change="changeLanguage">
            <option value="en">English</option>
            <option value="it">Italiano</option>
            <option value="fr">Français</option>
            <option value="de">Deutsch</option>
          </select>
        </div>
        <div class="account-icon">
          <img src="/APP/tripsphere/src/assets/aerei.png" alt="Account" @click="goToAccount" />
        </div>
      </div>
    </header>

    <div class="main-content">
      <div class="search-container">
        <input type="text" placeholder="Cerca destinazioni, voli, hotel..." v-model="searchQuery" />
        <button @click="performSearch">Cerca</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomePage',
  data() {
    return {
      searchQuery: '',
      selectedLanguage: 'en',
    };
  },
  methods: {
    performSearch() {
      console.log('Searching for:', this.searchQuery);
      // Logica di ricerca
    },
    goToAccount() {
      this.$router.push('/account'); // Reindirizza alla pagina dell'account
    },
    changeLanguage() {
      console.log('Lingua selezionata:', this.selectedLanguage);
      // Implementare la logica per cambiare la lingua
    },
  },
};
</script>

<style scoped>
.homepage {
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #f0f4f8;
}

header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 20px;
  background-color: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: fixed;
  top: 0;
  z-index: 1000;
}

.logo h1 {
  font-size: 2em;
  margin: 0;
  padding-left: 20px;
}

.account-area {
  display: flex;
  align-items: center;
}

.language-selector select {
  border: none;
  background-color: transparent;
  padding: 5px;
  margin-right: 20px;
  font-size: 1em;
}

.account-icon img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  cursor: pointer;
}

.main-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  padding-top: 100px; /* Spazio per il menu fisso */
}

.search-container {
  display: flex;
  align-items: center;
  background-color: #ffffff;
  padding: 10px;
  border-radius: 10px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.search-container input {
  padding: 10px;
  border: none;
  font-size: 1.2em;
  width: 400px;
}

.search-container button {
  padding: 10px 20px;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-left: 10px;
}

.search-container button:hover {
  background-color: #45a049;
}
</style>
