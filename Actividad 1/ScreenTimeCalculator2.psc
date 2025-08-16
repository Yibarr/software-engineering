// ===============================
// ScreenTimeCalculator (PSeInt)
// ===============================
Algoritmo ScreenTimeCalculator
	// Constantes
	Definir APP_MIN_QTY, APP_MAX_QTY, DAY_MINUTES Como Entero
	APP_MIN_QTY <- 5
	APP_MAX_QTY <- 10
	DAY_MINUTES <- 24*60
	// Estado
	Definir appCount, totalMinutes Como Entero
	appCount <- 0
	totalMinutes <- 0
	Definir finished Como Lógico
	finished <- Falso
	// Datos
	Dimensionar apps(APP_MAX_QTY,2)
	// 0) Nombre usuario
	Escribir 'Bienvenido a la calculadora de tiempo de pantalla.'
	Escribir 'Por favor, ingresa tu nombre:' // [i,1]=nombre, [i,2]=minutos (texto)
	Leer userName
	Mientras (Longitud(userName)=0) Hacer
		Escribir 'El nombre no puede estar vacío. Inténtalo de nuevo:'
		Leer userName
	FinMientras
	Escribir 'Hola, ', userName, '. Debes ingresar al menos ', APP_MIN_QTY, ' apps.'
	// 1) Bucle principal
	Mientras !finished Hacer
		// 1.1) Nombre app
		Escribir 'Ingrese el nombre de la app número: ', appCount+1
		Leer appName
		appName <- appName
		Mientras (Longitud(appName)=0) Hacer
			Escribir 'El nombre no puede estar vacío. Inténtalo de nuevo:'
			Leer appName
			appName <- appName
		FinMientras
		// 1.2) Horas (decimales) -> minutos
		Escribir 'Ingrese el tiempo de pantalla en horas (puede ser decimal, ej. 1.5):'
		Escribir hoursInput
		// Validación básica de número y no-negativo
		Escribir isNumeric(hoursInput)
		Mientras !isNumeric(hoursInput) O ConvertirANumero(hoursInput)<0 Hacer
			Escribir 'Entrada no válida. Ingrese un número de horas >= 0 (ej. 0, 0.5, 1.5):'
			Leer hoursInput
			
		FinMientras
		decimalHours <- ConvertirANumero(hoursInput)
		minutosDeApp <- convertDecimalToMinutes(decimalHours)
		// 1.3) Chequeo contra minutos del día
		Si (totalMinutes+minutosDeApp)<DAY_MINUTES Entonces
			appCount <- appCount+1
			totalMinutes <- totalMinutes+minutosDeApp
			apps[appCount,1]<-appName
			apps[appCount,2]<-ConvertirATexto(minutosDeApp)
			// ¿Podemos decidir terminar?
			Si appCount>=APP_MIN_QTY Y appCount<APP_MAX_QTY Entonces
				Si !leerSi('¿Desea agregar otra app? (Y/N)') Entonces
					finished <- Verdadero
				FinSi
			SiNo
				// Si ya llegamos al máximo, terminar
				Si appCount=APP_MAX_QTY Entonces
					Escribir 'Ha alcanzado el número máximo de apps ingresadas.'
					finished <- Verdadero
				FinSi
			FinSi
		SiNo
			// Exactamente llena el día
			Si (totalMinutes+minutosDeApp)=DAY_MINUTES Entonces
				appCount <- appCount+1
				totalMinutes <- totalMinutes+minutosDeApp
				apps[appCount,1]<-appName
				apps[appCount,2]<-ConvertirATexto(minutosDeApp)
				finished <- Verdadero
			SiNo
				// Excede: informar y NO registrar
				minutosDisponibles <- DAY_MINUTES-totalMinutes
				horasDisponibles <- convertMinutesToHours(minutosDisponibles)
				Escribir 'El tiempo ingresado excede el disponible.'
				Escribir 'Aún quedan: ', ConvertirATexto(horasDisponibles), ' horas (', ConvertirATexto(minutosDisponibles), ' minutos).'
			FinSi
		FinSi
		// Si no llegó al mínimo pero ya no hay espacio
		Si (!finished) Y (appCount<APP_MIN_QTY) Y (totalMinutes=DAY_MINUTES) Entonces
			finished <- Verdadero
		FinSi
	FinMientras
	// 2) Reporte
	// Declaraciones (agrega estas si no las tienes)
	Definir totalHours, percentUsed Como Real
	Definir minutosRestantes Como Entero
	// 7) Reporte final
	Escribir 'Resumen de ', userName, ':'
	Para i<-1 Hasta appCount Hacer
		Escribir '  ', i, ') ', apps[i,1], ' -> ', apps[i,2], ' minutos'
	FinPara
	totalHours <- convertMinutesToHours(totalMinutes)
	percentUsed <- (totalMinutes*100.0)/DAY_MINUTES
	Escribir 'Número de apps: ', appCount
	Escribir 'Total del día: ', totalMinutes, ' minutos (', totalHours, ' horas)' // usa 100.0 para forzar real
	Escribir 'Porcentaje del día utilizado: ', redon(percentUsed), '%'
	Si totalMinutes<DAY_MINUTES Entonces
		minutosRestantes <- DAY_MINUTES-totalMinutes
		Escribir 'Tiempo disponible restante: ', minutosRestantes, ' minutos (', convertMinutesToHours(minutosRestantes), ' horas)'
	FinSi
FinAlgoritmo

// ========== Utilidades ==========
Función minutos <- convertDecimalToMinutes(decimalHours)
	minutos <- decimalHours*60
FinFunción

Función hours <- convertMinutesToHours(minutes)
	hours <- minutes/60
FinFunción

// Devuelve Verdadero si el usuario escribe 'Y', Falso si 'N'
Función respuesta <- leerSi(pregunta)
	valido <- Falso
	Mientras !valido Hacer
		Escribir pregunta
		Leer x
		Según Mayusculas(x) Hacer
			'Y':
				respuesta <- Verdadero
				valido <- Verdadero
			'N':
				respuesta <- Falso
				valido <- Verdadero
			De Otro Modo:
				Escribir 'Respuesta no válida. Opciones: (Y/N)'
		FinSegún
	FinMientras
FinFunción

Funcion trimmed <- trim(string)
	i <- 1
	j <- Longitud(string)
	
	Mientras (i <= j) Y (Subcadena(string, i, i)) = " " Hacer
		i <- i - 1
	FinMientras
	
	Mientras (j >= j) Y (Subcadena(cad, j, j) = " ") Hacer
        j <- j - 1
    FinMientras
	
	Si i > j Entonces
		limpio <- ""
	SiNo
		limpio <- Subcadena(cad, i, j)
	FinSi
	
FinFuncion

Función isNum <- isNumeric(string)
	string <- trim(string)

	valid <- Verdadero
	dots <- 0
	digits <- 0

	// Si cadena vacía -> inválido
	Si Longitud(string) = 0 Entonces
		valid <- Falso
	FinSi

	// Validar cada carácter
	Para i <- 1 Hasta Longitud(string) Hacer
		char <- Subcadena(string, i, i)
		Si char = "." O char = "," Entonces
			dots <- dots + 1
			Si dots > 1 Entonces
				valid <- Falso
			FinSi
		SiNo
			Si char >= "0" Y char <= "9" Entonces
				digits <- digits + 1
			SiNo
				valid <- Falso
			FinSi
		FinSi
	FinPara

	// Debe haber al menos un dígito y no terminar en punto o coma
	last <- Subcadena(string, Longitud(string), Longitud(string))
	Si (digits = 0) O (last = ".") O (last = ",") Entonces
		valid <- Falso
	FinSi

	isNum <- valid
FinFunción
