# TripSphere

- ajax = http://localhost:3000/index.html
- swagger = http://localhost:3000/api-docs/
- email login = edoardocortinivis@gmail.com, password = Ed
- admin login = admin@admin.it, password = admin
- api 3 parti = cards homepage
- counter in alto a destra

requisiti installati 
- apk add git
- apk add nano
- node (nano /etc/apk/repositories) entrare in questa cartella e discommentare la seconda riga
apk add nodejs npm
- [git clone https](https://github.com/edoardocortinovis/TripSphere.git)


entrare nella cartella **API**
```
npm init
npm install python3
npm install sqlite3
apk add --no-cache make gcc g++ python3 nodejs #(creiamo tutte le dipendenze, quindi installiamo sqlite3 per poi rebuildarlo)
npm rebuild sqlite3 --build-from-source

node server.js
```

entrare nella cartella **APP**
entrare nella cartella **tripsphere**
```
npm install
npm run serve
```

**TtripSphere è un' applicazione per l'organizzazione di viaggi** 

L'app è un applicazione che arriva in aiuto a tutti i turisti, serve per - l'organizzazione di viaggi - e avere un elenco dettagliato delle migliori attrazioni per quel luogo, consultando le recensioni sui vari posti nel mondo, cosi da poter scegliere il proprio viaggio al meglio.


*target* 
- Viaggiatori
- Turisti
- Famiglie

------------------------------------------

*Problema* 
Come organizzare il proprio viaggio senza conoscere le attrazioni principali del luogo interessato

------------------------------------------

*Competitor* 
   - Sygic Travel Maps Trip Planner
   - TripCase
   - Visit a City
   - TripAdvisor

------------------------------------------

*Tecnologie*
   - **Frontend** : Html, css, javascript, vue
   - **Backend** : Node.js, express.js
   - **Database** : sqlite3

------------------------------------------

## Requisiti Funzionali

1. **Mostrare le città più visitate o in classifica consigliate in homepage**
   - Funzionalità per mostrare una selezione di città.
   - Le città possono essere visualizzate in base alla loro popolarità o consigliate.

2. **Poter ricercare tramite barra di ricerca per trovare città e relative attrazioni**
   - Funzionalità per cercare città specifiche.

3. **Mostrare le attrazioni organizzate per ogni città**
   - Ricerca delle attrazioni associate alle città

4. **Account utenti per lasciare recensioni sulle attrazioni**
   - Gli utenti devono poter creare un account personale.
   - Gli utenti registrati possono lasciare recensioni sulle attrazioni.

5. **Supporto multi-lingua**
   - Funzionalità per cambiare la lingua dell'interfaccia.

6. **Salvare attrazioni nei Preferiti**
   - Gli utenti possono salvare attrazioni nelle liste dei preferiti.
   - Funzionalità per creare una lista di "desideri" per future visite.

7. **Sistema di valutazione per le attrazioni**
   - Gli utenti possono valutare le attrazioni (es. da 1 a 5 stelle).

---

## Requisiti Non Funzionali

1. **Requisiti di password sicura**
   - Le password devono avere una lunghezza minima di 8 caratteri.
   - Devono contenere almeno una lettera maiuscola, una minuscola e un numero.

2. **Performance del sistema**
   - Tempo di risposta rapido per la ricerca di città e attrazioni.
   - Il caricamento delle informazioni sulle attrazioni deve essere ottimizzato.

3. **Responsive Design**
   - L'interfaccia utente deve essere responsive per adattarsi a diversi dispositivi.
   - Supporto completo per desktop, tablet e smartphone.

---

## Requisiti di Dominio

1. **Città come Destinazioni Turistiche**
L'applicazione supporta i viaggiatori nella pianificazione dei loro itinerari, fornendo informazioni dettagliate sulle città come destinazioni turistiche. Ogni città rappresenta un punto di interesse che può includere diverse attrazioni turistiche.

2. **Attrazioni Organizzate in Categorie di Interesse**
Le attrazioni disponibili nelle città devono rispecchiare diverse categorie di interesse (come cultura, natura, gastronomia), permettendo ai viaggiatori di scoprire e selezionare facilmente attività e luoghi in base alle loro preferenze e ai loro obiettivi di viaggio.

3. **Prezzo e sconti per studenti, insegnanti e scuole**
   - Le attrazioni possono avere politiche di prezzo differenti per studenti, insegnanti o scuole.


# Casi d'uso 

https://yuml.me/ledocorti/253d3f96.svg

![image](https://github.com/user-attachments/assets/288ee88d-3269-4038-98e6-f626dbb92db1)

------------------------------------------


# Registrazione
Endpoint: /registra
Metodo: POST

```
{
    "nome": "Mario",
    "cognome": "Rossi",
    "data": "1990-05-10",
    "nazionalita": "Italiana",
    "email": "mario.rossi@example.com",
    "password": "passwordSicura123"
}
```

# Accedi
Endpoint: /login
Metodo: GET

**Risposta**

```
{
    "message": "Login riuscito",
    "user": {
        "name": "Mario Rossi",
        "email": "mario@example.com"
    }
}
```


monte ore settimantale = 12

![image](https://github.com/user-attachments/assets/f205b5b0-38f7-4996-a83a-5f33dfcabfd5)


![image](https://github.com/user-attachments/assets/7d491ae0-9c28-4835-8676-2ea8c6e8f2cb)

*Riepilogo Sprint:*
- Sprint 1: Totale 12 Story Points
   - Registrazione dell'utente: 5
   - Accesso tramite email e password: 5   
   - Visualizzazione della Pagina Home: 2
- Sprint 2: Totale 12 Story Points
   - Ricerca di Destinazioni e Servizi: 1
   - Sistema di valutazione per le attrazioni: 8
   - Internazionalizzazione (i18n): 3
- Sprint 3: Totale 12 Story Points
   - Dettagli delle Attrazioni: 5
   - Aggiunta di Recensioni: 5
   - Salvataggio delle Destinazioni Preferite: 2
