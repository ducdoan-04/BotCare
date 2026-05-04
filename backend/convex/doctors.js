import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

export const getAll = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db.query("doctors").order("desc").collect();
  },
});

export const getById = query({
  args: { id: v.id("doctors") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.id);
  },
});

export const create = mutation({
  args: {
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
    availability: v.string(),
    workHours: v.optional(v.string()),
    avatar: v.optional(v.string()),
    totalPatients: v.optional(v.number()),
    surgeries: v.optional(v.number()),
    rating: v.optional(v.number()),
    reviewsCount: v.optional(v.number()),
    about: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    return await ctx.db.insert("doctors", {
      ...args,
      createdAt: Date.now(),
    });
  },
});

export const update = mutation({
  args: {
    id: v.id("doctors"),
    name: v.optional(v.string()),
    email: v.optional(v.string()),
    phone: v.optional(v.string()),
    address: v.optional(v.string()),
    country: v.optional(v.string()),
    state: v.optional(v.string()),
    city: v.optional(v.string()),
    postalCode: v.optional(v.string()),
    gender: v.optional(v.string()),
    specialty: v.optional(v.string()),
    department: v.optional(v.string()),
    qualification: v.optional(v.string()),
    experience: v.optional(v.string()),
    licenseNumber: v.optional(v.string()),
    username: v.optional(v.string()),
    availability: v.optional(v.string()),
    workHours: v.optional(v.string()),
    avatar: v.optional(v.string()),
    totalPatients: v.optional(v.number()),
    surgeries: v.optional(v.number()),
    rating: v.optional(v.number()),
    reviewsCount: v.optional(v.number()),
    about: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const { id, ...updates } = args;
    await ctx.db.patch(id, updates);
    return true;
  },
});

export const remove = mutation({
  args: { id: v.id("doctors") },
  handler: async (ctx, args) => {
    await ctx.db.delete(args.id);
    return true;
  },
});
