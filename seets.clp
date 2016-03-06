;Practica 3: Sistema experto diagnóstico
;Ahisahar Pretel Rodriguez

(deffacts init
  (diagnostico engine)
  (menu-level engine main)
  (menu-level engine main2)
  (troubleshoot-mode diagnostico)
)

;;*****************************************
;;*MODULO QUE INTERACTUA CON EL USUARIO****
;;*****************************************



;;*********************************************
;;Primer menu que pregunta el primer síntoma***
;;*********************************************


(defrule main-menu
  (declare (salience 500))
  (troubleshoot-mode diagnostico)
  ?ml <- (menu-level engine main)
=>
  (retract ?ml)
;;** print 25 crlf's to clear screen **
  (printout t crlf crlf)
  (printout t
  "        Elige uno de los siguientes sintomas" crlf
  "        pulsando el numero del sintoma que padezca." crlf crlf
  "                  1.) Pequeno tumor eruptivo de la piel no doloroso." crlf
  "                  2.) Úlcera en la zona genital." crlf
  "                  3.) Ampollas dolorosas en la zona genital." crlf
  "                  4.) Picor y escozor en la zona genital." crlf
  "                  5.) Ninguno. Salir del programa." crlf crlf
  "        Choice: " )
  (bind ?response (read))
  (assert (problem-response sintoma ?response))
  (printout t crlf))

;;*****************************
;;Salir del programa(Abortar)**
;;*****************************

(defrule user-quits
  (troubleshoot-mode diagnostico)
  ?pr <- (problem-response sintoma 5)
=>
  (printout t "Has presionado salir del sistema." crlf)
  (halt))


;;**********************************************
;;Pregunta si ha mantenido relaciones sexuales**
;;**********************************************



(defrule preguntarelaciones
	(declare (salience 399))
	?pr <- (preguntaRelaciones)
=>
  (printout t crlf crlf)
  (printout t
  "        ¿Ha mantenido relaciones sexuales recientemente?" crlf
  "        seleccione el numero correspondiente." crlf crlf
  "                  1.) Si." crlf
  "                  2.) No." crlf
  "        Choice: " )
  (bind ?response (read))
  (assert (relaciones ?response))
  (printout t crlf))


;;*****************************
;;Pregunta si tiene Fiebre*
;;*****************************


(defrule preguntafiebre
	(declare (salience 349))
	?pr <- (pregunta fiebre)

=>

  (printout t crlf crlf)
  (printout t
  "        ¿Padece de fiebre leve?" crlf
  "        seleccione el numero correspondiente." crlf crlf
  "                  1.) Si." crlf
  "                  2.) No." crlf
  "        Choice: " )
  (bind ?response (read))
  (assert (fiebre ?response))
  (printout t crlf))

;;******************************
;;Pregunta si padece dolor al orinar o secrecion
;;******************************

(defrule preguntadolor
	(declare (salience 349))
	?pr <- (pregunta dolor)
=>
  (printout t crlf crlf)
  (printout t
  "        ¿Padece dolor al orinar o secreción vaginal?" crlf
  "        seleccione el numero correspondiente." crlf crlf
  "                  1.) Si." crlf
  "                  2.) No." crlf
  "        Choice: " )
  (bind ?response (read))
  (assert (DolorOrinar ?response))
  (printout t crlf))




















;;****************************
;;MOTOR DE INFERENCIA iniciamos los diagnosticos**
;;****************************

;;Primero intentamos descartar la meningitis

(defrule descartaSifilis
	(declare (salience 400))
	?f <- (problem-response sintoma 2)
	   
	
=>
 	(assert (pregunta dolor)
		(diagnosticoDiferencial Herpes)))


(defrule diagnosticaSifilis
	(declare (salience 398))
	?f <- (problem-response sintoma 2)
	?s <- (diagnosticoDiferencial Herpes)
	?d <- (DolorOrinar 1)
	=>
	
	(assert (diagnostico Sifilis))
	(retract ?s))

;;Despues intentamos descartar el Dengue

(defrule descartaHerpes
	(declare (salience 350))
	?f <- (problem-response sintoma 3)
           
	
=>
	(assert (hipotesis Herpes))
	(assert (diagnosticoDiferencial Herpes)))

(defrule diagnosticaHerpes
	(declare (salience 350))
	?f <- (problem-response sintoma 3)
	?s <- (diagnosticoDiferencial Herpes)
	?h <- (hipotesis Herpes)
=>
	(assert (diagnostico Herpes))
	(retract ?s))

(defrule descartaLinfogranulama
	(declare (salience 349))
        ?f <- (problem-response sintoma 1)
	
=>

	(assert (pregunta fiebre)))

(defrule diagnosticaLinfogranulama
	(declare (salience 348))
	?f <- (problem-response sintoma 1)
	?fi <- (fiebre 1)
=>
	(assert (diagnostico Linfogranulama)))

(defrule descartaCandida
	?f <- (problem-response sintoma 4)
=>
	(assert (preguntaRelaciones))
	(assert (diagnosticoDiferencial Vaginitis)))

(defrule diagnosticaCandida
	(declare (salience 348))
	?f <- (problem-response sintoma 4)
	?fi <- (relaciones 0)
	?s <- (diagnosticoDiferencial Vaginitis)
=>
	(assert (diagnostico Candida))
	(retract ?s))


(defrule descartaVaginitis
	?f <- (problem-response sintoma 4)
=>
	(assert (preguntaRelaciones))
	(assert (diagnosticoDiferencial Candida)))

(defrule diagnosticaVaginitis
	(declare (salience 348))
	?f <- (problem-response sintoma 4)
	?fi <- (relaciones 1)
	?s <- (diagnosticoDiferencial Candida)
=>
	(assert (diagnostico Vaginitis))
	(retract ?s))


;;*******************************************
;;Modulo dedicado a imprimir el diagnóstico**
;;*******************************************

(defrule diagnosticarPacienteHerpes
	(declare (salience 200))
	?f <- (diagnostico Herpes)
=>
  (printout t crlf crlf)
  (printout t
  " Usted es probable que padezca Herpes" crlf crlf)(halt))

(defrule diagnosticarPacienteSifilis
	(declare (salience 200))
	?f <- (diagnostico Sifilis)
=>
  (printout t crlf crlf)
  (printout t
  " Usted es probable que padezca Sifilis, acuda a su medico con urgencia" crlf crlf)(halt))

(defrule diagnosticarPacienteVaginitis
	(declare (salience 200))
	?f <- (diagnostico Vaginitis)
=>
  (printout t crlf crlf)
  (printout t
  " Usted es probable que padezca Vaginitis"  crlf crlf)(halt))

(defrule diagnosticarPacienteLinfogranulama
	(declare (salience 200))
	?f <- (diagnostico Linfogranulama)
=>
  (printout t crlf crlf)
  (printout t
  " Usted es probable que padezca Linfogranulama" crlf crlf)(halt))

(defrule diagnosticarPacienteCandidas
	(declare (salience 200))
	?f <- (diagnostico Candida)
=>
  (printout t crlf crlf)
  (printout t
  " Usted es probable que padezca Candidas"  crlf crlf)(halt))

(defrule diagnosticarPacienteFalta
	(declare (salience 1))
	
=>
  (printout t crlf crlf)
  (printout t
  " No hay sintomas concluyentes para diagnosticar ninguna enfermedad, acuda a su medico para realizar mas pruebas"  crlf crlf)(halt))

