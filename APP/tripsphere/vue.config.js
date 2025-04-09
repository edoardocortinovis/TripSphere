const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    host: '0.0.0.0',  // Questo permette al server di accettare richieste da qualsiasi host
    allowedHosts: 'all', // Permette qualsiasi host (compreso Render o il tuo dominio personalizzato)
  }
})
