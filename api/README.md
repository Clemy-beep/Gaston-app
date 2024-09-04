


# gaston api

This folder handles the app's restful API, made with Python & FastAPI. 

## requirements

- python 3.12
- Docker
- Docker Compose

## dev

for developping it's recommended to use venv to avoid side effect and the it's work in my computer 

### Virtual Environment

```sh
# Create virtual environment
python -m venv venv

# Activate virtual environment

Bash/Zsh: `source venv/bin/activate`\
Fish: `source venv/bin/activate.fish`\
Csh/Tcsh: `source venv/bin/activate.csh`\
PowerShell: `.\venv\Scripts\Activate`\

### start developpement 

to facilitate the developpement and avoid side effect run the script:
./start-env-dev.sh  # Bash/Zsh
.\start-env-dev.bat  # PowerShell


## architecture

- main.py is the start of service avoid as possible to modify it
- routers/ : split by context, each responsible for handling specific requests.
- dependencies/ : These are services that are required by other routers.
- entities/ : 
- service/ : 
- validator/ : 


### alembic

- Faire la commande :  "alembic init" après installation 
- Dans le fichier alembic.ini modifier la ligne : prepend_sys_path = ./app
- Génerate a migration : alembic revision --autogenerate -m "Nom de la migration"
- Migrate the last migration :  alembic upgrade head
