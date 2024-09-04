CREATE TABLE users (
   id_users SERIAL PRIMARY KEY,
   firstname VARCHAR(50) NOT NULL,
   lastname VARCHAR(50) NOT NULL,
   email VARCHAR(50) NOT NULL UNIQUE,
   biography TEXT,
   createdAt DATE NOT NULL,
   reporting INT,
   roles VARCHAR(50),
   username VARCHAR(50)
);

CREATE TABLE sessions (
    id_session UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    jwt VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id_users)
);

CREATE TABLE recipies (
   id_recipies SERIAL PRIMARY KEY,
   name VARCHAR(50) NOT NULL,
   description TEXT,
   createdAt DATE NOT NULL,
   difficulty SMALLINT NOT NULL,
   estimatedTime INTERVAL,
   price INT,
   reporting INT,
   images TEXT,
   id_users INT NOT NULL,
   FOREIGN KEY (id_users) REFERENCES users (id_users)
);

CREATE TABLE step_recipies (
   id_step_recipies SERIAL PRIMARY KEY,
   descriptions TEXT NOT NULL,
   times INT,
   stepName VARCHAR(50),
   stepNumber INT NOT NULL,
   createdAt DATE,
   commentary TEXT,
   reporting VARCHAR(50),
   category VARCHAR(50),
   id_recipies INT NOT NULL,
   FOREIGN KEY (id_recipies) REFERENCES recipies (id_recipies)
);

CREATE TABLE ingredient (
   id_ingredient SERIAL PRIMARY KEY,
   ingredient_name VARCHAR(50)
);

CREATE TABLE mesure_unit (
   id_mesure SERIAL PRIMARY KEY,
   unite_name VARCHAR(50)
);

CREATE TABLE tag (
   id_tag SERIAL PRIMARY KEY,
   nameTag VARCHAR(50),
   idColors VARCHAR(50)
);

CREATE TABLE commentary (
   id_commentary SERIAL PRIMARY KEY,
   comment TEXT,
   reporting INT,
   images TEXT,
   id_users INT NOT NULL,
   id_step_recipies INT NOT NULL,
   id_recipies INT NOT NULL,
   FOREIGN KEY (id_users) REFERENCES users (id_users),
   FOREIGN KEY (id_step_recipies) REFERENCES step_recipies (id_step_recipies),
   FOREIGN KEY (id_recipies) REFERENCES recipies (id_recipies)
);

CREATE TABLE vote (
   id_users INT,
   id_recipies INT,
   vote BOOLEAN,
   PRIMARY KEY (id_users, id_recipies),
   FOREIGN KEY (id_users) REFERENCES users (id_users),
   FOREIGN KEY (id_recipies) REFERENCES recipies (id_recipies)
);

CREATE TABLE recipies_ingredient_quantity (
   id_recipies INT,
   id_ingredient INT,
   id_mesure INT,
   quantities VARCHAR(50),
   PRIMARY KEY (id_recipies, id_ingredient, id_mesure),
   FOREIGN KEY (id_recipies) REFERENCES recipies (id_recipies),
   FOREIGN KEY (id_ingredient) REFERENCES ingredient (id_ingredient),
   FOREIGN KEY (id_mesure) REFERENCES mesure_unit (id_mesure)
);

CREATE TABLE tagOwner (
   id_recipies INT,
   id_tag INT,
   PRIMARY KEY (id_recipies, id_tag),
   FOREIGN KEY (id_recipies) REFERENCES recipies (id_recipies),
   FOREIGN KEY (id_tag) REFERENCES tag (id_tag)
);
