/*
Crie uma View que mostre o valor e o tipo da Medicao juntos com 
os nomes, email e datas de nascimentos de todos os Pacientes do Doutor "Thomas Wayne
*/

CREATE VIEW medicoes_pacientes_DrThomas AS
    SELECT Paciente.nome AS Nome, Paciente.email AS Email,
        Paciente.data_nascimento AS DoB, 
        Medicao.valor AS Valor, Medicao.tipo AS Tipo FROM Paciente
    INNER JOIN Medicao ON Paciente.id = Medicao.Paciente_id
    WHERE Paciente.Nutricionista_email = 
        (SELECT email FROM Nutricionista
            WHERE nome = 'Thomas Wayne')