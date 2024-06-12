CREATE TABLE #Results (
    id INT,
    name NVARCHAR(255),
    sub_name NVARCHAR(255),
    sub_id INT,
    sub_level INT,
    colls_count INT
);

WITH RecursiveSubdivisions AS (
    SELECT id, name, parent_id, 0 AS sub_level
    FROM subdivisions
    WHERE id = (SELECT subdivision_id FROM collaborators WHERE id = 710253)
    UNION ALL
    SELECT s.id, s.name, s.parent_id, rs.sub_level + 1
    FROM subdivisions AS s
    INNER JOIN RecursiveSubdivisions AS rs ON s.parent_id = rs.id
),
CollaboratorsCount AS (
    SELECT subdivision_id, COUNT(*) AS colls_count
    FROM collaborators
    GROUP BY subdivision_id
)
INSERT INTO #Results
SELECT c.id, c.name, s.name AS sub_name, c.subdivision_id AS sub_id, rs.sub_level, cc.colls_count
FROM collaborators AS c
INNER JOIN RecursiveSubdivisions AS rs ON c.subdivision_id = rs.id
INNER JOIN CollaboratorsCount AS cc ON c.subdivision_id = cc.subdivision_id
INNER JOIN subdivisions AS s ON c.subdivision_id = s.id
WHERE c.age < 40
AND s.id NOT IN (100055, 100059)
ORDER BY rs.sub_level;

SELECT * FROM #Results;

DROP TABLE #Results;
