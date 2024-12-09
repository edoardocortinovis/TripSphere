import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import RegistraView from '../views/RegistraView.vue';
import AccediView from '../views/AccediView.vue';
import HomePageView from '@/views/HomePageView.vue';
import AccountView from '@/views/AccountView.vue';
import AdminView from '@/views/AdminView.vue';

// Funzione per verificare lo stato di autenticazione
const isAuthenticated = async () => {
  const userEmail = localStorage.getItem('email');
  const userPassword = localStorage.getItem('password');
  const loggedIn = localStorage.getItem('loggedIn') === 'true';

  console.log('Recupero email:', userEmail);
  console.log('Recupero password:', userPassword);

  if (loggedIn) {
    if (userEmail === 'admin@admin.it' && userPassword === 'admin') {
      return { loggedIn: true, isAdmin: true }; // Admin trovato
    } else {
      return { loggedIn: true, isAdmin: false }; // Utente normale
    }
  }

  console.log('User not logged in');
  return { loggedIn: false, isAdmin: false };
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
];

// Configurazione del router
const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Guardia di navigazione globale
router.beforeEach(async (to, from, next) => {
  
  if (to.meta.requiresAuth) {
    const { loggedIn, isAdmin } = await isAuthenticated();

    console.log('Is Admin:', isAdmin);

    if (loggedIn) {
      if (to.meta.requiresAdmin && !isAdmin) {
        next('/home'); // Reindirizza se non è un admin
      } else {
        next(); // Se è admin o non richiede admin, prosegui
      }
    } else {
      next('/accedi'); // Reindirizza alla pagina di login
    }
  } 
  // Evita il login se già loggato
  else if (to.name === 'accedi' && localStorage.getItem('loggedIn') === 'true') {
    next('/home');
  } 
  // Rotte pubbliche
  else {
    next();
  }
});

export default router;
