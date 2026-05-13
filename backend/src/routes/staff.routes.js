const express = require('express');
const router = express.Router();
const staffController = require('../controllers/staff.controller');
const authMiddleware = require('../middlewares/auth.middleware');

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

router.use(authMiddleware);

router.get('/', staffController.listStaff);
router.post('/', upload.single('avatar'), staffController.createStaff);
router.put('/:id', upload.single('avatar'), staffController.updateStaff);
router.delete('/:id', staffController.deleteStaff);
router.get('/:id', staffController.getStaffDetail);
router.get('/:id/summary', staffController.getStaffSummary);
router.get('/:id/timetable', staffController.getStaffTimetable);

module.exports = router;
