<template>
  <div class="login-container">
    <h2>Accedi</h2>
    <form @submit.prevent="loginUser">
      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" v-model="email" required />
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" v-model="password" required />
      </div>

      <button type="submit" class="submit-button">Accedi</button>
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
    </form>
    <p class="login-link">Non hai un account? <router-link to="/registra">Registrati qui</router-link></p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: '',
      successMessage: '',
    };
  },
  methods: {
    async loginUser() {
      const loginData = { email: this.email, password: this.password };

      try {
        const response = await fetch('http://localhost:3000/accedi', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(loginData),
        });
        const result = await response.json();

        if (response.ok) {
          localStorage.setItem('authToken', result.token);

          const payload = JSON.parse(atob(result.token.split('.')[1]));
          this.successMessage = 'Accesso effettuato con successo!';
          this.errorMessage = '';

          if (payload.role === 'admin') {
            this.$router.push('/admin');
          } else {
            this.$router.push('/home');
          }
        } else {
          this.errorMessage = result.message || 'Credenziali errate.';
        }
      } catch {
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
  width: calc(100% - 10px);
  padding: 0.75rem;
  font-size: 16px;
  border: 1px solid #ddd;
  border-radius: 12px;
  background-color: #fff;
  color: #333;
  margin-right: 10px;
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

fai si che l'accesso dei dati funzioni grazie al database non al localstorage 