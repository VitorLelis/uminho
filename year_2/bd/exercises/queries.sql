-- Consultas marcadas para o dia 09/05/2022
SELECT id, data, Paciente_id AS Paciente, Nutricionista_email AS Nutri FROM mydb.Consulta
    WHERE data = '2022-05-09';

-- Consultas marcadas entre os dias 05/05/2022 e 09/05/2022
SELECT id, data, Paciente_id FROM Consulta
    WHERE data >= '2022-05-05' AND data <= '2022-05-09';

-- Medicoes do tipo "Peso" ou "Altura"
SELECT Paciente_id AS codPac, tipo, valor FROM Medicao
    WHERE  tipo = "Peso" OR tipo = "Altura"
    ORDER BY codPac;

-- Pacientes com "Wayne" no  nome
SELECT id, nome FROM Paciente
    WHERE nome LIKE "%Wayne%"

-- Lista dos Pacientes que não pagaram a consulta
SELECT DISTINCT Paciente.id AS ID, Paciente.nome AS Nome FROM Paciente
    INNER JOIN Consulta ON Paciente.id = Consulta.Paciente_id
    WHERE pago = 0;

-- Atualize "Consultas" para pagar todas as consultas de "Bruce Wayne"
UPDATE Consulta
    SET pago = 1
    WHERE Paciente_id = 1;