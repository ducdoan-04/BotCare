const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const fs = require('fs');

if (fs.existsSync('.env.local')) {
  dotenv.config({ path: '.env.local', override: true });
}
dotenv.config();

const authRoutes = require('./routes/authRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');
const doctorRoutes = require('./routes/doctorRoutes');

const app = express();

// Explicit CORS — allow Flutter Web (localhost:8080) to call localhost:3000
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logger
app.use((req, res, next) => {
  if (req.method !== 'OPTIONS') {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    if (req.method === 'POST' || req.method === 'PUT') {
      console.log('Body:', JSON.stringify(req.body, null, 2));
    }
  }
  next();
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/doctors', doctorRoutes);

// Health check — open http://localhost:3000/health to verify
app.get('/health', (req, res) => {
  res.json({ status: 'ok', convexUrl: process.env.CONVEX_URL });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Convex URL: ${process.env.CONVEX_URL}`);
});
