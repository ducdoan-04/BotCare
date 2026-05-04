import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    email: v.string(),
    name: v.optional(v.string()),
    password: v.optional(v.string()), // Hashed password for email login
    authProvider: v.string(), // "email", "google", "apple"
    providerId: v.optional(v.string()), // ID from Google/Apple
    createdAt: v.number(),
  }).index("by_email", ["email"])
    .index("by_provider", ["authProvider", "providerId"]),

  doctors: defineTable({
    name: v.string(),
    email: v.optional(v.string()),
    phone: v.optional(v.string()),
    address: v.optional(v.string()),
    country: v.optional(v.string()),
    state: v.optional(v.string()),
    city: v.optional(v.string()),
    postalCode: v.optional(v.string()),
    gender: v.optional(v.string()),
    specialty: v.string(),
    department: v.optional(v.string()),
    qualification: v.optional(v.string()),
    experience: v.optional(v.string()),
    licenseNumber: v.optional(v.string()),
    username: v.optional(v.string()),
    availability: v.string(), // e.g. "Available"
    workHours: v.optional(v.string()), // e.g. "9AM - 2PM"
    avatar: v.optional(v.string()),
    totalPatients: v.optional(v.number()),
    surgeries: v.optional(v.number()),
    rating: v.optional(v.number()),
    reviewsCount: v.optional(v.number()),
    about: v.optional(v.string()),
    createdAt: v.number(),
  }),

  patients: defineTable({
    status: v.string(), // "under_treatment", "recovered"
    date: v.optional(v.string()), // e.g. "Wed", "Thu"
    createdAt: v.number(),
  }),

  appointments: defineTable({
    patientName: v.string(),
    disease: v.string(),
    time: v.string(),
    avatar: v.optional(v.string()),
    createdAt: v.number(),
  }),

  polyclinics: defineTable({
    name: v.string(),
    patientCount: v.number(),
    createdAt: v.number(),
  }),

  notifications: defineTable({
    title: v.string(),
    timeString: v.string(),
    type: v.string(), // "message", "new_patient", "leave_approved", "file"
    isRead: v.boolean(),
    createdAt: v.number(),
  }),
});
