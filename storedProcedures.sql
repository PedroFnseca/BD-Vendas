# Exemplo de stored procedure sem parâmetros
/*
delimiter $
create procedure prc_lista_prod()
	begin
		select * from tbl_produto
			where cod_produto in (1, 3, 5, 7);
	end $
    
# Para chamar a stored procedure
call prc_lista_prod();

# Para apagar a stored procedure
drop procedure prc_lista_prod;
*/


# Exemplo com o parametro IN
/*
delimiter $
create procedure prc_prod_param_in (in nome_prod varchar(50))
	begin
		select * from tbl_produto where nome_produto = nome_prod;
	end $
    
# Chamando a procedure
call prc_prod_param_in('arroz');
*/    

# Exemplo com o parametro OUT
/*
delimiter $
create procedure lista_produto_param_out(out total decimal(10, 2))
	begin
		select sum(valor) into total from tbl_produto;
	end $

# Chamanaod a procedure
call prc_prod_param_out(@total);
# Chamando o valor 
select @total;
*/

# Exemplo com o parametro INOUT
/*
delimiter $
create procedure prc_prod_param_inout
					(in codprod int, inout nome_prod char(15),
                     inout valor_prod decimal(10, 2))
	begin
		select nome_produto, valor
        from tbl_produto
        where cod_produto = codprod;
	end $

# Chamando a procedure
call prc_prod_param_inout(10, @nomeprod, @valorprod)
*/


#						EXERCICIOS

use bd_vendas;

# Crie um procedimento armazenado que é passado o código do produto na tabela de
# produtos e um percentual para calcular o acréscimo ao valor desse mesmo produto, o
# retorno deverá ser uma mensagem informando se a operação foi feita de forma correta.
delimiter $
	create procedure prc_acrescimo_prod(in codProd int, in percentual decimal(10, 2))
		begin
			update tbl_produto
				set valor = valor + (valor * percentual / 100)
					 where cod_produto = codProd ;
		end $


# Crie um procedimento armazenado que grave na tabela de log (Exercício d) da
# atividade anterior, no campo tipo de operação, informem “INS_TRIGGER” o registro de
# auditoria;

# OBS, fiz de uma forma generica para reutilização
delimiter $
	create procedure prc_ins_log(in operacao varchar(45) ,in tbl varchar(45))
		begin 
			insert into tbl_log(usuario, dt_log, hora, operacao, tbl)
				value(user(), curdate(), curtime(), operacao, tbl);
		end $
        

# DESAFIO: agora remova a TRIGGER que você criou conforme o exercício anterior - d),
# montando uma nova TRIGGER, só que agora, a mesma deverá chamar a execução do
# procedimento armazenado criado nessa atividade no item b).
drop trigger trg_instCliente;

delimiter $
create trigger trg_instCliente before insert 
	on tbl_pedido
    for each row
		begin
			call prc_ins_log("INS_TRIGGER", "tbl_pedido");
		end $


# Procedure para criação de tabela temporaria 
delimiter $
create procedure prc_cria_tabela_temp()
	begin
		create temporary table if not exists tbl_auxprod(
			aux_prod integer not null,
			aux_desc varchar(20),
			qtde_ajust varchar(10),
			data_hora datetime default now(),
			primary key(aux_prod, data_hora)
		)

	delete from tbl_auxprod;
end $


# Procedure para ajuste de estoque
delimiter $
create procedure prc_ajusta_estoque(in qtde int, out msg char(100))
	begin
		-- Definição de variáveis
		declare p_linha int default 0;
		declare p_codigo int default 0;
		declare p_descri varchar(100);
		declare p_estoque int default 0;
		declare p_status int default 0;

		-- Definição do cursor
		declare meuCursor cursor for
			select cod_produto, nome_produto, estoque_atual from tbl_produto;

		-- Definição da variavel de controle de looping do cursor
		declare continue handler for not found set p_linha = 1;

		-- Abertura do cursor
		open meuCursor;

		-- chamada da procedure para criação da tabela temporaria
		call prc_cria_tabela_temp();

		-- Looping do cursor
		meuLoop: loop
			fetch meuCursor into p_codigo, p_descri, p_estoque;

			-- controle de existir mais registros na tabela
			if p_linha = 1 then
				select count(*) into p_status from tbl_auxprod;	
			
				if p_status > 0 then
					-- seleciono a tabela temporaria
					select * from tbl_auxprod;
					leave meuLoop;
				else
					-- a procedure rodou mas sem nenhum processamento
					set msg = "Nada processado";
					select msg;
					leave meuLoop;
			end if;

			else if p_estoque = qtde then
				-- atualizo o estoque
				update tbl_produto set estoque_atual = qtde + 2
					where cod_produto = p_codigo;

				-- Insere os dados na tabela temporaria
				insert into tbl_auxprod(aux_prod, aux_desc, qtde_ajust)
					values(p_codigo, p_descri, p_estoque + 2)
			end if;

		end loop meuLoop;

		-- Fechamento do cursor
		close meuCursor;
end $


# De acordo com as aulas dadas, realizem as tarefas conforme abaixo:
# 1º - Analisem a procedure que acabamos de fazer e procure melhorar sua
# performance, otimizando-a de acordo com a proposta passada pelo professor;
delimiter $
create procedure prc_cria_tabela_temp()
	begin
		create temporary table if not exists tbl_auxprod(
			aux_prod integer not null,
			aux_desc varchar(20),
			qtde_ajust varchar(10),
			data_hora datetime default now(),
			primary key(aux_prod, data_hora)
		)

	delete from tbl_auxprod;
end $


# Procedure para ajuste de estoque
delimiter $
create procedure prc_ajusta_estoque(in qtde int, out msg char(100))
	begin
		-- Definição de variáveis
		declare p_linha int default 0;
		declare p_codigo int default 0;
		declare p_descri varchar(100);
		declare p_estoque int default 0;
		declare p_status int default 0;

		-- Definição do cursor
	  declare meuCursor cursor for
			select cod_produto, nome_produto, estoque_atual from tbl_produto;

		-- Definição da variavel de controle de looping do cursor
		declare continue handler for not found set p_linha = 1;

		-- Verifica se a quantidade passada é maior que zero
		if qtde <= 0 then
			set msg = "Nada processado";
			select msg;
		else
			-- Abertura do cursor
			open meuCursor;

			-- chamada da procedure para criação da tabela temporaria
			call prc_cria_tabela_temp();

			-- Looping do cursor
			meuLoop: loop
				fetch meuCursor into p_codigo, p_descri, p_estoque;

				-- controle de existir mais registros na tabela
				if p_linha = 1 then
					select count(*) into p_status from tbl_auxprod;	
				
					if p_status > 0 then
						-- seleciono a tabela temporaria
						select * from tbl_auxprod;
						leave meuLoop;
					else
						-- a procedure rodou mas sem nenhum processamento
						set msg = "Nada processado";
						select msg;
						leave meuLoop;
					end if;

				else if p_estoque = qtde then
					-- atualizo o estoque
					update tbl_produto set estoque_atual = qtde + 2
						where cod_produto = p_codigo;

					-- Insere os dados na tabela temporaria
					insert into tbl_auxprod(aux_prod, aux_desc, qtde_ajust)
						values(p_codigo, p_descri, p_estoque + 2);
				end if;
				end if;
			end loop meuLoop;
		end if;

			-- Fechamento do cursor
			close meuCursor;
end $


# Modifique a procedure que usamos em cursores de forma que ao passar um
# parâmetro (percentual de aumento), a tabela de produto tenha o valor do mesmo reajustado,
# mas somente para os produtos em que o valor seja inferior a R$ 10,00.
delimiter $
create procedure prc_reajuste_percentual_prod(in percentual decimal(10, 2), out msg char(100))
begin
	-- Definição de variáveis
	declare p_linha int default 0;
	declare p_codigo int default 0;
	declare p_descri varchar(100);
	declare p_valor decimal(10, 2) default 0;
	declare p_status int default 0;

	-- Definição do cursor
	declare meuCursor cursor for
		select cod_produto, nome_produto, valor from tbl_produto;

	-- Definição da variavel de controle de looping do cursor
	declare continue handler for not found set p_linha = 1;

	-- Abertura do cursor
	open meuCursor;

	-- chamada da procedure para criação da tabela temporaria
	call prc_cria_tabela_temp();

	-- Looping do cursor
	meuLoop: loop
		fetch meuCursor into p_codigo, p_descri, p_valor;

		-- controle de existir mais registros na tabela
		if p_linha = 1 then
			select count(*) into p_status from tbl_auxprod;	
			
			if p_status > 0 then
				-- seleciono a tabela temporaria
				select * from tbl_auxprod;
				leave meuLoop;
			else
				-- a procedure rodou mas sem nenhum processamento
				set msg = "Nada processado";
				select msg;
				leave meuLoop;
			end if;

		else if p_valor < 10 then
			-- atualizo o estoque com o percentual informado
			update tbl_produto set valor = p_valor + (p_valor * percentual / 100)
				where cod_produto = p_codigo;

			-- Insere os dados na tabela temporaria com o percentual informado
			insert into tbl_auxprod(aux_prod, aux_desc, qtde_ajust)
				values(p_codigo, p_descri, p_valor + (p_valor * percentual / 100));
		end if;
		end if;

	end loop meuLoop;

	-- Fechamento do cursor
	close meuCursor;
end $