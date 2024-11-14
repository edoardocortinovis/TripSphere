# TripSphere

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

![schema casi d'uso](https://github.com/user-attachments/assets/a57217f5-bb10-46ef-8447-5bc1c4b22557)


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

![image](https://github.com/user-attachments/assets/0dbbcec6-27eb-4f61-b7d8-3d7dfb18fbf2)

