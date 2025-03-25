import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // Assicurati di importare il router

createApp(App)
  .use(router) // Assicurati di usare il router
  .mount('#app');
