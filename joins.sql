-- ============================================
-- SKILL 2: MAP THE COUNTRY CLUB RELATIONSHIPS
-- ============================================

-- 1. Which columns in cd.bookings are foreign keys,
-- and which tables do they point to?

-- cd.bookings.facid is a foreign key that references
-- cd.facilities.facid.

-- cd.bookings.memid is a foreign key that references
-- cd.members.memid.


-- 2. What kind of relationship is there between
-- members and facilities?

-- This is a many-to-many relationship.
-- cd.bookings is the junction table because it connects
-- members to facilities.


-- 3. What kind of relationship is recommendedby?

-- recommendedby is a self-referencing relationship.
-- cd.members.recommendedby points to cd.members.memid.
-- This means one member can recommend multiple members.


-- ============================================
-- SKILL 3: JOINS AND SUBQUERIES
-- ============================================


-- 1. Retrieve the start times of members' bookings

SELECT bks.starttime
FROM cd.bookings bks
JOIN cd.members mems
    ON mems.memid = bks.memid
WHERE mems.firstname = 'David'
  AND mems.surname = 'Farrell';


-- 2. Work out the start times of bookings for tennis courts

SELECT
    bks.starttime,
    facs.name
FROM cd.bookings bks
JOIN cd.facilities facs
    ON bks.facid = facs.facid
WHERE facs.name IN ('Tennis Court 1', 'Tennis Court 2')
  AND bks.starttime >= '2012-09-21'
  AND bks.starttime < '2012-09-22'
ORDER BY bks.starttime;


-- 3. Produce a list of all members who have recommended another member

SELECT DISTINCT
    mems.firstname,
    mems.surname
FROM cd.members mems
JOIN cd.members recs
    ON recs.recommendedby = mems.memid
ORDER BY mems.surname, mems.firstname;


-- 4. Produce a list of all members, along with their recommender

SELECT
    mems.firstname,
    mems.surname,
    recs.firstname AS recommender_firstname,
    recs.surname AS recommender_surname
FROM cd.members mems
LEFT JOIN cd.members recs
    ON recs.memid = mems.recommendedby
ORDER BY mems.surname, mems.firstname;


-- 5. Produce a list of all members who have used a tennis court

SELECT DISTINCT
    mems.firstname,
    mems.surname,
    facs.name AS facility
FROM cd.members mems
JOIN cd.bookings bks
    ON mems.memid = bks.memid
JOIN cd.facilities facs
    ON bks.facid = facs.facid
WHERE facs.name IN ('Tennis Court 1', 'Tennis Court 2')
ORDER BY mems.surname, mems.firstname, facs.name;


-- 6. Produce a list of costly bookings

SELECT
    mems.firstname || ' ' || mems.surname AS member,
    facs.name AS facility,
    CASE
        WHEN bks.memid = 0
            THEN bks.slots * facs.guestcost
        ELSE bks.slots * facs.membercost
    END AS cost
FROM cd.bookings bks
JOIN cd.members mems
    ON bks.memid = mems.memid
JOIN cd.facilities facs
    ON bks.facid = facs.facid
WHERE bks.starttime >= '2012-09-14'
  AND bks.starttime < '2012-09-15'
  AND CASE
        WHEN bks.memid = 0
            THEN bks.slots * facs.guestcost
        ELSE bks.slots * facs.membercost
      END > 30
ORDER BY cost DESC;


-- 7. Produce a list of all members, along with their recommender,
-- using no joins

SELECT
    mems.firstname,
    mems.surname,
    (
        SELECT recs.firstname || ' ' || recs.surname
        FROM cd.members recs
        WHERE recs.memid = mems.recommendedby
    ) AS recommender
FROM cd.members mems
ORDER BY mems.surname, mems.firstname;


-- 8. Produce a list of costly bookings, using a subquery

SELECT
    costly.starttime,
    costly.facility,
    costly.cost
FROM (
    SELECT
        bks.starttime,
        facs.name AS facility,
        CASE
            WHEN bks.memid = 0
                THEN bks.slots * facs.guestcost
            ELSE bks.slots * facs.membercost
        END AS cost
    FROM cd.bookings bks
    JOIN cd.facilities facs
        ON bks.facid = facs.facid
    WHERE bks.starttime >= '2012-09-14'
      AND bks.starttime < '2012-09-15'
) AS costly
WHERE costly.cost > 30
ORDER BY costly.cost DESC;
