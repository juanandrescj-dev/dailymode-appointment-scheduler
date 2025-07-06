import "dotenv/config";
import express from "express";
import cors from "cors";
import { ApolloServer } from "@apollo/server";
import { expressMiddleware } from "@apollo/server/express4";
// import { AppDataSource } from "./infrastructure/persistence/typeorm/data-source";
// import { schema } from "./infrastructure/http/graphql/schema";
const PORT = process.env.PORT;

const typeDefs = `#graphql
  type Query {
    greeting: String
    currentTime: String
    aboutMe: AboutMe
  }

  type AboutMe {
    fullName: String
    mainOccupation: String
    secondaryOccupation: String
    country: String
  }
`;

const resolvers = {
  Query: {
    greeting: () => 'Hello! This is my second GraphQL API this time using Apollo Server.',
    aboutMe: () => ({
      fullName: "Juan Andrés César Jiménez",
      mainOccupation: "FullStack Developer",
      secondaryOccupation: "Professional youTuber",
      country: "Dominican Republic",
    }),
    currentTime: () => new Date().toISOString(),
  },
};

async function startServer() {
  try {
    // await AppDataSource.initialize();
    console.log(
      "✅⚠️⚠️ Connection to the database established X not successfully X. ⚠️⚠️⚠️ X (Temporarily omitted)"
    );

    const app = express();

    app.use(cors());

    const apolloServer = new ApolloServer({
      typeDefs,
      resolvers,
    });

    await apolloServer.start();
    console.log("🚀 Apollo GraphQL Server started.");

    app.use("/graphql", express.json(), expressMiddleware(apolloServer));

    app.listen(PORT, () => {
      console.log(`Server is running on http://localhost:${PORT}/graphql`);
      console.log(`Explore the API in http://localhost:${PORT}/graphql`);
    });
  } catch (error) {
    console.error("❌ Error starting server:", error);
    process.exit(1);
  }
}

startServer().catch((error) => {
  console.error("Unhandled rejection:", error);
  process.exit(1);
});
