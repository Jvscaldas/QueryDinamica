CREATE DATABASE functionexec
GO
USE functionexec
GO
CREATE TABLE funcionario (
codigo			INT					NOT NULL,
nome			VARCHAR(60)			NOT NULL,
salario			DECIMAL(7, 2)		NOT NULL,
PRIMARY KEY (codigo)
)

CREATE TABLE dependente (
codigo_funcionario		INT					NOT NULL,
nome_dependente			VARCHAR(60)			NOT NULL,
salario_dependente		DECIMAL(7, 2)		NOT NULL,
PRIMARY KEY (codigo_funcionario),
FOREIGN KEY (codigo_funcionario) REFERENCES funcionario (codigo)
)

INSERT INTO funcionario VALUES 
(1, 'Fulano',	1000.00),
(2, 'Beltrano', 2000.00),
(3, 'Ciclano',	3000.00)

SELECT * FROM funcionario

INSERT INTO dependente VALUES
(1, 'Antonio',	100),
(2,	'José',		200),
(3, 'Maria',	300)

SELECT * FROM dependente

-- a) Uma Function que Retorne uma tabela:
--		(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)

CREATE FUNCTION fn_tablefunc()
RETURNS @tabela TABLE (
nome_funcionario			VARCHAR(60),
nome_dependente				VARCHAR(60),
salario_funcionario			DECIMAL(7, 2),
salario_dependente			DECIMAL(7, 2)
)
AS
BEGIN

	INSERT INTO @tabela(nome_funcionario, nome_dependente, salario_funcionario, salario_dependente) 
	SELECT f.nome, d.nome_dependente, f.salario , d.salario_dependente FROM dependente d, funcionario f
	WHERE f.codigo = d.codigo_funcionario

	RETURN
END

SELECT * FROM fn_tablefunc()

-- b) Uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.
CREATE FUNCTION fn_soma()
RETURNS DECIMAL(7, 2)
AS
BEGIN
	DECLARE @somaD		DECIMAL(7, 2),
			@somaF		DECIMAL(7, 2),
			@somaT		DECIMAL(7, 2)

	SET @somaD = (SELECT SUM(salario_dependente) FROM dependente)
	SET @somaF = (SELECT SUM(salario) FROM funcionario)
	SET @somaT = @somaD + @somaF

	RETURN (@somaT)
END

SELECT dbo.fn_soma() AS soma_salario