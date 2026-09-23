# 📱 Aprendiendo Xcode + SwiftUI

Apuntes personales del proceso de aprendizaje de **Swift**, **SwiftUI** y el ecosistema de Apple, organizados por lecciones.

## 📚 Índice

| # | Lección | Tema |
|---|---------|------|
| 1 | [Bases](#-lección-1-bases) | Vistas, modificadores, contenedores y variables |
| 2 | [States](#-lección-2-states) | Estado interno de la vista con `@State` |
| 3 | [Listas](#-lección-3-listas) | Renderizar colecciones con `List` y `ForEach` |
| 4 | [Estados compartidos](#-lección-4-estados-compartidos) | Compartir y editar datos entre vistas con `@Binding` |
| 5 | [Sacar los datos de la vista](#-lección-5-sacar-los-datos-de-la-vista) | Componentizar con `class` y `@Observable` |
| 6 | [Persistencia (método copia)](#-lección-6-persistencia-método-copia) | `UserDefaults` / JSON con `Codable` |
| 7 | [Persistencia (SwiftData)](#-lección-7-persistencia-referenciasswiftdata) | Base de datos con `@Model` y `@Query` |
| 8 | [Consumir APIs externas](#-lección-8-consumir-apis-externas) | `async`/`await`, `URLSession` y `Codable` |

---

## 🧱 Lección 1: Bases

- Toda vista está **obligada a tener un `body`**, ya que todo lo que haya dentro va a ser lo que se renderice.

- Un **modificador** sirve para modificar las propiedades visuales de un elemento (tamaño, color, fondo, padding, etc). Para modificar un elemento (textos, imágenes, etc) simplemente **encadenás modificadores**: debajo de la vista agregás un punto (`.`) y el modificador que quieras.

- Existen **3 tipos de contenedores** para agrupar uno o más elementos:

  | Contenedor | Eje | Descripción |
  |------------|-----|-------------|
  | `VStack` | Y | Agrupa elementos en vertical |
  | `HStack` | X | Agrupa elementos en horizontal |
  | `ZStack` | Z | Agrupa elementos en profundidad |

- Las variables se pueden guardar de dos maneras:
  - **`var` (variable):** valor que cambia (monto, número, texto, etc).
  - **`let` (constante):** valor que no cambia (id, etc).

- Únicamente se pueden tener **10 redirecciones** por `HStack`, `VStack` o `List`.

---

## 🔄 Lección 2: States

- El `ContentView`, que engloba toda la vista, es un **`struct`**, por lo que no podemos agregar lógica que modifique valores en tiempo real directamente en los elementos (`Text`, `Button`, etc).

- Para solucionar esto existe **`@State`**, que sirve para definir datos básicos (`number`, `string`, `boolean`).
  - `@State` siempre va con la etiqueta **`private`**, ya que es un estado interno de la vista donde se define.

- Lo que genera `@State` es **eliminar y crear la vista constantemente**, comparando la vista antigua con la nueva. La información no se pierde porque `@State` guarda "screenshots" de las vistas **por fuera** del archivo.

```swift
@State private var contador = 0

Text("Contador: \(contador)")
```

- Sintaxis útil:
  - `\(variable)` → **interpolación de strings**: sirve para meter variables dentro de una cadena de texto.
  - `$variable` → sirve para agregar de manera directa variables a los elementos.

- Maneras de leer datos:
  - **Sin `$` (`subject`):** únicamente sirve para **leer** datos.
  - **Con `$` — Binding (`$subject`):** sirve para **leer, compartir y modificar** los datos, tanto en la vista donde se creó el `@State` como en otra a la que se le compartió.

---

## 📋 Lección 3: Listas

Colección de datos que posteriormente se renderizarán.

### Estructura del modelo

```swift
struct Medicamento: Identifiable {
    let id = UUID()
    let nombre: String
    let dosis: String
}
```

- **`Identifiable`:** requisito para identificar una lista.
- **`id = UUID()`:** crea un identificador único y aleatorio. Es obligatorio, ya que es lo que diferencia un dato de otro.
- Cada campo debe tener aclarado su tipo (`String`, `Int`, `Bool`, etc).

> Así se define la estructura del objeto que queremos crear. A la hora de invocarla para crear objetos, hay que definir todos los datos **menos `id`**, que se genera automáticamente.

### Ejemplo de uso

```swift
let medicamentos = [
    Medicamento(nombre: "Paracetamol", dosis: "500 mg"),
    Medicamento(nombre: "Ibuprofeno", dosis: "400 mg"),
    Medicamento(nombre: "Amoxicilina", dosis: "875 mg")
]
```

Acá creamos un array (lista) de `Medicamento` al que le pasamos los datos que necesita, menos el `id`.

Para mapear los datos de la lista, dentro del `body`:

```swift
List(medicamentos) { med in
    NavigationLink {
        DetalleView(medicamento: med)
    } label: {
        Text(med.nombre)
    }
}
```

- **`List`** → función de SwiftUI que recibe como parámetro el array creado y define quién lo va a recorrer (en este caso `med`).
- **`NavigationLink`** → sirve para navegar de una vista a otra; por defecto agrega una flecha para volver. En el `label` podés poner lo que quieras (como un `body` común: `VStack`, `HStack`, `Text`, etc).
- Dentro del `NavigationLink`, entre las primeras llaves, se define la vista a la que va a saltar (en este caso `DetalleView`), a la cual le pasamos los datos para renderizar lo que queramos.

### `List` vs `ForEach`

**`List`** → únicamente muestra lo que trae el array.

- **Modificadores genéricos:** `padding`, `disabled`, `listStyle`, `background`, etc.
- **Modificadores de navegación:**
  - `navigationTitle("TÍTULO")` → título de la página (uno por `NavigationStack`).
  - `toolbar { }` → agrega botones en la barra superior.
  - `searchable()` → agrega una barra de búsqueda.
  - `refreshable { }` → recarga la página.
- **Modificadores de fila:**
  - `swipeActions { }` → agrega botones con acciones (borrar, modificar, etc) por si `onDelete` queda corto.

**`ForEach`** → sirve para repetir algo en cada elemento del array.

- `onDelete { }` → elimina un elemento de la fila.
- `onMove { }` → ordena la lista arrastrando los elementos. **Solo** funciona si en la `toolbar` agregás `EditButton()`.

---

## 🔗 Lección 4: Estados compartidos

- Permite **modificar datos entre distintas vistas**.
- Los `@State` solo se pueden modificar en la vista donde fueron creados. Para modificar la información en otra vista, hay que compartirle los **"permisos"** (además de leer, poder modificar).

**Ejemplo:** en `ContentView` tengo un array `subjects`. Para poder actualizar cada materia desde `DetalleView`, le comparto los permisos así:

```swift
ForEach($subjects) { $sub in
    NavigationLink {
        DetalleView(subject: $sub)
    } label: {
        Text(sub.type)
            .font(.headline)
            .foregroundStyle(sub.hasTask ? .red : .green)
    }
}
```

- Al `ForEach` le compartimos directamente el array original con **`$subjects`**, y al indicador que lo recorre también lo definimos con `$` (`$sub`).
- Compartir con `$` significa que la vista que recibe la info está **habilitada para editarla**.
- Se pueden usar ambas formas de mostrar la información, con o sin `$`.

Luego, en `DetalleView`, la variable que recibe la información tiene este formato:

```swift
@Binding var subject: Subject
```

- **`@Binding`:** indica que los datos recibidos pueden ser modificados.
- **`var`:** variable que puede cambiar.
- **`subject`:** nombre de la variable (relacionado a lo que recibe).
- **`Subject`:** nombre del modelo que recibe.

Para modificar los datos de cada objeto, se llaman con `$`:

```swift
Form {
    TextField("Título", text: $subject.type)
    Toggle("Tarea pendiente", isOn: $subject.hasTask)
}
```

---

## 📦 Lección 5: Sacar los datos de la vista

- Lo ideal en cualquier proyecto es **componentizar**: muchos archivos, cada uno con código que hace una acción particular. Para armar funciones, variables, propiedades calculadas o arrays que se compartan entre componentes, conviene crear una **`class`** en vez de un `struct`. Funciona a modo de **contexto**: podés acceder a todo lo que tenga dentro desde cualquier parte del código.

- La particularidad de las `class` es que es un **mismo archivo para todo el proyecto**: lo que modifiques en un lado se refleja en otro. (Distinto a los hooks de React, donde podés llamar varias veces al mismo hook en distintos archivos y no se comparten entre ellos.)

### Estructura

```swift
@Observable
class NombreDeLaClase {
    // Variables
    // Funciones (func)
    // Arrays
    // Propiedades calculadas
}
```

Y a la hora de llamarlo en cada archivo:

```swift
@State private var store = NombreDeLaClase()
```

Una vez guardado en el `@State`, funciona como un objeto común: usás el punto (`.`) para recuperar lo que quieras.

### Ejemplo

```swift
// STORE
class SubjectStore {
    var subjects = [
        Subject(type: "Matemática", hasTask: true),
        Subject(type: "Lengua", hasTask: false),
        Subject(type: "Historia", hasTask: true),
        Subject(type: "Geografía", hasTask: true),
        Subject(type: "Inglés", hasTask: false),
        Subject(type: "Filosofía", hasTask: false)
    ]
}

// ARCHIVO
@State private var store = SubjectStore()

ForEach(store.subjects) { ... }
```

---

## 💾 Lección 6: Persistencia (método copia)

- Para que los datos persistan en el tiempo (sin importar si se cierra, actualiza o lo que le pase al proyecto) existe el **método de COPIA**, con dos variantes: usando **`UserDefaults`** o un **archivo JSON**.
- Para este método, a cada modelo que armemos hay que definirle la interface **`Codable`**, para poder transformarlo a JSON.

| Variante | Para qué sirve |
|----------|----------------|
| `UserDefaults` | Espacio en memoria de la app para guardar **pequeñas** cantidades de información |
| Archivo JSON | Guardar **más** cantidad de información, por si el proyecto crece |

### `UserDefaults`

Se divide en **5 puntos** que se setean en el store para una mejor organización.

**1) `key`** → variable donde definimos la key bajo la cual se guarda la información en memoria.

```swift
private let key = "subjects"
```

- Es `private` porque solo se accede a esta variable dentro del archivo donde se invocó.

**2) `save()`** → transforma la info a JSON y la guarda en memoria con `UserDefaults.standard.set(data, forKey: key)`.

```swift
private func save() {
    guard let data = try? JSONEncoder().encode(subjects) else { return }
    UserDefaults.standard.set(data, forKey: key)
}
```

- `JSONEncoder().encode(subjects)` transforma el `subject` a JSON para poder guardarlo.
- El `guard let` hace que, si falla la conversión, salga de la función sin hacer nada.
- El `try?` hace que, si falla el `.encode`, devuelva `nil`.

**3) `load()`** → función inversa al `save`: busca en memoria usando la key y decodifica con `.decode` para volver a un formato que se pueda renderizar.

```swift
private func load() {
    guard let data = UserDefaults.standard.data(forKey: key),
          let decoded = try? JSONDecoder().decode([Subject].self, from: data)
    else {
        subjects = Subject.ejemplos
        return
    }
    subjects = decoded
}
```

- El `guard let` hace que, si falla la recuperación desde memoria, caiga en el `else`, obligando a usar los datos de prueba.
- El `try?` hace que, si falla el `.decode`, devuelva `nil`.

**4) `init()`** → se llama siempre que se carga el store; sirve para recuperar lo último que se guardó (por defecto, los datos de prueba).

```swift
init() {
    load()
}
```

**5) `didSet`** → hace que el `save` se ejecute automáticamente, sin necesidad de anclarlo a cada función.

```swift
var subjects: [Subject] = [] {
    didSet { save() }
}
```

Luego, al armar alguna función (`delete`, `toggle`, etc):

```swift
func remove(at offsets: IndexSet) {
    subjects.remove(atOffsets: offsets)
}
```

- Cada vez que hagas un `remove`, se activa el `didSet` de `subjects`, generando que se haga el `save()` automáticamente.

### Conexión desde el root

Ahora, en vez de llamar al store en el `ContentView`, lo hacemos directamente en el root del proyecto (`learnXcodeApp`):

```swift
@State private var store = SubjectStore()

ContentView()
    .environment(store)
```

Luego, en el `ContentView` lo recuperamos así:

```swift
@Environment(SubjectStore.self) private var store
```

- De manera privada: solo vive en el archivo donde se invocó y en los hijos a los que se les compartió.

Por último, para seguir usándolo como binding, dentro del `body`:

```swift
@Bindable var store = store
```

> **💡 Dato extra:** para que funcione el `#Preview`, hay que concatenarle el `.environment` igual que en el root:
> ```swift
> #Preview {
>     ContentView()
>         .environment(SubjectStore())
> }
> ```

---

## 🗄️ Lección 7: Persistencia (referencias/SwiftData)

- A diferencia del método de COPIA (lección 6), donde nosotros transformábamos a JSON y guardábamos/leíamos de la memoria manualmente, **SwiftData es una base de datos que maneja Apple por nosotros**. Nos olvidamos del `save()`, `load()`, `init()` y `didSet`: SwiftData guarda los cambios solo.

- Al trabajar por **referencias**, el modelo pasa a ser una **`class`** en vez de un `struct`. Además ya no hacen falta `Codable` ni `Identifiable`, ni el campo `id`: SwiftData los maneja internamente.

**1) Modelo (`@Model`)** → el macro `@Model` convierte una clase en algo guardable en la base de datos.

```swift
import SwiftData

@Model
class Subject {
    var type: String
    var hasTask: Bool

    init(type: String, hasTask: Bool = false) {
        self.type = type
        self.hasTask = hasTask
    }
}
```

- `@Model` transforma la clase en una tabla de la base de datos.
- No hace falta `id`, ni `Codable`, ni `Identifiable` (los agrega SwiftData solo).

**2) Container** → en el root (`learnXcodeApp`) le decimos a SwiftData que arme la base de datos usando nuestro modelo.

```swift
WindowGroup {
    ContentView()
}
.modelContainer(for: Subject.self)
```

- `modelContainer(for:)` crea y conecta la base de datos para ese modelo.

**3) `@Query`** → consulta la base de datos, trae el array del modelo y se actualiza **solo** cada vez que algo cambia.

```swift
@Query private var subjects: [Subject]
```

También se le puede pasar un **filtro** con `#Predicate` para traer solo los que cumplan una condición:

```swift
@Query(filter: #Predicate<Subject> { $0.hasTask }) private var pending: [Subject]
```

- `pending` trae únicamente las materias cuyo `hasTask` sea `true`.
- El filtrado ocurre en la base de datos (más eficiente que filtrar el array en memoria).

**4) `@Environment(\.modelContext)`** → es el contexto con el que modificamos la base de datos (insertar, borrar). El `@Query` solo **lee**; el `context` es el que **escribe**.

```swift
@Environment(\.modelContext) private var context

// Insertar (guardar) un objeto nuevo
context.insert(Subject(type: "Nueva materia"))

// Borrar un objeto
context.delete(subjects[i])
```

- En cuanto insertás/borrás/modificás, los `@Query` se actualizan solos y la vista se redibuja.
- Modificar una propiedad de un objeto ya guardado (ej: `sub.hasTask.toggle()`) también se guarda solo, sin llamar a ningún `save()`.

> **💡 Dato extra:** para el `#Preview` conviene usar una base de datos **en memoria** (no toca el disco), así arranca limpia cada vez:
> ```swift
> #Preview {
>     ContentView()
>         .modelContainer(for: Subject.self, inMemory: true)
> }
> ```

---

## 🌐 Lección 8: Consumir APIs externas

- Para traer datos de un servicio externo (una API) usamos **`async`/`await`**: funciones que tardan (van a internet, esperan la respuesta) **sin congelar la app**. Se separa en 3 partes: el **modelo** (cómo llegan los datos), el **servicio** (el llamado) y la **vista** (mostrar / manejar carga y errores).

**1) Modelo** → como los datos vienen de un JSON, el modelo es un `struct` con `Codable` (para decodificar el JSON) e `Identifiable` (para poder listarlo).

```swift
struct Holiday: Codable, Identifiable {
    let fecha: String
    let tipo: String
    let nombre: String

    var id: String { fecha + nombre }
}
```

- `Codable` permite transformar el JSON de la API en este struct.
- Como la API no nos da un `id`, lo armamos nosotros combinando campos (`fecha + nombre`).
- Los nombres de los campos deben coincidir con los del JSON.

**2) Servicio** → `struct` con una función `async throws` que hace el llamado, valida la respuesta y decodifica.

```swift
struct HolidayService {
    func fetch(year: Int) async throws -> [Holiday] {
        let url = URL(string: "https://api.argentinadatos.com/v1/feriados/\(year)")!

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Holiday].self, from: data)
    }
}
```

- `async` → la función tarda (espera la respuesta de internet).
- `throws` → la función puede fallar (sin internet, error del server, etc).
- `await` → "espera acá" hasta que vuelva la respuesta, sin congelar la app.
- `URLSession.shared.data(from:)` → hace el llamado y devuelve la `data` + la `response`.
- `guard ... statusCode == 200` → valida que el server respondió OK; si no, lanza un error (`throw`).
- `JSONDecoder().decode([Holiday].self, from: data)` → transforma el JSON en el array de `Holiday`.

**3) Vista** → maneja 3 estados con `@State`: los datos, el "cargando" y el mensaje de error.

```swift
@State private var holidays: [Holiday] = []
@State private var loading = false
@State private var errorMsj: String?
```

La función que llama al servicio maneja el loading y captura los errores:

```swift
private func cargar() async {
    loading = true
    defer { loading = false }

    do {
        holidays = try await HolidayService().fetch(year: 2026)
        errorMsj = nil
    } catch {
        errorMsj = error.localizedDescription
    }
}
```

- `defer` → parecido al `finally`: se ejecuta sí o sí cuando termina la función (apaga el loading pase lo que pase).
- `do / catch` → intenta el llamado; si falla (`throw`), cae en el `catch` y guarda el mensaje de error.

**Modificadores clave en la vista:**

- `.task { await cargar() }` → llama al servicio automáticamente al abrir la vista. Si el usuario se va a otra pantalla mientras carga, corta el llamado solo (sin generar problemas).
- `.refreshable { await cargar() }` → permite recargar tirando la lista hacia abajo (*pull to refresh*).
- `.overlay { }` → muestra algo **por encima** de la vista. Se usa para el estado de carga y el de error:
  - `ProgressView("Cargando...")` → el spinner mientras carga.
  - `ContentUnavailableView` → pantalla de "no se pudo cargar" con un botón de reintentar.
