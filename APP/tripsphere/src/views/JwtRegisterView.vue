// JwtRegisterView.vue
<template>
  <div class="register-container">
    <div class="card">
      <h2 class="card-header">Registrati con JWT</h2>
      <div class="card-body">
        <div v-if="message" class="alert" :class="successful ? 'alert-success' : 'alert-danger'">
          {{ message }}
        </div>
        <form @submit.prevent="handleRegister">
          <div class="form-group">
            <label for="nome">Nome</label>
            <input
              v-model="user.nome"
              type="text"
              class="form-control"
              id="nome"
              name="nome"
              required
            />
          </div>
          <div class="form-group">
            <label for="cognome">Cognome</label>
            <input
              v-model="user.cognome"
              type="text"
              class="form-control"
              id="cognome"
              name="cognome"
            />
          </div>
          <div class="form-group">
            <label for="email">Email</label>
            <input
              v-model="user.email"
              type="email"
              class="form-control"
              id="email"
              name="email"
              required
            />
          </div>
          <div class="form-group">
            <label for="password">Password</label>
            <input
              v-model="user.password"
              type="password"
              class="form-control"
              id="password"
              name="password"
              required
            />
          </div>
          <div class="form-group">
            <label for="nazionalita">Nazionalità</label>
            <input
              v-model="user.nazionalita"
              type="text"
              class="form-control"
              id="nazionalita"
              name="nazionalita"
            />
          </div>
          <div class="form-group">
            <button class="btn btn-primary btn-block" :disabled="loading">
              <span v-if="loading" class="spinner-border spinner-border-sm"></span>
              <span>Registrati</span>
            </button>
          </div>
        </form>
        <div class="mt-3">
          <p>Hai già un account? <router-link to="/jwt-login">Accedi con JWT</router-link></p>
          <p>Torna alla <router-link to="/registra">registrazione standard</router-link></p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'JwtRegisterView',
  data() {
    return {
      user: {
        nome: '',
        cognome: '',
        email: '',
        password: '',
        nazionalita: '',
        data: new Date().toISOString().split('T')[0] // Data corrente in formato YYYY-MM-DD
      },
      loading: false,
      message: '',
      successful: false
    };
  },
  methods: {
    handleRegister() {
      this.loading = true;
      this.message = '';
      
      // Chiamata API per la registrazione JWT
      fetch('http://localhost:3000/jwt/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(this.user)
      })
      .then(response => {
        if (!response.ok) {
          throw new Error('Errore durante la registrazione');
        }
        return response.json();
      })
      .then(data => {
        if (data.token) {
          // Salva il token nel localStorage
          localStorage.setItem('jwt_user', JSON.stringify({
            id: data.id,
            email: this.user.email,
            nome: this.user.nome,
            token: data.token,
            isAdmin: false
          }));
          
          this.successful = true;
          this.message = 'Registrazione completata con successo!';
          
          // Reindirizza alla pagina del profilo JWT
          setTimeout(() => {
            this.$router.push('/jwt-profile');
          }, 1500);
        } else {
          this.successful = false;
          this.message = 'Errore durante la registrazione';
        }
        this.loading = false;
      })
      .catch(error => {
        this.successful = false;
        this.message = error.message || 'Errore durante la registrazione';
        this.loading = false;
      });
    }
  }
};
</script>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f8f9fa;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.card {
  background: #ffffff;
  border-radius: 16px;
  padding: 40px;
  width: 100%;
  max-width: 450px;
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.card-header {
  font-size: 1.8rem;
  font-weight: bold;
  color: #333;
  margin-bottom: 25px;
}

.card-body {
  color: #333;
  text-align: left;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  font-weight: 600;
  margin-bottom: 5px;
  color: #555;
}

.form-control {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  outline: none;
  transition: border 0.3s ease;
  background-color: #f8f9fa;
}

.form-control:focus {
  border-color: #c69c22;
  background-color: #fff;
}

.btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s ease;
  font-size: 1rem;
}

.btn-primary {
  background-color: #c69c22;
  color: #fff;
}

.btn-primary:hover {
  background-color: #a67c16;
}

.alert {
  padding: 12px;
  border-radius: 8px;
  font-weight: 600;
  text-align: center;
}

.alert-success {
  background-color: rgba(40, 167, 69, 0.2);
  color: #28a745;
}

.alert-danger {
  background-color: rgba(220, 53, 69, 0.2);
  color: #dc3545;
}

.mt-3 {
  margin-top: 1rem;
  text-align: center;
  font-size: 0.9rem;
}

a {
  color: #c69c22;
  font-weight: 600;
  text-decoration: none;
}

a:hover {
  color: #a67c16;
  text-decoration: underline;
}
</style>


