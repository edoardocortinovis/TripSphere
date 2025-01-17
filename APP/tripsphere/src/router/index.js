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
  const googleAuth = localStorage.getItem('googleAuth') === 'true'; // Controllo Google OAuth
  const isAdmin = userEmail === 'admin@admin.it' && userPassword === 'admin';

  if (loggedIn || googleAuth) {
    return { loggedIn: true, isAdmin, googleAuth };
  }

  console.log('User not logged in');
  return { loggedIn: false, isAdmin: false, googleAuth: false };
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
    //meta: { requiresAuth: true }, // Rotta protetta
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

// Vue Router - router/index.js
router.beforeEach(async (to, from, next) => {
  try {
    const { loggedIn, isAdmin, googleAuth } = await isAuthenticated(); // Controlla lo stato di autenticazione

    // Se la rotta richiede autenticazione
    if (to.meta.requiresAuth) {
      if (loggedIn) {
        // Se l'utente è autenticato ma non è un admin, reindirizza alla home
        if (isAdmin && to.path !== '/admin') {
          next('/admin');
        } else if (to.meta.requiresAdmin && !isAdmin) {
          // Se la rotta richiede un amministratore e l'utente non lo è, reindirizza alla home
          next('/home');
        } else {
          // Se l'utente è autenticato e la rotta non richiede un amministratore, prosegue
          next();
        }
      } else {
        // Se l'utente non è autenticato, reindirizza alla pagina di login
        next('/accedi');
      }
    }
    // Evita l'accesso alla pagina di login se l'utente è già autenticato o autenticato tramite Google
    else if (to.name === 'accedi' && (loggedIn || googleAuth)) {
      if (isAdmin) {
        next('/admin'); // Se l'utente è admin, reindirizza alla pagina admin
      } else {
        next('/home'); // Altrimenti, alla home
      }
    } else {
      // Se la rotta non richiede autenticazione, prosegue normalmente
      next();
    }
  } catch (error) {
    // In caso di errore (es. errore nella verifica dell'autenticazione), reindirizza alla login
    console.error('Errore durante la verifica dell\'autenticazione:', error);
    next('/accedi');
  }
});


export default router;
