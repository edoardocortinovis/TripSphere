<template>
  <div id="app">
    <nav>
        <router-link to="/home">Tripsphere</router-link> <!-- Collegamento alla home -->
        <!--<router-link to="/registra">Registra</router-link>  Collegamento alla home -->
    </nav>
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App',
};
</script>

<style>
#app {
  font-family: 'Inter', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

nav {
  padding: 20px;
}

nav a {
  font-weight: bold;
  color: #2c3e50;
  text-decoration: none;
  margin: 0 15px;
}

nav a.router-link-exact-active {
  color: #42b983;
}
</style>
