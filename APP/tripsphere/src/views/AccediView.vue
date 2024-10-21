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
      // Verifica che email e password non siano vuoti
      if (!this.email || !this.password) {
        this.errorMessage = 'Inserisci email e password.';
        return;
      }

      const loginData = {
        email: this.email,
        password: this.password,
      };

      try {
        // Effettua la richiesta POST all'endpoint '/accedi'
        const response = await fetch('http://localhost:3000/accedi', {
          method: 'POST', // Cambiato da GET a POST
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(loginData),
        });

        const result = await response.json();

        if (response.ok) {
          // Se il login ha successo
          this.successMessage = 'Accesso effettuato con successo!';
          this.errorMessage = ''; // Pulisci eventuali messaggi di errore

          // Puoi anche salvare i dati dell'utente nel localStorage o in una variabile di stato
          localStorage.setItem('user', JSON.stringify(result.user));

          // Reindirizza l'utente alla dashboard o altra pagina
          this.$router.push('/dashboard');
        } else {
          // Gestisci messaggio di errore (es. credenziali errate)
          this.errorMessage = result.message || 'Credenziali errate.';
          this.successMessage = ''; // Pulisci eventuali messaggi di successo
        }
      } catch (error) {
        // Gestisci errore di connessione al server
        this.errorMessage = 'Errore di connessione al server. Riprova più tardi.';
        this.successMessage = ''; // Pulisci eventuali messaggi di successo
      }
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
  border-color: #4CAF50;
}

.submit-button {
  width: 100%;
  padding: 0.8rem;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-button:hover {
  background-color: #45a049;
}

.error-message {
  color: #e74c3c;
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
  color: #4CAF50;
  text-decoration: none;
  font-weight: 500;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
