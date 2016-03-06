;;;	Ahisahar Pretel Rodriguez 
;;;	Sistema Experto familiar en CLIPS
;;;	IC 2015



;;;;;Regla que lee desde el teclado;;;;

(defrule lee-entrada
     (initial-fact)
=>
     (printout t "Introduzca un nombre" crlf)
     (assert (entrada (read)))
)




;;;;;;;;;;;;Metodos para imprimir todos los datos relacionados con la entrada;;;;;;;;;;



(defrule primos
 	(entrada ?entrada)
 	(primos ?primo ?entrada)
=>
	 (printout t "Es primo/a de" ?primo crlf))


(defrule tios
 	(entrada ?entrada)
 	(tios ?tio ?entrada)
=>
	 (printout t "Su tio/a es " ?tio crlf))

(defrule abuelos
 	(entrada ?entrada)
 	(abuelo ?abuelo ?entrada)
=>
	 (printout t "Su abuelo/a es " ?abuelo crlf))

(defrule padre
 	(entrada ?entrada)
 	(hijo_de ?padre ?entrada)
=>
	 (printout t "Su padre/madre es " ?padre crlf))

(defrule hermanos
 	(entrada ?entrada)
 	(hermano ?hermano1 ?entrada)
=>
	 (printout t "Su hermano/a es " ?hermano1 crlf))

(defrule hijos
 	(entrada ?entrada)
 	(hijo_de ?entrada ?hijo1)
=>
	 (printout t "Su hijo/a es " ?hijo1 crlf))


(defrule casado
 	(entrada ?entrada)
 	(casado ?casado ?entrada)
=>
	 (printout t "Esta casado/a con " ?casado crlf))

(defrule nietos
 	(entrada ?entrada)
 	(abuelo ?entrada ?nieto)
=>
	 (printout t "Su nieto/a es " ?nieto crlf))


(defrule sobrinos
 	(entrada ?entrada)
 	(tios ?entrada ?sobrino)
=>
	 (printout t "Su sobrino/a es " ?sobrino crlf))








;;;;;;;;;;;;;Reglas;;;;;;;;;;;;;





;Regla que detecta todos los hermanos/as

(defrule detectahermano 

	(hijo_de ?padre ?hijo1)
	(hijo_de ?padre ?hijo2)
	(test (neq ?hijo1 ?hijo2)) 
=>
	(assert(hermano ?hijo1 ?hijo2)))






;Regla que detecta a todos los tíos/as

(defrule detectatios

	(hijo_de ?padre1 ?hijo1)
	(hijo_de ?padre2 ?hijo2)
	(hermano ?padre1 ?padre2)
	(casado ?padre1 ?conyuge)
	(test (neq ?hijo1 ?hijo2))
=>
	(assert(tios ?padre1 ?hijo2))
	(assert(tios ?conyuge ?hijo2)))







;Regla que detecta a todos los primos/as

(defrule detectaprimos
	(hijo_de ?padre1 ?hijo1)
	(hijo_de ?padre2 ?hijo2)
	(hermano ?padre1 ?padre2)
	(test (neq ?hijo1 ?hijo2)) 
=>
	(assert(primos ?hijo1 ?hijo2)))







;Regla que detecta a los abuelos/as

(defrule detectabuelos
	(hijo_de ?padre1 ?hijo1)
	(hijo_de ?padre2 ?hijo2)
	(test (eq ?hijo2 ?padre1))
=>
	(assert(abuelo ?padre2 ?hijo1)))






Regla que detecta a todos los hijos de un matrimonio

(defrule detectahijos
	(hijo_de ?padre1 ?hijo1)
	(casado ?padre1 ?padre2)
=>
	(assert(hijo_de ?padre2 ?hijo1)))









;;;;;;;;;Miembros de la familia;;;;;;;;;;;;




(deffacts personas
	(Hombre Ahisahar)
	(Hombre Antonio)
	(Mujer Manoli)
	(Hombre Eleazar)
	(Mujer Euridice)
	(Hombre Manuel)
	(Mujer Julia)
	(Hombre JoseManuel)
	(Hombre Domingo)
	(Mujer Marina)
	(Hombre JoseFrancisco)
	(Mujer Celia)
	(Hombre Pepe)
	(Mujer MarinaJ)
	(Mujer JoseFina)
	
)

;Hijos/as

(deffacts hijos
	(hijo_de Antonio Ahisahar)
	(hijo_de Antonio Eleazar)
	(hijo_de Manoli Euridice)
	(hijo_de JoseManuel MarinaJ)
	(hijo_de Julia Celia)
	(hijo_de Julia JoseFranciso)
	(hijo_de Domingo Antonio)
	(hijo_de Domingo Julia)
	(hijo_de Domingo JoseManuel)

)

;Matrimonios

(deffacts matrimonio
	(casado Manoli Antonio)
	(casado Julia Pepe)
	(casado Marina JoseManuel)
	(casado JoseFina Domingo)
	(casado Antonio Manoli)
	(casado Pepe Julia)
	(casado JoseManuel Marina)
	(casado Domingo JoseFina)


)
