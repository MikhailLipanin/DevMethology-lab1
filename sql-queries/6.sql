WITH RECURSIVE CategoryHierarchy AS (SELECT id, name, idparent
                                     FROM souvenirscategories
                                     WHERE id = 2976
                                     UNION
                                     SELECT sc.id, sc.name, sc.idparent
                                     FROM souvenirscategories sc
                                              JOIN CategoryHierarchy ch ON sc.idparent = ch.id)
SELECT *
FROM CategoryHierarchy;
