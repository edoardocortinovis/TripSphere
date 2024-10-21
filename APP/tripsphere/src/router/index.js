import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import RegistraView from '../views/RegistraView.vue';
import AccediView from '../views/AccediView.vue';
import HomePageView from '@/views/HomePageView.vue';

const routes = [
  {
    path: '/homepage',
    name: 'homepage',
    component: HomePageView,
  },
  {
    path: '/',
    name: 'home',
    component: HomeView,
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
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
