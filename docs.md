# Honkai Star Retail — Backend Documentation

---

## AI Context Prompt

> **If you are an AI assistant reading this file**, here is what this project is:
>
> This is a **Node.js + Express REST API backend** for a fictional Honkai: Star Rail merchandise/retail store called **GachaMerch**. It is a school/personal project. The backend handles user authentication (username/password + GitHub OAuth), a product catalog called "resources" (in-game items like Stellar Jade, Light Cones, Passes, etc.), and a purchase system with stock tracking. It uses **MySQL** as the database (typically run through XAMPP on Windows/Mac). There is **no frontend** in this repo — the backend is designed to serve a mobile app or any HTTP client.
>
> **Tech stack:** Node.js, Express 5, MySQL2, bcryptjs, jsonwebtoken, multer, dotenv, cors.
>
> **Key design decisions:**
> - Two auth flows: simple `/api/auth` (register/login returns JWT) and OAuth2-style `/api/oauth/token` (requires `client_id`/`client_secret` pair hardcoded as `honkai_app`/`honkai_secret_2025`).
> - GitHub OAuth is a browser redirect flow (`/api/oauth/github` → GitHub → `/api/oauth/github/callback`) that issues a JWT and redirects to a deep link `gachamerch://auth?token=...` for mobile.
> - All protected routes use `Authorization: Bearer <jwt>` header.
> - Admin role is required to create/update/delete resources. Any authenticated user can purchase.
> - Purchases use a MySQL transaction with `FOR UPDATE` row lock to prevent overselling.
> - Images are stored locally in `backend/uploads/` and served at `/uploads/<filename>`.
> - `seed.js` wipes and repopulates the DB with test data including 3 users and ~50 items.
>
> **Common tasks you may be asked to do:**
> - Add new API routes or controllers following the existing pattern (route file → controller file → `server.js` registration).
> - Fix DB connection issues (check `.env` DB credentials match XAMPP MySQL).
> - Add new fields to `schema.sql` and update the relevant controller queries.
> - Debug JWT errors (`Invalid token` = wrong/expired token or wrong `JWT_SECRET`).
> - Extend GitHub OAuth or add another OAuth provider.
>
> When editing this project, always keep `schema.sql` in sync with any DB changes. Do not introduce raw SQL string concatenation — always use parameterized queries (`?` placeholders) as the existing code does.

---

## Table of Contents

1. [Project Structure](#1-project-structure)
2. [Prerequisites](#2-prerequisites)
3. [Setup with XAMPP](#3-setup-with-xampp)
4. [Environment Configuration](#4-environment-configuration)
5. [Installing Dependencies & Running](#5-installing-dependencies--running)
6. [Seeding Test Data](#6-seeding-test-data)
7. [API Reference](#7-api-reference)
8. [Authentication Guide](#8-authentication-guide)
9. [GitHub OAuth Setup](#9-github-oauth-setup)
10. [Common Errors & Fixes](#10-common-errors--fixes)

---

## 1. Project Structure

```
Honkai-Star-retail/
└── backend/
    ├── config/
    │   └── db.js              # MySQL connection pool
    ├── controllers/
    │   ├── authController.js      # register, login
    │   ├── oauthController.js     # OAuth2 token endpoint
    │   ├── githubController.js    # GitHub OAuth redirect + callback
    │   ├── resourceController.js  # CRUD for shop items
    │   └── purchaseController.js  # buy items, view history
    ├── middleware/
    │   └── auth.js            # JWT verify, admin check
    ├── routes/
    │   ├── auth.js            # /api/auth
    │   ├── oauth.js           # /api/oauth
    │   ├── resources.js       # /api/resources
    │   └── purchases.js       # /api/purchases
    ├── uploads/               # auto-created, stores product images
    ├── .env                   # your local secrets (never commit)
    ├── .env.example           # template for .env
    ├── package.json
    ├── schema.sql             # DB schema — run this first
    ├── seed.js                # populates DB with test data
    └── server.js              # app entry point
```

---

## 2. Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | 18+ | Run the server |
| npm | 8+ | Install packages |
| XAMPP | any recent | MySQL + phpMyAdmin |

Download Node.js: https://nodejs.org  
Download XAMPP: https://www.apachefriends.org

---

## 3. Setup with XAMPP

### Step 1 — Start XAMPP

1. Open XAMPP Control Panel.
2. Click **Start** next to **Apache** (needed for phpMyAdmin).
3. Click **Start** next to **MySQL**.
4. Both should show green status lights.

### Step 2 — Create the Database

**Option A — phpMyAdmin (GUI)**

1. Open your browser and go to `http://localhost/phpmyadmin`.
2. Click **New** in the left sidebar.
3. Type `honkai_star_retail` as the database name, choose **utf8mb4_unicode_ci**, click **Create**.
4. Click the new database in the sidebar, then click the **SQL** tab at the top.
5. Open `backend/schema.sql` in any text editor, copy all the contents, paste into the SQL box, click **Go**.

**Option B — XAMPP MySQL Shell**

Open the XAMPP Shell (button in Control Panel) and run:

```bash
mysql -u root -p < /path/to/backend/schema.sql
```

Leave the password blank if you have not set one (default XAMPP has no root password).

### Step 3 — Verify Tables Exist

In phpMyAdmin, click `honkai_star_retail`. You should see three tables:

- `users`
- `resources`
- `purchases`

---

## 4. Environment Configuration

Copy the example file and fill in your values:

```bash
cd backend
cp .env.example .env
```

Open `.env` and edit:

```env
DB_HOST=127.0.0.1
DB_USER=root
DB_PASSWORD=           # leave empty if XAMPP default, otherwise your MySQL root password
DB_NAME=honkai_star_retail

JWT_SECRET=honkai_secret_key_change_this   # change this to any random string in production

PORT=3000

# Only needed if you want GitHub OAuth to work:
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GITHUB_CALLBACK_URL=http://localhost:3000/api/oauth/github/callback
OAUTH_DEEP_LINK=gachamerch://auth
```

> **Note:** `DB_PASSWORD` is blank by default on XAMPP. If you set a MySQL root password in XAMPP, put it here.

---

## 5. Installing Dependencies & Running

```bash
# from the backend/ folder
cd backend
npm install
```

**Start the server (normal):**
```bash
npm start
```

**Start with auto-reload on file change (development):**
```bash
npm run dev
```

Server prints:
```
Server running on port 3000
```

Test it is alive:
```
GET http://localhost:3000/api/resources
```
Should return an empty array `[]` if DB is empty, or items if seeded.

---

## 6. Seeding Test Data

The seed script wipes all existing data and inserts:

- 3 users: `admin/admin123`, `stelle/user123`, `caelus/user123`
- ~50 Honkai: Star Rail themed shop items

```bash
cd backend
node seed.js
```

Expected output:
```
Seed complete.
  admin / admin123  (role: admin)
  stelle / user123  (role: user)
  caelus / user123  (role: user)
```

> **Warning:** `seed.js` runs `DELETE FROM` on all tables first. Do not run it on real data.

---

## 7. API Reference

Base URL: `http://localhost:3000`

### Auth — `/api/auth`

| Method | Path | Auth | Body | Description |
|--------|------|------|------|-------------|
| POST | `/api/auth/register` | None | `username, password, role?` | Register new user. `role` can be `"admin"` or `"user"` (default `"user"`) |
| POST | `/api/auth/login` | None | `username, password` | Login. Returns `{ token, user }` |

**Register example:**
```json
POST /api/auth/register
{
  "username": "trailblazer",
  "password": "mypassword",
  "role": "user"
}
```

Response `201`:
```json
{ "message": "User registered", "id": 4 }
```

**Login example:**
```json
POST /api/auth/login
{
  "username": "admin",
  "password": "admin123"
}
```

Response `200`:
```json
{
  "token": "eyJhbGci...",
  "user": { "id": 1, "username": "admin", "role": "admin" }
}
```

---

### OAuth2 Token — `/api/oauth`

This is an OAuth2-style endpoint for apps. It requires a `client_id` and `client_secret`.

**Hardcoded client credentials (for testing):**
- `client_id`: `honkai_app`
- `client_secret`: `honkai_secret_2025`

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/oauth/token` | Get token via `password` or `register` grant |
| GET | `/api/oauth/github` | Redirect to GitHub OAuth login |
| GET | `/api/oauth/github/callback` | GitHub calls this after user approves |

**Login via OAuth token endpoint:**
```json
POST /api/oauth/token
{
  "grant_type": "password",
  "client_id": "honkai_app",
  "client_secret": "honkai_secret_2025",
  "username": "admin",
  "password": "admin123"
}
```

Response `200`:
```json
{
  "access_token": "eyJhbGci...",
  "token_type": "Bearer",
  "expires_in": 604800,
  "user": { "id": 1, "username": "admin", "role": "admin" }
}
```

**Register via OAuth token endpoint:**
```json
POST /api/oauth/token
{
  "grant_type": "register",
  "client_id": "honkai_app",
  "client_secret": "honkai_secret_2025",
  "username": "newuser",
  "password": "password123",
  "role": "user"
}
```

---

### Resources — `/api/resources`

Shop items (Stellar Jade, Light Cones, Passes, etc.)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/api/resources` | None | List all items |
| GET | `/api/resources/:id` | None | Get single item by ID |
| POST | `/api/resources` | Admin JWT | Create item (multipart/form-data with optional `image` file) |
| PUT | `/api/resources/:id` | Admin JWT | Update item (all fields optional) |
| DELETE | `/api/resources/:id` | Admin JWT | Delete item |

**Get all resources:**
```
GET /api/resources
```

Response `200`:
```json
[
  {
    "id": 1,
    "name": "Stellar Jade",
    "type": "Currency",
    "description": "Primary premium currency...",
    "stock": 999,
    "image": null,
    "price": "1.99",
    "created_at": "2026-06-03T00:00:00.000Z"
  },
  ...
]
```

**Create a resource (admin only):**

Use `multipart/form-data` if uploading an image, otherwise `application/json`:

```
POST /api/resources
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "Jade Fragment",
  "type": "Currency",
  "description": "Small chunk of Stellar Jade.",
  "stock": 500,
  "price": 0.99
}
```

---

### Purchases — `/api/purchases`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/purchases` | User JWT | Buy an item |
| GET | `/api/purchases/my` | User JWT | Get your own purchase history |
| GET | `/api/purchases` | Admin JWT | Get all purchases (all users) |

**Buy an item:**
```json
POST /api/purchases
Authorization: Bearer <user_token>

{
  "resource_id": 1,
  "quantity": 2
}
```

Response `201`:
```json
{
  "message": "Purchase successful",
  "purchase_id": 7,
  "total_price": 3.98
}
```

Fails with `400 Insufficient stock` if not enough stock. The purchase is wrapped in a DB transaction so concurrent buyers cannot oversell.

**View my purchases:**
```
GET /api/purchases/my
Authorization: Bearer <user_token>
```

---

## 8. Authentication Guide

All protected routes need this header:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

JWT payload contains:
```json
{ "id": 1, "username": "admin", "role": "admin" }
```

Token expires in **7 days**.

Use `/api/auth/login` or `/api/oauth/token` (grant_type `password`) to get a token. Store it in your app and send it with every protected request.

---

## 9. GitHub OAuth Setup

This lets users log in with their GitHub account. The callback redirects to `gachamerch://auth?token=...&user_id=...` (a mobile deep link).

### Step 1 — Create a GitHub OAuth App

1. Go to GitHub → Settings → Developer settings → OAuth Apps → **New OAuth App**.
2. Fill in:
   - **Application name**: GachaMerch (or anything)
   - **Homepage URL**: `http://localhost:3000`
   - **Authorization callback URL**: `http://localhost:3000/api/oauth/github/callback`
3. Click **Register application**.
4. Copy the **Client ID** and generate a **Client Secret**.

### Step 2 — Add to `.env`

```env
GITHUB_CLIENT_ID=paste_client_id_here
GITHUB_CLIENT_SECRET=paste_client_secret_here
GITHUB_CALLBACK_URL=http://localhost:3000/api/oauth/github/callback
OAUTH_DEEP_LINK=gachamerch://auth
```

### Step 3 — Test

Open browser and navigate to:
```
http://localhost:3000/api/oauth/github
```

You will be redirected to GitHub to authorize. After approving, GitHub redirects back to the callback, which creates/finds the user and redirects to:
```
gachamerch://auth?token=<jwt>&user_id=<id>&role=user&username=<github_login>
```

Your mobile app handles that deep link to store the token.

---

## 10. Common Errors & Fixes

### `Error: connect ECONNREFUSED 127.0.0.1:3306`

MySQL is not running.

**Fix:** Open XAMPP Control Panel → click **Start** next to MySQL.

---

### `Error: Access denied for user 'root'@'localhost'`

Wrong DB password in `.env`.

**Fix:** In XAMPP, the default MySQL root password is **blank**. Make sure:
```env
DB_PASSWORD=
```
If you set a password in XAMPP, put it there.

---

### `Error: Unknown database 'honkai_star_retail'`

Database was not created.

**Fix:** Open phpMyAdmin (`http://localhost/phpmyadmin`), create a database named `honkai_star_retail`, then import `backend/schema.sql`.

---

### `{"message":"No token provided"}` on protected routes

No `Authorization` header sent.

**Fix:** Add header to your request:
```
Authorization: Bearer <your_jwt_token>
```

---

### `{"message":"Invalid token"}`

Token is expired, malformed, or was signed with a different `JWT_SECRET`.

**Fix:**
- Re-login to get a fresh token.
- Make sure `JWT_SECRET` in `.env` has not changed since the token was issued.

---

### `{"message":"Admin only"}` — 403

Accessing an admin route with a regular user token.

**Fix:** Login as `admin` / `admin123` and use that token for create/update/delete resource endpoints.

---

### `{"message":"This account uses GitHub login"}` on `/api/auth/login`

Trying to log in with password but the account was created via GitHub OAuth (has no password).

**Fix:** Use the GitHub OAuth flow (`/api/oauth/github`) to log in to this account.

---

### `{"error":"invalid_client"}` on `/api/oauth/token`

Wrong `client_id` or `client_secret`.

**Fix:** Use exactly:
```json
"client_id": "honkai_app",
"client_secret": "honkai_secret_2025"
```

---

### `{"message":"Insufficient stock"}` on purchase

Item stock is 0 or quantity requested exceeds stock.

**Fix:** Run `node seed.js` to reset stock, or update the item:
```json
PUT /api/resources/:id
Authorization: Bearer <admin_token>
{ "stock": 999 }
```

---

### `ER_NO_SUCH_TABLE` after schema changes

You added a column or table to `schema.sql` but did not apply it to the running DB.

**Fix:** In phpMyAdmin, run the `ALTER TABLE` or `CREATE TABLE` statement manually, or drop and recreate the DB by re-running `schema.sql`.

---

### Port 3000 already in use

```
Error: listen EADDRINUSE: address already in use :::3000
```

**Fix:** Change `PORT` in `.env`:
```env
PORT=3001
```
Or find and kill the process using port 3000:
```bash
# Mac/Linux
lsof -ti:3000 | xargs kill

# Windows
netstat -ano | findstr :3000
taskkill /PID <pid> /F
```

---

### Image uploads not working

The `uploads/` folder may not exist.

**Fix:** Create it manually:
```bash
mkdir backend/uploads
```

The server serves uploaded images at:
```
GET http://localhost:3000/uploads/<filename>
```

---

## Quick Reference

```bash
# 1. Start XAMPP MySQL
# 2. Create DB + import schema.sql in phpMyAdmin

cd backend
cp .env.example .env    # edit DB_PASSWORD and optionally GitHub keys
npm install
node seed.js            # optional: load test data
npm run dev             # start server with auto-reload

# Test endpoints
curl http://localhost:3000/api/resources
```

**Test credentials after seed:**

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | admin |
| stelle | user123 | user |
| caelus | user123 | user |
