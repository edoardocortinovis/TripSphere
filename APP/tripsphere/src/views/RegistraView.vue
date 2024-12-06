<template>
  <div class="login-container" v-if="!isLoggedIn">
    <h2>Registrati</h2>
    <form @submit.prevent="registerUser">
      <div class="form-group">
        <label for="nome">Nome</label>
        <input type="text" id="nome" v-model="nome" required />
      </div>

      <div class="form-group">
        <label for="cognome">Cognome</label>
        <input type="text" id="cognome" v-model="cognome" required />
      </div>

      <div class="form-group">
        <label for="data">Data di Nascita</label>
        <input type="date" id="data" v-model="data" required />
      </div>

      <div class="form-group">
        <label for="nazionalita">Nazionalità</label>
        <input type="text" id="nazionalita" v-model="nazionalita" required />
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" v-model="email" required />
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" v-model="password" required />
      </div>

      <button type="submit" class="submit-button">Registrati</button>

      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
    </form>

    <p class="login-link">Hai già un account? <router-link to="/accedi">Accedi qui</router-link></p>
  </div>
  <div v-else>
    <!-- Se l'utente è già loggato, puoi mostrare un messaggio di benvenuto o reindirizzare automaticamente -->
    <p>Sei già registrato, verrai reindirizzato alla home...</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      nome: '',
      cognome: '',
      data: '',
      nazionalita: '',
      email: '',
      password: '',
      errorMessage: '',
      successMessage: '',
      isLoggedIn: false, // Variabile per controllare se l'utente è loggato
    };
  },
  methods: {
    async registerUser() {
      const userData = {
        nome: this.nome,
        cognome: this.cognome,
        data: this.data,
        nazionalita: this.nazionalita,
        email: this.email,
        password: this.password,
      };

      try {
        const response = await fetch('http://localhost:3000/registra', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(userData),
        });

        const result = await response.json();

        if (response.ok) {
          // Se la registrazione è andata a buon fine
          this.successMessage = 'Registrazione avvenuta con successo!';
          this.errorMessage = ''; // Pulisci eventuali messaggi di errore

          // Puoi anche reindirizzare l'utente a un'altra pagina, se necessario
          this.$router.push('/accedi');
        } else {
          // Mostra un messaggio di errore
          this.errorMessage = result.message || 'Errore nella registrazione.';
          this.successMessage = ''; // Pulisci eventuali messaggi di successo
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
        //this.successMessage = ''; // Pulisci eventuali messaggi di successo
      }
    },
  },
  mounted() {
    // Verifica se l'utente è già loggato
    if (localStorage.getItem('loggedIn') === 'true') {
      this.isLoggedIn = true;
      this.$router.push('/home'); // Se è loggato, reindirizza alla home
    }
  },
};
</script>

<style scoped>
.login-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 2rem;
  background-color: #f9f9f9;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-align: center;
}

h2 {
  font-size: 24px;
  margin-bottom: 1.5rem;
  color: #333;
}

.form-group {
  margin-bottom: 1.2rem;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 0.4rem;
  font-weight: 500;
  color: #555;
}

input {
  width: calc(100% - 10px); /* Larghezza ridotta per creare spazio */
  padding: 0.75rem;
  font-size: 16px;
  border: 1px solid #ddd;
  border-radius: 12px;
  background-color: #fff;
  color: #333;
  margin-right: 10px; /* Spazio a destra */
  outline: none;
  transition: border-color 0.3s;
}

input:focus {
  border-color: rgb(219, 143, 0);
}

.submit-button {
  width: 100%;
  padding: 0.8rem;
  background-color: rgb(219, 143, 0);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-button:hover {
  background-color: rgb(169, 110, 1);
}

.error-message {
  color: red;
  margin-top: 1rem;
}

.success-message {
  color: #2ecc71;
  margin-top: 1rem;
}

.login-link {
  margin-top: 2rem;
  font-size: 14px;
}

.login-link a {
  color: rgb(219, 143, 0);
  text-decoration: none;
  font-weight: 500;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
