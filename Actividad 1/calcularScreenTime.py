def get_valid_input(prompt, validate_func, error_message):
    value = input(prompt).strip()
    while not validate_func(value):
        print(error_message)
        value = input(prompt).strip()
    return value

def in_numeric(valor):
    try:
        float(valor)
        return True
    except ValueError:
        return False

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
    userName = userName = get_valid_input(
        "Por favor, ingresa tu nombre: ",
        lambda x: len(x) > 0,
        "El nombre no puede estar vacío. Inténtalo de nuevo."
    )
    print(f"Hola, {userName}! Bienvenido a la calculadora de tiempo de pantalla.")
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
            lambda x: in_numeric(x) and float(x) >= 0,
            "Entrada no válida. Ingrese un número de horas >= 0 (ej. 0, 0.5, 1.5):"
        )
        # ...existing code...



if __name__ == "__main__":
    calculate_screen_time()