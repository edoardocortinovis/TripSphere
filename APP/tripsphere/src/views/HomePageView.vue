<template>
  <div class="home">
    <div class="content">
      <div class="overlay">
        <h1>TripSphere</h1>
        <p>Esplora il mondo con noi!</p>
        <div class="button-container">
          <button @click="goToAccedi"><b>Accedi</b></button>
          <button @click="goToRegistra"><b>Registrati</b></button>
          <button @click="goToApp"><b>Continua senza account</b></button>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomePageView',
  methods: {
    goToAccedi() {
      this.$router.push('/accedi'); // Reindirizza alla pagina di login
    },
    goToRegistra() {
      this.$router.push('/registra'); // Reindirizza alla pagina di registrazione
    },
    goToApp() {
      this.$router.push('/home'); // Reindirizza alla pagina di registrazione
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
  background-position: center; /* Centra l'immagine */
}

.content {
  display: flex; /* Usa Flexbox per allineare i contenuti */
  justify-content: center; /* Centra i contenuti */
  width: 80%; /* Larghezza del contenitore per le colonne */
}

.button-container {
  display: flex;
  justify-content: center; /* Centra i bottoni */
  margin-top: 20px; /* Spaziatura sopra i bottoni */
}

button {
  background-color: #ffffff; /* Colore verde */
  color: black;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1em;
  margin: 0 10px; /* Margini laterali per i pulsanti */
}

button:hover {
  background-color: #c0bdbd; /* Colore verde scuro al passaggio del mouse */
}

h1 {
  font-size: 100px;
  margin: 0;
}

p {
  font-size: 25px;
}

.content {
  display: flex; /* Usa Flexbox per allineare i contenuti */
  justify-content: flex-start; /* Allinea i contenuti a sinistra */
  width: 80%; /* Larghezza del contenitore per le colonne */
}

.overlay {
  z-index: 2;
  background-color: rgba(0, 0, 0, 0.55); /* Overlay semi-trasparente */
  color: white;
  padding: 40px; /* Maggiore padding per un aspetto più arioso */
  text-align: left; /* Allinea il testo a sinistra */
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5); /* Ombra per il titolo */
}

.button-container {
  display: flex;
  justify-content: flex-start; /* Allinea i bottoni a sinistra */
  margin-top: 20px; /* Spaziatura sopra i bottoni */
}

</style>
