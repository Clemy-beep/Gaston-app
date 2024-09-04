from dotenv import load_dotenv
import os
from sqlalchemy import create_engine

from sqlalchemy.orm import sessionmaker, Session

# Charger les variables d'environnement depuis .env
load_dotenv(dotenv_path='./database/.env')

# Récupérer les informations de connexion à partir des variables d'environnement
db_url = os.getenv("DATABASE_URL") 

if not db_url:
    db_url = "postgresql://dev:dev@127.0.0.1:5432/gaston"
    
engine = create_engine(db_url)

_Session = sessionmaker(bind=engine)


def get_session() -> Session:
    return _Session()


# Établir la connexion
try:
    connection = engine.connect()
    print("Connexion réussie!")
except Exception as e:
    print(f"Erreur de connexion : {e}")
    
finally:
    connection.close()
