<template>
  <div class="login-container">
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

      <button type="submit">Registrati</button>

      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
    </form>
    
    <!-- Link alla pagina di login -->
    <p>Hai già un account? <router-link to="/login">Accedi qui</router-link></p>
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
        const response = await fetch('https:localhost/utenti', {
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
          // this.$router.push('/login');
        } else {
          // Mostra un messaggio di errore
          this.errorMessage = result.message || 'Errore nella registrazione.';
          this.successMessage = ''; // Pulisci eventuali messaggi di successo
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
        this.successMessage = ''; // Pulisci eventuali messaggi di successo
      }
    },
  },
};
</script>

<style scoped>
.login-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
}
.form-group {
  margin-bottom: 15px;
}
input {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
}
button {
  width: 100%;
  padding: 10px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 5px;
}
.error-message {
  color: red;
  margin-top: 10px;
}
.success-message {
  color: green;
  margin-top: 10px;
}
</style>
