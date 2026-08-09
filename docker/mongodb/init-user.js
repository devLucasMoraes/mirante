const dbName = process.env.MONGO_INITDB_DATABASE;
const username = process.env.MONGO_INITDB_USERNAME;
const password = process.env.MONGO_INITDB_PASSWORD;

if (!dbName || !username || !password) {
  throw new Error('MONGO_INITDB_DATABASE, MONGO_INITDB_USERNAME and MONGO_INITDB_PASSWORD must be set');
}

db = db.getSiblingDB(dbName);

db.createUser({
  user: username,
  pwd: password,
  roles: [{ role: 'readWrite', db: dbName }],
});