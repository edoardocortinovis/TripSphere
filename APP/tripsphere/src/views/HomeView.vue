<template>
  <div class="homepage">
    <header>
      <div class="logo">
        <h1>TripSphere</h1>
      </div>
      <div class="account-area">
        <div class="live-user">
          <p>UTENTI COLLEGATI :    </p>
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

    <!-- Nuova sezione per le card -->
    <div class="cards-section">
      <h2>Scopri le destinazioni</h2>
      <div class="cards-container">
        <div class="card" v-for="card in cards" :key="card.id">
          <img :src="card.image" alt="Destination" />
          <h3>{{ card.title }}</h3>
          <p>{{ card.description }}</p>
          <button @click="viewDetails(card.id)">Vedi Dettagli</button>
        </div>
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
      // Lista di card come esempio (potresti cambiarla con un'API)
      cards: [
        { id: 1, title: 'Parigi', description: 'La città della luce.', image: '@/assets/paris.jpg' },
        { id: 2, title: 'Roma', description: 'La città eterna.', image: '@/assets/rome.jpg' },
        { id: 3, title: 'Londra', description: 'La capitale inglese.', image: '@/assets/london.jpg' },
      ],
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
    viewDetails(id) {
      console.log('Viewing details for card ID:', id);
    },
  },
};
</script>

<style scoped>
.homepage {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  background: url('@/assets/aerei.png') no-repeat center center;
  background-size: cover;
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

.account-text {
  cursor: pointer;
  color: white;
  margin-right: 20px;
  margin-left: 10px;
  background-color: rgb(219, 143, 0);
  border-radius: 10px;
  padding: 8px;
}

.account-text:hover {
  background-color: rgb(169, 110, 1);
}

.account-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  border-radius: 100%;
  white-space: nowrap;
}

.live-user select {
  border: none;
  background-color: white;
  padding: 10px;
  margin-right: 20px;
  font-size: 1em;
}

.account-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 50px;
}

.main-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  padding-top: 100px;
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

h2{
  color: white;
}

/* Sezione card */
.cards-section {
  width: 80%;
  margin-top: 100px; /* Separato dalla search bar */
  text-align: center;
  margin-bottom: 20px;
}

.cards-section h2 {
  font-size: 2em;
  margin-bottom: 20px;
}

.cards-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr); /* 3 card per riga */
  gap: 20px;
}

.card {
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.card img {
  width: 100%;
  border-radius: 8px;
  height: 200px;
  object-fit: cover;
}

.card h3 {
  font-size: 1.5em;
  margin-top: 10px;
}

.card p {
  font-size: 1em;
  color: #555;
  margin-top: 10px;
}

.card button {
  margin-top: 10px;
  padding: 10px 20px;
  background-color: rgb(219, 143, 0);
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.card button:hover {
  background-color: rgb(169, 110, 1);
}

@media (max-width: 768px) {
  .cards-section {
    width: 95%;
  }

  .card img {
    height: 180px;
  }

  .cards-container {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  }
}

@media (max-width: 480px) {
  .card img {
    height: 160px;
  }
}
</style>
