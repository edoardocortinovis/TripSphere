<template>
  <div class="homepage">
    <header>
      <div class="logo">
        <h1>TripSphere</h1>
      </div>
      <div class="account-area">
        <div class="live-user">
          <p>UTENTI COLLEGATI : {{ connectedUsers }}      , </p>
        </div>
        <div class="account-icon">
          <a class="account-text" @click="goToAccount">Account</a>
        </div>
      </div>
    </header>

    <div class="main-content">
      <div class="search-container">
        <input
          type="text"
          placeholder="Dove vuoi andare"
          v-model="searchQuery"
        />
        <!-- Puoi mantenere il bottone se desideri un'azione aggiuntiva, altrimenti il filtro è dinamico -->
        <button @click="performSearch">Cerca</button>
      </div>
    </div>

    <!-- Sezione per le card -->
    <div class="cards-section">
      <h2>Scopri le destinazioni</h2>
      <div class="cards-container">
        <div class="card" v-for="(card, index) in filteredCards" :key="index">
          <img :src="card.imageUrl" alt="Attraction Image" />
          <h3>{{ card.name }}</h3>
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
      cards: [], // Verrà popolato con i dati dell'API
      connectedUsers: 0, // Variabile per memorizzare il numero di utenti connessi
      ws: null, // Oggetto WebSocket
    };
  },
  computed: {
    filteredCards() {
      // Se non c'è nulla nella search, restituisci tutte le card
      if (!this.searchQuery.trim()) {
        return this.cards;
      }
      // Filtra le card in base al nome, case insensitive
      return this.cards.filter(card =>
        card.name.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    }
  },
  methods: {
    async fetchAttractions() {
      try {
        const response = await fetch(
          'https://api.jsonbin.io/v3/b/67cc4077ad19ca34f818a4b7',
          {
            headers: {
              'X-Master-Key':
                '$2a$10$cyEZuzQe51UOmCHsKrvHf.t0nN7eBHMbcNQHTpQ8.XE4kzoRl7WGq'
            }
          }
        );
        const data = await response.json();
        console.log('Dati ricevuti:', data);
        // Se data.record è un array, usalo direttamente. Altrimenti, incapsulalo in un array.
        if (data && data.record) {
          if (Array.isArray(data.record)) {
            this.cards = data.record;
          } else {
            this.cards = [data.record];
          }
        } else {
          console.error('Struttura dati non valida', data);
        }
      } catch (error) {
        console.error('Errore durante il recupero dei dati:', error);
      }
    },
    performSearch() {
      // Questo metodo non è strettamente necessario dato il filtro dinamico
      console.log('Ricerca per:', this.searchQuery);
    },
    goToAccount() {
      this.$router.push('/account');
    },
    setupWebSocket() {
      // Connessione al server WebSocket
      this.ws = new WebSocket('ws://localhost:3000');

      // Gestione dei messaggi ricevuti dal server
      this.ws.onmessage = (event) => {
        const message = JSON.parse(event.data);
        if (message.type === 'connectedUsers') {
          this.connectedUsers = message.count; // Aggiorna il numero di utenti connessi
        }
      };

      // Gestione degli errori
      this.ws.onerror = (error) => {
        console.error('WebSocket error:', error);
      };

      // Gestione della chiusura della connessione
      this.ws.onclose = () => {
        console.log('WebSocket connection closed');
      };
    }
  },
  mounted() {
    // Effettua la chiamata API una sola volta quando il componente viene montato
    this.fetchAttractions();

    // Configura la connessione WebSocket
    this.setupWebSocket();
  },
  beforeUnmount() {
    // Chiudi la connessione WebSocket quando il componente viene distrutto
    if (this.ws) {
      this.ws.close();
    }
  }
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

.main-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 30vh;
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

h2 {
  color: white;
}

/* Sezione card */
.cards-section {
  width: 80%;
  text-align: center;
  margin-bottom: 20px;
}

.cards-section h2 {
  font-size: 2em;
  margin-bottom: 20px;
}

.cards-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
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
