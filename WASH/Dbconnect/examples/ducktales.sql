

CREATE TABLE persons (
    anrede character varying(5),
    given_name character varying(20),
    sur_name character varying(20),
    email character varying(50),
    notes text,
    PRIMARY KEY (given_name, sur_name)
);



INSERT INTO persons VALUES ('Herr', 'Donald', 'Duck', 'dduck@entenhausen.info', 'Pechvogel');
INSERT INTO persons VALUES ('Herr','Dagobert','Duck', 'geizgragen@entenhausen.de','Reich und Geizig');
INSERT INTO persons VALUES ('Frau','Dasy','Duck','dasy@duck.de','Wird von Donald und Gustav verehrt');
INSERT INTO persons VALUES ('Herr','Gustaf','Gans','gluecklich@erfolgreich.com','zufrieden, Rivale von Donald'); 