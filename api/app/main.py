# from dependencies.database import connection
from fastapi.staticfiles import StaticFiles
import uvicorn
from fastapi import Depends, FastAPI

from routers import recipes, users, auth, tags, step_recipes as step, likeDislike, comments, recipe_difficulty_votes

app = FastAPI()

app.include_router(auth.router, prefix="/auth")

app.include_router(step.router)  # no prefix can be start with /recipes or /steps

app.include_router(recipes.router, prefix="/recipes")

app.include_router(users.router, prefix="/users")

app.include_router(tags.router, prefix="/tags")

app.mount("/images", StaticFiles(directory="app/images"), name="images")

app.include_router(
    likeDislike.router,
    prefix = "/likeDislike")

app.include_router(
    comments.router,
    prefix="/comments"
)

app.include_router(
    recipe_difficulty_votes.router,
    prefix="/recipe-difficulty-votes"
)

@app.get("/")
async def root():
    return {"message": "Gaston votre chef a la maison !"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
