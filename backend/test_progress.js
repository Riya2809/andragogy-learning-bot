require('dotenv').config();
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI).then(async () => {
  const User = require('./src/models/User');
  const jwt  = require('jsonwebtoken');
  const http = require('http');

  const f     = await User.findOne({ role: 'facilitator' });
  const token = jwt.sign({ id: f._id }, process.env.JWT_SECRET);

  http.get({
    hostname: 'localhost',
    port: 5000,
    path: '/api/progress',
    headers: { Authorization: 'Bearer ' + token }
  }, (r) => {
    let b = '';
    r.on('data', d => b += d);
    r.on('end', () => {
      const data = JSON.parse(b);
      console.log('Count:', data.count);
      console.log('First learner:', JSON.stringify(data.data && data.data[0], null, 2));
      mongoose.disconnect();
    });
  });
});