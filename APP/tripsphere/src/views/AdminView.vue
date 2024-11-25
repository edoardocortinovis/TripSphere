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
            <a class="account-text" @click="goToAccount">Account</a>
          </div>
        </div>
      </header>
      <div class="main-content">
        <div class="search-container">
            <button class="open-modal-btn" @click="openModal">Apri finestra</button>
        </div>
        <!-- Pulsante per aprire la finestra -->
      </div>
  
      <!-- Finestra modale -->
      <div class="modal" v-if="isModalOpen">
        <div class="modal-content">
          <h2>Inserisci i dati dell'applicazione</h2>
          <form @submit.prevent="submitApplication">
            <label for="data1">Dato 1:</label>
            <input id="data1" v-model="applicationData.data1" type="text" required />
  
            <br>

            <label for="data2">Dato 2:</label>
            <input id="data2" v-model="applicationData.data2" type="text" required />
  
            <div class="modal-buttons">
              <button type="submit">Invia</button>
              <button type="button" @click="closeModal">Chiudi</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script>

  
  export default {
    name: "HomePage",
    data() {
      return {
        searchQuery: "",
        selectedLanguage: "en",
        isModalOpen: false, // Stato per controllare la visibilità della finestra modale
        applicationData: {
          data1: "",
          data2: "",
        },
      };
    },
    methods: {

  login() {
    const credentials = {
      email: this.email,
      password: this.password,
    };

    // Utilizza 'fetch' per inviare la richiesta al backend
    fetch('http://localhost:3000/accedi', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(credentials),
    })
    .then(response => response.json())  // Elabora la risposta JSON
    .then(data => {
      if (data.isAdmin) {
        // Se è un admin, redirigi alla vista admin
        console.log('Redirecting to: ', data.redirectUrl);  // Aggiungi un log per vedere il valore di redirectUrl
        this.$router.push(data.redirectUrl);  // Esegui il reindirizzamento
      } else {
        // Se è un utente normale, redirigi alla home
        this.$router.push('/');
      }
    })
    .catch(error => {
      console.error('Login failed:', error);
      alert('Credenziali errate');
    });
},
  

      performSearch() {
        console.log("Searching for:", this.searchQuery);
        // Logica di ricerca
      },
      goToAccount() {
        this.$router.push("/account"); // Reindirizza alla pagina dell'account
      },
      changeLanguage() {
        console.log("Lingua selezionata:", this.selectedLanguage);
        // Implementare la logica per cambiare la lingua
      },
      openModal() {
        this.isModalOpen = true; // Mostra la finestra modale
      },
      closeModal() {
        this.isModalOpen = false; // Nasconde la finestra modale
      },
      submitApplication() {
        console.log("Dati inviati:", this.applicationData);
        // Logica per gestire i dati inviati
        this.closeModal(); // Chiudi la finestra dopo l'invio
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
  
  .account-text {
    cursor: pointer;
    margin-right: 20px;
    margin-left: 10px;
  }
  
  .language-selector select {
    border: none;
    background-color: transparent;
    padding: 5px;
    margin-right: 20px;
    font-size: 1em;
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
  }
  
  .search-container button:hover {
    background-color: rgb(169, 110, 1);
  }
  
  .open-modal-btn {
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .open-modal-btn:hover {
    background-color: #0056b3;
  }
  
  /* Stile della finestra modale */
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
  }
  
  .modal-content {
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    width: 400px;
    max-width: 90%;
  }
  
  .modal-content h2 {
    margin-top: 0;
  }
  
  .modal-buttons {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
  }
  
  .modal-buttons button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .modal-buttons button[type="submit"] {
    background-color: #28a745;
    color: white;
  }
  
  .modal-buttons button[type="submit"]:hover {
    background-color: #218838;
  }
  
  .modal-buttons button[type="button"] {
    background-color: #dc3545;
    color: white;
  }
  
  .modal-buttons button[type="button"]:hover {
    background-color: #c82333;
  }
  </style>
  