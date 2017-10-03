### VRTCL
Sport Climbing App
http://lindemann.github.io/VRTCL


Die iOS App verbindet sich zu dem Backen auf Heroku.

Um einen lokalen Backend-Server zu nutzen müssen in APIController.swift der iOS App folgende Zeile einkommentiert werden:

//	#if (arch(i386) || arch(x86_64)) && os(iOS) //Simulator
//		static let baseURL = "http://localhost:8080/"
//	#else //Device
//		static let baseURL = "https://vrtcl.herokuapp.com/"
//	#endif

Die Zeile darunter muss auskommentiert werden.
static let baseURL = "https://vrtcl.herokuapp.com/"

Um das Vapor-API Projekt lokal zu starten müssen folgende Vorraussetzungen erfüllt sein:

1. Die Vapor Toolbox muss installiert sein (https://docs.vapor.codes/2.0/getting-started/toolbox/)
2. PostgreSQL muss über homebrew installiert werden
3. Es muss eine PostgreSQL Datenbank mit dem Namen "VRTCL" auf Host: 127.0.0.1, Port: 5432 vorhanden sein.

Die Postgre App kann dazu genutzt werden (http://postgresapp.com)
 