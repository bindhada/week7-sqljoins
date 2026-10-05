-- ============================================
-- RESET TABLES
-- ============================================

DROP TABLE IF EXISTS student_courses;
DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS users;

-- ============================================
-- SKILL 1: RELATIONSHIPS
-- ============================================

-- 1. ONE-TO-ONE RELATIONSHIP
-- One user can have one profile.
-- profiles.user_id is UNIQUE, so the same user
-- cannot have multiple profiles.

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL
);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    bio TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert some users
INSERT INTO users (username)
VALUES
    ('alice'),
    ('bob'),
    ('charlie');

-- Insert one profile for each user
INSERT INTO profiles (user_id, bio)
VALUES
    (1, 'I like programming.'),
    (2, 'I enjoy playing football.'),
    (3, 'I love music.');

-- JOIN users and profiles
SELECT users.username, profiles.bio
FROM users
JOIN profiles ON users.id = profiles.user_id;

-- ============================================
-- 2. ONE-TO-MANY RELATIONSHIP
-- One author can have many books.
-- Each book belongs to one author.
-- ============================================

CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INTEGER NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

-- Insert some authors
INSERT INTO authors (name)
VALUES
    ('George Orwell'),
    ('J.K. Rowling'),
    ('J.R.R. Tolkien');

-- Insert some books
INSERT INTO books (title, author_id)
VALUES
    ('1984', 1),
    ('Animal Farm', 1),
    ('Harry Potter and the Philosopher''s Stone', 2),
    ('The Hobbit', 3);

-- JOIN authors and books
SELECT authors.name, books.title
FROM authors
JOIN books ON authors.id = books.author_id;

-- ============================================
-- 3. MANY-TO-MANY RELATIONSHIP
-- A student can take many courses.
-- A course can have many students.
-- student_courses is the junction table.
-- ============================================

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE student_courses (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Insert students
INSERT INTO students (name)
VALUES
    ('Alice'),
    ('Bob'),
    ('Charlie');

-- Insert courses
INSERT INTO courses (name)
VALUES
    ('SQL'),
    ('JavaScript'),
    ('Python');

-- Connect students to courses
INSERT INTO student_courses (student_id, course_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 3),
    (3, 2),
    (3, 3);

-- JOIN students, student_courses and courses
SELECT students.name AS student, courses.name AS course
FROM students
JOIN student_courses
    ON students.id = student_courses.student_id
JOIN courses
    ON student_courses.course_id = courses.id;

-- ============================================
-- 4. TRY TO BREAK IT
-- ============================================

-- Test 1: Try to insert a book with an author_id
-- that does not exist.
-- This fails because of the FOREIGN KEY constraint.

-- INSERT INTO books (title, author_id)
-- VALUES ('Fake Book', 999);

-- PostgreSQL error:
-- violates foreign key constraint
-- because author_id 999 does not exist in authors.


-- Test 2: Try to add the same student to the
-- same course twice.
-- Student 1 is already enrolled in course 1,
-- so this fails because of the composite PRIMARY KEY.

-- INSERT INTO student_courses (student_id, course_id)
-- VALUES (1, 1);

-- PostgreSQL error:
-- duplicate key value violates unique constraint
-- because (student_id, course_id) must be unique.
