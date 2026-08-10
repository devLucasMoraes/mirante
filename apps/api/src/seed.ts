import mongoose from "mongoose";
import { config, mongoUri } from "./config.ts";
import { UserModel } from "./models/User.ts";
import { hashPassword } from "./services/passwords.ts";

async function main() {
  await mongoose.connect(mongoUri, { serverSelectionTimeoutMS: 5000 });

  const passwordHash = await hashPassword(config.SEED_ADMIN_PASSWORD);
  const result = await UserModel.updateOne(
    { username: config.SEED_ADMIN_USERNAME },
    {
      $set: {
        name: config.SEED_ADMIN_NAME,
        passwordHash,
        role: "admin",
      },
    },
    { upsert: true },
  ).exec();

  if (result.upsertedCount > 0) {
    console.log(
      `Admin criado: "${config.SEED_ADMIN_USERNAME}" (senha: ${config.SEED_ADMIN_PASSWORD})`,
    );
  } else {
    console.log(`Admin atualizado: "${config.SEED_ADMIN_USERNAME}"`);
  }

  await mongoose.disconnect();
}

await main();
