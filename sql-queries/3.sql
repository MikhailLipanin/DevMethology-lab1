SELECT s.id, s.name, sc.name AS CategoryName, s.rating
FROM souvenirs s
         JOIN souvenirscategories sc ON s.idcategory = sc.id
ORDER BY s.rating ASC;
