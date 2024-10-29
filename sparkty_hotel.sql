CREATE DATABASE sparky_hotel_db;
USE sparky_hotel_db;

--1
CREATE TABLE user_data (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    password VARCHAR(50),
	telp_num VARCHAR(15),
	role VARCHAR(10),
    picture VARCHAR(200),
    email VARCHAR(50)
);
INSERT INTO user_data VALUES (1,'ray','12345','081326458686','user','IMG_20230417_195506.jpg','rayanthonylim@gmail.com');
INSERT INTO user_data VALUES (2,'diaz','67890','089475687932','user','IMG_20786435_475698.jpg','christopherabidiaz@gmail.com');
INSERT INTO user_data VALUES (3,'edmund','24564','081587987324','user','IMG_57694038_254976.jpg','edmunddaniel@gmail.com');
INSERT INTO user_data VALUES (4,'nic','68799','081698235434','user','IMG_68724312_123789.jpg','nicholasalven@gmail.com');
INSERT INTO user_data VALUES (5,'francesco','57694','081453242424','user','IMG_46512378_176980.jpg','francescotony@gmail.com');
SELECT * FROM user_data

DROP TABLE user_data


--2
CREATE TABLE wedding_type (
    wedding_type_id INT PRIMARY KEY,
    type_name VARCHAR(100)
);
INSERT INTO wedding_type VALUES (35,'Simple Package');
INSERT INTO wedding_type VALUES (45,'regular Package');
INSERT INTO wedding_type VALUES (67,'Premium Package');
INSERT INTO wedding_type VALUES (70,'Royal Package');
INSERT INTO wedding_type VALUES (78,'Special Package');
SELECT * FROM wedding_type
DROP TABLE wedding_type

--3
CREATE TABLE room_type (
    room_type_id INT PRIMARY KEY,
    type_name VARCHAR(100)
);
INSERT INTO room_type VALUES (20,'Standard Room');
INSERT INTO room_type VALUES (24,'Superior Room');
INSERT INTO room_type VALUES (32,'Deluxe Room');
INSERT INTO room_type VALUES (47,'Single Room');
INSERT INTO room_type VALUES (53,'Twin Room');
INSERT INTO room_type VALUES (56,'Suite Room');
INSERT INTO room_type VALUES (58,'Presidential Room suite');
INSERT INTO room_type VALUES (64,'Connecting Room');
SELECT * FROM room_type
DROP TABLE room_type

--4
CREATE TABLE meeting_room_type (
    meeting_type_id INT PRIMARY KEY,
    type_name VARCHAR(100)
);
INSERT INTO meeting_room_type VALUES (11,'U-shape room');
INSERT INTO meeting_room_type VALUES (17,'Boardroom');
INSERT INTO meeting_room_type VALUES (21,'Classroom');
INSERT INTO meeting_room_type VALUES (29,'teater');
INSERT INTO meeting_room_type VALUES (31,'Banquet');
INSERT INTO meeting_room_type VALUES (33,'Hollow Shape room');
SELECT * FROM meeting_room_type
DROP TABLE meeting_room_type

--5 
CREATE TABLE reservation (
	reservation_id INT PRIMARY KEY,
	user_id INT
	CONSTRAINT FK_reservation_user_id REFERENCES user_data(user_id),
	start_date date,
	end_date date,
	reserv_created time,
	reserv_updated time,
	discount_percent DECIMAL (5,2),
	total_price DECIMAL (10,2)
);
SELECT ud.user_id, ud.name, ud.email, ud.telp_num, r.reservation_id, sr.room_name, sr.description, mro.package, mro.description, we.package, we.description, rt.room_type_id, mrt.meeting_type_id, wt.wedding_type_id FROM reservation r
JOIN room_reserved rr ON r.reservation_id = rr.reservation_id
JOIN suite_room sr ON rr.room_id = sr.room_id
JOIN room_type rt ON rt.room_type_id = sr.room_type_id
JOIN meeting_reserved mr ON mr.reservation_id = r.reservation_id
JOIN meeting_room mro ON mr.meeting_id = mro.meeting_id
JOIN meeting_room_type mrt ON mro.meeting_type_id = mrt.meeting_type_id
JOIN wedding_reserved wr ON r.reservation_id = wr.reservation_id
JOIN wedding_event we ON wr.wedding_id = we.wedding_id
JOIN wedding_type wt ON we.wedding_type_id = wt.wedding_type_id
JOIN user_data ud ON r.user_id = ud.user_id
SELECT * FROM meeting_room


SELECT * FROM reservation
INSERT INTO reservation VALUES (7,1,'2023-06-01','2023-06-02','12:34:56','11:56:32',0.05,350000);
INSERT INTO reservation VALUES (14,2,'2023-05-11','2023-05-13','09:25:45','14:55:21',0.07,500000);
INSERT INTO reservation VALUES (16,3,'2023-05-16','2023-05-19','08:56:20','12:34:12',0.07,700000);
INSERT INTO reservation VALUES (26,4,'2023-05-21','2023-05-22','12:21:23','13:30:31',0.05,1000000);
INSERT INTO reservation VALUES (30,5,'2023-06-03','2023-06-06','15:38:47','07:50:12',0.07,2000000);

DROP TABLE reservation

--6
CREATE TABLE wedding_event (
    wedding_id INT PRIMARY KEY,
    package VARCHAR(100),
    description TEXT,
    wedding_type_id INT
	CONSTRAINT FK_wedding_event_wedding_type_id REFERENCES wedding_type(wedding_type_id),
    current_price DECIMAL(10,2)
);

INSERT INTO wedding_event VALUES (12, 'Simple Package', 'standard', 35, 12000000.00);
INSERT INTO wedding_event VALUES (13, 'Regular Package', 'high quality', 45, 5000000.00);
INSERT INTO wedding_event VALUES (15, 'Premium Package', 'full privilege', 67, 10000000.00);
INSERT INTO wedding_event VALUES (18, 'Royal Package', 'free allfood', 70, 20000000.00);
INSERT INTO wedding_event VALUES (19, 'Special Package', 'all item', 78, 40000000.00);

DROP TABLE wedding_event
SELECT * FROM wedding_event

--7
CREATE TABLE wedding_reserved (
    id INT PRIMARY KEY,
    reservation_id INT
	CONSTRAINT FK_wedding_reserved_reservation_id REFERENCES reservation(reservation_id),
    wedding_id INT
	CONSTRAINT FK_wedding_reserved_wedding_id REFERENCES wedding_event(wedding_id),
    price DECIMAL(10,2)
);
INSERT INTO wedding_reserved VALUES (81,7,12,12000000.00);
INSERT INTO wedding_reserved VALUES (82,14,13,5000000.00);
INSERT INTO wedding_reserved VALUES (83,16,15,10000000.00);
INSERT INTO wedding_reserved VALUES (84,26,18,20000000.00);
INSERT INTO wedding_reserved VALUES (85,30,19,40000000.00);
SELECT * FROM wedding_reserved
DROP TABLE wedding_reserved

--8
CREATE TABLE reservation_status (
    reservation_id INT
	CONSTRAINT FK_reservation_status_reservation_id REFERENCES reservation(reservation_id),
    status VARCHAR (50),
	--PRIMARY KEY (reservation_id)
);

INSERT INTO reservation_status VALUES (7,'confirm');
INSERT INTO reservation_status VALUES (14,'pending');
INSERT INTO reservation_status VALUES (16,'confirm');
INSERT INTO reservation_status VALUES (26,'confirm');
INSERT INTO reservation_status VALUES (30,'confirm');

SELECT * FROM reservation_status
DROP TABLE reservation_status


--9
CREATE TABLE invoice_user (
    user_id INT
	CONSTRAINT FK_invoice_user_user_id REFERENCES user_data(user_id),
    guest_id INT PRIMARY KEY,
    reservation_id INT
	CONSTRAINT FK_invoice_user_reservation_id REFERENCES reservation(reservation_id),
    invoice_amount DECIMAL(10,2),
    inv_issued TIME,
    inv_paid TIME,
    inv_cancelled TIME,
);
INSERT INTO invoice_user VALUES (1,71,7,350000,'12:34:56','11:56:32','21:45:30');
INSERT INTO invoice_user VALUES (2,72,14,500000,'09:25:45','14:55:21','12:34:45');
INSERT INTO invoice_user VALUES (3,73,16,700000,'08:56:20','12:34:12','20:32:12');
INSERT INTO invoice_user VALUES (4,74,26,1000000,'12:21:23','13:30:31','10:23:39');
INSERT INTO invoice_user VALUES (5,75,30,2000000,'15:38:47','07:50:12','13:24:21');
select * from invoice_user
DROP TABLE invoice_user

--10
CREATE TABLE meeting_room (
    meeting_id INT PRIMARY KEY,
    package VARCHAR(100),
    description TEXT,
    meeting_type_id INT
	CONSTRAINT FK_meeting_room_meeting_type_id REFERENCES meeting_room_type(meeting_type_id),
    current_price DECIMAL(10,2)
);
INSERT INTO meeting_room VALUES (76,'U-shape room','capacity: 50',11,500000);
INSERT INTO meeting_room VALUES (77,'Boardroom','capacity: 120',17,1000000);
INSERT INTO meeting_room VALUES (79,'Classroom','capacity: 150',21,2000000);
INSERT INTO meeting_room VALUES (80,'teater','capacity: 240',29,3000000);
INSERT INTO meeting_room VALUES (86,'Hollow Shape room','capacity: 500',33,4000000);
SELECT * FROM meeting_room
DROP TABLE meeting_room	

--11
CREATE TABLE meeting_reserved (
    id INT PRIMARY KEY,
    reservation_id INT
	CONSTRAINT FK_meeting_reserved_reservation_id REFERENCES reservation(reservation_id),
    meeting_id INT
	CONSTRAINT FK_meeting_reserved_meeting_id REFERENCES meeting_room(meeting_id),
    price DECIMAL(10,2)
);
INSERT INTO meeting_reserved VALUES (87,7,76,500000);
INSERT INTO meeting_reserved VALUES (88,14,77,1000000);
INSERT INTO meeting_reserved VALUES (89,16,79,2000000);
INSERT INTO meeting_reserved VALUES (90,26,80,3000000);
INSERT INTO meeting_reserved VALUES (91,30,86,4000000);

SELECT * FROM meeting_reserved
DROP TABLE meeting_reserved

--12
CREATE TABLE suite_room (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(100),
    description TEXT,
    room_type_id INT
	CONSTRAINT FK_suite_room_room_type_id REFERENCES room_type(room_type_id),
    current_price DECIMAL(10,2)
);

INSERT INTO suite_room VALUES (41,'Superior Room','mountain view',24,150000);
INSERT INTO suite_room VALUES (42,'Deluxe Room','high quality room',32,300000);
INSERT INTO suite_room VALUES (43,'Single Room','bathtub',47,450000);
INSERT INTO suite_room VALUES (44,'Twin Room','double bed',53,600000);
INSERT INTO suite_room VALUES (46,'Suite Room','premium room',56,750000);

SELECT * FROM suite_room
DROP TABLE suite_room

--13
CREATE TABLE room_reserved (
    id INT PRIMARY KEY,
    reservation_id INT
	CONSTRAINT FK_room_reserved_reservation_id REFERENCES reservation(reservation_id),
    room_id INT
	CONSTRAINT FK_room_reserved_room_id REFERENCES suite_room(room_id),
    price DECIMAL(10,2)
);

INSERT INTO room_reserved VALUES (47,7,41,150000)
INSERT INTO room_reserved VALUES (48,14,42,300000)
INSERT INTO room_reserved VALUES (49,16,43,450000)
INSERT INTO room_reserved VALUES (50,26,44,600000)
INSERT INTO room_reserved VALUES (51,30,46,750000)

SELECT * FROM room_reserved

DROP TABLE room_reserved


--view one (Ray) room
CREATE VIEW reservation_summary AS 
SELECT u.name, r.start_date, r.end_date,sr.room_name,CONVERT(varchar(max), 
sr.description) AS room_description, SUM(rr.price) AS total_price,COUNT(*) AS total_rooms
FROM user_data u
JOIN reservation r ON u.user_id = r.user_id
JOIN room_reserved rr ON r.reservation_id = rr.reservation_id
JOIN suite_room sr ON rr.room_id = sr.room_id
GROUP BY u.name, r.start_date, r.end_date,sr.room_name, CONVERT(varchar(max), sr.description);

select * from reservation_summary


DROP VIEW reservation_summary

--view two (diaz)
CREATE VIEW weddingReservation AS
SELECT u.user_id ,r.reservation_id, u.name AS user_name, we.package, wr.price,we.description, rs.status
FROM reservation r
JOIN wedding_reserved wr ON r.reservation_id = wr.reservation_id
JOIN wedding_event we ON wr.wedding_id = we.wedding_id
JOIN reservation_status rs ON r.reservation_id = rs.reservation_id
JOIN user_data u ON r.user_id = u.user_id;

select * from weddingReservation

--view three (alven)

CREATE VIEW meeting_invoice_details AS
SELECT i.guest_id, u.user_id, u.name AS guest_name, SUM(CAST(i.invoice_amount AS DECIMAL(10,2))) AS total_invoice_amount, 
m.package, CAST(m.description AS VARCHAR(MAX)) AS room_description
FROM invoice_user i
JOIN user_data u ON i.user_id = u.user_id
JOIN reservation r ON i.reservation_id = r.reservation_id
JOIN meeting_reserved mr ON r.reservation_id = mr.reservation_id
JOIN meeting_room m ON mr.meeting_id = m.meeting_id
GROUP BY i.guest_id, u.user_id, u.name, m.package, CAST(m.description AS VARCHAR(MAX));






--view fourth (edmund)
CREATE VIEW reservation_details AS
SELECT r.reservation_id, u.name AS user_name, wt.type_name AS wedding_type, rt.type_name AS room_type, SUM(rr.price) AS total_price
FROM reservation r
JOIN user_data u ON r.user_id = u.user_id
JOIN wedding_reserved wr ON r.reservation_id = wr.reservation_id
JOIN wedding_event we ON wr.wedding_id = we.wedding_id
JOIN room_reserved rr ON r.reservation_id = rr.reservation_id
JOIN suite_room sr ON rr.room_id = sr.room_id
JOIN room_type rt ON sr.room_type_id = rt.room_type_id
JOIN wedding_type wt ON we.wedding_type_id = wt.wedding_type_id
GROUP BY r.reservation_id, u.name, wt.type_name, rt.type_name;


--view kelima (francesco) bole ini
CREATE VIEW invoice_summary AS
SELECT i.guest_id, u.name AS user_name, r.reservation_id, SUM(i.invoice_amount) AS total_invoice_amount
FROM invoice_user i
JOIN user_data u ON i.user_id = u.user_id
JOIN reservation r ON i.reservation_id = r.reservation_id
JOIN meeting_reserved mr ON r.reservation_id = mr.reservation_id
GROUP BY i.guest_id, u.name, r.reservation_id;

SELECT invoice_amount, guest_id FROM invoice_user

SELECT meeting_type_id, type_name FROM meeting_room_type

SELECT room_id, rt.room_type_id FROM suite_room sr
JOIN room_type rt ON rt.room_type_id = sr.room_type_id


SELECT mr.id, mr.reservation_id, mr.meeting_id, mr.price FROM meeting_reserved mr
JOIN meeting_room mro ON mr.meeting_id = mro.meeting_id


SELECT FROM reservation

SELECT guest_id, user_id FROM invoice_user



















