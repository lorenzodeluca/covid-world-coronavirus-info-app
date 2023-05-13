# **Lorenzo De Luca** [github](https://github.com/lorenzodeluca) - [gitlab](https://gitlab.com/lorenzodeluca) - [stackoverflow](https://stackoverflow.com/users/9441578/lorenzo?tab=profile)

# Progetto

ANDROID/Flutter: Coronavirus data viewer

Punti principali: `Model MVC,  Database(floor), Socket http, Api, Animazioni, Layout portait/landscape, SnackBar, Parametri di default nelle funzioni, Liste, Grafici, Google api, Maps` e altro

### Prerequisiti

L'applicazione è compatibile con tutti i nuovi smartphones android(Huawei,Samsung,ecc...).

### Installazione 

Istruzioni passo passo per compilare ed ottenere un eseguibile del programma
Per compilare il programma e ottenere un file compilato(APK) serve aver installato `Flutter-SDK` e `Visual studio code` con i rispettivi plugin

Per installare l'app su un dispositivo:
```
Aprire la cartella del client su Visual Studio Code -> Collegare il dispositivo -> Premere 'F5'
```
A compilazione terminata si potra trovare l'app installata sul dispositivo e  l'apk pronto per l'installazione nella directory `build/app/outputs/apk/app.apk`

<br />

## Eseguire i test

Per avviare l'app dopo aver compilato tutti i sorgenti e averli installati in un dispositivo basta clickare sull'icona nominata `Covid World`


### Il programma(dettagli)
La applicazione è composta solo da un applicativo `client`, i sorgenti sono nella directory flutter divisi in sottocartelle secondo il modello  `MVC`(Model View Controller). Lato server necessità di un servizio api che gli metta a disposizione i dati(noi abbiamo implementato 3 servizi api esterni scambiabili), l'applicazione è molto flessibile e permette di aggiungerne facilmente altri se necessario. 
All'avvio dell'applicazione la prima cosa che verra caricata è la schermata principale del app, dove è presente una lista di stati e un grafico sull'andamento globale del virus, cliccando su uno stato si aprono i dettagli per lo stato. `Cliccando sull'icona mappa in basso a destra si apre la mappa`. La mappa dispone di pulsanti all'interno per caricare dati aggiuntivi da delle api esterne e per cambiare le modalità di visualizzazione. 
Ecco nei dettagli i delle classi e dei principali metodi presenti nel codice:

> `Directory db`
- Sono presenti le entità e le classi necessarie per far funzionare il database
- Il database viene usato per salvare i dati delle api in modo da renderli disponibili anche in modalità offline
<br />  <br /> 
  

> `Directory models`
- Classi/Modelli utilizzati nella app
<br />  <br /> 


> `Directory Utils`
- Classi con funzioni utili alla ottimizzazione e al riutilizzo del codice per ottimizzare il funzionamento dell'app.
<br />  <br /> 

> `details.dart, main.dart e map.dart`
- Le 3 schermate dell'applicazione
<br />  <br /> 

<p float="left">
  <img src="/screenshots/Screenshot_2020-06-15-02-02-20-261_pro.delucalorenzo.covidworld.jpg" width="300">
  <img src="/screenshots/Screenshot_2020-06-14-22-14-01-042_pro.delucalorenzo.covidworld.jpg" width="300">
  <img src="/screenshots/Screenshot_2020-06-14-23-18-56-898_pro.delucalorenzo.covidworld.jpg" width="300">
</p>
<p float="left">
  <img src="/screenshots/Screenshot_2020-06-14-23-23-21-195_pro.delucalorenzo.covidworld.jpg" width="300">
</p>


