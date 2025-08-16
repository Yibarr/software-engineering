Proceso ScreenTimeCalculator
	appMaxQty <- 10
	Dimensionar apps[appMaxQty, 2]
	AddApp(apps, appMaxQty)
FinProceso
SubProceso AddApp(apps, appMaxQty)
	appMinQty <- 5
	
	appQty <- 1
	isUserFinished <- Falso
	
	Escribir "Bienvenido a la calculadora de tiempo de pantalla. Debes ingresar al menos aplicaciones, para comenzar"
	Mientras !isUserFinished Hacer
		Escribir "Ingresa el nombre de la aplicaci�n n�mero:"
		Escribir appQty
		Leer apps[appQty, 1]
		Escribir "Ingresa el tiempo de pantalla en minutos"
		Leer apps[appQty, 2]
		appQty <- appQty + 1
		isAnswerValid <- Falso
		Si  appQty > appMinQty Entonces
			Mientras !isAnswerValid Hacer
				Escribir 'Deseas agregar otra aplicaci�n (Y/N)'
				Leer userResponse
				Seg�n userResponse Hacer
				'N':
					isUserFinished <- Verdadero
					isAnswerValid <- Verdadero
				'Y':
					Si appQty = appMaxQty Entonces
						Escribir "Haz alcanzado el n�mero m�ximo de aplicaciones ingresadas"
						isUserFinished <- Verdadero
					FinSi
					isAnswerValid <- Verdadero
				De Otro Modo:
					Escribir 'Respuesta no v�lida, opciones: Y o N'
				FinSeg�n
			FinMientras
		FinSi
	FinMientras
FinSubProceso

