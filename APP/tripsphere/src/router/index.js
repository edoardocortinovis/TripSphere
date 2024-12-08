import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import RegistraView from '../views/RegistraView.vue';
import AccediView from '../views/AccediView.vue';
import HomePageView from '@/views/HomePageView.vue';
import AccountView from '@/views/AccountView.vue';
import AdminView from '@/views/AdminView.vue';

// Funzione per verificare lo stato di autenticazione
const isAuthenticated = async () => {
  // Controllo immediato dal localStorage
  if (localStorage.getItem('loggedIn') === 'true') {
    return true;
  }

  // Verifica lato server
  try {
    const response = await fetch('http://localhost:3000/home', {
      method: 'GET',
      credentials: 'include',
    });

    if (response.ok) {
      const data = await response.json();
      return data.loggedIn; // Restituisce true/false dal server
    } else {
      return false;
    }
  } catch (err) {
    console.error('Errore di autenticazione:', err);
    return false;
  }
};

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
    meta: { requiresAuth: true }, // Rotta protetta
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Guardia di navigazione globale
router.beforeEach(async (to, from, next) => {
  if (to.meta.requiresAuth) {
    const loggedIn = await isAuthenticated();

    if (loggedIn) {
      next(); // Se autenticato, prosegui
    } else {
      next('/accedi'); // Altrimenti reindirizza al login
    }
  } else if (to.name === 'accedi' && localStorage.getItem('loggedIn') === 'true') {
    next('/home'); // Evita il login se già loggato
  } else {
    next(); // Prosegui alla rotta pubblica
  }
});

export default router;
