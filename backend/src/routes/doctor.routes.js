const express = require('express');
const doctorController = require('../controllers/doctor.controller');
const authMiddleware = require('../middlewares/auth.middleware');

const router = express.Router();

// Doctor Management Endpoints
router.get('/', authMiddleware, doctorController.getDoctors);
router.post('/', authMiddleware, doctorController.createDoctor);
router.get('/:id', authMiddleware, doctorController.getDoctorById);
router.put('/:id', authMiddleware, doctorController.updateDoctor);
router.delete('/:id', authMiddleware, doctorController.deleteDoctor);
router.get('/:id/timetable', authMiddleware, doctorController.getDoctorTimetable);

module.exports = router;
