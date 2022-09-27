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
