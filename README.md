# TripSphere

*TtripSphere è un' applicazione per l'organizzazione di viaggi* 

l'app è un applicazione che arriva in aiuto a tutti i turisti, serve per - l'organizzazione di viaggi - e avere un elenco dettagliato delle migliori attrazioni per quel luogo, consultando le recensioni sui vari posti nel mondo, cosi da poter scegliere il proprio viaggio al meglio (la prenotazione di hotel).


----------LOGIN-----------

{
  "email": "utente@example.com",
  "password": "password123"
}

  "password_requirements": 
  {
    "min_length": 8,
    "uppercase_required": true,
    "lowercase_required": true,
    "numbers_required": true,
    "special_characters_required": false
  }

{
  "status": "success",
  "message": "Benvenuto, utente!",
  "travel_info": {
    "destination": "Roma, Italia",
    "departure_date": "2024-10-15",
    "return_date": "2024-10-22",
    },
  "favorite_places": [
    {
      "place": "Colosseo",
      "type": "Monumento storico",
      "description": "Un antico anfiteatro romano simbolo della città."
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
{
  "user_id": "12345",
  "new_language": {
    "code": "it",
    "name": "Italiano"
  }
}


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
    },
    
    {
      "code": "es",
      "name": "Español"
    }
  ]
}

