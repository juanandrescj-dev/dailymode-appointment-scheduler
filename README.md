# DailyMode Appointment Scheduler

**Full-stack Appointment Management System for small clinics and business and barber shops**, built with:
- 🧠 Node.js + GraphQL + TypeORM + PostgreSQL (Backend)
- ⚛️ React + TypeScript + Vite + Tailwind CSS (Frontend)

---

## 🏛️ Architecture to use
**Clean Architecture - Domain Driven Design (DDD).**
**Order:** As this is a medium- to small-sized web application, we will use a global Domain and Infrastructure, 
while the application layer will be separated by Features (Vertical Slice). For very large applications, 
it is advisable to have a separate Domain and Infrastructure for each Feature.

## 📸 Screenshots

> Images of the results of the development process. In progress....

---

## 🚀 Features

- User authentication and role management
- Booking and managing appointments
- Clients and professionals management
- Schedule availability per day/hour
- Responsive and modern UI
- Backend GraphQL API
- PostgreSQL relational database

---

## 🛠️ Tech Stack

| Layer | Stack |
|-------|-------|
| Frontend | React, Vite, TypeScript, Tailwind CSS, Apollo Client |
| Backend | Node.js, GraphQL, TypeORM, PostgreSQL |
| Tools | Git, VS Code, ESLint, Prettier, Husky, Vercel/Render |

---

## 📂 Project Structure

dailymode-appointment-scheduler/
├── frontend/ # React App
├── backend/ # Node + GraphQL API
└── README.md

## 🧠📂 Backend Folder Structure

src/
├── application/         # Capa de Aplicación
│   └── features/        # Organizada por funcionalidades (Vertical Slices)
│       └── appointments/
│           ├── commands/
│           │   └── create-appointment/
│           │       ├── create-appointment.command.ts
│           │       ├── create-appointment.dto.ts
│           │       └── create-appointment.resolver.ts
│           └── queries/
│               └── get-appointment-by-id/
│                   ├── get-appointment-by-id.query.ts
│                   └── get-appointment-by-id.resolver.ts
│
├── core/         # Dominio e infraestructura compartida
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── appointment.entity.ts
│   │   │   └── user.entity.ts
│   │   └── repositories/
│   │       └── IUserRepository.ts
│   └── infrastructure/
│       └── security/
│           └── auth.guard.ts
│
├── infrastructure/      # Infraestructura global (conexión a BD, servidor)
│   ├── persistence/
│   │   └── typeorm/
│   │       ├── implementation/
│   │       ├── models/
│   │       └── data-source.ts
│   └── http/
│       ├── graphql/
│       │   └── schema.ts
│       └── server.ts
│
└── main.ts       # Punto de entrada de la aplicación
