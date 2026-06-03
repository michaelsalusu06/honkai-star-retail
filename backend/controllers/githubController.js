const db = require('../config/db');
const jwt = require('jsonwebtoken');

function redirect(req, res) {
  const params = new URLSearchParams({
    client_id: process.env.GITHUB_CLIENT_ID,
    redirect_uri: process.env.GITHUB_CALLBACK_URL,
    scope: 'user:email',
    state: Math.random().toString(36).slice(2),
  });
  res.redirect(`https://github.com/login/oauth/authorize?${params}`);
}

async function callback(req, res) {
  const { code } = req.query;
  if (!code) return res.status(400).json({ message: 'Missing code' });

  try {
    const tokenRes = await fetch('https://github.com/login/oauth/access_token', {
      method: 'POST',
      headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
      body: JSON.stringify({
        client_id: process.env.GITHUB_CLIENT_ID,
        client_secret: process.env.GITHUB_CLIENT_SECRET,
        code,
        redirect_uri: process.env.GITHUB_CALLBACK_URL,
      }),
    });
    const tokenData = await tokenRes.json();

    if (tokenData.error) {
      return res.status(401).json({ message: tokenData.error_description || tokenData.error });
    }

    const userRes = await fetch('https://api.github.com/user', {
      headers: {
        Authorization: `Bearer ${tokenData.access_token}`,
        Accept: 'application/json',
        'User-Agent': 'GachaMerch-HonkaiStarRetail',
      },
    });
    const ghUser = await userRes.json();

    const [existing] = await db.query('SELECT * FROM users WHERE github_id = ?', [String(ghUser.id)]);

    let user;
    if (existing.length > 0) {
      user = existing[0];
    } else {
      const [nameTaken] = await db.query('SELECT id FROM users WHERE username = ?', [ghUser.login]);
      const username = nameTaken.length > 0 ? `${ghUser.login}_gh` : ghUser.login;

      const [result] = await db.query(
        'INSERT INTO users (username, password, role, github_id, avatar_url) VALUES (?, NULL, ?, ?, ?)',
        [username, 'user', String(ghUser.id), ghUser.avatar_url || null]
      );
      user = { id: result.insertId, username, role: 'user' };
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    const deepLink = process.env.OAUTH_DEEP_LINK;
    if (deepLink) {
      const params = new URLSearchParams({
        token,
        user_id: String(user.id),
        role: user.role,
        username: user.username,
      });
      return res.redirect(`${deepLink}?${params}`);
    }

    return res.json({
      access_token: token,
      token_type: 'Bearer',
      expires_in: 604800,
      user: { id: user.id, username: user.username, role: user.role },
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
}

module.exports = { redirect, callback };
