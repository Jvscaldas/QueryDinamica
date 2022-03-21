CREATE DATABASE querydinamica
GO
USE querydinamica

CREATE TABLE produto(
codigo	INT,
nome	VARCHAR(100),
valor	DECIMAL(7,2)
PRIMARY KEY (codigo)
)

SELECT * FROM produto

INSERT INTO produto VALUES (1, 'caneta', 10.99);
INSERT INTO produto VALUES (2, 'lapis', 2.99);
INSERT INTO produto VALUES (3, 'caderno', 1.99);
INSERT INTO produto VALUES (4, 'cola', 10.00);
INSERT INTO produto VALUES (5, 'tesoura', 5.00);
INSERT INTO produto VALUES (6, 'estojo', 9.00);

CREATE TABLE entrada(
codigo_transacao	INT NOT NULL,
codigo_produto		INT NOT NULL,
quantidade			INT NOT NULL,
valor_total			DECIMAL(7,2),
PRIMARY KEY (codigo_transacao),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)

CREATE TABLE saida(
codigo_transacao	INT NOT NULL,
codigo_produto		INT NOT NULL,
quantidade			INT NOT NULL,
valor_total			DECIMAL(7,2),
PRIMARY KEY (codigo_transacao),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)

CREATE PROCEDURE sp_registro(
	@codigo_transacao	INT, 
	@codigo_produto		INT,
	@quantidade			INT, 
	@saida				VARCHAR(30) OUTPUT 
)
AS
	DECLARE	@cod			CHAR(1),
			@query			VARCHAR(MAX),
			@tabela			VARCHAR(10),
			@erro			VARCHAR(MAX),
			@valor_total	DECIMAL(7, 2),
			@valor_produto	DECIMAL(7, 2)
 
	
	BEGIN TRY
		IF (@cod = 'e')
		BEGIN
			SET @tabela = 'entrada'
		END
	END TRY
	BEGIN CATCH
		IF (@cod = 's')
		BEGIN
			SET @tabela = 'saida'
		END
	END CATCH
 
	SET @query = 'INSERT INTO '+@tabela+' VALUES ('+CAST(@codigo_transacao AS VARCHAR(5))
					+','''+CAST(@codigo_produto AS VARCHAR(5))+','''+CAST(@quantidade AS VARCHAR(5))+','''+CAST(@valor_total AS VARCHAR(5))+ ')'
	PRINT @query
	BEGIN TRY
		EXEC (@query)
		SET @saida = UPPER(@tabela)+' inserido com sucesso'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('Id duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro no armazenamento do produto', 16, 1)
		END
	END CATCH




DECLARE @out1 VARCHAR(30)
EXEC sp_registro 1, 1, 10,  @out1 OUTPUT
PRINT @out1
	
SELECT p.codigo, p.nome, p.valor, e.codigo_transacao, e.quantidade, e.valor_total
FROM produto p, entrada e
WHERE p.codigo = e.codigo_produto

select * from entrada
SELECT * FROM produto
select * from saida