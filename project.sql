-- =========================================
-- ATIVIDADE 1: SGBDs
-- =========================================
CREATE TABLE SGBD (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    categoria VARCHAR(20) NOT NULL,  -- Relacional, NoSQL, Embarcado
    caso_uso VARCHAR(255),
    licenca VARCHAR(50)               -- Livre ou Pago
);

INSERT INTO SGBD (nome, categoria, caso_uso, licenca) VALUES
('MySQL', 'Relacional', 'Aplicações web e sistemas que necessitam de transações confiáveis', 'Livre'),
('MongoDB', 'NoSQL', 'Aplicações que lidam com grandes volumes de dados não estruturados', 'Livre'),
('SQLite', 'Embarcado', 'Aplicações móveis e pequenos sistemas que precisam de um banco leve', 'Livre');

-- =========================================
-- ATIVIDADE 2: Agenda de Contatos
-- =========================================
CREATE TABLE Contato (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(150),
    aniversario DATE
);

INSERT INTO Contato (nome, telefone, email, endereco, aniversario) VALUES
('João Silva', '(11) 91234-5678', 'joao.silva@email.com', 'Rua das Flores, 123, SP', '1990-05-10');

-- =========================================
-- ATIVIDADE 3 e 4: Clínica Médica
-- =========================================
-- Tabela Medico
CREATE TABLE Medico (
    crm VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- Tabela Paciente
CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_nascimento DATE
);

-- Tabela Consulta
CREATE TABLE Consulta (
    id_consulta INT PRIMARY KEY AUTO_INCREMENT,
    crm_medico VARCHAR(20),
    id_paciente INT,
    data_hora DATETIME,
    observacoes TEXT,
    FOREIGN KEY (crm_medico) REFERENCES Medico(crm),
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

-- Tabela Exame
CREATE TABLE Exame (
    id_exame INT PRIMARY KEY AUTO_INCREMENT,
    id_consulta INT,
    nome_exame VARCHAR(100),
    resultado TEXT,
    data_exame DATE,
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);

-- =========================================
-- Exemplos de inserção de dados para Clínica Médica
-- =========================================
-- Médicos
INSERT INTO Medico (crm, nome, especialidade, telefone, email) VALUES
('12345', 'Dra. Ana Costa', 'Cardiologia', '(11) 99876-5432', 'ana.costa@clinicamed.com'),
('67890', 'Dr. Paulo Lima', 'Dermatologia', '(11) 98765-4321', 'paulo.lima@clinicamed.com');

-- Pacientes
INSERT INTO Paciente (nome, telefone, email, data_nascimento) VALUES
('Carlos Souza', '(11) 91234-1111', 'carlos.souza@email.com', '1985-07-12'),
('Mariana Alves', '(11) 92345-2222', 'mariana.alves@email.com', '1992-03-20');

-- Consultas
INSERT INTO Consulta (crm_medico, id_paciente, data_hora, observacoes) VALUES
('12345', 1, '2025-12-20 10:00:00', 'Consulta de rotina'),
('67890', 2, '2025-12-21 14:30:00', 'Avaliação de alergia');

-- Exames
INSERT INTO Exame (id_consulta, nome_exame, resultado, data_exame) VALUES
(1, 'ECG', 'Normal', '2025-12-20'),
(2, 'Exame de Pele', 'Lesão benigna', '2025-12-21');


/* ===== 
   Clínica Médica (DER + Modelo Lógico)
   ===== */

CREATE TABLE Medico (
    id_medico INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100),
    crm VARCHAR(20) UNIQUE
);

CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(20)
);

CREATE TABLE Consulta (
    id_consulta INT PRIMARY KEY,
    data_consulta DATE NOT NULL,
    horario TIME NOT NULL,
    diagnostico VARCHAR(255),
    id_medico INT NOT NULL,
    id_paciente INT NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

CREATE TABLE Exame (
    id_exame INT PRIMARY KEY,
    tipo_exame VARCHAR(100) NOT NULL,
    resultado VARCHAR(255),
    data_exame DATE,
    id_consulta INT NOT NULL,
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);

/* ===== ATIVIDADE 7
   Normalização até a 3FN
   ===== */

CREATE TABLE Cliente (
    cpf_cliente VARCHAR(14) PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    email_cliente VARCHAR(100)
);

CREATE TABLE Produto (
    cod_produto VARCHAR(10) PRIMARY KEY,
    desc_produto VARCHAR(100) NOT NULL,
    valor_unit DECIMAL(10,2) NOT NULL
);

CREATE TABLE Pedido (
    num_pedido INT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    cpf_cliente VARCHAR(14) NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf_cliente)
);

CREATE TABLE Item_Pedido (
    num_pedido INT,
    cod_produto VARCHAR(10),
    quantidade INT NOT NULL,
    PRIMARY KEY (num_pedido, cod_produto),
    FOREIGN KEY (num_pedido) REFERENCES Pedido(num_pedido),
    FOREIGN KEY (cod_produto) REFERENCES Produto(cod_produto)
);
/* =====================================================
   ATIVIDADE 8 – CRIAÇÃO DO BANCO DE DADOS
===================================================== */
DROP DATABASE IF EXISTS clinica_medica;
CREATE DATABASE clinica_medica;
USE clinica_medica;

/* =====================================================
   ATIVIDADES 9 e 10 – CRIAÇÃO DAS TABELAS COM RESTRIÇÕES
===================================================== */

CREATE TABLE MEDICO (
    id_medico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    CHECK (especialidade IN ('Cardiologia', 'Dermatologia', 'Clínico Geral'))
);

CREATE TABLE PACIENTE (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE CONSULTA (
    id_consulta INT PRIMARY KEY AUTO_INCREMENT,
    data_consulta DATE NOT NULL,
    id_medico INT NOT NULL,
    id_paciente INT NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES MEDICO(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente)
);

CREATE TABLE EXAME (
    id_exame INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(100) NOT NULL,
    data_exame DATE NOT NULL,
    id_consulta INT NOT NULL,
    FOREIGN KEY (id_consulta) REFERENCES CONSULTA(id_consulta)
);

/* =====================================================
   ATIVIDADE 11 – POPULANDO O BANCO
===================================================== */

INSERT INTO MEDICO (nome, especialidade) VALUES
('Dr. João Silva', 'Cardiologia'),
('Dra. Maria Souza', 'Dermatologia'),
('Dr. Carlos Lima', 'Clínico Geral');

INSERT INTO PACIENTE (nome, cpf, data_nascimento, telefone) VALUES
('Ana Paula', '11111111111', '1995-05-10', '11988887777'),
('Bruno Santos', '22222222222', '2002-08-20', '11977776666'),
('Carla Mendes', '33333333333', '1988-12-01', '11966665555'),
('Daniel Rocha', '44444444444', '2005-03-15', '11955554444'),
('Eduarda Lima', '55555555555', '1999-09-30', '11944443333');

INSERT INTO CONSULTA (data_consulta, id_medico, id_paciente) VALUES
('2024-01-10', 1, 1),
('2024-01-15', 2, 2),
('2024-02-01', 3, 3);

/* Remover paciente com ID = 3 */
DELETE FROM PACIENTE
WHERE id_paciente = 3;

/* =====================================================
   ATIVIDADE 12 – UPDATE E SELECTS
===================================================== */

/* UPDATE */
UPDATE PACIENTE
SET telefone = '11999999999'
WHERE id_paciente = 2;

/* SELECTS */
SELECT * FROM PACIENTE;

SELECT nome, especialidade
FROM MEDICO;

SELECT * FROM CONSULTA
WHERE id_consulta = 1;

SELECT * FROM PACIENTE
WHERE data_nascimento > '2000-01-01';

SELECT * FROM MEDICO
WHERE especialidade = 'Cardiologia';

/* =====================================================
   ATIVIDADE 13 – CONSULTAS AGREGADAS
===================================================== */

SELECT COUNT(*) AS total_pacientes
FROM PACIENTE;

SELECT MIN(data_consulta) AS consulta_mais_antiga
FROM CONSULTA;

SELECT AVG(id_consulta) AS media_consultas
FROM CONSULTA;

SELECT nome
FROM PACIENTE
ORDER BY nome;

SELECT id_medico, COUNT(*) AS total_consultas
FROM CONSULTA
GROUP BY id_medico;

/* =====================================================
   ATIVIDADE 14 – JOINS
===================================================== */

/* Paciente e data da consulta */
SELECT p.nome AS paciente, c.data_consulta
FROM PACIENTE p
INNER JOIN CONSULTA c ON p.id_paciente = c.id_paciente;

/* Médico, especialidade e paciente */
SELECT m.nome AS medico, m.especialidade, p.nome AS paciente
FROM CONSULTA c
INNER JOIN MEDICO m ON c.id_medico = m.id_medico
INNER JOIN PACIENTE p ON c.id_paciente = p.id_paciente;

/* Médicos e consultas (incluindo médicos sem consulta) */
SELECT m.nome AS medico, c.data_consulta
FROM MEDICO m
LEFT JOIN CONSULTA c ON m.id_medico = c.id_medico;
