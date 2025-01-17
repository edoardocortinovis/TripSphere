<template>
  <div class="login-container" v-if="!isLoggedIn">
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

    <button @click="loginWithGoogle" class="google-login-button">
      Accedi con Google
    </button>

    <p class="login-link">Non hai un account? <router-link to="/registra">Registrati qui</router-link></p>
  </div>

  <div v-else>
    <p>Sei già loggato, verrai reindirizzato...</p>
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
      isLoggedIn: false,
    };
  },
  methods: {
    async loginUser() {
      try {
        const response = await fetch('http://localhost:3000/accedi', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: this.email, password: this.password }),
        });
        const result = await response.json();

        if (response.ok) {
          this.successMessage = 'Login effettuato con successo!';
          this.errorMessage = '';
          this.isLoggedIn = true;

          // Salva lo stato in localStorage
          localStorage.setItem('loggedIn', 'true');
          localStorage.setItem('email', this.email);
          localStorage.setItem('password', this.password);
          localStorage.setItem('isAdmin', result.isAdmin ? 'true' : 'false');
          localStorage.setItem('googleAuth', 'false'); // Segna come login con email

          // Reindirizza in base al ruolo
          if (result.isAdmin) {
            this.$router.push('/admin');
          } else {
            this.$router.push('/home');
          }
        } else {
          this.errorMessage = result.message || 'Credenziali errate.';
          this.successMessage = '';
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
        this.successMessage = '';
      }
    },

    loginWithGoogle() {
      window.location.href = 'http://localhost:3000/auth/google'; // Reindirizza al login con Google
    },
  },

  mounted() {
    const loggedIn = localStorage.getItem('loggedIn') === 'true';
    const isAdmin = localStorage.getItem('isAdmin') === 'true';
    const googleAuth = localStorage.getItem('googleAuth') === 'true';

    if (loggedIn) {
      if (googleAuth) {
        this.$router.push('/home'); // Se l'utente ha effettuato il login tramite Google
      } else if (isAdmin) {
        this.$router.push('/admin');
      } else {
        this.$router.push('/home');
      }
    } else {
      // Verifica se il login con Google ha già avuto successo tramite token URL
      const urlParams = new URLSearchParams(window.location.search);
      const token = urlParams.get('token');

      if (token) {
        this.isLoggedIn = true;
        localStorage.setItem('loggedIn', 'true');
        localStorage.setItem('googleAuth', 'true'); // Segna come login tramite Google
        localStorage.setItem('token', token); // Salva il token nel localStorage
        this.$router.push('/home');
      }
    }
  },
};
</script>

<!--<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: '',
      successMessage: '',
      isLoggedIn: false, // Variabile per controllare lo stato di login
    };
  },
  methods: {
    async loginUser() {
      try {
        const response = await fetch('http://localhost:3000/accedi', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: this.email, password: this.password }),
        });
        const result = await response.json();

        if (response.ok) {
          this.successMessage = 'Login effettuato con successo!';
          this.errorMessage = '';
          this.isLoggedIn = true;

          localStorage.setItem('googleAuth', 'true');

          // Salva lo stato in localStorage
          localStorage.setItem('loggedIn', 'true');
          localStorage.setItem('isAdmin', result.isAdmin ? 'true' : 'false'); // Verifica se è admin

          // Salva anche l'email
          localStorage.setItem('email', this.email);
          localStorage.setItem('password', this.password);

          // Redirige in base al ruolo
          if (result.isAdmin) {
            this.$router.push('/admin');
          } else {
            this.$router.push('/home');
          }
        } else {
          this.errorMessage = result.message || 'Credenziali errate.';
          this.successMessage = '';
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
        this.successMessage = '';
      }
    },

    loginWithGoogle() {
      window.location.href = 'http://localhost:3000/auth/google'; // Reindirizza al login con Google
    }
  },

  mounted() {
    // Verifica se l'utente è già loggato tramite localStorage
    const loggedIn = localStorage.getItem('loggedIn') === 'true';
    const isAdmin = localStorage.getItem('isAdmin') === 'true';
    if (loggedIn) {
      if (isAdmin) {
        this.$router.push('/admin');
      } else {
        this.$router.push('/home');
      }
    } else {
      // Verifica anche se il login con Google ha già avuto successo tramite token URL
      const urlParams = new URLSearchParams(window.location.search);
      const token = urlParams.get('token');

      if (token) {
        // Se c'è un token, significa che l'utente ha fatto il login con Google
        this.isLoggedIn = true;
        localStorage.setItem('loggedIn', 'true');
        localStorage.setItem('googleAuth', 'true');
        localStorage.setItem('token', token); // Salva il token nel localStorage
        this.$router.push('/home'); // Reindirizza alla pagina principale
      }
    }
    const isAuthenticated = localStorage.getItem("access_token");
    if (isAuthenticated) {
      this.$router.push({ name: "home" }); // O la tua pagina di destinazione
    }
  }
};
</script>-->


<style scoped>
.google-login-button {
  width: 100%;
  padding: 0.8rem;
  background-color: #4285f4;
  /* Colore blu di Google */
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
  margin-top: 1rem;
}

.google-login-button:hover {
  background-color: #357ae8;
  /* Colore blu più scuro di Google */
}

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
