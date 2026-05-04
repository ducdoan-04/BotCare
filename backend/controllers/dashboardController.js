const { ConvexHttpClient } = require("convex/browser");

const convex = new ConvexHttpClient(process.env.CONVEX_URL || "https://grand-magpie-457.convex.cloud");

const getDashboardData = async (req, res) => {
  try {
    const data = await convex.query("dashboard:getDashboardData", {});
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const seedDashboardData = async (req, res) => {
  try {
    await convex.mutation("dashboard:seedDashboardData", {});
    res.status(200).json({ success: true, message: "Dashboard data seeded successfully" });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

module.exports = {
  getDashboardData,
  seedDashboardData
};
