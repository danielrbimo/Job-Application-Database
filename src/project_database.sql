drop database job;
create database if not exists job;
use job;

-- Vocational School

drop table if exists voc_school;
create table voc_school (
	voc_school_id int primary key auto_increment, 
    voc_school_name varchar(150) not null,
    voc_school_specialty varchar(150) not null,
    voc_school_quality enum('poor', 'decent', 'great') not null);
    
    truncate voc_school;
    insert into voc_school values
    (1, 'School of Agriculture', 'agriculture', 'poor'),
    (2, 'School of Tourism & Trade', 'tourism and trade', 'great'),
    (3, 'School of Manufacturing', 'manufacturing', 'poor'),
    (4, 'School of Construction', 'construction', 'poor');
    
-- Profile

drop table if exists profile;
create table profile (
	profile_id int(30) primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    sex enum('male', 'female') not null,
    is_employed tinyint not null,
    province varchar(50) not null,
    voc_school_id int default null,
    CONSTRAINT fk_profile_school FOREIGN KEY (voc_school_id) REFERENCES voc_school (voc_school_id));
	
    truncate profile;
    insert into profile(profile_id, first_name, last_name, sex, is_employed, province, voc_school_id) values
    (11, "Adit", "Mulyadi", "male", false, 'East Java', 4),
    (12, "Naditya", "Dinka", "female", true, 'East Java', 3),
    (13, "Modrick", "Joesoef", "male", true, 'East Java', 1),
    (14, "Ardian", "Sukamdani", "male", true, 'East Java', 1),
    (15, "Radja", "Nasution", "male", true, 'East Java', 1),
    (16, "Allegra", "Sudarto", "female", false, 'West Java', 1),
    (17, "Raina", "Ernawan", "female", false, 'West Java', 2),
    (18, "Aiman", "Hadi", "male", false, 'West Java', 1),
    (19, "Alfreno", "Ramadhan", "male", false, 'West Java', 1),
    (20, "Amyra", "Uno", "female", true, 'West Java', 2),
    (21, 'Abi', 'Herianto', 'male', true, 'Central Java', 2),
    (22, 'Ado', 'Herianto', 'male', true, 'Central Java', 2),
    (23, 'Fauzan', 'Bennyman', 'male', false, 'Central Java', 3),
    (24, 'Iwan', 'Indraprasto', 'male', true, 'Central Java', 3),
    (25, 'Tisa', 'Umar', 'female', false, 'DKI Jakarta', 2),
    (26, 'Emmanuel', 'Ernawan', 'male', true, 'North Sumatra', 4),
    (27, 'Daniel', 'Hantoro', 'male', false, 'North Sumatra', 3),
    (28, 'Ghani', 'Natakusuma', 'male', true, 'South Sulawesi', 1),
    (29, 'Jonathan', 'Anthony', 'male', false, 'Riau', 1),
    (30, 'Edho', 'Putra', 'male', false, 'West Kalimantan', 1);
-- Company

drop table if exists company;
create table company (
	company_id int(115) primary key,
    company_name varchar(50) not null,
    industry varchar(150) not null);
    
    truncate company;
    insert into company values
    (110, "Maspion Group", "manufacturing"),
    (111, "Intrepid Travel", "tourism"),
    (112, "Wijaya Karya", "construction"),
    (113, "HM Sampoerna", "agriculture");
-- Employer Profile

drop table if exists employer_profile;
create table employer_profile (
	employer_profile_id int(106) primary key,
    job_title varchar(50) not null,
    company_id int default null,
	CONSTRAINT fk_employer_profile_company FOREIGN KEY (company_id) REFERENCES company (company_id));
	
    truncate employer_profile;
    insert into employer_profile values
    (101, "Head of HR", 110),
    (102, "Staffing Manager", 111),
    (103, "Development Manager", 112),
    (104, "Safety Manager", 113),
    (105, "Freelance manager", null);
    
-- Job posting
drop table if exists job_posting;
create table job_posting (
	job_posting_id int primary key,
    company_id int default null,
    employer_profile_id int not null,
    position varchar(50) not null,
    skill_level enum('poor', 'decent', 'great') not null,
    wages int not null,
    province varchar(100) not null,
    address varchar(250) not null,
    no_positions_open int not null,
    timestamp DATETIME not null,
    job_posting_status tinyint not null);
    
    truncate job_posting;
    
    insert into job_posting values
    (1, 110, 101, 'Machinist', 'decent', 2000, 'Central Java', 'Jl. Diponegoro 1', 1, now(), 1),
    (2, 110, 101, 'Assembler', 'poor', 500, 'Central Java', 'Jl. Diponegoro 1', 3, now(), 1),
    (3, 110, 101, 'Technician', 'great', 4000, 'East Java', 'Jl. Pancasila 5', 0, now(), 0),
    (4, 111, 102, 'Travel Agent', 'great', 1000, 'DKI Jakarta', 'Jl. Sudirman 2', 0, now(), 0),
    (5, 111, 102, 'Tour Guide', 'great', 1000, 'Bali', 'Jl. Seminyak 20', 1, now(), 1),
    (6, 112, 103, 'Site Supervisor', 'great', 4000, 'East Java', 'Jl. Merdeka 17', 1, now(), 1),
    (7, 112, 103, 'Construction Manager', 'decent', 2000, 'North Sumatra', 'Jl. Kartini 21', 2, now(), 1),
    (8, 113, 104, 'Quality Control', 'decent', 1000, 'West Java', 'Jl. Pangeran 55', 1, now(), 1),
    (9, 113, 104, 'Farm Manager', 'decent', 1000, 'South Sulawesi', 'Jl. Selatan 1', 0, now(), 0),
    (10, 113, 104, 'Plantation Manager', 'decent', 1000, 'Riau', 'Jl. Merantau 99', 1, now(), 1),
    (11, 113, 104, 'Mill Assitant', 'poor', 500, 'East Java', 'Jl. Perkebunan 7', 0, now(), 0);
    
-- acceptance
drop table if exists acceptance;
create table acceptance (
	profile_id int not null,
    job_posting_id int not null,
    status tinyint default null,
    constraint fk_profile_job_posting foreign key (profile_id) references profile (profile_id),
    constraint fk_job_posting_profile foreign key (job_posting_id) references job_posting (job_posting_id));
    
    truncate acceptance;
    insert into acceptance values
    (12, 3, true),
    (13, 11, true),
    (14, 11, true),
    (15, 11, true),
    (20, 5, true),
    (21, 4, true),
    (22, 4, true),
    (23, 1, false),
    (24, 1, true),
    (25, 4, false),
    (26, 7, true),
    (28, 9, true),
    (29, 10, null);
    