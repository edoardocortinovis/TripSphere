import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import RegistraView from '../views/RegistraView.vue';
import AccediView from '../views/AccediView.vue';
import HomePageView from '@/views/HomePageView.vue';
import AccountView from '@/views/AccountView.vue';
import AdminView from '@/views/AdminView.vue';

import JwtLoginPage from '@/views/JwtLoginPage.vue';
import JwtProfilePage from '@/views/JwtProfilePage.vue';
import JwtRegisterPage from '@/views/JwtRegisterView.vue';

const isAuthenticated = async () => {
  //const userEmail = localStorage.getItem('email');
  //const userPassword = localStorage.getItem('password');
  const loggedIn = localStorage.getItem('loggedIn') === 'true';
  const googleAuth = localStorage.getItem('googleAuth') === 'true'; // Controllo Google OAuth
  const isAdmin = localStorage.getItem('isAdmin') === 'true'; 
  //const isAdmin = userEmail === 'admin@admin.it' && userPassword === 'admin';

  if (loggedIn || googleAuth) {
    return { loggedIn: true, isAdmin, googleAuth };
  }

  console.log('User not logged in');
  return { loggedIn: false, isAdmin: false, googleAuth: false };
};

// Funzione per verificare l'autenticazione JWT
const isJwtAuthenticated = () => {
  const jwtUserStr = localStorage.getItem('jwt_user');
  if (jwtUserStr) {
    const jwtUser = JSON.parse(jwtUserStr);
    return { 
      loggedIn: true, 
      isAdmin: jwtUser.isAdmin || false,
      token: jwtUser.token
    };
  }
  return { loggedIn: false, isAdmin: false, token: null };
};

// Definizione delle rotte
const routes = [
  {
    path: '/home',
    name: 'home',
    component: HomeView,
    meta: { requiresAuth: true }, // Rotta protetta
  },
  {
    path: '/',
    name: 'homepage',
    component: HomePageView,
  },
  {
    path: '/registra',
    name: 'registra',
    component: RegistraView,
  },
  {
    path: '/accedi',
    name: 'accedi',
    component: AccediView,
  },
  {
    path: '/account',
    name: 'account',
    component: AccountView,
    meta: { requiresAuth: true }, // Rotta protetta
  },
  {
    path: '/admin',
    name: 'admin',
    component: AdminView,
    meta: { requiresAuth: true, requiresAdmin: true }, // Rotta protetta solo per admin
  },
  {
    path: '/jwt-login',
    name: 'jwt-login',
    component: JwtLoginPage
  },
  {
    path: '/jwt-register',
    name: 'jwt-register',
    component: JwtRegisterPage
  },
  {
    path: '/jwt-profile',
    name: 'jwt-profile',
    component: JwtProfilePage,
    meta: { requiresJwtAuth: true }
  }

];

// Configurazione del router
const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Vue Router - router/index.js
router.beforeEach(async (to, from, next) => {
  try {
    if (to.meta.requiresJwtAuth) {
      const { loggedIn } = isJwtAuthenticated();
      if (loggedIn) {
        next();
      } else {
        next('/jwt-login');
      }
      return; // Importante: termina qui per le rotte JWT
    }


    const { loggedIn, isAdmin } = await isAuthenticated(); // Controlla lo stato di autenticazione

    // Se la rotta richiede autenticazione
    if (to.meta.requiresAuth) {
      if (loggedIn) {
        if (isAdmin && to.path !== '/admin') {
          next('/admin');
        } else if (to.meta.requiresAdmin && !isAdmin) {
          next('/home');
        } else {
          next();
        }
      } else {
        next('/accedi');
      }
    }
    // Se la rotta è la pagina di login e l'utente è già autenticato
    else if (to.name === 'accedi' && (loggedIn)) {
      if (isAdmin == true) {
        next('/admin');
      } else {
        next('/home');
      }
    } else {
      next();
    }
  } catch (error) {
    console.error('Errore durante la verifica dell\'autenticazione:', error);
    next('/accedi');
  }
});



export default router;
