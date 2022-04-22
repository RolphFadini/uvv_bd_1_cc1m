 mysql -u root -p
 123456

 create user 'rolph'@'localhost' identified by '123456';
 grant all on uvv.* to 'rolph'@'localhost';

 system mysql -u rolph -p
 123456

 create database uvv;
 use uvv;
 
 create table funcionario ( 
		 cpf char(11) not null, 
                 primeiro_nome varchar(15) not null, 
                 nome_meio char(1), 
                 ultimo_nome varchar(15) not null, 
                 data_nascimento date, 
                 endereco varchar(50), 
                 sexo char(1), 
                 salario numeric(10,2), 
                 cpf_supervisor char(11) not null, 
                 numero_departamento integer not null, 
                 constraint pk_funcionario primary key (cpf) 
 ); 
 
 alter table funcionario comment 'tabela que armazenará as informações dos funcionários.';
 alter table funcionario modify column cpf char(11) comment 'cpf do funcionário. pk da tabela funcionario.'; 
 alter table funcionario modify column primeiro_nome varchar(15) comment 'primeiro nome do funcionário.'; 
 alter table funcionario modify column nome_meio char(1) comment 'primeira letra do nome do meio do funcionário.'; 
 alter table funcionario modify column ultimo_nome varchar(15) comment 'último nome do funcionário.'; 
 alter table funcionario modify column data_nascimento date comment 'endereço do funcionário.'; 
 alter table funcionario modify column sexo char(1) comment 'sexo do funcionário.'; 
 alter table funcionario modify column salario numeric(10,2) comment 'salário do funcionário.'; 
 alter table funcionario modify column cpf_supervisor char(11) comment 'cpf do supervisor. fk para a própria tabela funcionario (um auto-relacionamento).'; 
 alter table funcionario modify column numero_departamento integer comment 'número do departamento em que o funcionário trabalha.'; 
 alter table funcionario add check (sexo in('M', 'm', 'F', 'f'));
 alter table funcionario add check (salario>=0.0);
  

 create table departamento ( 
                 numero_departamento integer not null, 
                 nome_departamento varchar(15) not null, 
                 cpf_gerente char(11) not null, 
                 data_inicio_gerente date, 
                 constraint pk_departamento primary key (numero_departamento) 
 ); 
 
 alter table departamento comment 'tabela que armazenará as informaçoẽs dos departamentos.'; 
 alter table departamento modify column numero_departamento integer comment 'número do departamento. pk da tabela departamento..'; 
 alter table departamento modify column nome_departamento varchar(15) comment 'nome do departamento. deverá ser único.'; 
 alter table departamento modify column cpf_gerente comment char(11) 'cpf do gerente do departamento. fk para a tabela funcionario.'; 
 alter table departamento modify column data_inicio_gerente date comment 'data em que o gerente começou a trabalhar no departamento.'; 
  
 create unique index departamento_idx 
 on departamento 
  ( nome_departamento ); 
  
 
 create table localizacoes_departamento ( 
                 numero_departamento integer not null, 
                 local varchar(15) not null, 
                 constraint pk_localizacoes_departamento primary key (numero_departamento, local) 
 ); 
 
 alter table localizaoes_departamento comment 'tabela que armazenará localizações de cada departamento.'; 
 alter table localizacoes_departamento modify column numero_departamento integer comment 'número do departamento. pk da tabela localizacoes_departamento e também é uma fk para a tabela departamento.'; 
 alter table localizacoes_departamento modify column local varchar(15) comment 'localização de cada departamento. pk da tabela localizacoes_departamento.'; 
  
  
 create table projeto ( 
                 numero_projeto integer not null, 
                 nome_projeto varchar(15) not null, 
                 local_projeto varchar(15), 
                 numero_departamento integer not null, 
                 constraint pk_projeto primary key (numero_projeto) 
 ); 
 
 alter table projeto comment 'tabela que armazenará as informações sobre os projetos de cada departamento.'; 
 alter table projeto modify column numero_projeto integer comment 'número do projeto. pk da tabela projeto.'; 
 alter table projeto modify column nome_projeto varchar(15) comment 'nome do projeto. deverá ser único.'; 
 alter table projeto modify column local_projeto varchar(15) comment 'localização do projeto.'; 
 alter table projeto modify column numero_departamento integer comment 'número do departamento. fk para a tabela departamento.'; 
  
  
 create unique index projeto_idx 
 on projeto 
  ( nome_projeto ); 
  
 
 create table trabalha_em ( 
                 cpf_funcionario char(11) not null, 
                 numero_projeto integer not null, 
                 horas numeric(3,1) not null, 
                 constraint pk_trabalha_em primary key (cpf_funcionario, numero_projeto) 
 ); 
 
 alter table trabalha_em comment 'tabela para armazenará quais funcionários trabalham em quais projetos.'; 
 alter table trabalha_em modify column cpf_funcionario char(11) comment 'cpf do funcionário. pk da tabela trabalha_em e também é uma fk para a tabela funcionario.'; 
 alter table trabalha_em modify column numero_projeto integer comment 'número do projeto. pk da tabela trabalha_em e também é uma fk para a tabela projeto.'; 
 alter table trabalha_em modify column horas numeric(3,1) comment 'quantidade de horas que o funcionário trabalhou no projeto.'; 
 alter table trabalha_em add check (horas>=0.0);
  
 create table dependente ( 
                 cpf_funcionario char(11) not null, 
                 nome_dependente varchar(15) not null, 
                 sexo char(1), 
                 data_nascimento date, 
                 parentesco varchar(15), 
                 constraint pk_dependente primary key (cpf_funcionario, nome_dependente) 
 ); 
 
 alter table dependente comment 'tabela que armazenará as informações dos dependentes dos funcionários.'; 
 alter table dependente modify column cpf_funcionario char(11) comment 'cpf do funcionário. pk da tabela dependente e também é uma fk para a tabela funcionario.'; 
 alter table dependente modify column nome_dependente varchar(15) comment 'nome do dependente. pk da tabela dependente.'; 
 alter table dependente modify column sexo char(1) comment 'sexo do dependente.'; 
 alter table dependente modify column data_nascimento date comment 'data de nascimento do dependente.'; 
 alter table dependente modify column parentesco varchar(15) comment 'descrição do parentesco do dependente com o funcionário.'; 
 alter table dependente add check (sexo in('M', 'm', 'F', 'f'));
  
 alter table dependente add constraint funcionario_dependente_fk 
 foreign key (cpf_funcionario) 
 references funcionario (cpf) 
 on delete no action 
 on update no action 
 not deferrable; 
  
 alter table trabalha_em add constraint funcionario_trabalha_em_fk 
 foreign key (cpf_funcionario) 
 references funcionario (cpf) 
 on delete no action 
 on update no action 
 not deferrable; 
  
 alter table departamento add constraint funcionario_departamento_fk 
 foreign key (cpf_gerente) 
 references funcionario (cpf) 
 on delete no action 
 on update no action 
 not deferrable; 
  
 alter table funcionario add constraint funcionario_funcionario_fk 
 foreign key (cpf_supervisor) 
 references funcionario (cpf) 
 on delete no action 
 on update no action 
 not deferrable; 
  
 alter table projeto add constraint departamento_projeto_fk 
 foreign key (numero_departamento) 
 references departamento (numero_departamento) 
 on delete no action 
 on update no action 
 not deferrable; 
  
 alter table localizacoes_departamento add constraint departamento_localizacoes_departamento_fk 
 foreign key (numero_departamento) 
 references departamento (numero_departamento) 
 on delete no action 
 on update no action 
 not deferrable; 
  
 alter table trabalha_em add constraint projeto_trabalha_em_fk 
 foreign key (numero_projeto) 
 references projeto (numero_projeto) 
 on delete no action 
 on update no action 
 not deferrable;

 insert into funcionario values 
 		 (88866555579, 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, 88866555579, 1),
 		 (12345678966, 'João', 'B', 'Silva', '1965-01-09', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 33344555587, 5),
 		 (33344555587, 'Fernando', 'T', 'Wong', '1955-12-08', 'Rua da Lapa, 34, São Paulo, SP', 'M', 40000, 88866555576, 5),
 		 (99988777767, 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza de Lima, 35, Curitiba, PR', 'F', 25000, 98765432168, 4),
 		 (98765432168, 'Jennifer', 'S', 'Souza', '1941-06-20', 'Av. Arthur de Lima, 54, Santo André, SP', 'F', 43000, 88866555576, 4),
 		 (66688444476, 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP', 'M', 38000, 33344555587, 5),
 		 (45345345376, 'Joice', 'A', 'Leite', '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP', 'F', 25000, 33344555587, 5),
 		 (98798798733, 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira, 35, São Paulo, SP', 'M', 25000, 98765432168, 4);

 insert into departamento values
 		 (5, 'Pesquisa', 33344555587, '1988-05-22'),
 		 (4, 'Administração', 98765432168, '1995-01-01'),
 		 (1, 'Matriz', 88866555576, '1981-06-19');

 insert into localizacoes_departamento values
 		 (1, 'São Paulo'),
 		 (4, 'Mauá'),
 		 (5, 'Santo André'),
 		 (5, 'Itu'),
 		 (5, 'São Paulo');

 insert into projeto values 
 		 (1, 'ProdutoX', 'Santo André', 5),
 		 (2, 'ProdutoY', 'Itu', 5),
 		 (3, 'ProdutoZ', 'São Paulo', 5),
 		 (10, 'Informatização', 'Mauá', 4),
 		 (20, 'Reorganização', 'São Paulo', 1),
		 (30, 'Novosbenefícios', 'Mauá', 4);

 insert into dependente values
		 (33344555587, 'Alicia', 'F', '1986-04-05', 'Filha'),
		 (33344555587, 'Tiago', 'M', '1983-10-25', 'Filho'),
		 (33344555587, 'Janaína', 'F', '1958-05-03', 'Esposa'),
		 (98765432168, 'Antonio', 'M', '1942-02-28', 'Marido'),
 		 (12345678966, 'Michael', 'M', '1988-01-04', 'Filho'),
		 (12345678966, 'Alicia', 'F', '1988-12-30', 'Filha'),
  		 (12345678966, 'Elizabeth', 'F', '1967-05-05', 'Esposa');

 insert into trabalha_em values
 		 (12345678966, 1, 32.5),
		 (12345678966, 2, 7.5),
		 (66688444476, 3, 40),
		 (45345345376, 1, 20),
		 (45345345376, 2, 20),
	  	 (33344555587, 2, 10),
		 (33344555587, 3, 10),
		 (33344555587, 10, 10),
		 (33344555587, 20, 10),
		 (99988777767, 30, 30),
		 (99988777767, 10, 10),
		 (98798798733, 10, 35),
		 (98798798733, 30, 5),
		 (98765432168, 30, 20),
		 (98765432168, 20, 15),
		 (88866555576, 20, 0);
 