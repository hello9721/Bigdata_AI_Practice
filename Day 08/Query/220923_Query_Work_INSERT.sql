USE WORK;

SELECT * FROM shopuser;

DESC shopuser;

INSERT INTO shopuser VALUES ( 'A1', 'Scat', 25 );
INSERT INTO shopuser VALUES ( 'A2', 'Marie', 22 );
INSERT INTO shopuser VALUES ( 'A3', 'Katy', 24 );


SELECT * FROM shopproduct;

DESC shopproduct;

INSERT INTO shopproduct VALUES ( 101, '냉장고', 1000000 );
INSERT INTO shopproduct VALUES ( 102, '세탁기', 550000 );
INSERT INTO shopproduct VALUES ( 103, 'HDTV', 1200000 );
INSERT INTO shopproduct VALUES ( 104, '청소기', 200000 );


SELECT * FROM shopsale;

DESC shopsale;

INSERT INTO shopsale VALUES ( 'A1', 103, 4 );
INSERT INTO shopsale VALUES ( 'A3', 101, 1 );
INSERT INTO shopsale VALUES ( 'A3', 104, 2 );
INSERT INTO shopsale VALUES ( 'A2', 101, 5 );
INSERT INTO shopsale VALUES ( 'A1', 102, 3 );


