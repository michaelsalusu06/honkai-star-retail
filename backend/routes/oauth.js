const router = require('express').Router();
const { token } = require('../controllers/oauthController');
const { redirect, callback } = require('../controllers/githubController');

router.post('/token', token);
router.get('/github', redirect);
router.get('/github/callback', callback);

module.exports = router;
