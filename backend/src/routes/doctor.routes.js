const express = require('express');
const doctorController = require('../controllers/doctor.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const fs = require('fs');
const path = require('path');

let upload = {
  single: () => (req, res, next) => next()
};

try {
  const multer = require('multer');
  
  // Ensure upload directory exists in public/uploads
  const uploadDir = path.join(__dirname, '../../public/uploads');
  if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
  }

  const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
      const ext = path.extname(file.originalname);
      cb(null, 'doctor-' + uniqueSuffix + ext);
    }
  });

  upload = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 } // 5MB file size limit
  });
} catch (e) {
  console.log('Multer module not loaded, fallback to JSON body parsing.');
}

const router = express.Router();

// Doctor Management Endpoints
router.get('/', authMiddleware, doctorController.getDoctors);
router.post('/', authMiddleware, upload.single('profile_image'), doctorController.createDoctor);
router.get('/:id', authMiddleware, doctorController.getDoctorById);
router.put('/:id', authMiddleware, doctorController.updateDoctor);
router.delete('/:id', authMiddleware, doctorController.deleteDoctor);
router.get('/:id/timetable', authMiddleware, doctorController.getDoctorTimetable);

module.exports = router;
