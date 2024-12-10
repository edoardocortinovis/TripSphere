<template>
  <div class="profile-container">
    <!-- Banner -->
    <div class="banner">
      <img class="banner-image" :src="user.bannerUrl" alt="Profile Banner" />
      <div v-if="editing" class="edit-icon banner-edit" @click="selectFile('banner')">
        <i class="fas fa-pencil-alt"></i>
        <input type="file" ref="bannerInput" class="hidden-input" @change="uploadFile('banner')" />
      </div>
    </div>

    <!-- Profile Details -->
    <div class="profile-details">
      <div class="profile-picture-wrapper">
        <img class="profile-picture" :src="user.profilePictureUrl" alt="Profile" />
        <div v-if="editing" class="edit-icon profile-edit" @click="selectFile('profile')">
          <i class="fas fa-pencil-alt"></i>
          <input type="file" ref="profileInput" class="hidden-input" @change="uploadFile('profile')" />
        </div>
      </div>
      <h2 class="username">@{{ user.username }}</h2>
      <h3 class="full-name">{{ user.firstName }} {{ user.lastName }}</h3>
    </div>

    <!-- Actions -->
    <div class="actions">
      <button class="edit-button" v-if="!editing" @click="startEditing">Modifica Profilo</button>
      <button class="save-button" v-if="editing" @click="saveChanges">Salva</button>
      <button class="cancel-button" v-if="editing" @click="cancelEditing">Annulla</button>
      <button class="logout-button" @click="Logout">Esci</button>
    </div>

    <!-- Content -->
    <div class="content">
      <div class="posts">
        <h3>I tuoi Viaggi</h3>
        <div v-if="posts.length > 0" class="post-grid">
          <div v-for="post in posts" :key="post.id" class="post">
            <img :src="post.imageUrl" alt="Post image" />
            <p>{{ post.caption }}</p>
          </div>
        </div>
        <p v-else>Non hai ancora pubblicato nulla.</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: {
        username: '',
        firstName: '',
        lastName: '',
        profilePictureUrl: 'https://via.placeholder.com/150',
        bannerUrl: 'https://via.placeholder.com/1200x400',
      },
      posts: [],
      editing: false,
      originalUser: null, // Per annullare le modifiche
    };
  },
  methods: {
    startEditing() {
      this.editing = true;
      this.originalUser = { ...this.user }; // Salva lo stato originale
    },
    saveChanges() {
      // Logica per salvare i cambiamenti al server
      console.log('Salvataggio modifiche:', this.user);
      this.editing = false;
    },
    cancelEditing() {
      this.user = { ...this.originalUser }; // Ripristina lo stato originale
      this.editing = false;
    },
    selectFile(type) {
      if (type === 'banner') {
        this.$refs.bannerInput.click();
      } else if (type === 'profile') {
        this.$refs.profileInput.click();
      }
    },
    uploadFile(type) {
      const fileInput = type === 'banner' ? this.$refs.bannerInput : this.$refs.profileInput;
      const file = fileInput.files[0];

      if (!file) return;

      const formData = new FormData();
      formData.append('file', file);
      formData.append('type', type);

      fetch('http://localhost:3000/upload', {
        method: 'POST',
        credentials: 'include',
        body: formData,
      })
        .then((response) => response.json())
        .then((data) => {
          if (type === 'banner') {
            // Aggiorna l'URL del banner con la nuova immagine
            this.user.bannerUrl = data.url;
          } else if (type === 'profile') {
            // Aggiorna l'URL dell'immagine profilo con la nuova immagine
            this.user.profilePictureUrl = data.url;
          }
        })
        .catch((error) => console.error('Errore durante il caricamento:', error));
    },

    Logout() {
      fetch('http://localhost:3000/logout', {
        method: 'POST',
        credentials: 'include',
      })
        .then((response) => {
          if (response.ok) {
            localStorage.clear();
            this.$router.push('/accedi');
          } else {
            console.error('Errore durante il logout');
          }
        })
        .catch((error) => console.error('Errore di rete:', error));
    },
  },
  mounted() {
    fetch('http://localhost:3000/account', {
      method: 'GET',
      credentials: 'include',
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.user) {
          this.user = {
            username: data.user.username,
            firstName: data.user.firstName,
            lastName: data.user.lastName,
            profilePictureUrl: data.user.profilePictureUrl || this.user.profilePictureUrl,
            bannerUrl: data.user.bannerUrl || this.user.bannerUrl,
          };
        }
        if (data.posts) {
          this.posts = data.posts;
        }
      })
      .catch((error) => console.error('Errore nel recupero dei dati:', error));
  },
};
</script>

<style scoped>
/* Stile base */
.profile-container {
  font-family: 'Roboto', sans-serif;
  color: #333;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
  width: 100%;
  background-color: #f4f4f9;
}

/* Banner */
.banner {
  width: 100%;
  height: 30vh;
  background-color: #ddd;
  position: relative;
}

.banner-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-details {
  text-align: center;
  margin-top: -75px;
}

.profile-picture-wrapper {
  position: relative;
}

.profile-picture {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  object-fit: cover;
  border: 4px solid #fff;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* Icone di modifica */
.edit-icon {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0, 0, 0, 0.6);
  color: #fff;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  transition: background-color 0.3s;
}

.edit-icon:hover {
  background: rgba(0, 0, 0, 0.8);
}

.hidden-input {
  display: none;
}

/* Pulsanti */
.actions button {
  margin: 5px;
  padding: 10px 20px;
  font-size: 16px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.edit-button {
  background-color: #007bff;
  color: #fff;
}

.edit-button:hover {
  background-color: #0056b3;
}

.save-button {
  background-color: #28a745;
  color: #fff;
}

.save-button:hover {
  background-color: #218838;
}

.cancel-button {
  background-color: #ffc107;
  color: #fff;
}

.cancel-button:hover {
  background-color: #e0a800;
}

.logout-button {
  background-color: #dc3545;
  color: #fff;
}

.logout-button:hover {
  background-color: #b02a37;
}
</style>