const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patient.controller');
const multer = require('multer');
const path = require('path');

// Setup multer for avatar uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'public/uploads/');
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

const authMiddleware = require('../middlewares/auth.middleware');

router.get('/', authMiddleware, patientController.listPatients);
router.post('/', authMiddleware, upload.single('avatar'), patientController.createPatient);
router.put('/:id', authMiddleware, upload.single('avatar'), patientController.updatePatient);
router.delete('/:id', authMiddleware, patientController.deletePatient);

module.exports = router;
