<template>
  <div class="home">
    <img src="/APP/tripsphere/src/assets/aereoporto.png" alt="Logo" class="logo">
    <div class="overlay">
      <h1>Trip Sphere</h1>
      <p>Esplora il mondo con noi!</p>
      <button @click="goToLogin">Accedi</button>
      <button @click="goToRegister">Registrati</button>
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
</template>

<script>
export default {
  name: 'HomeView',
  methods: {
    goToLogin() {
      this.$router.push('/login'); // Reindirizza alla pagina di login
    },
    goToRegister() {
      this.$router.push('/register'); // Reindirizza alla pagina di registrazione
    },
  },
};
</script>

<style scoped>
.home {
  position: relative;
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.logo {
  position: absolute;
  top: 20px; /* Regola la posizione del logo */
  z-index: 2;
  width: 150px; /* Regola la larghezza del logo */
}

.overlay {
  position: relative;
  z-index: 2;
  background-color: rgba(0, 0, 0, 0.5); /* Overlay semi-trasparente */
  color: white;
  padding: 20px;
  text-align: center;
  border-radius: 10px;
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

.features {
  position: relative;
  z-index: 2;
  color: white;
  text-align: center;
  margin-top: 40px; /* Distanza dalla parte superiore */
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
