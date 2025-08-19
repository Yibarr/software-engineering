Algoritmo ScreenTimeCalculator
	Definir APP_MIN_QTY, APP_MAX_QTY, DAY_MINUTES Como Entero
	APP_MIN_QTY <- 5
	APP_MAX_QTY <- 10
	DAY_MINUTES <- 24*60 
	Definir appCount, totalMinutes Como Entero
	appCount <- 0
	totalMinutes <- 0
	Definir finished Como Lógico
	finished <- Falso
	// Data
	Dimensionar apps(APP_MAX_QTY,2)
	Escribir 'Bienvenido a la calculadora de tiempo de pantalla.'
	Escribir 'Por favor, ingresa tu nombre:'
	Leer userName
	Mientras (Longitud(trim(userName))=0) Hacer
		Escribir 'El nombre no puede estar vacío. Inténtalo de nuevo:'
		Leer userName
	FinMientras
	Escribir 'Hola, ', userName, '. Debes ingresar al menos ', APP_MIN_QTY, ' apps.'
	Mientras !finished Hacer
		Escribir 'Ingrese el nombre de la app número: ', appCount+1
		Leer appName
		appName <- appName
		Mientras (Longitud(trim(appName))=0) Hacer
			Escribir 'El nombre no puede estar vacío. Inténtalo de nuevo:'
			Leer appName
			appName <- appName
		FinMientras
		Escribir 'Ingrese el tiempo de pantalla en horas (puede ser decimal, ej. 1.5):'
		Leer hoursInput
		Mientras !isNumeric(hoursInput) O ConvertirANumero(hoursInput)<0 Hacer
			Escribir 'Entrada no válida. Ingrese un número de horas >= 0 (ej. 0, 0.5, 1.5):'
			Leer hoursInput
		FinMientras
		decimalHours <- ConvertirANumero(hoursInput)
		appMinutes <- convertDecimalToMinutes(decimalHours)
		Si (totalMinutes+appMinutes)<DAY_MINUTES Entonces
			appCount <- appCount+1
			totalMinutes <- totalMinutes+appMinutes
			apps[appCount,1]<-appName
			apps[appCount,2]<-ConvertirATexto(appMinutes)
			Si appCount>=APP_MIN_QTY Y appCount<APP_MAX_QTY Entonces
				Si !readIf('¿Desea agregar otra app? (Y/N)') Entonces
					finished <- Verdadero
				FinSi
			SiNo 
				// Si ya llegamos al máximo, terminar
				Si appCount=APP_MAX_QTY Entonces Escribir 'Ha alcanzado el número máximo de apps ingresadas.'
					finished <- Verdadero
				FinSi
			FinSi
		SiNo
			// Exactamente llena el día
			Si (totalMinutes+appMinutes)=DAY_MINUTES Entonces
				appCount <- appCount+1
				totalMinutes <- totalMinutes+appMinutes
				apps[appCount,1]<-appName
				apps[appCount,2]<-ConvertirATexto(appMinutes)
				finished <- Verdadero
			SiNo
				// Excede: informar y NO registrar
				availableMinutes <- DAY_MINUTES-totalMinutes
				availableHours <- convertMinutesToHours(availableMinutes)
				Escribir 'El tiempo ingresado excede el disponible.'
				Escribir 'Aún quedan: ', ConvertirATexto(availableHours), ' horas (', ConvertirATexto(availableMinutes), ' minutos).'
			FinSi
		FinSi
		// Si no llegó al mínimo pero ya no hay espacio
		Si (!finished) Y (appCount<APP_MIN_QTY) Y (totalMinutes=DAY_MINUTES) Entonces
			finished <- Verdadero
		FinSi
	FinMientras
	Report(userName, apps, appCount, totalMinutes, DAY_MINUTES)
FinAlgoritmo
Funcion Report(userName, apps, appCount, totalMinutes, DAY_MINUTES)
	Definir totalHours, percentUsed Como Real
	Definir leftMinutes Como Entero
	Definir i Como Entero
	Escribir "Resumen de ", userName, ":"
	Para i <- 1 Hasta appCount Hacer
		Escribir " ", i, ") ", apps[i, 1], " -> ", apps[i, 2], " minutos"
	FinPara
	totalHours <- convertMinutesToHours(totalMinutes)
	percentUsed <- (totalMinutes * 100.0) / DAY_MINUTES
	Escribir "Número de apps: ", appCount
	Escribir "Total del día: ", totalMinutes, " minutos (", totalHours, " horas)"
	Escribir "Porcentaje del día utilizado: ", Redon(percentUsed), "%"
	Si totalMinutes < DAY_MINUTES Entonces leftMinutes <- DAY_MINUTES - totalMinutes
		Escribir "Tiempo disponible restante: ", leftMinutes, " minutos (", convertMinutesToHours(leftMinutes), " horas)"
	FinSi
FinFuncion
Función answer <- readIf(question)
	valid <- Falso
	Mientras !valid Hacer
		Escribir question
		Leer x
		Según Mayusculas(x) Hacer
			'Y':
				answer <- Verdadero
				valid <- Verdadero
			'N':
				answer <- Falso
				valid <- Verdadero
			De Otro Modo:
				Escribir 'Respuesta no válida. Opciones: (Y/N)'
		FinSegún
	FinMientras
FinFunción
Función minutes <- convertDecimalToMinutes(decimalHours)
	inutes <- decimalHours*60
FinFunción
Función hours <- convertMinutesToHours(minutes)
	hours <- minutes/60
FinFunción
Funcion trimmed <- trim(string)
	i <- 1
	j <- Longitud(string)
	Mientras (i <= j) Y (Subcadena(string, i, i)) = " " Hacer
		i <- i - 1
	FinMientras
	Mientras (j >= j) Y (Subcadena(string, j, j) = " ") Hacer
		j <- j - 1
	FinMientras
	Si i > j Entonces
		trimmed <- ""
	SiNo trimmed <- Subcadena(string, i, j)
	FinSi
FinFuncion
Función isNum <- isNumeric(string)
	string <- trim(string)
	valid <- Verdadero
	dots <- 0
	digits <- 0 
	Si Longitud(string) = 0 Entonces
		valid <- Falso
	FinSi
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
	last <- Subcadena(string, Longitud(string), Longitud(string))
	Si (digits = 0) O (last = ".") O (last = ",") Entonces
		valid <- Falso
	FinSi
	isNum <- valid
FinFunción
	