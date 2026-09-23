
-- LECCION 1: BASES --

*Toda vista esta obligada a tener un body ya que todo lo que haya dentro va a ser lo que se renderice.

*Un modificador sirve para justamente modificar las propiedades visuales de un elemento (tamaño, color, fondo, padding, etc)
    Para modificar X elemento (textos, imagenes, etc) simplemente encadenas modificadores (debajo de la vista agregar un punto (.) y el modificador que quieras)
    
*Existen 3 tipos de contenedores para agrupar uno o mas elementos
    VSTACK: Agrupa elemetos sobre el eje Y (vertical)
    HSTACK: Agrupa elementos sobre el eje X (horizontal)
    ZSTACK: Agrupa elementos sobre el eje Z (profundidad)
    
*Las variables se pueden guardar de dos maneras:
    VAR (variable): Refiere a variables cuyo valor cambia (monto, numero, texto, etc)
    LET (constante): Refiere a variables cuyo valor no cambia (id, etc)
    
*Unicamente se pueden tener 10 redirecciones por HStack, VStack o list.

-- LECCION 2: STATES -- 

*El contentView el cual engloba toda la vista es un STRUCT, por lo que no podemos agregar ninguna logica que modifique valores en tiempo real directamente en los elementos 
(text, buttons, etc).

*Para solucionar esto existe "@State" la cual sirve para definir datos basicos (numbers, string, boolean).
    @State siempre va con la etiqueta "private" ya que es un estado interno de la vista en donde se define.
    
*State lo que genera es eliminar y crear constantemente la vista, compara la vista antigua con la nueva. Por el unico motivo que no se pierde la informacion es porque State guarda "screnshots" de las vistas por fuera del archivo.
    
    ESTRUCTURA: @State private var [NOMBRE-DE-VARIABLE] = [VALOR]
                
                Text("Contador: \([NOMBRE-DE-VARIABLE])")
                
    \([VARIABLE]) -> Este formato se conoce como interpolacion de strings, sirve para meter variables dentro de una cadena de string
    $[VARIABLE] -> Esto sirve para agregar de manera directa variables a los elementos.
    
*Maneras de leer datos:
    
    sin $ (subject): Unicamente sirve para leer datos
    con $ - Binding ($subject): Sirve para leer, compartir y modificar los datos tanto en la vista en la que fue creado el @State como en otra a la que se le compartio.
    
    
-- LECCION 3: LISTAS --

*Coleccion de datos que los cuales posteriormente se renderizaran

    ESTRUCTURA: 
    
        struct Medicamento: Identifiable {
            let id = UUID()
            let nombre: String
            let dosis: String
        }
        
        -Identificable: Es un requisito para identificar una lista
        -id = UUID(): Crea un identificador unico y aleatorio. El ID es obligatorio ya que es lo que diferencia un dato de otro
        -Cada campo debe tener aclarado su tipo (string, int, bool, etc)
        
        *Esto es como se define la estructura del objeto que queremos crear, se definen los datos que va a recibir y de que tipo. A la hora de invocar esta estructura para crear dichos objetos, hay que definir todos los datos que necesita MENOS "ID" ya que este se define automaticamente.
        
        EJEMPLO:
        
            let medicamentos = [
                Medicamento(nombre: "Paracetamol", dosis: "500 mg"),
                Medicamento(nombre: "Ibuprofeno", dosis: "400 mg"),
                Medicamento(nombre: "Amoxicilina", dosis: "875 mg")
            ]
            
            *Aca estamos creando un array (lista) de Medicamento (estructura creada anteriormente) a la cual le pasamos los datos que necesita, menos el ID.
            
            *Para mapear los datos de la lista creada tenemos que hacer lo siguiente dentro del body:
            
                List(medicamentos) { med in
                NavigationLink {
                    DetalleView(medicamento: med)
                } label: {
                    Text(med.nombre)
                }
                
                - List -> Funcion de SwiftUI que recibe como parametro el array creado, define quien lo va a recorrer (en este caso "med")
                - NavigationLink -> sirve para navegar de una vista a otra, por defecto agrega una flecha para volver a la pantalla inicial, en el label podemos agregar lo que queramos como si fuera un body comun y corriente (VStack, HStack, Text, etc)
                - Dentro del "NavigationLink" entre las primeras llaves, se define la vista a la que va a saltar, en este caso "DetalleView" a la cual le pasamos la lista completa para luego, en dicha vista, renderizar lo que queramos mostrar.
                  

    LIST VS FOREACH:
    
        List: Unicamente muestra lo que trae el array (en este caso "medicamentos")
            Modificadores:
                * genericos: padding, disabled, listStyle, background, etc
                * navegacion: - navigationTitle(["TITULO"]) -> titulo de la pagina (es uno por "NavigationStack")
                              - toolbar{} -> sirve para agregar botones en la barra superior (burguer, etc)
                              - searchable() -> agrega una barra de busqueda
                              - refreshable{} -> sirve para recargar la pagina
                              
                * modificadores de fila: - swipeAction {} -> sirve para agregar mas botones con acciones distintas (borrar, modificar, etc) por si el ".onDelete" queda corto.
                
                
        ForEach: Sirve para repetir X cosa en cada elemento del array
            Modificadores:  - onDelete{} -> sirve para eliminar un elemento de la fila
                            - onMove{} -> sirve para ordenar la lista arrastrando los elementos. UNICAMENTE funciona si en la toolbar agregas la funcion "editButton()"
                            

-- LECCION 4: ESTADOS COMPARTIDOS --

*Permite modificar datos entre distintas vistas.
*Los states unicamente se pueden modificar en la vista en la que fueron creados. Para obviar esta clausura, si queremos modificar la informacion en otra vista, tenemos que compartirle los "permisos" para que ademas de leer la info, tambien tenga la posibilidad de modificarla si asi lo requiere.

    EJ: En el "ContentView" tengo un array de materias llamado "subjects", para poder actualizar la informacion de cada materia en la pantalla de "DetalleView" debo compartirle los "permisos". Para esto, a la hora de compartirle la informacion a la vista, lo hacemos de esta manera:
        
        ForEach($subjects) { $sub in
            NavigationLink {
                DetalleView(subject: $sub)
            } label: {
                Text(sub.type)
                    .font(.headline)
                    .foregroundStyle(sub.hasTask ? .red : .green)
            }
        }
        
        * Al forEach le compartimos directamente el array original de esta manera: "$subjects", tambien al indicador que recorre el array lo definimos con el simbolo "$" delante. Por ultimo, a la vista "DetalleView" le compartimos el array de esta manera: "$sub", compartirlo con el simbolo "$" significa que la vista a la que se le comparte esta informacion esta habilitada para editarla.
        * Como se ve en el ejemplo, pueden utilizarse ambas formas de mostrar la informacion, con o sin el "$".  
        
        LUEGO, en el DetalleView, la variable que recupera la informacion recibida tiene que tener este formato:
        
                @Binding var subject: Subject
                
                * @Binging: Indica que los datos que recibio pueden ser modificados
                * var: variable que puede cambiar
                * subject: nombre de la variable (siempre que este relacionado a lo que esta recibiendo)
                * Subject: Nombre de la List que recibe
                
        Para modificar los datos de cada objeto del array, se llaman con el simbolo $.
            
            EJ:
                
                Form {
                    TextField("Título", text: $subject.type)
                    Toggle("tarea pendiente", isOn: $subject.hasTask)
                }
                


-- LECCION 5: SACAR LOS DATOS DE LA VISTA --

*Lo ideal en cualquier proyecto es componentizar, es decir, muchos archivos con codigos que hagan una accion en particular. Para esto, a la hora de armar funciones, variables, propiedades calculadas, array, o cualquier cosa que se vaya a compartir entre componentes, lo ideal es crear una CLASS en vez de un STRUCT. Funciona a modo de contexto, es decir, podes acceder a todo lo que tenga dentro la CLASS desde cualquier parte del codigo.
*La particularidad de las CLASS es que es un mismo archivo para todo el proyecto, es decir, lo que modifiques en un archivo se va a er reflejado en otro. Distinto a por ejemplo los hooks de react, en donde podes llamar varias veces al mismo hook en distintos archivos y no se comparten entre ellos
 
    ESTRUCTURA:
        
        @Observable
        class [NOMBRE DE LA CLASE] {
            
            VARIABLES
            FUNCIONES (func)
            ARRAYS
            PROPIEDADES CALCULADAS
        
        }
        
    Y A LA HORA DE LLAMARLO EN CADA ARCHIVO:
    
            @State private var store = [NOMBRE DE LA CLASS]()
            
            *Una vez guardado en el state funciona como un objeto comun y corriente, utilizando el punto ( . ) para recuperar la informacion que deseamos.
            
            EJ:
            
                STORE:
                
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
                    
                ARCHIVO:
                    
                    @State private var store = SubjectStore()
                    
                    ForEach(store.subjects){...}
                    


        
-- LECCION 6: PERSISTENCIA (METODO COPIA) --

*Para que los datos persistan en el tiempo, sin importar si se cierra, actualiza o lo que pueda llegar a sucederle al proyecto existe el metodo de COPIA, el cual a su vez tiene dos variantes, utilizando el "UserDefaults" o un "archivo JSON".
*Para este metodo de persistencia, a cada list que armemos debemos definirle otra interface llamada "codable" para luego poder transformarlos a json

    UserDefaults -> espacio en la memoria de la app para guardar pequeñas cantidades de informacion
    archivo JSON -> Sirve para guardar mas cantidad de informacion por si el proyecto en un futuro crece

*UserDefaults:
    
    *Basicamente se divide en 5 puntos los cuales se setean en el store para una mejor organizacion.
    
    1) KEY: Variable donde definimos la key en donde se va a guardar la informacion en memoria
        
        EJ: private let key = "subjects"
        
            - Es "private" ya que unicamente se puede acceder a esta variable dentro del archivo donde fue invocada
            
    2) SAVE(): Funcion la cual, luego de transformar la informacion que queremos guardar a JSON, guarda en la memoria mediante esta funcion:  UserDefaults.standard.set(data, forKey: key), utilizando como "KEY" la que definimos con anterioridad.
    
        EJ: 
        
            private func save() {
               guard let data = try? JSONEncoder().encode(subjects) else { return }
               UserDefaults.standard.set(data, forKey: key)
           }
           
           - El "JSONEncoder().encode(subjects)" transforma el "subject" a JSON para poder guardarlo
           - El "guard let" genera que si falla la conversion, sale de la funcion sin hacer nada
           - El "try" genera que si falla el ".encode", devuelve un nil
           
    3) LOAD: Funcion inversa al save, busca en la memoria la informacion guardada utilizando la key para encontrarla y luego mediante la funcion ".decode" transformar dicha informacion nuevamente a un lenguaje el cual se pueda renderizar.
    
        EJ: 
            
            private func load() {
                guard let data = UserDefaults.standard.data(forKey: key),
                let decoded = try? JSONDecoder().decode([Subject].self, from: data)
               else {
                   subjects = Subject.ejemplos
                   return
               }
               subjects = decoded
           }
           
           - El "guard let" genera que si falla la recuperacion de la informacion desde la memoria cae en el else, obligando a utilizar los datos de prueba
           - El "try" genera que si falla el ".decode", devuelve un nil
           
    4) INIT(): Funcion que se llama siempre que se carga el store, sirve para recuperar lo ultimo que se guardo (por defecto la informacion de prueba)
    
        EJ: 
        
            init() {
                load()
            }
            
            
    5) DIDSET: Genera que el save se ejecute siempre de forma automatica sin la necesidad de anclarlo a cada funcion que invoques.
    
        EJ:
        
            var subjects: [Subject] = [] {
                didSet { save() }
            }

        *Luego a la hora de armar alguna funcion (delete, toggle, etc), lo harias de esta manera:
        
            func remove(at offsets: IndexSet) {
                subjects.remove(atOffsets: offsets)
            }
            
            - Entonces cada vez que hagas un remove, automaticamente se activa la propiedad calculada "subjects", generando que se haga el save() automaticamente
            
            
*Con todo esto, ahora en vez de llamar al store en el contentView, lo hacemos directamente en el root del proyecto, en este caso el archivo "learnXcodeApp" de esta manera: 

        @State private var store = SubjectStore()
        
        *Y se lo pasamos al contentView asi:
        
            ContentView()
                .environment(store)
                
        *Luego en el "ContentView" lo recuperamos asi: 
        
            @Environment(SubjectStore.self) private var store
            
            - De manera privada, eso quiere decir que unicamente vive en el archivo en el cual se invoco y en los hijos a los que se les compartio
            - en este caso bajo el nombre de "store"
            
        *Por ultimo, para poder seguir utilizandolo como veniamos, es decir, como un binding, dentro del body lo armamos asi:
        
            @Bindable var store = store
            

DATO EXTRA:
    
    *Para que funcione el "preview" ahora tambien hay que concatenarle el ".enviroment" igual que en el root del proyecto:
    
        #Preview {
            ContentView()
                .environment(SubjectStore())
        }



-- LECCION 7: PERSISTENCIA (REFERENCIAS/SWIFTDATA) --

*A diferencia del metodo de COPIA (leccion 6), donde nosotros manualmente transformabamos a JSON y guardabamos/leiamos de la memoria, SwiftData es una base de datos que maneja Apple por nosotros. Nos olvidamos de armar el save(), load(), init() y didSet: SwiftData guarda los cambios solo.

*Al trabajar por REFERENCIAS, el modelo pasa a ser una CLASS en vez de un STRUCT. Ademas ya no hacen falta las interfaces "Codable" ni "Identifiable", ni el campo "id": SwiftData los maneja internamente.

    1) MODELO (@Model): El macro "@Model" convierte una clase en algo guardable en la base de datos.

        EJ:

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

            - "@Model" -> transforma la clase en una tabla de la base de datos
            - No hace falta "id", ni "Codable", ni "Identifiable" (los agrega SwiftData solo)

    2) CONTAINER: En el root del proyecto (learnXcodeApp) le decimos a SwiftData que arme la base de datos usando como estructura nuestro modelo.

        EJ:

            WindowGroup {
                ContentView()
            }
            .modelContainer(for: Subject.self)

            - "modelContainer(for:)" -> crea y conecta la base de datos para ese modelo

    3) @QUERY: Consulta la base de datos, trae el array del modelo y se actualiza SOLO cada vez que algo cambia (no hace falta recargar nada a mano).

        EJ:

            @Query private var subjects: [Subject]

            *Tambien se le puede pasar un FILTRO con "#Predicate" para traer solo los que cumplan una condicion:

            @Query(filter: #Predicate<Subject> { $0.hasTask }) private var pending: [Subject]

            - Este "pending" trae unicamente las materias cuyo "hasTask" sea true
            - El filtrado ocurre en la base de datos (mas eficiente que filtrar el array en memoria)

    4) @ENVIRONMENT(\.modelContext): Es el "contexto" con el que modificamos la base de datos (insertar, borrar). El @Query solo LEE, el context es el que ESCRIBE.

        EJ:

            @Environment(\.modelContext) private var context

            *Insertar (guardar) un objeto nuevo:

                context.insert(Subject(type: "Nueva materia"))

            *Borrar un objeto:

                context.delete(subjects[i])

            - En cuanto insertas/borras/modificas, los @Query se actualizan solos y la vista se redibuja
            - Modificar una propiedad de un objeto ya guardado (ej: sub.hasTask.toggle()) tambien se guarda solo, sin llamar a ningun save()

DATO EXTRA:

    *Para el "preview" conviene usar una base de datos en memoria (no toca el disco), asi cada vez arranca limpia:

        #Preview {
            ContentView()
                .modelContainer(for: Subject.self, inMemory: true)
        }



-- LECCION 8: CONSUMIR APIS EXTERNAS --

*Para traer datos de un servicio externo (una API) usamos "async/await": son funciones que tardan (van a internet, esperan la respuesta) sin congelar la app. Se separa en 3 partes: el MODELO (como llegan los datos), el SERVICIO (el llamado) y la VISTA (mostrar/manejar carga y errores).

    1) MODELO: Como los datos vienen de un JSON de la API, el modelo es un STRUCT con la interface "Codable" (para poder decodificar el JSON) e "Identifiable" (para poder listarlo).

        EJ:

            struct Holiday: Codable, Identifiable {
                let fecha: String
                let tipo: String
                let nombre: String

                var id: String { fecha + nombre }
            }

            - "Codable" -> permite transformar el JSON de la API en este struct
            - Como la API no nos da un "id", lo armamos nosotros combinando campos (fecha + nombre)
            - Los nombres de los campos deben coincidir con los del JSON

    2) SERVICIO: Struct con una funcion "async throws" que hace el llamado, valida la respuesta y decodifica.

        EJ:

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

            - "async" -> la funcion tarda (espera la respuesta de internet)
            - "throws" -> la funcion puede fallar (sin internet, error del server, etc)
            - "await" -> "espera aca" hasta que vuelva la respuesta, sin congelar la app
            - "URLSession.shared.data(from:)" -> hace el llamado y devuelve la data + la response
            - "guard ... statusCode == 200" -> valida que el server respondio OK, si no, lanza un error (throw)
            - "JSONDecoder().decode([Holiday].self, from: data)" -> transforma el JSON en el array de Holiday

    3) VISTA: Maneja 3 estados con @State: los datos, el "cargando" y el mensaje de error.

        EJ:

            @State private var holidays: [Holiday] = []
            @State private var loading = false
            @State private var errorMsj: String?

        *La funcion que llama al servicio maneja el loading y captura los errores:

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

            - "defer" -> parecido al "finally", se ejecuta si o si cuando termina la funcion (apaga el loading pase lo que pase)
            - "do / catch" -> intenta el llamado; si falla (throw), cae en el catch y guarda el mensaje de error

        *Modificadores clave en la vista:

            - .task { await cargar() } -> llama al servicio automaticamente al abrir la vista. Si el usuario se va a otra pantalla mientras carga, corta el llamado solo (sin generar problemas)
            - .refreshable { await cargar() } -> permite recargar tirando la lista hacia abajo (pull to refresh)
            - .overlay { } -> muestra algo POR ENCIMA de la vista. Se usa para el estado de carga y el de error:
                * ProgressView("Cargando...") -> el spinner mientras carga
                * ContentUnavailableView -> pantalla de "no se pudo cargar" con un boton de reintentar




