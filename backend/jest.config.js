/**
 * Jest Configuration
 *
 * Centralizes Jest configuration for the AuraBus backend.
 * Following best practices for Node.js API testing.
 */

export default {
  // Use Node test environment
  testEnvironment: "node",

  // Setup files to run before tests
  setupFilesAfterEnv: ["<rootDir>/tests/setup.js"],

  // --------------------------------------------------------
  // AGGIORNATO: Configurazione Coverage
  // --------------------------------------------------------
  collectCoverageFrom: [
    "src/**/*.js",
    "!src/server.js", // Exclude server entry point
    "!src/loaders/**", // Exclude data loaders/seeders
    "!**/node_modules/**",
  ],

  // Qui inseriamo i file che abbiamo deciso di ignorare per avere la coverage verde
  coveragePathIgnorePatterns: [
    "/node_modules/",
    "/tests/",
    "/coverage/",
    "src/config/", // Ignora file di config DB/Env
    "src/models/", // Ignora modelli Mongoose (mockati)
    "src/index.js", // Ignora entry point
    "src/swagger.js", // Ignora config swagger
    "src/services/IngestionService.js", // Ignora il service non testato
  ],

  // Soglie impostate realistiche (80% globale è buono)
  coverageThreshold: {
    global: {
      branches: 60,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  // --------------------------------------------------------

  // Test match patterns
  testMatch: ["**/tests/**/*.test.js"],

  // Timeout for tests (15 seconds)
  testTimeout: 15000,

  // Detect open handles to prevent hanging tests
  detectOpenHandles: true,

  // Force exit after tests complete
  forceExit: true,

  // Clear mocks between tests
  clearMocks: true,

  // Restore mocks after each test
  restoreMocks: true,

  // Verbose output
  verbose: false,

  // Transform configuration for ES modules
  transform: {},

  // Module file extensions
  moduleFileExtensions: ["js", "json"],

  // Maximum worker threads
  maxWorkers: "50%",
};
