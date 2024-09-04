from sqlalchemy.engine import Engine

def init_db(engine: Engine, Base: any):
    Base.metadata.create_all(bind=engine)