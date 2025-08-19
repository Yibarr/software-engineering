def get_valid_input(prompt, validate_func, error_message):
    value = input(prompt).strip()
    while not validate_func(value):
        print(error_message)
        value = input(prompt).strip()
    return value

def read_yes_no(prompt: str) -> bool:
    while True:
        ans = input(prompt).strip().upper()
        if ans == 'Y':
            return True
        if ans == 'N':
            return False
        print("Respuesta no válida. Opciones: (Y/N)")

def report(user_name: str, apps: dict[str, int], total_minutes: int) -> None:
    DAY_MINUTES = 24 * 60
    print(f"\nResumen de {user_name}:")
    for i, (name, minutes) in enumerate(apps.items(), start=1):
        print(f"  {i}) {name} -> {minutes} minutos")

    total_hours = convert_minutes_to_hours(total_minutes)
    percent_used = (total_minutes * 100.0) / DAY_MINUTES

    print(f"Número de apps: {len(apps)}")
    print(f"Total del día: {total_minutes} minutos ({total_hours:.2f} horas)")
    print(f"Porcentaje del día utilizado: {percent_used:.2f}%")

    if total_minutes < DAY_MINUTES:
        left_minutes = DAY_MINUTES - total_minutes
        left_hours = convert_minutes_to_hours(left_minutes)
        print(f"Tiempo disponible restante: {left_minutes} minutos ({left_hours:.2f} horas)")

def is_numeric(valor):
    try:
        float(valor)
        return True
    except ValueError:
        return False

def convert_decimal_to_minutes(decimal_hours):
    return int(decimal_hours) * 60

def convert_minutes_to_hours(minutes: int) -> float:
    return minutes / 60.0

def calculate_screen_time():
    # Constants
    APP_MIN_QTY = 5
    APP_MAX_QTY = 10
    DAY_MINUTES = 24 * 60
    # State
    app_count = 0
    total_minutes = 0
    finished = False
    # Data
    apps = {}

    print('Bienvenido a la calculadora de tiempo de pantalla')
    user_name = get_valid_input(
        "Por favor, ingresa tu nombre: ",
        lambda x: len(x) > 0,
        "El nombre no puede estar vacío. Inténtalo de nuevo."
    )
    print(f"Hola, {user_name}! Bienvenido a la calculadora de tiempo de pantalla.")
    while not finished:
        print(f'Ingrese el nombre de la app número: {app_count + 1}')
        app_name = get_valid_input(
            "Nombre de la app: ",
            lambda x: len(x) > 0,
            "El nombre de la app no puede estar vacío. Inténtalo de nuevo."
        )

        print('Ingrese el tiempo de pantalla en horas (puede ser decimal, ej. 1.5):')
        hours = get_valid_input(
            "Horas: ",
            lambda x: is_numeric(x) and float(x) >= 0,
            "Entrada no válida. Ingrese un número de horas >= 0 (ej. 0, 0.5, 1.5):"
        )
        app_minutes = convert_decimal_to_minutes(hours)
        if (total_minutes + app_minutes) < DAY_MINUTES:
            app_count += 1
            total_minutes += app_minutes
            apps[app_name] = app_minutes

            if app_count >= APP_MIN_QTY and app_count < APP_MAX_QTY:
                if not read_yes_no("¿Deseas agregar otra app? (Y/N): "):
                    finished = True
            elif app_count >= APP_MAX_QTY:
                print(f'Has alcanzado el número máximo de apps ingresadas ({APP_MAX_QTY}).')
                finished = True

        elif (total_minutes + app_minutes) == DAY_MINUTES:
            app_count += 1
            total_minutes += app_minutes
            apps[app_name] = app_minutes
            finished = True
        else:
            left_minutes = DAY_MINUTES - total_minutes
            left_hours = convert_minutes_to_hours(left_minutes)
            print('El tiempo ingresado excede el disponible en el día')
            print(f'Aún quedan: {left_hours} horas ( {left_minutes} minutos)')

        if not finished and app_count < APP_MIN_QTY and total_minutes == DAY_MINUTES:
            finished = True
    report(user_name, apps, total_minutes)

if __name__ == "__main__":
    calculate_screen_time()