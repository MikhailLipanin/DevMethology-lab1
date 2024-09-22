SELECT s.id, s.name, sm.name AS material, s.price
FROM souvenirs s
         JOIN souvenirmaterials sm ON s.idmaterial = sm.id
WHERE sm.name = 'полиэстер';
