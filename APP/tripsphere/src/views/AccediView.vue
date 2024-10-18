<template>
  <div class="login-container">
    <h1>Login</h1>
    <form @submit.prevent="loginUser">
      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" v-model="email" required />
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" v-model="password" required />
      </div>

      <button type="submit">Accedi</button>

      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: '',
    };
  },
  methods: {
    async loginUser() {
      const loginData = {
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
