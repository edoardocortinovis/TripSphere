// JwtProfilePage.vue
<template>
  <div class="profile-container">
    <div class="card">
      <h2 class="card-header">Profilo Utente JWT</h2>
      <div class="card-body">
        <div v-if="message" class="alert" :class="successful ? 'alert-success' : 'alert-danger'">
          {{ message }}
        </div>
        
        <div v-if="loading" class="text-center">
          <div class="spinner-border" role="status">
            <span class="sr-only">Caricamento...</span>
          </div>
        </div>
        
        <div v-if="currentUser && !loading">
          <div class="user-info">
            <div class="info-item">
              <strong>Nome:</strong> {{ userData.nome || 'Non specificato' }}
            </div>
            <div class="info-item">
              <strong>Cognome:</strong> {{ userData.cognome || 'Non specificato' }}
            </div>
            <div class="info-item">
              <strong>Email:</strong> {{ userData.email }}
            </div>
            <div class="info-item">
              <strong>Data di registrazione:</strong> {{ userData.data || 'Non specificata' }}
            </div>
            <div class="info-item">
              <strong>Nazionalità:</strong> {{ userData.nazionalita || 'Non specificata' }}
            </div>
          </div>
          
          <div class="jwt-info">
            <h4>Informazioni JWT</h4>
            <p>Questa pagina utilizza l'autenticazione JWT per accedere ai dati dell'utente.</p>
            <p>Il token JWT è memorizzato nel localStorage e viene inviato con ogni richiesta.</p>
          </div>
          
          <div class="mt-4">
            <button @click="logout" class="btn btn-danger">Logout JWT</button>
          </div>
        </div>
        
        <div v-if="!currentUser && !loading" class="text-center">
          <p>Devi effettuare l'accesso con JWT per visualizzare questa pagina.</p>
          <router-link to="/jwt-login" class="btn btn-primary">Vai al login JWT</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'JwtProfilePage',
  data() {
    return {
      loading: true,
      message: '',
      successful: false,
      currentUser: null,
      userData: {
        id: null,
        nome: '',
        cognome: '',
        email: '',
        data: '',
        nazionalita: ''
      }
    };
  },
  created() {
    // Controlla se l'utente è autenticato con JWT
    const userStr = localStorage.getItem('jwt_user');
    if (userStr) {
      this.currentUser = JSON.parse(userStr);
      this.fetchUserData();
    } else {
      this.loading = false;
    }
  },
  methods: {
    fetchUserData() {
      // Recupera i dati dell'utente dal server usando JWT
      fetch('http://localhost:3000/jwt/profile', {
        method: 'GET',
        headers: {
          'Authorization': 'Bearer ' + this.currentUser.token
        }
      })
      .then(response => {
        if (!response.ok) {
          if (response.status === 401 || response.status === 403) {
            // Token non valido o scaduto
            this.logout();
            throw new Error('Sessione JWT scaduta. Effettua nuovamente il login.');
          }
          throw new Error('Errore nel recupero dei dati utente');
        }
        return response.json();
      })
      .then(data => {
        this.userData = data;
        this.loading = false;
      })
      .catch(error => {
        this.message = error.message;
        this.successful = false;
        this.loading = false;
      });
    },
    logout() {
      // Rimuovi solo il token JWT dal localStorage
      localStorage.removeItem('jwt_user');
      this.currentUser = null;
      
      // Reindirizza alla pagina di login JWT
      this.$router.push('/jwt-login');
    }
  }
};
</script>

<style scoped>
.profile-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f4f6f9;
  padding: 20px;
  font-family: 'Poppins', sans-serif;
}

.card {
  background: #ffffff;
  border-radius: 12px;
  padding: 30px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.card-header {
  font-size: 1.5rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
  border-bottom: 2px solid #eee;
  padding-bottom: 15px;
}

.card-body {
  text-align: left;
}

.user-info, .jwt-info {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.05);
}

.jwt-info {
  background-color: #e3f2fd;
  border-left: 4px solid #007bff;
}

.info-item {
  margin-bottom: 12px;
  padding-bottom: 10px;
  font-size: 1rem;
  border-bottom: 1px solid #eee;
}

.info-item:last-child {
  border-bottom: none;
}

strong {
  color: #444;
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
  display: inline-block;
  text-align: center;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
  margin-top: 10px;
}

.btn-secondary:hover {
  background-color: #545b62;
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

.text-center {
  text-align: center;
}

.spinner-border {
  display: inline-block;
  width: 2rem;
  height: 2rem;
  border: 0.25em solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spinner-border .75s linear infinite;
}

@keyframes spinner-border {
  to { transform: rotate(360deg); }
}
</style>
