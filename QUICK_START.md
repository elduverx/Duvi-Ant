# Guía Rápida - Duvi Ant 🐜

## Para Empezar

1. **Abre el proyecto en Xcode**
   - Busca `Duvi Ant.xcodeproj`
   - Abre en Xcode

2. **Selecciona tu destino**
   - Elige un simulador de iPhone (iOS 17+)
   - O conecta un dispositivo real

3. **Compila y ejecuta**
   - Presiona `Cmd + R`
   - La app debería compilar sin errores

## Navegación Principal

La app tiene 3 pestañas principales:

### 1️⃣ **Gastos** 📋
- Agrupa todos tus gastos
- Búsqueda y filtros avanzados
- Toca un gasto para editarlo
- Desliza para eliminar

### 2️⃣ **Estadísticas** 📊
- Visualiza tus gastos con gráficos
- Análisis por categoría
- Tendencia de últimos 7 días
- Resumen del mes

### 3️⃣ **Ajustes** ⚙️
- Elige tema (claro/oscuro)
- Selecciona tu moneda
- Califica la app

## Acciones Principales

### Agregar un Gasto
```
1. Toca el botón "+" en la esquina superior derecha
2. Ingresa el monto
3. Escribe una nota (opcional)
4. Selecciona categoría
5. Toca "Guardar"
```

### Editar un Gasto
```
1. Toca el gasto que deseas editar
2. Modifica los detalles
3. Toca "Actualizar"
```

### Eliminar un Gasto
```
1. Desliza el gasto hacia la izquierda
2. Toca "Borrar"
```

### Buscar Gastos
```
1. En la pestaña "Gastos", usa la barra de búsqueda
2. Busca por nota o categoría
3. Filtra por fecha (Hoy, Semana, Mes)
4. Filtra por categoría
```

### Ver Presupuestos
```
1. (Pronto) Acceso a través de la app
2. Crear presupuestos por categoría
3. Ver alertas de límites excedidos
```

## Características Clave

✨ **Moderno**
- Usa los últimos APIs de Apple
- Diseño limpio y elegante
- Rendimiento optimizado

🔐 **Seguro**
- Los datos se guardan localmente
- No se comparten en internet
- Acceso rápido a historial

📊 **Analítico**
- Gráficos claros
- Estadísticas detalladas
- Exporta a CSV

🎨 **Personalizable**
- Tema claro/oscuro
- Múltiples monedas
- Widgets en pantalla de inicio

## Troubleshooting

### La app no compila
- Asegúrate de tener Xcode 15+ instalado
- Limpia la compilación: `Cmd + Shift + K`
- Reconstruye: `Cmd + B`

### Los datos no se guardan
- Comprueba el simulador tiene espacio disponible
- Reinicia el simulador
- Borra datos de aplicación y vuelve a instalar

### Widgets no aparecen
- Los widgets requieren iOS 17+
- Edita la pantalla de inicio
- Busca "Duvi Ant" y agrega el widget

## Archivos Importantes

| Archivo | Propósito |
|---------|-----------|
| `DuviAntApp.swift` | Punto de entrada |
| `ExpenseViewModel.swift` | Lógica de negocio |
| `ContentView.swift` | Pantalla principal |
| `StatisticsView.swift` | Gráficos y análisis |
| `Models/` | Estructuras de datos |

## Estructura de Datos

### Expense (Gasto)
```swift
- id: UUID
- amount: Double
- note: String
- date: Date
- category: Category?
```

### Category (Categoría)
```swift
- id: UUID
- name: String
- icon: String (emoji)
- expenses: [Expense]
```

### Budget (Presupuesto)
```swift
- id: UUID
- limit: Double
- period: BudgetPeriod (weekly/monthly/yearly)
- category: Category?
```

## Tips y Trucos

💡 **Usa emojis en categorías**
- Las categorías vienen con emojis predeterminados
- Crea tus propias categorías con emojis personalizados

💡 **Filtros combinados**
- Busca + Categoría + Fecha = resultados específicos

💡 **Exporta tus datos**
- Los datos se exportan automáticamente a CSV
- Puedes compartirlos por email o iCloud

💡 **Widgets útiles**
- Pon el widget en tu pantalla de inicio
- Actualiza cada cierto tiempo automáticamente

## Próximas Versiones Planeadas

- 🌐 Sincronización con iCloud
- 🗣️ Soporte multiidioma
- 🤖 Predicción inteligente de gastos
- 📱 Companion app para macOS
- ⌚ App para Apple Watch

---

**¡Disfruta controlando tus gastos con Duvi Ant! 🐜💰**
