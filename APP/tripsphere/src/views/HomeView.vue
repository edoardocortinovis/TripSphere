<template>
  <div class="home">
    <div class="content">
      <div class="overlay">
        <h1>Trip Sphere</h1>
        <p>Esplora il mondo con noi!</p>
        <button @click="goToAccedi">Accedi</button>
        <button @click="goToRegistra">Registrati</button>
      </div>
      <div class="features">
        <h2>Le nostre funzionalità</h2>
        <ul>
          <li>🌍 Scopri nuove destinazioni</li>
          <li>✈️ Prenota voli e hotel</li>
          <li>🗺️ Crea il tuo itinerario personalizzato</li>
          <li>🤝 Unisciti alla nostra comunità di viaggiatori</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
//import AccediView from './AccediView.vue';
//import RegistraView from './RegistraView.vue';

export default {
  name: 'HomeView',
  methods: {
    goToAccedi() {
      this.$router.push('/accedi'); // Reindirizza alla pagina di login
    },
    goToRegistra() {
      this.$router.push('/registra'); // Reindirizza alla pagina di registrazione
    },
  },
};
</script>

<style scoped>
.home {
  position: absolute; /* Cambiato da relative a absolute */
  top: 0;
  left: 0;
  height: 100vh;
  width: 100vw; /* Assicura che copra tutta la larghezza */
  overflow: hidden;
  display: flex;
  align-items: center; /* Allinea verticalmente al centro */
  justify-content: center; /* Allinea orizzontalmente al centro */
  background-image: url('@/assets/aereoporto.png'); /* Usa il percorso corretto */
  background-size: cover; /* Assicura che l'immagine copra l'intera area */
  background-position: center; /* Centra l'immagine */ /* Riduce la luminosità dell'immagine */
}

.content {
  display: flex; /* Usa Flexbox per allineare i contenuti */
  justify-content: space-between; /* Spazio tra le colonne */
  width: 80%; /* Larghezza del contenitore per le colonne */
}

.overlay {
  flex: 1; /* Prende una porzione della larghezza */
  margin-right: 20px; /* Margine destro per separare dall'altra colonna */
  z-index: 2;
  background-color: rgba(0, 0, 0, 0.5); /* Overlay semi-trasparente */
  color: white;
  padding: 20px;
  text-align: left; /* Allinea il testo a sinistra */
  border-radius: 10px;
}

.features {
  flex: 1; /* Prende una porzione della larghezza */
  z-index: 2;
  color: white;
  text-align: left; /* Allinea il testo a sinistra */
}

h1 {
  font-size: 3em;
  margin: 0;
}

p {
  font-size: 1.5em;
}

button {
  background-color: #4CAF50; /* Colore verde */
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1em;
  margin-top: 20px;
  margin-right: 10px; /* Margine destro per il pulsante di registrazione */
}

button:hover {
  background-color: #45a049; /* Colore verde scuro al passaggio del mouse */
}

.features h2 {
  font-size: 2em;
  margin-bottom: 10px;
}

.features ul {
  list-style-type: none; /* Rimuove i punti dalla lista */
  padding: 0; /* Rimuove il padding della lista */
}

.features li {
  font-size: 1.2em; /* Dimensione del testo della lista */
  margin: 5px 0; /* Spaziatura tra gli elementi della lista */
}
</style>
