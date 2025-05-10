# News Aggregator Backend

This is the backend for the News Aggregator App. It fetches news from NewsAPI.org and provides endpoints for trending news, category filtering, and search.

## Setup

1. Clone the repository.
2. Navigate to the backend directory:
   ```
   cd backend
   ```
3. Install dependencies:
   ```
   npm install
   ```
4. Create a `.env` file in the backend directory and add your NewsAPI.org API key:
   ```
   NEWS_API_KEY=your_news_api_key_here
   PORT = your_port_number
   ```
   ```
5. Start the server:
   ```
   npm run dev
   ```

## Endpoints

- **GET /api/news**: Fetch trending news.
- **GET /api/news/category/:category**: Filter news by category.
- **GET /api/news/search?q=keyword**: Search news by keyword.