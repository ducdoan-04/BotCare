import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const getUserByEmail = query({
  args: { email: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();
  },
});

export const getUserByProvider = query({
  args: { authProvider: v.string(), providerId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("users")
      .withIndex("by_provider", (q) =>
        q.eq("authProvider", args.authProvider).eq("providerId", args.providerId)
      )
      .first();
  },
});

export const createUser = mutation({
  args: {
    email: v.string(),
    name: v.optional(v.string()),
    password: v.optional(v.string()),
    authProvider: v.string(),
    providerId: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const existingUser = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();

    if (existingUser && args.authProvider === "email") {
      throw new Error("User already exists");
    }

    if (existingUser) {
        return existingUser._id;
    }

    const userId = await ctx.db.insert("users", {
      ...args,
      createdAt: Date.now(),
    });
    return userId;
  },
});
