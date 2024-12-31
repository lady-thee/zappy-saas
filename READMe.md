## Project Goal

This project aims to build a robust SaaS platform that provides real-time transcription and sentiment analysis for various services. By utilizing PostgreSQL for data storage and FastAPI for backend development, we ensure smooth functionality and scalability. The project serves as a foundation for scalable AI-driven solutions tailored to client needs.

## Why This Project?

In today's fast-paced digital world, businesses need efficient tools to manage and analyze data. This project focuses on developing a system that leverages real-time streaming and sentiment analysis to enhance data insights and user experience.

## Tools Used

- **PostgreSQL**: For database management and data storage.
- **FastAPI**: For building the API endpoints and handling server-side logic.
- **Python**: The programming language used for both backend development and database interactions.

## Database Schema

The database schema for this project can be found at [Database Schema](https://drawsql.app/teams/the-a-team-9/diagrams/zappy).


## Loading the Project

### 1. Clone the Repository:
```bash
git clone [repository_link]
cd [project_directory]
```
### 2. Set Up PostgreSQL:
  - Ensure PostgreSQL is installed and running.
  - Create a database using:
```sql
Copy code
CREATE DATABASE zappy_saas_db;
```

### 3. Run Migrations:
 - Apply any necessary migrations or scripts to create tables and set up your schema.

### 4. Start FastAPI Server:
```bash
Copy code
uvicorn main:app --reload
```
This will start the FastAPI server, and you can access it at http://127.0.0.1:8000.
