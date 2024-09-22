SELECT DISTINCT p.name AS ProviderName
FROM providers p
         JOIN souvenirprocurements sp ON p.id = sp.idprovider
         JOIN procurementsouvenirs ps ON sp.id = ps.idprocurement
         JOIN souvenirs s ON ps.idsouvenir = s.ID
         JOIN souvenirscategories sc ON s.idcategory = sc.id
WHERE sc.name = 'Наборы для виски';
