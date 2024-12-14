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

router.beforeEach(async (to, from, next) => {
  const { loggedIn, isAdmin } = await isAuthenticated();

  if (to.meta.requiresAuth) {
    if (loggedIn) {
      // Se è un admin e tenta di accedere a una pagina diversa da /admin, reindirizza a /admin
      if (isAdmin && to.path !== '/admin') {
        next('/admin');
      } 
      // Se è un utente normale e tenta di accedere a una pagina admin, reindirizza a /home
      else if (to.meta.requiresAdmin && !isAdmin) {
        next('/home');
      } 
      // Altrimenti consenti l'accesso
      else {
        next();
      }
    } else {
      next('/accedi'); // Reindirizza alla pagina di login
    }
  } 
  // Evita il login se già loggato
  else if (to.name === 'accedi' && loggedIn) {
    if (isAdmin) {
      next('/admin'); // Se è un admin già loggato, reindirizza a /admin
    } else {
      next('/home'); // Se è un utente normale già loggato, reindirizza a /home
    }
  } 
  // Rotte pubbliche
  else {
    if (isAdmin && to.path !== '/admin') {
      next('/admin'); // Se è admin, reindirizza sempre a /admin
    } else {
      next(); // Permetti accesso alle rotte pubbliche
    }
  }
});


export default router;
