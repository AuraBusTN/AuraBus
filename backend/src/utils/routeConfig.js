export const routeConfig = {
  614: {
    // Line A
    profile: "flat_high",
    peakLocation: 0.5,
  },
  536: {
    // Line 1 from Ospedale to Sopramonte
    profile: "accumulator",
    peakLocation: 0.3,
  },
  538: {
    // Line 2 from Piedicastello to P.Dante
    profile: "accumulator",
    peakLocation: 0.3,
  },
  396: {
    // Line 3 from Cortesano to Villazzano
    profile: "accumulator",
    peakLocation: 0.65,
  },
  539: {
    // Line 4/ from Roncafort to Madonna Bianca
    profile: "accumulator",
    peakLocation: 0.3,
  },
  400: {
    // Line 5 From P.Dante to Povo
    profile: "university",
    peakLocation: 0.7,
  },

  535: {
    // Line 5/ from P.Dante to university
    profile: "university",
    peakLocation: 0.7,
  },
  541: {
    // Line 6 from Vela to Grotta
    profile: "standard",
    peakLocation: 0.6,
  },
  404: {
    // Line 8 from Centochiavi to Mattarello
    profile: "accumulator",
    peakLocation: 0.3,
  },
  406: {
    // Line 9 from P.Dante to Villamontagna
    profile: "draining",
    peakLocation: 0.2,
  },
  408: {
    // Line 10 from P.Dante to Cognola
    profile: "draining",
    peakLocation: 0.2,
  },
  624: {
    // Line 12 from P.Dante to Romagnano
    profile: "draining",
    peakLocation: 0.2,
  },
  466: {
    // Line 13 from P.Dante to Povo
    profile: "accumulator",
    peakLocation: 0.3,
  },
  626: {
    // Line 14 from P.Dante to Belvedere
    profile: "draining",
    peakLocation: 0.2,
  },

  629: {
    // Line 17 to Dogana
    profile: "accumulator",
    peakLocation: 0.9,
  },
  623: {
    // Line 19 from P.Dante to P.Dante Regione
    profile: "flat_high",
    peakLocation: 0.5,
  },

  default: {
    profile: "standard",
    peakLocation: 0.5,
  },
};

export const getRouteConfig = (routeId) => {
  const id = String(routeId);
  return routeConfig[id] || routeConfig["default"];
};
