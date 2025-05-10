const express = require('express');
const axios = require('axios');
const dotenv = require('dotenv');
const cors = require('cors');

dotenv.config();

const app = express();
app.use(cors())
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/api/news', async (req, res) => {
  try {
    const response = await axios.get('https://newsapi.org/v2/top-headlines', {
      params: {
        country: 'us',
        apiKey: process.env.NEWS_API_KEY
      }
    });
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

// Endpoint to filter news by category
app.get('/api/news/category/:category', async (req, res) => {
  try {
    const { category } = req.params;
    const response = await axios.get('https://newsapi.org/v2/top-headlines', {
      params: {
        country: 'us',
        category,
        apiKey: process.env.NEWS_API_KEY
      }
    });
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch news by category' });
  }
});

// Endpoint to search news by keyword
app.get('/api/news/search', async (req, res) => {
  try {
    const { q } = req.query;
    const response = await axios.get('https://newsapi.org/v2/everything', {
      params: {
        q,
        apiKey: process.env.NEWS_API_KEY
      }
    });
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: 'Failed to search news' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 