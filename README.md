# TripSphere

*TtripSphere è un' applicazione per l'organizzazione di viaggi* 

l'app è un applicazione che arriva in aiuto a tutti i turisti, serve per - l'organizzazione di viaggi - e avere un elenco dettagliato delle migliori attrazioni per quel luogo, consultando le recensioni sui vari posti nel mondo, cosi da poter scegliere il proprio viaggio al meglio (la prenotazione di hotel).


***Requisiti Funzionali:***

**1- Città più visitate o in classifica consigliate in homepage**
Funzionalità per mostrare una selezione di città.

**2- Barra di ricerca per trovare città e relative attrazioni**
Funzionalità per cercare città e attrazioni associate.

**3 - Attrazioni organizzate per ogni città**
Funzionalità per mostrare le attrazioni organizzate in base alla città selezionata.

**4 - Account utenti per lasciare recensioni sulle attrazioni**
Funzionalità per permettere agli utenti di creare account e lasciare recensioni sulle attrazioni.

**5 - Multi-lingua**
Funzionalità per supportare diverse lingue nell'interfaccia.

**6 - Preferiti o wishlist**
Funzionalità per permettere agli utenti di salvare attrazioni preferite o creare una lista di "desideri" per future visite.

**7 - Sistema di valutazione per le attrazioni**
Gli utenti possono dare un voto o una valutazione (es. da 1 a 5 stelle) alle attrazioni, oltre a lasciare recensioni.

***Requisiti Non Funzionali:***

**1 - Requisiti di password sicura**
Vincolo di sicurezza per garantire che le password degli utenti rispettino determinati criteri di robustezza (lunghezza minima, caratteri speciali, ecc.).

**2- Performance del sistema**
Tempo di risposta rapido per la ricerca di città e attrazioni, nonché per il caricamento delle informazioni sulle attrazioni.

**3- Responsive**
Il sito o l'app deve essere responsive 

***Requisiti di Dominio:***

**1 - Città e relative attrazioni**
Concetti specifici del dominio dell'applicazione. Le città e le attrazioni sono entità del dominio che rappresentano il cuore delle informazioni gestite dall'applicazione.

**2 - Categorie di attrazzioni**
Definizione di diverse categorie di attrazioni (es. musei, parchi, ristoranti, ecc.) per consentire una migliore organizzazione e ricerca.

**3.extra - Prezzo e sconti per studenti, insegnanti e scuole**
Concetti del dominio legati alle politiche di prezzo e sconti che potrebbero variare a seconda degli utenti (ad es. categorie speciali come studenti o insegnanti).



----------LOGIN-----------

{ "email": "utente@example.com", "password": "password123" }

"password_requirements": 
{ 
  "min_length": 8, 
  "uppercase_required": true, 
  "lowercase_required": true, 
  "numbers_required": true, 
  "special_characters_required": false 
  }

{ 
"status": "success", "message": "Benvenuto, utente!"
},

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
], 
} 
] 
}

---------CAMBIO LINGUA--------- 

{ "user_id": "12345", "new_language": { "code": "it", "name": "Italiano" } }

{ "status": "success", "message": "Lingua cambiata con successo.", "current_language": { "code": "it", "name": "Italiano" }, "available_languages": [

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
},

{
  "code": "es",
  "name": "Español"
}
] }

