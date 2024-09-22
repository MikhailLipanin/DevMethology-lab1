SELECT sp.id, sp.data, ps.name AS Status, p.name AS ProviderName
FROM souvenirprocurements sp
         JOIN providers p ON sp.idprovider = p.id
         JOIN procurementstatuses ps ON sp.idstatus = ps.id
WHERE sp.data BETWEEN '2010-01-01' AND '2024-12-31'
ORDER BY ps.name ASC;
