const express = require('express');
const { login, register, googleLogin, appleLogin } = require('../controllers/authController');

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/google-login', googleLogin);
router.post('/apple-login', appleLogin);

module.exports = router;
