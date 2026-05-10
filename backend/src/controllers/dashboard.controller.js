const dashboardService = require('../services/dashboard.service');

class DashboardController {
  async getDashboard(req, res) {
    try {
      const { period } = req.query; // 'today', 'week', 'month'
      
      const dashboardData = await dashboardService.getDashboardData(period);

      res.status(200).json({
        success: true,
        data: dashboardData
      });
    } catch (error) {
      console.error('Controller Error fetching dashboard data:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to retrieve dashboard data'
      });
    }
  }
}

module.exports = new DashboardController();
