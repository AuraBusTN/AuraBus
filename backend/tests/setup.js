process.env.NODE_ENV = "test";
process.env.JWT_SECRET = "test_jwt_secret";
process.env.REFRESH_SECRET = "test_refresh_secret";
process.env.GOOGLE_AUTH_CLIENT_ID = "test-google-client-id";

process.env.TNT_URL = "https://api.tnt.test";
process.env.TNT_USERNAME = "test_user";
process.env.TNT_PASSWORD = "test_pass";

process.env.API_URL = "https://api.tnt.test";
process.env.API_USER = "test_user";
process.env.API_PASSWORD = "test_pass";

process.env.MONGO_USER = "test_mongo_user";
process.env.MONGO_PASSWORD = "test_mongo_password";
process.env.REDIS_PASSWORD = "test_redis_password";

process.env.PREDICTION_URL = "https://prediction.test";

const originalError = console.error;
beforeAll(() => {
  console.error = (...args) => {
    const message = args.join(" ");
    if (message.includes("CRITICAL") || message.includes("FATAL")) {
      originalError(...args);
    }
  };
});

afterAll(() => {
  console.error = originalError;
});
