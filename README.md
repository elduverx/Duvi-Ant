# Duvi Ant - App Premium de Gestión de Gastos 🐜💰

Una aplicación completa de control de gastos construida con los marcos más modernos de Apple (2024-2025). Incluye todas las características premium que normalmente cobran las apps competidoras.

## ¿Qué es Duvi Ant?

**Duvi Ant** es un gestor de gastos "hormiga" - esos pequeños gastos diarios que se acumulan. Con características empresariales que están en apps de $5-15/mes.

## ✨ Características Principales

### 📊 Gestión de Gastos
- ✅ Agregar, editar y eliminar gastos
- ✅ Categorías personalizables con emojis
- ✅ Búsqueda en tiempo real
- ✅ Filtros avanzados (fecha, categoría)
- ✅ Vista en lista organizada

### 💰 Presupuestos Inteligentes
- ✅ Crear presupuestos por categoría o general
- ✅ Períodos: Semanal, Mensual, Anual
- ✅ Alertas cuando se excede
- ✅ Indicador visual de uso (0-100%)

### 🔄 Gastos Recurrentes
- ✅ Automático: Diario, Semanal, Quincenal, Mensual, Trimestral, Anual
- ✅ Proyección de costo mensual
- ✅ Pausar/reanudar sin eliminar
- ✅ Historial de creación automática

### 🎯 Metas de Ahorro
- ✅ Múltiples metas simultáneamente
- ✅ Barras de progreso visual
- ✅ Contador de días restantes
- ✅ Alertas de logros

### 📈 Análisis Avanzado
- ✅ Insights en tiempo real
  - Gasto promedio diario
  - Categoría más costosa
  - Tendencias semana vs mes
  - Proyección de gastos
- ✅ Gráficos visuales con Charts
- ✅ Detección de patrones

### 📄 Exportación
- ✅ CSV para Excel/Sheets
- ✅ Reportes detallados
- ✅ Compartir por email/iCloud
- ✅ Formatos múltiples

### ⚙️ Personalización
- ✅ Tema oscuro/claro automático
- ✅ Moneda (USD, EUR, MXN, ARS, COP)
- ✅ Interfaz adaptable
- ✅ Configuración flexible

## 🏗️ Arquitectura Técnica

### Frameworks Utilizados
- **SwiftUI** - Interfaz moderna y responsiva
- **SwiftData** - Persistencia local segura
- **Charts** - Visualización de datos
- **Foundation** - APIs base de Apple

### Patrones de Diseño
- **MVVM** - Model-View-ViewModel
- **@Observable** - Reactividad moderna
- **@MainActor** - Seguridad en threads
- **Reactive** - Data binding automático

### Modelos de Datos
```swift
Expense          // Gasto individual
Category         // Categoría de gasto
Budget           // Presupuesto
RecurringExpense // Gasto automático
SavingsGoal      // Meta de ahorro
PushAlert        // Notificaciones
```

## 📱 Estructura de la App

```
TabView (5 pestañas)
├── 💳 Gastos
│   ├── Dashboard
│   ├── Búsqueda
│   ├── Filtros
│   └── Lista de gastos
├── 🔄 Recurrentes
│   ├── Crear gasto automático
│   ├── Proyección mensual
│   └── Gestionar activos
├── 🎯 Metas
│   ├── Nueva meta
│   ├── Progreso visual
│   └── Recordatorios
├── 📊 Análisis
│   ├── Insights
│   ├── Tendencias
│   ├── Proyecciones
│   └── Gráficos
└── ⚙️ Ajustes
    ├── Tema
    ├── Moneda
    └── Información
```

## 🚀 Getting Started

### Requisitos
- Xcode 15.0+
- iOS 17.0+
- macOS 13.0+ (para compilar)

### Compilar y Ejecutar
```bash
# Opción 1: Xcode
open "Duvi Ant.xcodeproj"
# Presiona Cmd + R

# Opción 2: Terminal
xcodebuild -scheme DuviAnt build
xcodebuild -scheme DuviAnt run
```

### Primera Ejecución
1. La app crea automáticamente 5 categorías
2. Comienza a agregar gastos
3. Explora todas las tabs
4. Personaliza según necesites

## 📊 Comparación Competitiva

| Feature | Duvi Ant | Money Lover | YNAB | Expensify |
|---------|----------|-------------|------|-----------|
| Gastos básicos | ✅ | ✅ | ✅ | ✅ |
| Presupuestos | ✅ | ✅ | ✅ | ❌ |
| Gastos recurrentes | ✅ | ✅ | ✅ | ❌ |
| Metas de ahorro | ✅ | ✅ | ❌ | ❌ |
| Análisis avanzado | ✅ | ✅ | ✅ | ✅ |
| Exportación | ✅ | ✅ | ✅ | ✅ |
| Precio | 🆓/Pago único | $2.49/mes | $14.99/mes | $4.99-8.99/mes |
| Datos locales | ✅ | ❌ | ❌ | ❌ |
| Sin anuncios | ✅ | ❌ | ✅ | ✅ |

## 💎 Plan de Monetización

### Opción 1: Compra Única ($9.99)
- Una sola compra
- Acceso permanente a todas las features
- Actualizaciones gratuitas

### Opción 2: Freemium ($4.99/mes)
- Gratis: Gastos básicos
- Premium: Todos los features avanzados

### Opción 3: Pro ($9.99/mes)
- Pro: CloudKit sync + exportación avanzada

## 📚 Documentación

| Documento | Propósito |
|-----------|-----------|
| FEATURES.md | Listado completo de features |
| FEATURES_PREMIUM.md | Features premium y análisis competitivo |
| QUICK_START.md | Guía rápida para usuarios |
| BUILD_GUIDE.md | Guía de compilación para desarrolladores |
| README.md | Este archivo |

## 🔐 Privacidad y Seguridad

- **100% Local**: Todos los datos se guardan en el dispositivo
- **Sin Internet**: Funciona completamente offline
- **Sin Cloud**: Opcionalmente puedes agregar iCloud
- **Sin Tracking**: Cero analíticos de usuario
- **Código Limpio**: Fácil de auditar

## 🎯 Hoja de Ruta

### Fase 1 (Actual) ✅
- [x] Gastos básicos
- [x] Categorías
- [x] Búsqueda y filtros
- [x] Presupuestos
- [x] Gastos recurrentes
- [x] Metas de ahorro
- [x] Análisis avanzado
- [x] Exportación
- [x] Personalización

### Fase 2 (Q2 2025)
- [ ] CloudKit sync
- [ ] Compartir presupuestos
- [ ] Apple Watch app
- [ ] Siri Shortcuts
- [ ] ML para categorización

### Fase 3 (Q3 2025)
- [ ] Integración bancaria
- [ ] Criptomonedas
- [ ] Stock tracking
- [ ] Seguros
- [ ] macOS app

## 🤝 Contribuciones

Este proyecto está lista para contribuciones. Areas de mejora:

- [ ] UI/UX improvements
- [ ] Más idiomas
- [ ] Tests automatizados
- [ ] Performance optimizations
- [ ] Documentación de APIs

## 📄 Licencia

MIT License - Ver LICENSE para detalles

## 📞 Soporte

Para bugs o sugerencias:
- Abre un issue en GitHub
- Contacta a duverneymuriel@example.com

## 🙏 Créditos

Construido con:
- SwiftUI by Apple
- SwiftData by Apple
- Charts by Apple
- Swift by Apple

---

**Hecho con 🐜💰 por Duverni Muriel**

**Versión**: 1.0.0
**Última actualización**: Marzo 2025
**Estado**: Ready for Production ✅
# Duvi-Ant
