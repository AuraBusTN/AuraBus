import { Bus } from "./models/Bus.js";

const busData = [
  { bus_id: 111, capacity: 80, type: "standard_single" },
  { bus_id: 124, capacity: 80, type: "standard_single" },
  {
    bus_id: 303,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 304,
    capacity: 160,
    type: "articulated",
  },
  {
    bus_id: 305,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 306, capacity: 80, type: "standard_single" },
  {
    bus_id: 307,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 308, capacity: 80, type: "standard_single" },
  { bus_id: 335, capacity: 80, type: "standard_single" },
  { bus_id: 348, capacity: 80, type: "standard_single" },
  { bus_id: 353, capacity: 80, type: "standard_single" },
  { bus_id: 355, capacity: 80, type: "standard_single" },
  { bus_id: 358, capacity: 80, type: "standard_single" },
  { bus_id: 360, capacity: 80, type: "standard_single" },
  {
    bus_id: 371,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 374, capacity: 80, type: "standard_single" },
  { bus_id: 375, capacity: 80, type: "standard_single" },
  {
    bus_id: 376,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 377, capacity: 80, type: "standard_single" },
  {
    bus_id: 381,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 383, capacity: 80, type: "standard_single" },
  {
    bus_id: 384,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 389, capacity: 80, type: "standard_single" },
  {
    bus_id: 405,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 406, capacity: 80, type: "standard_single" },
  { bus_id: 409, capacity: 80, type: "standard_single" },
  {
    bus_id: 411,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 413,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 414, capacity: 80, type: "standard_single" },
  { bus_id: 415, capacity: 80, type: "standard_single" },
  {
    bus_id: 416,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 417, capacity: 80, type: "standard_single" },
  { bus_id: 418, capacity: 80, type: "standard_single" },
  { bus_id: 419, capacity: 80, type: "standard_single" },
  { bus_id: 420, capacity: 80, type: "standard_single" },
  {
    bus_id: 421,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 424,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 430,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 705, capacity: 80, type: "standard_single" },
  { bus_id: 706, capacity: 80, type: "standard_single" },
  { bus_id: 707, capacity: 80, type: "standard_single" },
  {
    bus_id: 708,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 710, capacity: 80, type: "standard_single" },
  {
    bus_id: 713,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 715, capacity: 80, type: "standard_single" },
  { bus_id: 716, capacity: 80, type: "standard_single" },
  { bus_id: 717, capacity: 80, type: "standard_single" },
  { bus_id: 719, capacity: 80, type: "standard_single" },
  { bus_id: 720, capacity: 80, type: "standard_single" },
  {
    bus_id: 721,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 731, capacity: 80, type: "standard_single" },
  { bus_id: 732, capacity: 80, type: "standard_single" },
  { bus_id: 735, capacity: 80, type: "standard_single" },
  { bus_id: 736, capacity: 80, type: "standard_single" },
  {
    bus_id: 738,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 741,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 797, capacity: 80, type: "standard_single" },
  {
    bus_id: 810,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 811, capacity: 80, type: "standard_single" },
  { bus_id: 814, capacity: 80, type: "standard_single" },
  { bus_id: 817, capacity: 80, type: "standard_single" },
  { bus_id: 823, capacity: 80, type: "standard_single" },
  {
    bus_id: 825,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 827, capacity: 80, type: "standard_single" },
  {
    bus_id: 830,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 831,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 832,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 833, capacity: 80, type: "standard_single" },
  {
    bus_id: 834,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 835, capacity: 80, type: "standard_single" },
  { bus_id: 836, capacity: 80, type: "standard_single" },
  { bus_id: 837, capacity: 80, type: "standard_single" },
  { bus_id: 838, capacity: 80, type: "standard_single" },
  { bus_id: 839, capacity: 80, type: "standard_single" },
  { bus_id: 840, capacity: 80, type: "standard_single" },
  { bus_id: 841, capacity: 80, type: "standard_single" },
  { bus_id: 842, capacity: 80, type: "standard_single" },
  {
    bus_id: 843,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 845, capacity: 80, type: "standard_single" },
  {
    bus_id: 848,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 849,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 850, capacity: 80, type: "standard_single" },
  { bus_id: 851, capacity: 80, type: "standard_single" },
  {
    bus_id: 853,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 854, capacity: 80, type: "standard_single" },
  {
    bus_id: 855,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 857,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 858,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 859,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 860,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 861,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 862,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 869,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 877,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 879,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 880, capacity: 40, type: "mini" },
  { bus_id: 881, capacity: 80, type: "standard_single" },
  {
    bus_id: 882,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 883, capacity: 80, type: "standard_single" },
  {
    bus_id: 884,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 885,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 887,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 888,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 889,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 890,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 891, capacity: 80, type: "standard_single" },
  {
    bus_id: 893,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 894,
    capacity: 100,
    type: "standard",
  },
  { bus_id: 896, capacity: 80, type: "standard_single" },
  {
    bus_id: 897,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 898,
    capacity: 100,
    type: "standard",
  },
  {
    bus_id: 899,
    capacity: 100,
    type: "standard",
  },
];

export async function seedDatabase() {
  try {
    await Bus.deleteMany({});
    console.log('🧹 Collection "buses" cleaned.');

    const result = await Bus.insertMany(busData);
    console.log(
      `🚀 Inserted ${result.length} buses into the database automatically!`
    );
  } catch (error) {
    console.error("❌ Error during automatic seeding:", error);
  }
}
