from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config.database import start_db


app = FastAPI()

origins = [
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def on_startup():
    await start_db()

@app.get('/')
async def main():
    return {
        "status": 200,
        "message": "App initialized"
    }



