# 🚀 Project Backend

This contains the source code for our project's backend, built with Node.js, TypeScript, GraphQL (Apollo Server), and PostgreSQL.

---

## 🌟 Tecnologías Principales

* **Node.js**: JavaScript runtime environment.
* **TypeScript**: JavaScript superset that adds static typing.
* **GraphQL**: Query language for APIs.
* **Apollo Server**: GraphQL server implementation for Node.js.
* **PostgreSQL**: Relational database management system. It is important to know that "pg" is the official Node.js client for PostgreSQL.
* **TypeORM**: ORM (Object Relational Mapper) for TypeScript and Node.js, compatible with PostgreSQL.
* **Express**: Framework web for Node.js.
* **bcryptjs**: Library for password hashing.
* **CORS**:Middleware to enable Cross-Origin Resource Sharing.
---

## 📋 Prerequisites

The necessary facilities are the following:

* **Node.js** (version 16 or higher recommended).
* **npm** (Node Package Manager) o **Yarn**
* **PostgreSQL** (database server running).

---

## 🧠📂 Backend Folder Structure

src/
├── application/            # Application Layer
│   └── features/           # Organized by functionalities (Vertical Slices)
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
├── core/                   # Domain and shared infrastructure
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
├── infrastructure/         # Global infrastructure (connection to database, server)
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
└── main.ts                 # Application entry point

---

## 🛠️ Configuration and Installation

Below are some steps and configurations that were necessary for this backend.

### 1. Command to create package.json:
npm init -y

### 2. Command to install what is needed (For Production):
npm install express graphql pg typeorm cors bcryptjs @apollo/server

### 3. src folder to organize and separate the code.
___backend
____src

### 4 – Dependencies or modules for development:
1. **typescript:** Allows you to write your project code in TypeScript (a statically typed JavaScript superset).
2. **ts-node-dev:** Run .ts files directly without pre-compiling them, and restart the server automatically when changes are detected. Improves development productivity, similar to nodemon but for TypeScript.

### 🧩 4.1 Types for JavaScript libraries:
1. **@types/bcryptjs:** Adds type support to the bcryptjs library, used for password hashing.
4. **@types/cors:** Adds type definitions for the cors middleware, which manages Cross-Origin Resource Sharing security policies.
5. **@types/express:** Typed for the express library, the HTTP framework commonly used for building servers in Node.js.
6. **@types/node:** Defines the types of the native Node.js APIs (such as fs, path, etc.).

### 🌿 4.2 Handling environment variables:
7. dotenv: Loads environment variables from a .env file into the process.env object. Useful for managing sensitive settings such as secret keys, database URLs, etc.

### 🗃️ 4.3 Soporte para PostgreSQL:
9. @types/pg: Typed for the pg library, the official PostgreSQL client in Node.js.

### 4.4 Finally, the command to install the development dependencies is as follows:
npm install -D typescript ts-node-dev @types/bcryptjs @types/cors @types/express @types/node @types/pg dotenv

### 5 – Create initial configuration file:
npx tsc --init
Generates the tsconfig.json file, which is the main configuration file for TypeScript in the project.

### 6 – Configure the tsconfig.json file:
**"rootDir":** "./src" >>> Tells TypeScript that the source code is inside the src/ folder.
**"outDir":** "./build" >>> Specifies where the compiled JavaScript code will be placed.

### 7 - Enable for TypeORM (Crucial!):

**"emitDecoratorMetadata":** true >>> Enables decorator support in TypeScript. This is required to use decorators such as @Entity(), @Column(), @PrimaryGeneratedColumn(), etc.

**"experimentalDecorators":** true >>> Causes TypeScript to emit type metadata at compile time. This allows TypeORM to understand the actual types of decorated properties.
For example, it helps TypeORM know that name is a string, without you explicitly declaring it.
@Column()
name: string;

**"skipLibCheck":** true - Helps avoid type errors in third-party libraries that are not always perfectly typed.
**"moduleResolution":** "node"
**"esModuleInterop":** true

### Scripts section in package.json:
"scripts": {
  "dev": "ts-node-dev src/index.ts",
  "build": "tsc -p .",
  "start": "node build/index.js"
}

### Below is what is needed in tsconfig.json:
{
  "compilerOptions": {
    "target": "es2020", // Or a newer version
    "module": "commonjs",
    "lib": ["es2020"],
    "outDir": "./build",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    ""skipLibCheck": true",
    "forceConsistentCasingInFileNames": true,
    "emitDecoratorMetadata": true, // Necessary for TypeORM
    "experimentalDecorators": true, // Necessary for TypeORM
    "sourceMap": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules"]
}


### IMPORTANT, problem I had and its solution:
No overload matches this call...
Types of parameters 'req' and 'req' are incompatible...

### 🔍 Cause of the problem
express@5 doesn't yet have full official support in DefinitelyTyped (@types/express) because Express 5 is in beta, and its API differs slightly from Express 4. This causes conflicts between the type definitions of @apollo/server (which expects Express 4) and your express@5.


### ✅ Recommended solution
To avoid problems with type definitions, use express@4 for now:

1. Uninstall express@5 and its type:
npm uninstall express @types/express

2. Install compatible versions (Express 4):
npm install express@4
npm install -D @types/express@4