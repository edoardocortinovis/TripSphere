<template>
  <div class="login-container">
    <h2>Login</h2>
    <form @submit.prevent="loginUser">
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

      <button type="submit">Login</button>

      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
    </form>
    
    <!-- Link alla pagina di registrazione -->
    <p>Non hai un account? <router-link to="/accedi">Accedi qui</router-link></p>
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
    };
  },
  methods: {
    async loginUser() {
      const loginData = {
        nome: this.nome,
        cognome: this.cognome,
        data: this.data,
        nazionalita: this.nazionalita,
        email: this.email,
        password: this.password,
      };

      try {
        const response = await fetch('http://localhost:3000/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(loginData),
        });

        const result = await response.json();

        if (response.ok) {
          // Memorizza i dati dell'utente nel local storage o nello stato dell'applicazione
          localStorage.setItem('user', JSON.stringify(result.user));
          
          // Login riuscito
          alert('Login riuscito!');
          
          // Qui puoi reindirizzare l'utente ad un'altra pagina, per esempio:
          // this.$router.push('/dashboard');
        } else {
          // Mostra un messaggio di errore
          this.errorMessage = result.message || 'Errore di login.';
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
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
</style>
