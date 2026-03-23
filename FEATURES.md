# Duvi Ant - Gestor de Gastos 🐜

Una aplicación moderna de control de gastos construida con los últimos frameworks de Apple.

## Características Implementadas ✅

### 1. **Gestión de Gastos**
- ➕ Agregar nuevos gastos con monto, nota y categoría
- ✏️ Editar gastos existentes
- 🗑️ Eliminar gastos (deslizar para borrar)
- 📋 Vista en lista con información detallada

### 2. **Búsqueda y Filtrado Avanzado**
- 🔍 Búsqueda por texto en notas y categorías
- 🏷️ Filtro por categoría
- 📅 Filtro por rango de fechas:
  - Todo el tiempo
  - Hoy
  - Esta semana
  - Este mes

### 3. **Estadísticas y Análisis**
- 📊 Gráficos de gastos por categoría (BarChart)
- 📈 Tendencia de últimos 7 días (LineChart)
- 💰 Resumen mensual con total y promedio
- 📌 Detalles de gastos por categoría

### 4. **Gestión de Presupuestos**
- 💵 Crear presupuestos por categoría o generales
- 📅 Períodos de presupuesto: semanal, mensual, anual
- ⚠️ Alertas cuando se excede el presupuesto
- 📊 Indicador visual de uso (0-100%)

### 5. **Exportación de Datos**
- 📄 Exportar a CSV con fecha, monto, categoría y nota
- 💾 Guardar archivos localmente
- 📤 Compartir datos con otras aplicaciones

### 6. **Personalización**
- 🌓 Soporte para tema claro y oscuro
- 💱 Selección de moneda (USD, EUR, MXN, ARS, COP)
- ⚙️ Ajustes de aplicación

### 7. **Widgets de Pantalla de Inicio**
- 🏠 Widget pequeño (small) con resumen rápido
- 📱 Widget mediano (medium) con más detalles
- 📊 Muestra gastos del mes y conteo de transacciones

### 8. **Persistencia de Datos**
- 🗄️ SwiftData para almacenamiento local
- 💾 Sincronización automática
- 🔄 Recuperación ante fallos de esquema
- 📁 Almacenamiento en directorio Application Support

### 9. **Interfaz de Usuario**
- 🎨 Diseño moderno con SwiftUI
- 📱 Adaptable a diferentes tamaños de pantalla
- ♿ Accesibilidad mejorada
- 🎯 Navegación intuitiva

## Estructura del Proyecto

```
Duvi Ant/
├── DuviAntApp.swift                 # Punto de entrada
├── Models/
│   ├── Expense.swift               # Modelo de gasto
│   ├── Category.swift              # Modelo de categoría
│   └── Budget.swift                # Modelo de presupuesto
├── ViewModels/
│   └── ExpenseViewModel.swift      # Lógica de negocio
├── Views/
│   ├── Main/
│   │   ├── ContentView.swift       # Vista principal
│   │   └── RootView.swift          # Navegación con tabs
│   ├── Dashboard/
│   │   └── DashboardHeaderView.swift
│   ├── Statistics/
│   │   └── StatisticsView.swift
│   ├── Expenses/
│   │   ├── AddExpenseSheet.swift
│   │   └── EditExpenseSheet.swift
│   ├── Budgets/
│   │   └── BudgetsView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Components/
│       └── SearchBar.swift
├── Widgets/
│   └── DuviAntWidget.swift
└── Assets.xcassets

```

## Tecnologías Utilizadas

### Frameworks de Apple
- **SwiftUI** - Interfaz de usuario declarativa
- **SwiftData** - Almacenamiento y persistencia de datos
- **Charts** - Visualización de datos
- **WidgetKit** - Widgets de pantalla de inicio

### Patrones de Arquitectura
- **MVVM** - Model-View-ViewModel
- **@Observable** - Reactividad moderna
- **@MainActor** - Seguridad en hilos

## Cómo Compilar y Ejecutar

1. Abre el proyecto en Xcode
2. Selecciona el simulador o dispositivo destino
3. Presiona `Cmd + R` para compilar y ejecutar

## Características Futuras 🚀

- Sincronización con iCloud
- Soporte multiidioma (i18n)
- Gráficos más avanzados
- Predicción de gastos con ML
- Notificaciones push para límites de presupuesto
- Integración con Apple Health

## Notas de Desarrollo

Los errores de SourceKit en Xcode son solo problemas de indexación. La compilación real debe funcionar sin problemas:

```bash
xcodebuild -scheme DuviAnt build
```

Todos los modelos, vistas y funcionalidad están implementados siguiendo las mejores prácticas de Apple para 2024-2025.
