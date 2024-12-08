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
          <!--<img :src="require('@/assets/aerei.png')" @click="goToAccount" />-->
          <a class="account-text" @click="goToAccount">Account</a>
        </div>
      </div>
    </header>
    <div class="main-content">
      <div class="search-container">
        <input type="text" placeholder="Dove vuoi andare" v-model="searchQuery" />
        <button @click="performSearch">Cerca</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomeView',
  data() {
    return {
      searchQuery: '',
      selectedLanguage: 'en',
    };
  },
  methods: {
    performSearch() {
      console.log('Searching for:', this.searchQuery);
    },
    goToAccount() {
      this.$router.push('/account'); 
    },
    changeLanguage() {
      console.log('Lingua selezionata:', this.selectedLanguage);
    },
  },
};
</script>

<style scoped>
.homepage {
  height: 89vh;
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

.account-text{
  cursor: pointer;
  margin-right: 20px;
  margin-left: 10px;
}

/* .account-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  border-radius: 100%;
  white-space: nowrap; 
} */

.language-selector select {
  border: none;
  background-color: transparent;
  padding: 5px;
  margin-right: 20px;
  font-size: 1em;
}

.account-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  /*width: 50px; /* Dimensiona l'area dell'icona */
  height: 50px; /* Evita che il testo o l'immagine escano */
}

.account-icon img {
  max-width: 100%; /* Assicura che l'immagine si adatti */
  height: auto;
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
  background-color: rgb(219, 143, 0);
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-left: 10px;
}

.search-container button:hover {
  background-color: rgb(169, 110, 1);
}
</style>
