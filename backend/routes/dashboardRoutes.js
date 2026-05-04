const express = require('express');
const { getDashboardData, seedDashboardData } = require('../controllers/dashboardController');

const router = express.Router();

router.get('/', getDashboardData);
router.get('/seed', seedDashboardData);

module.exports = router;
