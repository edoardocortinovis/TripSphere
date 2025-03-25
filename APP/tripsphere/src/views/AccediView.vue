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

    <div id="google-button" class="google-login-button"></div>

    <p class="login-link">
      Non hai un account?
      <router-link to="/registra">Registrati qui</router-link>
    </p>
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
    // Login manuale
    async loginUser() {
      try {
        const response = await fetch('http://localhost:3000/accedi', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          //body: JSON.stringify({ email: this.email, password: this.password }),
          body: JSON.stringify({ email: this.email, password: this.password }),

        });

        const result = await response.json();

        if (response.ok) {
          this.successMessage = 'Login effettuato con successo!';
          this.errorMessage = '';
          this.saveUserSession(result);
        } else {
          this.errorMessage = result.message || 'Credenziali errate.';
          this.successMessage = '';
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
        this.successMessage = '';
      }
    },

    // Login tramite Google OAuth
    async handleCredentialResponse(response) {
      const token = response.credential;

      try {
        const res = await fetch('http://localhost:3000/auth/google', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ credential: token }), // Change from idToken to credential
        });

        const result = await res.json();

        if (res.ok) {
          this.successMessage = 'Login con Google effettuato con successo!';
          this.errorMessage = '';
          this.saveUserSession(result);
        } else {
          this.errorMessage = result.message || "Errore durante l'accesso con Google.";
        }
      } catch (error) {
        this.errorMessage = 'Errore di connessione al server.';
      }
    },
    // Salva la sessione utente e reindirizza
    saveUserSession(userData) {
      this.isLoggedIn = true;
      localStorage.setItem('loggedIn', 'true');
      localStorage.setItem('email', userData.email);
      localStorage.setItem('isAdmin', userData.isAdmin ? 'true' : 'false');
      localStorage.setItem('googleAuth', userData.googleAuth || 'false');

      // Reindirizza l'utente
      const route = userData.isAdmin ? '/admin' : '/home';
      this.$router.push(route);
    },
  },
  mounted() {
    const script = document.createElement('script');
    script.src = 'https://accounts.google.com/gsi/client';
    script.async = true;
    script.onload = () => {
      window.google.accounts.id.initialize({
        client_id: '114549057021-1regresnv2eue5ig42h76idmn34rh38s.apps.googleusercontent.com',
        callback: this.handleCredentialResponse,
      });
      window.google.accounts.id.renderButton(
        document.getElementById('google-button'),
        { theme: 'outline', size: 'large' }
      );
    };
    document.head.appendChild(script);
  },
};
</script>

<style scoped>
.login-container {
  max-width: 450px;
  margin: 5rem auto;
  padding: 2.5rem;
  background-color: #ffffff;
  border-radius: 20px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  text-align: center;
  animation: fadeIn 0.5s ease-in-out;
}

h2 {
  font-size: 28px;
  margin-bottom: 1.5rem;
  color: #333;
  font-weight: 600;
}

.form-group {
  margin-bottom: 1.5rem;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #555;
}

input {
  width: 100%;
  padding: 0.75rem;
  font-size: 16px;
  border: 1px solid #ddd;
  border-radius: 12px;
  background-color: #f9f9f9;
  outline: none;
  transition: border-color 0.3s;
}

input:focus {
  border-color: #db8f00;
}

.submit-button {
  width: 100%;
  padding: 0.9rem;
  background-color: #db8f00;
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 18px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-button:hover {
  background-color: #a96e01;
}

.google-login-button {
  width: 100%;
  margin-top: 1.5rem;
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
  color: #db8f00;
  text-decoration: none;
  font-weight: 500;
}

.login-link a:hover {
  text-decoration: underline;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
