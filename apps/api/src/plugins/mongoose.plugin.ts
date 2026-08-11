import type { FastifyInstance } from "fastify";
import fp from "fastify-plugin";
import mongoose from "mongoose";

declare module "fastify" {
  interface FastifyInstance {
    mongoose: typeof mongoose;
  }
}

export interface MongoosePluginOptions {
  uri: string;
}

export const mongoosePlugin = fp<MongoosePluginOptions>(
  async function (fastify: FastifyInstance, opts) {
    mongoose.connection.on("error", (err) => {
      fastify.log.error({ err }, "MongoDB connection error");
    });

    await mongoose.connect(opts.uri, { serverSelectionTimeoutMS: 5000 });
    fastify.log.info("MongoDB connected");

    fastify.decorate("mongoose", mongoose);

    fastify.addHook("onClose", async () => {
      await mongoose.disconnect();
    });
  },
  { name: "mongoose-connector" },
);
