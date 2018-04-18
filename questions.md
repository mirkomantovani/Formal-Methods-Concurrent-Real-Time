- sarebbe meglio utilizzare l'automa di Mealy o quello di Moore per modellizare l'FSM relativo al comportamente del robot?
- se il robot non arriva a prendere i pezzi dallo scaffale, si deve muovere o l'operatore deve spostare il vassoio che contiene i pezzi?
- dobbiamo modellizare il movimento con la griglia -- quindi con le equazioni della velocità -- oppure è sufficiente utilizzare le macro aree con un'indicazione di velocità e direzione del movimento di robot e operatore?
  * variabili con macro aree: (posizione corrente, posizione obiettivo, distanza operatore, velocità di approccio)
  * variabili con griglia: (posizione corrente, posizione obiettivo, distanza operatore, velocità robot, velocità operatore, equazioni della posizione
- il robot quando arriva working station, prende il pezzo e lo mette sul pallet. Deve aspettare che l'operatore gli dia il via libera oppure può metterlo direttamente sulla conveyor belt?