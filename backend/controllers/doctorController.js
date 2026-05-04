const { ConvexHttpClient } = require("convex/browser");

const convex = new ConvexHttpClient(process.env.CONVEX_URL);

const getAllDoctors = async (req, res) => {
  try {
    const data = await convex.query("doctors:getAll", {});
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const getDoctorById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await convex.query("doctors:getById", { id });
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const createDoctor = async (req, res) => {
  try {
    const {
      name, email, phone, address, country, state, city, postalCode, gender,
      specialty, department, qualification, experience, licenseNumber, username,
      availability, workHours, avatar,
      totalPatients, surgeries, rating, reviewsCount, about
    } = req.body;

    if (!name || !specialty) {
      return res.status(400).json({ success: false, message: 'Name and specialty are required' });
    }

    const doctorData = {
      name,
      specialty,
      availability: availability || 'Available',
      ...(email && { email }),
      ...(phone && { phone }),
      ...(address && { address }),
      ...(country && { country }),
      ...(state && { state }),
      ...(city && { city }),
      ...(postalCode && { postalCode }),
      ...(gender && { gender }),
      ...(department && { department }),
      ...(qualification && { qualification }),
      ...(experience && { experience }),
      ...(licenseNumber && { licenseNumber }),
      ...(username && { username }),
      ...(workHours && { workHours }),
      ...(avatar && { avatar }),
      ...(totalPatients !== undefined && { totalPatients: Number(totalPatients) }),
      ...(surgeries !== undefined && { surgeries: Number(surgeries) }),
      ...(rating !== undefined && { rating: Number(rating) }),
      ...(reviewsCount !== undefined && { reviewsCount: Number(reviewsCount) }),
      ...(about && { about }),
    };

    const result = await convex.mutation("doctors:create", doctorData);
    res.status(201).json({ success: true, data: result, message: 'Doctor created successfully' });
  } catch (error) {
    console.error('createDoctor error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const updateDoctor = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = { ...req.body };

    // Convert numeric fields
    ['totalPatients', 'surgeries', 'rating', 'reviewsCount'].forEach(field => {
      if (updates[field] !== undefined) updates[field] = Number(updates[field]);
    });

    const result = await convex.mutation("doctors:update", { id, ...updates });
    res.status(200).json({ success: true, data: result });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const deleteDoctor = async (req, res) => {
  try {
    const { id } = req.params;
    await convex.mutation("doctors:remove", { id });
    res.status(200).json({ success: true, message: 'Doctor deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  createDoctor,
  updateDoctor,
  deleteDoctor
};
