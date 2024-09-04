import os
import uuid
from fastapi import HTTPException, UploadFile
from entities.recipes import RecipeEntity
from entities.users import UserEntity
from sqlalchemy.orm import Session
from ._singleton import Singleton
from validators.recipe_validator import RecipeAddValidator

ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}
IMAGEDIR_RECIPE = "./app/images/recipes/"
IMAGEDIR_USER = "./app/images/users/"
IMAGEDIR = "./app/images/"

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

async def save_image(imagedir, filename, contents: bytes):
    file_path = os.path.join(imagedir, filename)
    os.makedirs(imagedir, exist_ok=True) 
    with open(file_path, "wb") as f:
        f.write(contents)
    return

class UploadImageService(metaclass=Singleton):
    async def upload_image_recipe(self, session: Session, file: UploadFile, recipe_id) -> str:
        if not allowed_file(file.filename):
            raise HTTPException(status_code=400, detail="File type not allowed")
        else:
            db_recipe = session.query(RecipeEntity).filter(RecipeEntity.id == recipe_id).first()
            path_image = IMAGEDIR_RECIPE + db_recipe.images[0]
            await delete_image(path_image)
        
        unique_filename = f"recipes/{recipe_id}_{uuid.uuid4()}.png"
        
        try:
            contents = await file.read()
            await save_image(IMAGEDIR, unique_filename, contents)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error saving image: {str(e)}")
        
        try:
            db_recipe = session.query(RecipeEntity).filter(RecipeEntity.id == recipe_id).first()
            
            if not db_recipe:
                raise HTTPException(status_code=404, detail=f"User with id {recipe_id} not found")
            
            db_recipe.images = [unique_filename]
            
            session.commit()
            return "Image uploaded and user updated successfully"
        except Exception as e:
            session.rollback()
            raise HTTPException(status_code=500, detail=f"Error updating user: {str(e)}")
        finally:
            session.close()
    
    async def upload_image_user(self, session: Session, file: UploadFile, user_id: int) -> str:
        if not allowed_file(file.filename):
            raise HTTPException(status_code=400, detail="File type not allowed")
        else:
            db_user = session.query(UserEntity).filter(UserEntity.id == user_id).first()
            path_image = IMAGEDIR_USER + db_user.images
            await delete_image(path_image)
        
        unique_filename = f"users/{user_id}_{uuid.uuid4()}.png"
        
        try:
            contents = await file.read()
            await save_image(IMAGEDIR, unique_filename, contents)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error saving image: {str(e)}")
        
        try:
            db_user = session.query(UserEntity).filter(UserEntity.id == user_id).first()
            
            if not db_user:
                raise HTTPException(status_code=404, detail=f"User with id {user_id} not found")
            
            db_user.images = unique_filename
            
            session.commit()
            return "Image uploaded and user updated successfully"
        except Exception as e:
            session.rollback()
            raise HTTPException(status_code=500, detail=f"Error updating user: {str(e)}")
        finally:
            session.close()

async def delete_image(image_path: str):
    try:
        if os.path.exists(image_path):
            os.remove(image_path)
            print(f"Deleted old image: {image_path}")
        else:
            print(f"Image {image_path} does not exist.")
    except Exception as e:
        print(f"Error deleting image: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error deleting image: {str(e)}")


