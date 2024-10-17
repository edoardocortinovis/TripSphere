# TripSphere

*TtripSphere è un' applicazione per l'organizzazione di viaggi* 

Descrizione (evidenziare una possibile tag line)
TARGET
PROBLEMA 
COMPETITOR
TECNOLOGIE



l'app è un applicazione che arriva in aiuto a tutti i turisti, serve per - l'organizzazione di viaggi - e avere un elenco dettagliato delle migliori attrazioni per quel luogo, consultando le recensioni sui vari posti nel mondo, cosi da poter scegliere il proprio viaggio al meglio (la prenotazione di hotel).

------------------------------------------

## Requisiti Funzionali

1. **Mostrare le città più visitate o in classifica consigliate in homepage**
   - Funzionalità per mostrare una selezione di città.
   - Le città possono essere visualizzate in base alla loro popolarità o consigliate.

2. **Poter ricercare tramite barra di ricerca per trovare città e relative attrazioni**
   - Funzionalità per cercare città specifiche.
   - Ricerca delle attrazioni associate alle città.

3. **Mostrare le attrazioni organizzate per ogni città**
   - Visualizzazione delle attrazioni suddivise per città selezionata.
   - Categorizzazione delle attrazioni per una facile navigazione.

4. **Account utenti per lasciare recensioni sulle attrazioni**
   - Gli utenti devono poter creare un account personale.
   - Gli utenti registrati possono lasciare recensioni sulle attrazioni.

5. **Supporto multi-lingua**
   - Funzionalità per cambiare la lingua dell'interfaccia.
   - Supporto per diverse lingue come Italiano, Inglese, Francese, ecc.

6. **Salvare attrazioni nei Preferiti**
   - Gli utenti possono salvare attrazioni nelle liste dei preferiti.
   - Funzionalità per creare una lista di "desideri" per future visite.

7. **Sistema di valutazione per le attrazioni**
   - Gli utenti possono valutare le attrazioni (es. da 1 a 5 stelle).
   - Sistema di recensioni scritto e di valutazioni con stelle.

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

1. **Città e relative attrazioni**
   - Le città e le attrazioni sono entità chiave dell'applicazione.
   - Ogni città deve avere una lista di attrazioni associate.

2. **Categorie di attrazioni**
   - Le attrazioni devono essere organizzate in categorie (es. musei, parchi, ristoranti).
   - Le categorie aiutano gli utenti a filtrare e cercare più facilmente.

3. **Prezzo e sconti per studenti, insegnanti e scuole**
   - Le attrazioni possono avere politiche di prezzo differenti per studenti, insegnanti o scuole.
   - Devono essere gestiti sconti e prezzi agevolati per queste categorie speciali.

https://yuml.me/ledocorti/253d3f96.svg

------------------------------------------



# API di Autenticazione
Endpoint: /login
Metodo: POST

**Richiesta:**

{
  "email": "utente@example.com",
  "password": "password123"
}

**Requisiti Password:**

{
  "min_length": 8,
  "uppercase_required": true,
  "lowercase_required": true,
  "numbers_required": true,
  "special_characters_required": false
}

**Risposta:**
{
  "status": "success",
  "message": "Benvenuto, utente!"
}

# API per i Luoghi di Interesse
Endpoint: /places
Metodo: GET

**Risposta:**
[
  {
  "place": "Fontana di Trevi",
    "type": "Fontana",
    "description": "Una delle fontane più famose al mondo, dove lanciare una moneta porta fortuna."
  },
  
  {
    "place": "Piazza di Spagna",
    "type": "Piazza",
    "description": "Un'iconica piazza con la famosa scalinata di Trinità dei Monti."
  }
  
]



# API per il Cambio Lingua
Endpoint: /change-language
Metodo: POST

**Richiesta:**


{
  "user_id": "12345",
  "new_language": {
    "code": "it",
    "name": "Italiano"
  }
}

**Risposta:**

{
  "status": "success",
  "message": "Lingua cambiata con successo.",
  "current_language": {
    "code": "it",
    "name": "Italiano"
  },
  "available_languages": [
    {
      "code": "en",
      "name": "English"
    },
    
    {
      "code": "fr",
      "name": "Français"
    },
    {
      "code": "de",
      "name": "Deutsch"
    }
  ]
}
