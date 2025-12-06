import { Bus } from '../models/Bus.js';

export const findBusByIds = async (busIdsFromApi) => {
    const busDetails = await Bus.find({ bus_id: { $in: busIdsFromApi } });
    const busMap = new Map();
    busDetails.forEach((b) => {
      busMap.set(b.bus_id, { capacity: b.capacity, type: b.type });
    });
    return busMap;
}